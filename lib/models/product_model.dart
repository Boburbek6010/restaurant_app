class Product {
  final int? id;
  final String name;
  final double price;
  final int stock;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.quantity = 0,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      stock: map['stock'],
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'quantity': quantity,
    };
  }
}
