import 'package:flutter/material.dart';

class BestDeals extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'mainImage': 'images/banner.png',
      'productName': 'Product Name',
      'price': 199.99,
    },
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Deals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: products.map((product) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildProductCard(product, context),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Navigating to ProductDetailPage with productId: ${product['id']}');
        Navigator.pushNamed(context, '/productDetailPage',
            arguments: product['id']);
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.blue, // Set primary color
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 130,
              width: 130,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  product['mainImage'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              product['productName'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              '₹${product['price']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
