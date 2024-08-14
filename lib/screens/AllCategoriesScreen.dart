// ignore: file_names
import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import 'SubCategoryScreen.dart'; // Adjust this import if necessary

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final List<dynamic> _categories = [];
  final bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {}

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
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 10),
                  Text('Loading categories...',
                      style: TextStyle(color: AppColors.primary)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                  leading: const Icon(Icons.category, color: AppColors.primary),
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
