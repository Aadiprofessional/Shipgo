import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  List<DocumentSnapshot> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchUserAndOrders();
  }

  Future<void> _fetchUserAndOrders() async {
    _user = _auth.currentUser!;
    var ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('uid', isEqualTo: _user.uid)
        .get();

    setState(() {
      _orders = ordersSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        foregroundColor: Color.fromARGB(255, 252, 252, 252),
        backgroundColor: Color(0xFF25424D),
      ),
      body: _orders.isEmpty
          ? Center(child: Text('No orders available'))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index].data() as Map<String, dynamic>;
                final products = (order['products'] as List<dynamic>?) ?? []; // Handle null value
                final totalPrice = order['totalPrice'] as double? ?? 0.0;
                final timestamp = (order['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
                
                return ListTile(
                  title: Text('Order ID: ${_orders[index].id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (products.isNotEmpty) ...[
                        for (var product in products)
                          Text(
                            '${product['productName']} - ${product['quantity']} x ${product['price']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        SizedBox(height: 8),
                      ] else
                        Text('No products available'),
                      Text('Total Price: $totalPrice'),
                      Text('Order Date: ${timestamp.toLocal()}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
