import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  final String userId;
  final Function(String) onAddressSaved;

  MapScreen({required this.userId, required this.onAddressSaved});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _currentLocation = LatLng(0.0, 0.0);
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _optionalAddressController =
      TextEditingController();
  final TextEditingController _customAddressTypeController =
      TextEditingController();
  String _residentType = 'Apartment';
  late MapController _mapController;
  List<Map<String, dynamic>> _savedLocations = [];
  bool _isCustomType = false;
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _getCurrentLocation();
    _mapController = MapController();
    _fetchSavedLocations();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Location permission is required to use this feature.')),
      );
    }
  }

  Future<void> _saveAddress() async {
    String fullAddress = _fullAddressController.text;
    String addressType =
        _isCustomType ? _customAddressTypeController.text : _residentType;

    // Check for existing address of the same type
    var existingDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('addresses')
        .where('type', isEqualTo: addressType)
        .get();

    if (existingDocs.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An address of this type already exists.')),
      );
      return;
    }

    // Save location data to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('addresses')
        .add({
      'address': fullAddress,
      'latitude': _currentLocation.latitude,
      'longitude': _currentLocation.longitude,
      'type': addressType,
    });

    // Fetch saved locations
    _fetchSavedLocations();

    widget.onAddressSaved(fullAddress);
    Navigator.pop(context);
  }

  Future<void> _fetchSavedLocations() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('addresses')
        .get();

    setState(() {
      _savedLocations = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'address': data['address'],
          'type': data['type'],
          'latitude': data['latitude'],
          'longitude': data['longitude'],
        };
      }).toList();

      // Select the first address by default
      if (_savedLocations.isNotEmpty) {
        _selectedAddressId = _savedLocations.first['id'];

        // Find the closest address to the current location
        double closestDistance = double.infinity;
        String? closestAddressId;

        for (var location in _savedLocations) {
          double distance = Geolocator.distanceBetween(
            _currentLocation.latitude,
            _currentLocation.longitude,
            location['latitude'],
            location['longitude'],
          );

          if (distance < closestDistance) {
            closestDistance = distance;
            closestAddressId = location['id'];
          }
        }

        // Set the closest address as the selected address if found
        if (closestAddressId != null) {
          _selectedAddressId = closestAddressId;
        }
      }
    });
  }

  void _showMyLocation() {
    _mapController.move(_currentLocation, 14.0);
  }

  void _onAddressSelected(String id, String address) {
    widget.onAddressSaved(address);
    Navigator.pop(context); // Navigate back to the home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Address'),
        backgroundColor: Color(0xFF25424D),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _currentLocation,
                    zoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentLocation,
                          builder: (context) => Container(
                            child: Icon(Icons.location_pin, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: _showMyLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF25424D),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12),
                    ),
                    child: Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _fullAddressController,
              decoration: InputDecoration(
                labelText: 'Your Full Address',
                labelStyle: TextStyle(color: Color(0xFF25424D)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _optionalAddressController,
              decoration: InputDecoration(
                labelText: 'Optional Address',
                labelStyle: TextStyle(color: Color(0xFF25424D)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resident Type:',
                    style: TextStyle(color: Color(0xFF25424D))),
                RadioListTile(
                  value: 'Apartment',
                  groupValue: _residentType,
                  onChanged: (value) {
                    setState(() {
                      _residentType = value!;
                      _isCustomType = false;
                    });
                  },
                  title: Text('Apartment'),
                  activeColor: Color(0xFF25424D),
                ),
                RadioListTile(
                  value: 'House',
                  groupValue: _residentType,
                  onChanged: (value) {
                    setState(() {
                      _residentType = value!;
                      _isCustomType = false;
                    });
                  },
                  title: Text('House'),
                  activeColor: Color(0xFF25424D),
                ),
                RadioListTile(
                  value: 'Custom',
                  groupValue: _residentType,
                  onChanged: (value) {
                    setState(() {
                      _residentType = value!;
                      _isCustomType = true;
                    });
                  },
                  title: Text('Custom'),
                  activeColor: Color(0xFF25424D),
                ),
                if (_isCustomType)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _customAddressTypeController,
                      decoration: InputDecoration(
                        labelText: 'Custom Address Type',
                        labelStyle: TextStyle(color: Color(0xFF25424D)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _saveAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF25424D),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _savedLocations.length,
              itemBuilder: (context, index) {
                final location = _savedLocations[index];
                final isSelected = _selectedAddressId == location['id'];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF25424D) : Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () =>
                        _onAddressSelected(location['id'], location['address']),
                    title: Text(
                      location['address'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Color(0xFF25424D),
                      ),
                    ),
                    subtitle: Text(
                      location['type'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Color(0xFF25424D),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
