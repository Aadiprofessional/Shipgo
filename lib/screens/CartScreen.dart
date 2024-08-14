import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipgo/components/CartItem.dart';
import 'package:shipgo/components/cartContext.dart';
import 'package:shipgo/screens/OrderMapScreen.dart';
import '../styles/colors.dart'; // Ensure this path is correct


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _loading = false;
  bool _isUserLoggedIn = false; // Update this based on your authentication logic

  @override
  void initState() {
    super.initState();
    // Simulate a delay to mimic loading state
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _loading = false;
        _isUserLoggedIn = true; // Simulate user login state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.main),
        ),
      );
    }

    if (!_isUserLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/Login.png', width: 300, height: 300),
              Text(
                'Please log in to access your cart.',
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.second,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                onPressed: () {
                  // Implement login functionality
                },
              ),
            ],
          ),
        ),
      );
    }

    final cartItems = cartProvider.cartItems;
    final totalPrice = cartProvider.totalPrice;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            color: AppColors.main,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cart',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Subtotal: ₹${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
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
                   
                  },
                  onRemoveItem: (cartId) {
                    cartProvider.removeItemFromCart(cartId);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
               
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text('Place Order'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.main,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                       Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderMapScreen(), // Navigate to OrderMapScreen
                  ),
                );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(String, int) onUpdateQuantity;
  final Function(String) onRemoveItem;

  CartItemWidget({
    required this.item,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: item.image.isNotEmpty
              ? Image.network(
                  item.image,
                  fit: BoxFit.cover,
                )
              : Icon(Icons.image, size: 40), // Placeholder icon if no image
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.itemName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("₹${(item.price * item.quantity).toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text("Color: ${item.color}"),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        onRemoveItem(item.cartId);
                      },
                      child: Text('Remove', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        onUpdateQuantity(item.cartId, item.quantity - 1);
                      },
                    ),
                    Text(item.quantity.toString(), style: TextStyle(fontSize: 18)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        onUpdateQuantity(item.cartId, item.quantity + 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
