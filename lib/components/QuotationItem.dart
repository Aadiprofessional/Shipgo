import 'package:flutter/material.dart';
import 'package:shipgo/screens/QuotationContent.dart';
// Adjust import based on your QuotationContent file

class QuotationItem extends StatelessWidget {
  final dynamic item; // Replace dynamic with your item type
  final Function(String, String) onUpdateQuantity;

  const QuotationItem({
    Key? key,
    required this.item,
    required this.onUpdateQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _handleIncrease() => onUpdateQuantity(item.cartId, 'increase');
    void _handleDecrease() => onUpdateQuantity(item.cartId, 'decrease');

    return QuotationContent(
      item: item, onIncrease: (String ) {  }, onDecrease: (String ) {  },
    
    );
  }
}
