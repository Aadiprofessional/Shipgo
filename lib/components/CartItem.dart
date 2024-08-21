class CartItem {
  final String cartId;
  final String name;
  final double price;
  int quantity;
  final String image; // New field for image URL

  CartItem({
    required this.cartId,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.image, // Add image URL to the constructor
  });

  // Implement the fromMap method
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      cartId: map['cartId'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
      image: map['imageUrl'], // Add image URL to fromMap
    );
  }

  // Implement the copyWith method
  CartItem copyWith({
    String? cartId,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl, // Add image URL to copyWith
  }) {
    return CartItem(
      cartId: cartId ?? this.cartId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: imageUrl ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': image, // Add image URL to toMap
    };
  }
}
