import 'package:flutter/material.dart';

class GoToCartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/Cart');
      },
      child: Text('Go to Cart'),
    );
  }
}
