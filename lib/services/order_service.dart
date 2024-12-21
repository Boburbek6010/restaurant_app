import '../models/order_model.dart';
import '../models/product_model.dart';
import 'db_service.dart';

class OrderService {
  static Future<int> createOrder(int tableId, List<Product> products) async {
    final db = await DatabaseService.getDatabase();
    final totalCost = products.fold(
        0.0, (sum, product) => sum + (product.price * product.quantity));

    final orderId = await db.insert('orders', {
      'tableId': tableId,
      'totalCost': totalCost,
      'timestamp': DateTime.now().toIso8601String(),
    });

    for (final product in products) {
      await db.insert('order_items', {
        'orderId': orderId,
        'productId': product.id,
        'quantity': product.quantity,
      });
    }

    print('Order saved with ID: $orderId');
    return orderId;
  }

  static Future<List<Order>> fetchOrders() async {
    final db = await DatabaseService.getDatabase();
    final orderList = await db.query('orders');

    final List<Order> orders = [];
    for (final order in orderList) {
      final orderId = order['id'] as int;

      final productList = await db.rawQuery('''
      SELECT p.*, oi.quantity
      FROM order_items oi
      INNER JOIN products p ON oi.productId = p.id
      WHERE oi.orderId = ?
    ''', [orderId]);

      final products = productList.map((product) {
        return Product(
          id: product['id'] as int,
          name: product['name'] as String,
          price: product['price'] as double,
          stock: product['stock'] as int,
          quantity: product['quantity'] as int,
        );
      }).toList();

      orders.add(Order(
        id: orderId,
        tableId: order['tableId'] as int,
        totalCost: order['totalCost'] as double,
        timestamp: DateTime.parse(order['timestamp'] as String),
        products: products,
      ));
    }

    print('Orders fetched: $orders');
    return orders;
  }

  static Future<int> deleteOrder(int orderId) async {
    final db = await DatabaseService.getDatabase();

    await db.delete('order_items', where: 'orderId = ?', whereArgs: [orderId]);

    return await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
  }
}
