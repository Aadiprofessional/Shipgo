import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shipgo/components/ProductContainer.dart';

class ProductScreen extends StatefulWidget {
  final String categoryName;

  ProductScreen({required this.categoryName});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<DocumentSnapshot>> _productsFuture;

  @override
  void didUpdateWidget(ProductScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categoryName != oldWidget.categoryName) {
      _productsFuture = _fetchProducts(widget.categoryName);
    }
  }

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts(widget.categoryName);
  }

  Future<List<DocumentSnapshot>> _fetchProducts(String categoryName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('category')
        .doc(categoryName)
        .collection('products')
        .get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching products'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found'));
        }

        List<DocumentSnapshot> products = snapshot.data!;
        return SingleChildScrollView(
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(), // Disable internal scrolling
            shrinkWrap: true, // Allow GridView to occupy only necessary space
            padding: EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.7, // Adjust this based on your image and container size
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              var productId = product.id; // Extract productId from document ID
              return ProductContainer(
                product: product,
                categoryId: widget.categoryName, // Pass categoryId
                productId: productId,
              );
            },
          ),
        );
      },
    );
  }
}
