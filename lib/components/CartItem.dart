class CartItem {
  final String cartId;
  final String productName;
  final double price;
  final int quantity;
  final String image;

  CartItem({
    required this.cartId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      cartId: map['cartId'],
      productName: map['productName'],
      price: map['price'],
      quantity: map['quantity'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }
}
