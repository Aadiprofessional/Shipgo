import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import 'SubCategoryScreen.dart'; // Adjust this import if necessary

class AllCategoriesScreen extends StatefulWidget {
  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  List<dynamic> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
   
  }

  void _navigateToSubCategory(String mainId, String categoryId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SubCategoryScreen(mainId: mainId, categoryId: categoryId),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 10),
                  Text('Loading categories...', style: TextStyle(color:AppColors.primary)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                  leading: Icon(Icons.category, color: AppColors.primary),
                  title: Text(category['categoryName']),
                  subtitle: Text(category['mainCategory']),
                  onTap: () => _navigateToSubCategory(
                    category['mainCategoryId'],
                    category['categoryId'],
                  ),
                );
              },
            ),
    );
  }
}
