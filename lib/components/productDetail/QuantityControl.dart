import 'package:flutter/material.dart';

class QuantityControl extends StatefulWidget {
  final int minValue;
  final Function onIncrease;
  final Function onDecrease;

  QuantityControl({
    required this.minValue,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  _QuantityControlState createState() => _QuantityControlState();
}

class _QuantityControlState extends State<QuantityControl> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.minValue > 0 ? widget.minValue : 1;
  }

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
          onTap: quantity <= widget.minValue ? null : () {
            setState(() {
              quantity--;
            });
            widget.onDecrease();
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: quantity <= widget.minValue ? Color(0xFFB3B3B3) : Color(0xFF25424D),
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
          onTap: () {
            setState(() {
              quantity++;
            });
            widget.onIncrease();
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xFF25424D),
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
