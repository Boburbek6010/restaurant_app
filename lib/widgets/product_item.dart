import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ProductItem({
    Key? key,
    required this.product,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          'https://via.placeholder.com/50', // Placeholder image
          width: 50,
          height: 50,
        ),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ${product.price}'),
            Text('Stock: ${product.stock}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove, color: Colors.red),
              onPressed: onRemove,
            ),
            Text('${product.quantity}', style: TextStyle(fontSize: 18)),
            IconButton(
              icon: Icon(Icons.add, color: Colors.green),
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
