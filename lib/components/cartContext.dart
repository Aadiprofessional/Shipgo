import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shipgo/components/CartItem.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CartItem> get cartItems => _cartItems;

  CartProvider() {
    _startCartListener();
  }

  void _startCartListener() {
    final user = _auth.currentUser;
    if (user != null) {
      _firestore.collection('users').doc(user.uid).collection('cart').snapshots().listen((snapshot) {
        _cartItems.clear();
        for (var doc in snapshot.docs) {
          _cartItems.add(CartItem.fromMap(doc.data()));
        }
        notifyListeners();
      });
    }
  }

  void addItemToCart(CartItem item) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).collection('cart').doc(item.cartId).set(item.toMap());
    }
  }

  void removeItemFromCart(String cartId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).collection('cart').doc(cartId).delete();
    }
  }

  void updateItemQuantity(String cartId, int newQuantity) async {
    final user = _auth.currentUser;
    if (user != null) {
      final docRef = _firestore.collection('users').doc(user.uid).collection('cart').doc(cartId);
      await docRef.update({'quantity': newQuantity});
    }
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}
