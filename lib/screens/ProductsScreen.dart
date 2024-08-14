import 'package:flutter/material.dart';
import 'package:shipgo/styles/colors.dart';


class ProductsScreen extends StatefulWidget {
  final String subCategoryId;

  ProductsScreen({required this.subCategoryId});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<dynamic> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
   
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: AppColors.primary,
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 10),
                  Text('Loading products...', style: TextStyle(color: AppColors.primary)),
                ],
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              padding: EdgeInsets.all(10),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                
              },
            ),
    );
  }
}
