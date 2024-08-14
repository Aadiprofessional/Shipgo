import 'package:flutter/foundation.dart';
import 'package:shipgo/components/CartItem.dart';


class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addItemToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItemFromCart(String cartId) {
    _cartItems.removeWhere((item) => item.cartId == cartId);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}
