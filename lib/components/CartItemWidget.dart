import 'package:flutter/material.dart';
import 'package:shipgo/components/CartItem.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(String cartId, int newQuantity) onUpdateQuantity;
  final Function(String cartId) onRemoveItem;

  CartItemWidget({
    required this.item,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(item.image),
      title: Text(item.productName),
      subtitle: Text('₹${item.price.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => onUpdateQuantity(item.cartId, item.quantity - 1),
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => onUpdateQuantity(item.cartId, item.quantity + 1),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onRemoveItem(item.cartId),
          ),
        ],
      ),
    );
  }
}
