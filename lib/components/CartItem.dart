import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function(String, int) onUpdateQuantity;
  final Function(String) onRemoveItem;

  CartItem({
    required this.item,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int itemQuantity;

  @override
  void initState() {
    super.initState();
    itemQuantity = widget.item['quantity'];
  }

  void _handleIncreaseQuantity() {
    setState(() {
      itemQuantity += 1;
      widget.onUpdateQuantity(widget.item['cartId'], itemQuantity);
    });
  }

  void _handleDecreaseQuantity() {
    setState(() {
      int newQuantity = itemQuantity - 1;
      if (newQuantity < widget.item['colorminCartValue']) {
        itemQuantity = widget.item['colorminCartValue'];
      } else {
        itemQuantity = newQuantity;
        widget.onUpdateQuantity(widget.item['cartId'], itemQuantity);
      }
    });
  }

  void _handleRemoveItem() {
    widget.onRemoveItem(widget.item['cartId']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.blue, // Replace with your colors.primary
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/productDetailPage', arguments: widget.item['productId']);
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                widget.item['image'],
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("₹${(widget.item['price'] * itemQuantity).toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300, // Replace with your colors.GrayLight
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(widget.item['color'], style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: _handleRemoveItem,
                      child: Text('Remove', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _handleDecreaseQuantity,
                    ),
                    Text(itemQuantity.toString(), style: TextStyle(fontSize: 18)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _handleIncreaseQuantity,
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
