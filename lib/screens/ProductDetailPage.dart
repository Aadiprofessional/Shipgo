import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:provider/provider.dart';
import 'package:shipgo/components/CartItem.dart';
import 'package:shipgo/components/cartContext.dart';
import 'package:shipgo/components/productDetail/AttributesSelector.dart';
import 'package:shipgo/components/productDetail/ImageCarousel.dart';
import 'package:shipgo/components/productDetail/ProductHeader.dart';
import 'package:shipgo/components/productDetail/QuantityControl.dart';
import 'package:shipgo/components/productDetail/SpecificationsTable.dart';
import 'package:shipgo/styles/colors.dart';

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
  bool loading = true;
  String? selectedStorage;
  String? selectedRam;
  String? selectedColor;
  int imageIndex = 0;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    final url = 'https://test-one-nu-30.vercel.app/api/product-details';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'categoryId': widget.categoryId,
        'productId': widget.productId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        productData = data['data'] as Map<String, dynamic>?;
        loading = false;

        // Set default selections
        if (productData != null && productData!.isNotEmpty) {
          selectedStorage = productData!.keys.first;
          selectedRam = (productData![selectedStorage] as Map<String, dynamic>)
              .keys
              .first;
          selectedColor = (productData![selectedStorage]![selectedRam]
                  as Map<String, dynamic>)
              .keys
              .first;
        }
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

 Future<void> addToCart() async {
  if (selectedStorage == null ||
      selectedRam == null ||
      selectedColor == null ||
      productData == null) {
    return;
  }

  final colorDetails =
      (productData![selectedStorage]![selectedRam]![selectedColor]
          as Map<String, dynamic>);
  
  // Generate a unique cartId using Firestore's DocumentReference
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User not authenticated')),
    );
    return;
  }

  final cartRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart')
      .doc(); // This will generate a new DocumentReference with a unique ID

  final cartId = cartRef.id; // Get the generated ID

  final cartItem = CartItem(
    cartId: cartId, // Set the cartId to the generated ID
    name: colorDetails['product'] ?? 'Unknown Product',
    price: double.tryParse(colorDetails['price'] ?? '0') ?? 0.0,
    quantity: quantity,
    
    image: colorDetails['image'] ??
        'default_image_url', // Provide a default image URL
  );

  await cartRef.set(cartItem.toMap()); // Use the generated DocumentReference to add the item

  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  cartProvider.addItemToCart(cartItem);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Item added to cart')),
  );
}


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
          backgroundColor: Color(0xFF25424D),
          foregroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (productData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
          backgroundColor: Color(0xFF25424D),
          foregroundColor: Colors.white,
        ),
        body: Center(child: Text('No product data available')),
      );
    }

    // Extract storage options
    final storageOptions = productData!.keys.map((key) {
      return {
        'value': key.toString(),
        'label': key.toString(),
      };
    }).toList();

    // Extract RAM options based on selected storage
    final ramOptions =
        (selectedStorage != null && productData![selectedStorage] != null)
            ? (productData![selectedStorage] as Map<String, dynamic>)
                .keys
                .map((key) {
                return {
                  'value': key.toString(),
                  'label': key.toString(),
                };
              }).toList()
            : <Map<String, String>>[];

    // Extract color options based on selected RAM
    final colorOptions = (selectedRam != null &&
            productData![selectedStorage]?[selectedRam] != null)
        ? (productData![selectedStorage]![selectedRam] as Map<String, dynamic>)
            .keys
            .map((key) {
            return {
              'value': key.toString(),
              'label': key.toString(),
            };
          }).toList()
        : <Map<String, String>>[];

    // Extract details of the selected color
    final colorDetails = (selectedColor != null &&
            productData![selectedStorage]?[selectedRam]?[selectedColor] != null)
        ? (productData![selectedStorage]![selectedRam]![selectedColor]
            as Map<String, dynamic>)
        : {};

    final List<String> imageUrls = [colorDetails['image']?.toString() ?? ''];
    final int colorDeliveryTime =
        int.tryParse(colorDetails['deliveryTime']?.toString() ?? '0') ?? 0;
    final productName = colorDetails['product']?.toString() ?? 'N/A';
    final productDescription = colorDetails['description']?.toString() ?? 'N/A';
    final productPrice =
        double.tryParse(colorDetails['price']?.toString() ?? '0') ?? 0;
    final minCartValue =
        int.tryParse(colorDetails['minCartValue']?.toString() ?? '1') ?? 1;
    final specifications =
        (colorDetails['specification'] as List<dynamic>?)?.map((item) {
              final spec = item as Map<String, dynamic>;
              return {
                'label': spec['label']?.toString() ?? '',
                'value': spec['value']?.toString() ?? '',
              };
            }).toList() ??
            [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Color(0xFF25424D),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrls.isNotEmpty)
                ImageCarousel(
                  images: imageUrls,
                  imageIndex: imageIndex,
                  loading: false,
                  colorDeliveryTime: colorDeliveryTime,
                  onPrevious: () {
                    setState(() {
                      imageIndex = (imageIndex - 1 + imageUrls.length) %
                          imageUrls.length;
                    });
                  },
                  onNext: () {
                    setState(() {
                      imageIndex = (imageIndex + 1) % imageUrls.length;
                    });
                  },
                ),
              ProductHeader(
                name: productName,
                description: productDescription,
                price: productPrice,
                onCall: () {
                  // Handle call action
                },
              ),
              QuantityControl(
                minValue: minCartValue,
                onIncrease: () {
                  setState(() {
                    quantity++;
                  });
                },
                onDecrease: () {
                  setState(() {
                    if (quantity > minCartValue) {
                      quantity--;
                    }
                  });
                },
              ),
              AttributesSelector(
                attributeData: storageOptions,
                selectedValue: selectedStorage ?? '',
                onSelect: (value) {
                  setState(() {
                    selectedStorage = value;
                    selectedRam =
                        (productData![selectedStorage] as Map<String, dynamic>)
                            .keys
                            .first;
                    selectedColor = (productData![selectedStorage]![selectedRam]
                            as Map<String, dynamic>)
                        .keys
                        .first;
                  });
                },
                attributeName: 'Storage',
              ),
              if (selectedStorage != null)
                AttributesSelector(
                  attributeData: ramOptions,
                  selectedValue: selectedRam ?? '',
                  onSelect: (value) {
                    setState(() {
                      selectedRam = value;
                      selectedColor =
                          (productData![selectedStorage]![selectedRam]
                                  as Map<String, dynamic>)
                              .keys
                              .first;
                    });
                  },
                  attributeName: 'RAM',
                ),
              if (selectedRam != null)
                AttributesSelector(
                  attributeData: colorOptions,
                  selectedValue: selectedColor ?? '',
                  onSelect: (value) {
                    setState(() {
                      selectedColor = value;
                    });
                  },
                  attributeName: 'Color',
                ),
              if (selectedColor != null && colorDetails.isNotEmpty)
                SpecificationsTable(
                  specifications: specifications,
                ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    child: Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.main,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      addToCart();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
