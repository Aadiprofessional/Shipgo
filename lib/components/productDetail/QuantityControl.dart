import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  final int quantity;
  final int minValue;
  final Function onIncrease;
  final Function onDecrease;

  QuantityControl({
    required this.quantity,
    required this.minValue,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Quantity:',
          style: TextStyle(fontSize: 18, color: Color(0xFF000000)),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: quantity <= minValue ? null : () => onDecrease(),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: quantity <= minValue ? Color(0xFFB3B3B3) : Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                '-',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          '$quantity',
          style: TextStyle(fontSize: 18, color: Color(0xFF000000)),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () => onIncrease(),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
