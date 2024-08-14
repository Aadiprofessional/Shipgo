import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shipgo/components/ProductContainer.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _allProducts = [];
  List<DocumentSnapshot> _searchResults = [];
  List<DocumentSnapshot> _sortedResults = [];
  bool _loading = true;
  String? _sortValue;

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
    _searchController.addListener(_debouncedSearch);
  }

  Future<void> _fetchAllProducts() async {
    try {
      List<DocumentSnapshot> allProducts = [];

      // Get all categories
      final categoriesSnapshot = await FirebaseFirestore.instance.collection('category').get();

      for (var categoryDoc in categoriesSnapshot.docs) {
        // For each category, get the products
        final productsSnapshot = await FirebaseFirestore.instance
            .collection('category')
            .doc(categoryDoc.id)
            .collection('products')
            .get();

        for (var productDoc in productsSnapshot.docs) {
          // Check if the categoryId field exists before adding it
          final productData = productDoc.data() as Map<String, dynamic>;
          if (!productData.containsKey('categoryId')) {
            // If categoryId does not exist, add it
            await FirebaseFirestore.instance
                .collection('category')
                .doc(categoryDoc.id)
                .collection('products')
                .doc(productDoc.id)
                .update({'categoryId': categoryDoc.id});
          }
          allProducts.add(productDoc);
        }
      }

      setState(() {
        _allProducts = allProducts;
        _searchResults = allProducts;
        _sortedResults = allProducts;
        _loading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _loading = false;
      });
      print('Error fetching products: $e');
    }
  }

  void _debouncedSearch() {
    Future.delayed(Duration(milliseconds: 300), () {
      final query = _searchController.text.toLowerCase();
      List<DocumentSnapshot> filteredProducts = _allProducts.where((product) {
        final productData = product.data() as Map<String, dynamic>;
        return (productData['name'] as String).toLowerCase().contains(query);
      }).toList();

      setState(() {
        _searchResults = filteredProducts;
        _sortProducts();
      });
    });
  }

  void _sortProducts() {
    List<DocumentSnapshot> sortedProducts = List.from(_searchResults);
    if (_sortValue == 'low_to_high') {
      sortedProducts.sort((a, b) => (a['price'] as num).compareTo(b['price']));
    } else if (_sortValue == 'high_to_low') {
      sortedProducts.sort((a, b) => (b['price'] as num).compareTo(a['price']));
    }
    setState(() {
      _sortedResults = sortedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    _sortProducts();

    return Scaffold(
      body: Container(
        color: Colors.white, // Set white background
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search your products',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _sortValue,
                      hint: Text('Sort By'),
                      items: [
                        DropdownMenuItem(value: 'low_to_high', child: Text('Low to High')),
                        DropdownMenuItem(value: 'high_to_low', child: Text('High to Low')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortValue = value;
                          _sortProducts();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : _sortedResults.isNotEmpty
                      ? GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: _sortedResults.length,
                          itemBuilder: (context, index) {
                            final product = _sortedResults[index];
                            final productData = product.data() as Map<String, dynamic>;
                            final categoryId = productData.containsKey('categoryId')
                                ? productData['categoryId']
                                : ''; // Default to an empty string if not found
                            return ProductContainer(
                              product: product,
                              categoryId: categoryId, // Pass categoryId
                              productId: product.id, // Pass productId
                            );
                          },
                        )
                      : Center(child: Text('No products found')),
            ),
          ],
        ),
      ),
    );
  }
}
