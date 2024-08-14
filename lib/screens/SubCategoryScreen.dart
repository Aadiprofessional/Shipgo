import 'package:flutter/material.dart';
import 'package:shipgo/styles/colors.dart';

class SubCategoryScreen extends StatefulWidget {
  final String mainId;
  final String categoryId;

  SubCategoryScreen({required this.mainId, required this.categoryId});

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  List<dynamic> _subCategories = [];
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
        title: Text('Subcategories'),
        backgroundColor: AppColors.primary,
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 10),
                  Text('Loading subcategories...', style: TextStyle(color: AppColors.primary)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _subCategories.length,
              itemBuilder: (context, index) {
                final subCategory = _subCategories[index];
                return ListTile(
                  leading: Icon(Icons.subdirectory_arrow_right, color: AppColors.primary),
                  title: Text(subCategory['subCategoryName']),
                );
              },
            ),
    );
  }
}
