import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final Function onCall;

  ProductHeader({
    required this.name,
    required this.description,
    required this.price,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
             
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF000000),
            
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price: ₹$price',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF000000),
                ),
              ),
              GestureDetector(
                onTap: () => onCall(),
                child: Image.asset(
                  'images/call.png',
                  width: 65,
                  height: 65,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
