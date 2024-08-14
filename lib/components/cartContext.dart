import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// CartItem class
class CartItem {
  final String cartId;
  final String itemName;
  final double price;
  int quantity;

  CartItem({
    required this.cartId,
    required this.itemName,
    required this.price,
    this.quantity = 1,
  });
}

// CartProvider class
class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  bool _isLoggedIn = false;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoggedIn => _isLoggedIn;

  void loginUser() {
    _isLoggedIn = true;
    // Simulate fetching cart items from server or database
    _cartItems = [
      CartItem(cartId: '1', itemName: 'Item 1', price: 100.0),
    ];
    notifyListeners();
  }

  void logoutUser() {
    _isLoggedIn = false;
    _cartItems.clear();
    notifyListeners();
  }

  void addItemToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void updateCartItemQuantity(String cartId, int newQuantity) {
    final cartItem = _cartItems.firstWhere((item) => item.cartId == cartId);
    if (newQuantity < 1) {
      _cartItems.remove(cartItem);
    } else {
      cartItem.quantity = newQuantity;
    }
    notifyListeners();
  }

  void removeItemFromCart(String cartId) {
    _cartItems.removeWhere((item) => item.cartId == cartId);
    notifyListeners();
  }
}
