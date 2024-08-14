import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shipgo/components/AutoImageSlider2.dart';
import 'package:shipgo/components/ProductScreen.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final List<Map<String, dynamic>> categories = [
    {'id': 1, 'name': 'Electronics', 'image': 'images/Categories.png'},
    {'id': 2, 'name': 'Stationary', 'image': 'images/Categories3.png'},
    {'id': 3, 'name': 'Tools', 'image': 'images/Categories2.png'},
    {'id': 4, 'name': 'Furniture', 'image': 'images/Categories4.png'},
  ];

  int _activeCategoryId = 1; // Default to Electronics
  String _selectedCategoryName = 'Electronics';

  void _handleCategoryPress(Map<String, dynamic> category) {
    setState(() {
      _activeCategoryId = category['id'];
      _selectedCategoryName = category['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
      children: [
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              bool isActive = _activeCategoryId == category['id'];
              return GestureDetector(
                onTap: () => _handleCategoryPress(category),
                child: Container(
                  width: 70,
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isActive ? Color(0xFF25424D) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          category['image'],
                          width: 40,
                          height: 40,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center, // Center-align text within the container
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Featured Products',
            textAlign: TextAlign.left, // Align text to the left
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ProductScreen(categoryName: _selectedCategoryName),
        Image.asset('images/sale.png',
            width: 450, height: 100, fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Best Products',
            textAlign: TextAlign.left, // Align text to the left
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ProductScreen(categoryName: _selectedCategoryName),
        AutoImageSlider2(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'UpComing Products',
            textAlign: TextAlign.left, // Align text to the left
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ProductScreen(categoryName: _selectedCategoryName),
      ],
    );
  }
}
