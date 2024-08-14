// ignore: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shipgo/components/CartItemWidget.dart';
import 'package:shipgo/components/cartContext.dart';
import 'package:shipgo/screens/OrderMapScreen.dart';
import '../styles/colors.dart'; // Ensure this path is correct

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _loading = true; // Start with loading true
  bool _isUserLoggedIn = false; // Update this based on your authentication logic

  @override
  void initState() {
    super.initState();
    // Simulate a delay to mimic loading state
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _loading = false;
        _isUserLoggedIn = true; // Simulate user login state
      });
    });
  }

  Future<void> _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle case where the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to place an order.')),
      );
      return;
    }

    final uid = user.uid;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItems = cartProvider.cartItems;
    final totalPrice = cartProvider.totalPrice;

    try {
      final orderRef = FirebaseFirestore.instance.collection('orders').doc();
      final orderData = {
        'uid': uid,
        'timestamp': FieldValue.serverTimestamp(),
        'totalPrice': totalPrice,
        'items': cartItems.map((item) => {
          'productName': item.productName,
          'price': item.price,
          'quantity': item.quantity,
          'image': item.image,
        }).toList(),
      };

      await orderRef.set(orderData);

      // Optionally, navigate to another screen or show a success message
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => OrderMapScreen(),
        ),
      );
    } catch (e) {
      // Handle error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to place order. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.main),
        ),
      );
    }

    if (!_isUserLoggedIn) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Please log in to access your cart.',
            style: TextStyle(fontSize: 16, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final cartItems = cartProvider.cartItems;
    final totalPrice = cartProvider.totalPrice;

    if (cartItems.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Your cart is empty.',
            style: TextStyle(fontSize: 16, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            color: AppColors.main,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cart',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Subtotal: ₹${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemWidget(
                  item: item,
                  onUpdateQuantity: (cartId, newQuantity) {
                    cartProvider.updateItemQuantity(cartId, newQuantity);
                  },
                  onRemoveItem: (cartId) {
                    cartProvider.removeItemFromCart(cartId);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.main,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: cartItems.isEmpty
                      ? null
                      : () {
                          _placeOrder();
                        },
                  child: const Text('Place Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
