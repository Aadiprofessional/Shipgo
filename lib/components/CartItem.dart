class CartItem {
  final String cartId;
  final String itemName;
  final double price;
  final int quantity;
  final String color; // Add this field
  final String image; // Add this field

  CartItem({
    required this.cartId,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.color,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
      'color': color, // Add this field
      'image': image, // Add this field
    };
  }

 factory CartItem.fromMap(Map<String, dynamic> map) {
  return CartItem(
    cartId: map['cartId'] ?? '',
    itemName: map['itemName'] ?? '',
    price: map['price']?.toDouble() ?? 0.0,
    quantity: map['quantity']?.toInt() ?? 1,
    color: map['color'] ?? 'Unknown Color', // Default value for color
    image: map['image'] ?? 'default_image_url', // Default value for image
  );
}

}
