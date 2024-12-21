import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/order_service.dart';

class ProductSelectionPage extends StatefulWidget {
  const ProductSelectionPage({super.key});

  @override
  _ProductSelectionPageState createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  List<Product> products = [];
  List<Product> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final fetchedProducts = await ProductService.fetchProducts();
    setState(() {
      products = fetchedProducts;
    });
  }

  Future<void> _addProduct() async {
    String productName = '';
    double productPrice = 0.0;
    int productStock = 0;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Product Name'),
                onChanged: (value) => productName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => productPrice = double.tryParse(value) ?? 0.0,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) => productStock = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (productName.isNotEmpty && productPrice > 0 && productStock > 0) {
                  await ProductService.addProduct(
                    Product(
                      id: null,
                      name: productName,
                      price: productPrice,
                      stock: productStock,
                      quantity: 0,
                    ),
                  );
                  Navigator.pop(context); // Close dialog
                  _fetchProducts(); // Refresh product list
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid product details!')),
                  );
                }
              },
              child: const Text('Add Product'),
            ),
          ],
        );
      },
    );
  }

  void _toggleProductSelection(Product product) {
    setState(() {
      if (selectedProducts.contains(product)) {
        selectedProducts.remove(product);
      } else {
        selectedProducts.add(product);
      }
    });
  }

  Future<void> _moveToHistoryPage() async {
    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No products selected!')),
      );
      return;
    }

    await OrderService.createOrder(1, selectedProducts); // Save order to DB
    Navigator.pushNamed(context, '/orders'); // Navigate to Order History Page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Selection'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addProduct, // Add new product
          ),
        ],
      ),
      body: products.isEmpty
          ? Center(
        child: Text('No products available. Add a new product!'),
      )
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isSelected = selectedProducts.contains(product);

          return Card(
            child: ListTile(
              title: Text(product.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: ${product.price}, Stock: ${product.stock}'),
                  if (isSelected)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              if (product.quantity > 0) product.quantity--;
                            });
                          },
                        ),
                        Text('Quantity: ${product.quantity}'),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              if (product.quantity < product.stock)
                                product.quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                ],
              ),
              trailing: Checkbox(
                value: isSelected,
                onChanged: (value) {
                  _toggleProductSelection(product);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _moveToHistoryPage, // Move to Order History
      ),
    );
  }
}
