import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final String image;

  CategoryItem({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.orange.shade100,
          child: Image.asset(
            image,
            width: 40,
            height: 40,
          ),
        ),
        SizedBox(height: 5),
        Text(name, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
