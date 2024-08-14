import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  OrderDetailsScreen({required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Header
            Text('Order Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            
            // Order Details
            Text('Order ID: ${orderDetails['orderId']}'),
            Text('Order Date: ${orderDetails['orderDate']}'),
            Text('Customer Name: ${orderDetails['customerName']}'),
            Text('Shipping Address: ${orderDetails['shippingAddress']}'),
            SizedBox(height: 20),
            
            // Ordered Items
            Text('Ordered Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: orderDetails['items'].length,
                itemBuilder: (context, index) {
                  final item = orderDetails['items'][index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Quantity: ${item['quantity']} | Price: ₹${item['price']}'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            // Total Amount
            Text('Total Amount: ₹${orderDetails['totalAmount'].toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle PDF generation logic here
                  },
                  child: Text('Generate PDF'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
