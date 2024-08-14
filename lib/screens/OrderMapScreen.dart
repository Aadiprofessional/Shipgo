import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shipgo/components/CartItemWidget.dart';
import 'package:shipgo/components/cartContext.dart';
import 'package:shipgo/screens/CartScreen.dart'; // Keep only this import

class OrderMapScreen extends StatefulWidget {
  @override
  _OrderMapScreenState createState() => _OrderMapScreenState();
}

class _OrderMapScreenState extends State<OrderMapScreen> {
  late MapController _mapController;
  LatLng _currentLocation = LatLng(28.544788, 77.18987);
  LatLng _warehouseLocation = LatLng(28.544788, 77.18987);
  LatLng _deliveryPartnerLocation = LatLng(28.544788, 77.18987);
  List<Marker> _markers = [];
  bool _loading = true;
  double _zoomLevel = 14.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
    _fetchDeliveryPartnerLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          point: _currentLocation,
          builder: (context) => Icon(Icons.location_on, color: Colors.blue),
        ),
      );
      _markers.add(
        Marker(
          point: _warehouseLocation,
          builder: (context) => Icon(Icons.store, color: Colors.green),
        ),
      );
      _loading = false;
    });
  }

  Future<void> _fetchDeliveryPartnerLocation() async {
    final response = await http.get(Uri.parse('https://your-api.com/api/delivery-partner-location'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final latitude = data['latitude'];
      final longitude = data['longitude'];
      setState(() {
        _deliveryPartnerLocation = LatLng(latitude, longitude);
        _markers.add(
          Marker(
            point: _deliveryPartnerLocation,
            builder: (context) => Icon(Icons.delivery_dining, color: Colors.orange),
          ),
        );
        _fetchRoute();
      });
    } else {
      throw Exception('Failed to load delivery partner location');
    }
  }

  Future<void> _fetchRoute() async {
    final response = await http.get(Uri.parse(
        'https://api.openrouteservice.org/v2/directions/foot-walking?api_key=YOUR_API_KEY&start=${_deliveryPartnerLocation.longitude},${_deliveryPartnerLocation.latitude}&end=${_currentLocation.longitude},${_currentLocation.latitude}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['routes'][0]['geometry']['coordinates'];
      final points = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      setState(() {
        _markers.add(
          PolylineLayer(
            polylines: [
              Polyline(
                points: points,
                color: Colors.blue,
                strokeWidth: 4.0,
              ),
            ],
          ) as Marker,
        );
      });
    } else {
      throw Exception('Failed to load route');
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 1).clamp(1.0, 20.0);
      _mapController.move(_currentLocation, _zoomLevel);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 1).clamp(1.0, 20.0);
      _mapController.move(_currentLocation, _zoomLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Map'),
        backgroundColor: Color(0xFF25424D),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: _currentLocation,
                          zoom: _zoomLevel,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: _markers,
                          ),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: [
                                  _deliveryPartnerLocation,
                                  _currentLocation,
                                ],
                                color: Colors.blue,
                                strokeWidth: 4.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Column(
                          children: [
                            FloatingActionButton(
                              onPressed: _zoomIn,
                              child: Icon(Icons.add),
                            ),
                            SizedBox(height: 10),
                            FloatingActionButton(
                              onPressed: _zoomOut,
                              child: Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemWidget(
                  item: item,
                  onUpdateQuantity: (cartId, newQuantity) {
                    // Handle update quantity
                    cartProvider.updateItemQuantity(cartId, newQuantity);
                  },
                  onRemoveItem: (cartId) {
                    cartProvider.removeItemFromCart(cartId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
