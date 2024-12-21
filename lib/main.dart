import 'package:flutter/material.dart';
import 'pages/table_selection_page.dart';
import 'pages/product_selection_page.dart';
import 'pages/order_history_page.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TableSelectionPage(),
        '/products': (context) => ProductSelectionPage(),
        '/orders': (context) => const OrderHistoryPage(),
      },
    );
  }
}
