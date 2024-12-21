import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final fetchedOrders = await OrderService.fetchOrders();
    setState(() {
      orders = fetchedOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('No orders found'))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            child: ListTile(
              title: Text('Table: ${order.tableId}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Cost: ${order.totalCost.toStringAsFixed(2)}'),
                  Text('Timestamp: ${order.timestamp}'),
                  const SizedBox(height: 5),
                  const Text(
                    'Products:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...order.products.map(
                        (product) => Text(
                        '${product.name} - ${product.quantity} x ${product.price.toStringAsFixed(2)}'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
