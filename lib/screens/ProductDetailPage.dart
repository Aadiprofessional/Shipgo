import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shipgo/components/productDetail/AttributesSelector.dart';
import 'package:shipgo/components/productDetail/ImageCarousel.dart';
import 'package:shipgo/components/productDetail/ProductHeader.dart';
import 'package:shipgo/components/productDetail/QuantityControl.dart';
import 'package:shipgo/components/productDetail/SpecificationsTable.dart';

class ProductDetailPage extends StatefulWidget {
  final String categoryId;
  final String productId;

  ProductDetailPage({
    required this.categoryId,
    required this.productId,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic>? productData;
  String? selectedAttribute1;
  String? selectedAttribute2;
  String? selectedColor;
  int quantity = 1;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> productDoc =
          await FirebaseFirestore.instance
              .collection('category')
              .doc(widget.categoryId)
              .collection('products')
              .doc(widget.productId)
              .get();

      if (productDoc.exists) {
        productData = productDoc.data();

        // Set initial selections
        updateSelections();
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print('Error fetching product details: $error');
      setState(() {
        loading = false;
      });
    }
  }

  void updateSelections() {
    if (productData != null) {
      final attribute1 =
          productData!['attribute1'] as Map<String, dynamic>? ?? {};
      final attribute2 =
          productData!['attribute2'] as Map<String, dynamic>? ?? {};

      if (attribute1.isNotEmpty) {
        selectedAttribute1 = attribute1.keys.first;

        if (attribute2.isNotEmpty) {
          selectedAttribute2 = attribute2.keys.first;

          final colors =
              attribute2[selectedAttribute2] as Map<String, dynamic>? ?? {};
          if (colors.isNotEmpty) {
            selectedColor = colors.keys.first;
          }
        }
      }
    }
  }

  int getMinCartValue() {
    if (selectedAttribute1 != null &&
        selectedAttribute2 != null &&
        selectedColor != null) {
      final colorDetails = productData?['attribute1'][selectedAttribute1]
          ['attribute2'][selectedAttribute2]['colors'][selectedColor];
      if (colorDetails != null) {
        return colorDetails['minquantity'] ?? 1;
      }
    }
    return 1;
  }

  void handleAttribute1Change(String attribute1) {
    setState(() {
      selectedAttribute1 = attribute1;
      selectedAttribute2 = null;
      selectedColor = null;

      updateSelections();
    });
  }

  void handleAttribute2Change(String attribute2) {
    setState(() {
      selectedAttribute2 = attribute2;
      selectedColor = null;

      updateSelections();
    });
  }

  void handleColorChange(String color) {
    setState(() {
      selectedColor = color;
    });
  }

  void handleIncrease() {
    setState(() {
      quantity += 1;
      Fluttertoast.showToast(
        msg: "Quantity Increased: $quantity",
        toastLength: Toast.LENGTH_SHORT,
      );
    });
  }

  void handleDecrease() {
    final minCartValue = getMinCartValue();
    if (quantity > minCartValue) {
      setState(() {
        quantity -= 1;
        Fluttertoast.showToast(
          msg: "Quantity Decreased: $quantity",
          toastLength: Toast.LENGTH_SHORT,
        );
      });
    } else {
      Fluttertoast.showToast(
        msg: "Minimum Quantity Reached: $minCartValue",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
      );
    }
  }

  void handleAddToCart() {
    if (selectedAttribute1 != null &&
        selectedAttribute2 != null &&
        selectedColor != null) {
      final productDetails = productData?['attribute1'][selectedAttribute1]
          ['attribute2'][selectedAttribute2]['colors'][selectedColor];
      if (productDetails != null) {
        final item = {
          'productId': widget.productId,
          'name': productDetails['name'],
          'price': productDetails['price'],
          'color': selectedColor,
          'quantity': quantity,
          'image': productDetails['image'],
          'minCartValue': productDetails['minquantity'],
        };

        // Add item to cart (implement your cart logic here)
        // ...

        Fluttertoast.showToast(
          msg: "Item added to cart",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Incomplete Selection",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final attribute1Options = productData?['attribute1']?.keys.toList() ?? [];
    final attribute2Options = selectedAttribute1 != null
        ? (productData?['attribute1'][selectedAttribute1]['attribute2']
                ?.keys
                .toList() ??
            [])
        : [];
    final colorOptions = selectedAttribute2 != null
        ? (productData?['attribute1'][selectedAttribute1]['attribute2']
                    [selectedAttribute2]['colors']
                ?.keys
                .toList() ??
            [])
        : [];

    final specifications =
        productData?['specifications'] as List<Map<String, String>> ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(productData?['productName'] ?? 'Product Name'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageCarousel(
              images: productData?['images'] ?? [],
              imageIndex:
                  0, // You can manage the image index based on your logic
              loading: loading,
              colorDeliveryTime: productData?['deliveryTime'] ?? 0,
              onPrevious: () {
                // Handle image previous
              },
              onNext: () {
                // Handle image next
              },
            ),
            ProductHeader(
              name: productData?['productName'] ?? 'Product Name',
              description: productData?['description'] ?? '',
              price: productData?['price'] ?? 0.0,
              onCall: () {
                // Handle call button press
              },
            ),
            SpecificationsTable(
              specifications: specifications,
            ),
            AttributesSelector(
              attributeData: productData?['attribute1']
                      ?.entries
                      .map((entry) => {'label': entry.key, 'value': entry.key})
                      .toList() ??
                  [],
              selectedValue: selectedAttribute1 ?? '',
              onSelect: handleAttribute1Change,
              attributeName: 'Attribute 1',
            ),
            if (selectedAttribute1 != null)
              AttributesSelector(
                attributeData: productData?['attribute1'][selectedAttribute1]
                            ['attribute2']
                        ?.entries
                        .map(
                            (entry) => {'label': entry.key, 'value': entry.key})
                        .toList() ??
                    [],
                selectedValue: selectedAttribute2 ?? '',
                onSelect: handleAttribute2Change,
                attributeName: 'Attribute 2',
              ),
            if (selectedAttribute2 != null)
              AttributesSelector(
                attributeData: productData?['attribute1'][selectedAttribute1]
                            ['attribute2'][selectedAttribute2]['colors']
                        ?.entries
                        .map(
                            (entry) => {'label': entry.key, 'value': entry.key})
                        .toList() ??
                    [],
                selectedValue: selectedColor ?? '',
                onSelect: handleColorChange,
                attributeName: 'Color',
              ),
            QuantityControl(
              quantity: quantity,
              minValue: getMinCartValue(),
              onIncrease: handleIncrease,
              onDecrease: handleDecrease,
            ),
            ElevatedButton(
              onPressed: handleAddToCart,
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
