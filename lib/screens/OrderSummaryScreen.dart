import 'package:flutter/material.dart';


class OrderSummaryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  OrderSummaryScreen({required this.cartItems, required this.totalAmount});

  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  List<Map<String, dynamic>> cartItems = [];
  double totalAmount = 0.0;
  bool useRewardPoints = false;
  String couponCode = '';
  Map<String, dynamic>? appliedCoupon;
  String? selectedCompanyId;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
    totalAmount = widget.totalAmount;
  }

  double calculateTotalAmount() {
    double amount = cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
    if (useRewardPoints) amount -= 100.0; // Example reward points price
    if (appliedCoupon != null) amount -= (amount * (appliedCoupon!['value'] / 100));
    amount += 50.0 - 10.0; // Example shipping charges and discount
    return amount;
  }

  double calculateSubtotal() {
    double subtotal = cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
    if (appliedCoupon != null) subtotal -= (subtotal * (appliedCoupon!['value'] / 100));
    return subtotal;
  }

  void _handleApplyCoupon() {
    // Assuming you have your coupons list and logic here
    // Mock coupon application
    setState(() {
      appliedCoupon = {'code': couponCode, 'value': 10}; // Example coupon
   
    });
  }

  void _handleRemoveCoupon() {
    setState(() {
      appliedCoupon = null;
     
    });
  }

  void _handleToggleRewardPoints() {
    setState(() {
      useRewardPoints = !useRewardPoints;
    });
  }

  void _handleCheckout() {
    if (selectedCompanyId == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Select Company'),
          content: Text('Please select a company before proceeding.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
        ),
      );
      return;
    }

    // Handle checkout logic

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Summary')),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${cartItems.length} items:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('₹${calculateSubtotal().toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 20),

          // Summary Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2, offset: Offset(0, 2))],
            ),
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping Charges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping Charges:', style: TextStyle(color: Colors.black)),
                    Text('₹50.00', style: TextStyle(color: Colors.black)),
                  ],
                ),
                // Additional Discount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Additional Discount:', style: TextStyle(color: Colors.black)),
                    Text('-₹10.00', style: TextStyle(color: Colors.black)),
                  ],
                ),
                // Coupon Discount
                if (appliedCoupon != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Coupon Discount:', style: TextStyle(color: Colors.black)),
                      Text('-₹${((calculateSubtotal() * (appliedCoupon!['value'] / 100))).toStringAsFixed(2)}', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                // Reward Points Discount
                if (useRewardPoints)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reward Points Discount:', style: TextStyle(color: Colors.black)),
                      Text('-₹100.00', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹${calculateTotalAmount().toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Reward Points Toggle
          Row(
            children: [
              Expanded(child: Text('Use Reward Points (-₹100.00)', style: TextStyle(fontSize: 16))),
              Switch(value: useRewardPoints, onChanged: (value) => _handleToggleRewardPoints()),
            ],
          ),
          SizedBox(height: 20),

          // Coupon Input
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2, offset: Offset(0, 2))],
            ),
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter coupon code',
                  ),
                  onChanged: (value) => couponCode = value,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _handleApplyCoupon,
                  child: Text('Apply Coupon'),
                ),
                if (appliedCoupon != null)
                  TextButton(
                    onPressed: _handleRemoveCoupon,
                    child: Text('Remove Coupon'),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Checkout Button
          ElevatedButton(
            onPressed: _handleCheckout,
            child: Text('Checkout'),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFCC51)),
          ),
        ],
      ),
    );
  }
}
