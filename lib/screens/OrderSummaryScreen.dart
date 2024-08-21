import 'package:flutter/material.dart';
import 'package:shipgo/components/CartItem.dart'; // Ensure this import is correct
import 'package:shipgo/components/CartItemWidget.dart'; // Ensure this import is correct
import 'package:shipgo/screens/OrderMapScreen.dart'; // Import the OrderMapScreen here

class OrderSummaryScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;
  final double totalAdditionalDiscount;

  const OrderSummaryScreen({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
    required this.totalAdditionalDiscount,
  }) : super(key: key);

  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late List<CartItem> cartItems;
  late double totalAmount;
  String couponCode = '';
  bool useRewardPoints = false;
  Coupon? appliedCoupon;
  List<Coupon> coupons = [];
  String? selectedCompanyId;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
    totalAmount = widget.totalAmount;
    coupons = fetchCoupons();
    calculateTotalAmount();
  }

  List<Coupon> fetchCoupons() {
    return [
      Coupon(code: "SAVE10", value: 10, description: "Save 10%"),
      Coupon(code: "FREESHIP", value: 50, description: "Free Shipping"),
    ];
  }

  void calculateTotalAmount() {
    double amount = cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    if (useRewardPoints) {
      amount -= 20;
    }
    if (appliedCoupon != null) {
      amount -= appliedCoupon!.value;
    }
    amount += 50; // Shipping Charges
    amount -= widget.totalAdditionalDiscount;
    setState(() {
      totalAmount = amount;
    });
  }

  void applyCoupon(String code) {
    final coupon = coupons.firstWhere((c) => c.code == code,
        orElse: () => Coupon(code: '', value: 0, description: ''));
    if (coupon.code.isNotEmpty) {
      setState(() {
        appliedCoupon = coupon;
        calculateTotalAmount();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Coupon applied successfully!')));
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid coupon code.')));
    }
  }

  void removeCoupon() {
    setState(() {
      appliedCoupon = null;
      calculateTotalAmount();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Coupon removed.')));
    });
  }

  void toggleRewardPoints() {
    setState(() {
      useRewardPoints = !useRewardPoints;
      calculateTotalAmount();
    });
  }

  void checkout() {
    if (selectedCompanyId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select a company.')));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderMapScreen()),
    );
  }

  void selectCompany(String? companyId) {
    setState(() {
      selectedCompanyId = companyId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cartItems.length} items:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            buildSummarySection(),
            buildRewardPointsToggle(),
            buildCouponSection(),
            CompanyDropdown(onSelectCompany: selectCompany),
            ...cartItems.map((item) => CartItemWidget(
                  item: item,
                  onUpdateQuantity: (newQuantity) =>
                      handleUpdateQuantity(item.cartId, newQuantity),
                  onRemoveItem: () => handleRemoveItem(item.cartId),
                )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: checkout,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color(0xFF25424D), // Background color for checkout button
          ),
          child: Text('Checkout', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget buildSummarySection() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping Charges:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹50',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Additional Discount:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '-₹${widget.totalAdditionalDiscount}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (appliedCoupon != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Coupon Discount:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '-₹${appliedCoupon!.value}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
                if (useRewardPoints) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reward Points Discount:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '-₹20',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildRewardPointsToggle() {
    return Row(
      children: [
        Checkbox(
            value: useRewardPoints, onChanged: (value) => toggleRewardPoints()),
        Text('Use Reward Points (-₹20)', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget buildCouponSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Enter coupon code'),
                onChanged: (value) => couponCode = value,
              ),
            ),
            SizedBox(width: 8), // Adds space between TextField and Button
            ElevatedButton(
              onPressed: () => applyCoupon(couponCode),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF25424D), // Background color for "Apply" button
              ),
              child: Text(
                appliedCoupon != null ? 'Applied' : 'Apply',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        if (appliedCoupon != null)
          TextButton(
            onPressed: removeCoupon,
            child: Text('Remove Coupon', style: TextStyle(color: Colors.red)),
          ),
        SizedBox(height: 10), // Adds space between sections
        Text(
          'Applicable Coupons',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...coupons.map((coupon) => ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon.code,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(coupon.description),
                ],
              ),
              trailing: TextButton(
                onPressed: appliedCoupon != null
                    ? null
                    : () => applyCoupon(coupon.code),
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF25424D), // Text color
                ),
                child: Text(
                  appliedCoupon != null && appliedCoupon!.code == coupon.code
                      ? 'Applied'
                      : 'Apply',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  void handleUpdateQuantity(String id, int quantity) {
    setState(() {
      cartItems = cartItems
          .map((item) {
            if (item.cartId == id) {
              return item.copyWith(quantity: quantity);
            }
            return item;
          })
          .where((item) => item.quantity > 0)
          .toList();
      calculateTotalAmount();
    });
  }

  void handleRemoveItem(String id) {
    setState(() {
      cartItems.removeWhere((item) => item.cartId == id);
      calculateTotalAmount();
    });
  }
}

class Coupon {
  final String code;
  final double value;
  final String description;

  Coupon({
    required this.code,
    required this.value,
    required this.description,
  });
}

class CompanyDropdown extends StatelessWidget {
  final ValueChanged<String?> onSelectCompany;

  const CompanyDropdown({Key? key, required this.onSelectCompany})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      hint: Text('Select Company'),
      onChanged: onSelectCompany,
      items: [
        DropdownMenuItem(value: 'company1', child: Text('Company 1')),
        DropdownMenuItem(value: 'company2', child: Text('Company 2')),
      ],
    );
  }
}
