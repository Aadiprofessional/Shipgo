import 'package:flutter/material.dart';
import 'package:shipgo/components/CartItem.dart'; // Correct import for CartItem

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onUpdateQuantity;
  final VoidCallback onRemoveItem;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(item.name),
        subtitle: Text('₹${item.price} x ${item.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => onUpdateQuantity(item.quantity - 1)),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () => onUpdateQuantity(item.quantity + 1)),
            IconButton(icon: Icon(Icons.delete), onPressed: onRemoveItem),
          ],
        ),
      ),
    );
  }
}
