import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderItem extends StatelessWidget {
  final Order order;
  final VoidCallback onDetailsTap;

  const OrderItem({
    Key? key,
    required this.order,
    required this.onDetailsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Table ${order.tableId}'),
        subtitle: Text(
          'Total: ${order.totalCost}\nDate: ${order.timestamp}',
          style: TextStyle(fontSize: 14),
        ),
        trailing: IconButton(
          icon: Icon(Icons.info, color: Colors.blue),
          onPressed: onDetailsTap,
        ),
      ),
    );
  }
}
