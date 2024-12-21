import 'package:restaurant_app/models/product_model.dart';

class Order {
  final int id;
  final int tableId;
  final List<Product> products;
  final double totalCost;
  final DateTime timestamp;

  Order({
    required this.id,
    required this.tableId,
    required this.products,
    required this.totalCost,
    required this.timestamp,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      tableId: map['tableId'],
      products: (map['products'] as List)
          .map((productMap) => Product.fromMap(productMap))
          .toList(),
      totalCost: map['totalCost'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableId': tableId,
      'products': products.map((product) => product.toMap()).toList(),
      'totalCost': totalCost,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
