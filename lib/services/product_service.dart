import '../models/product_model.dart';
import 'db_service.dart';

class ProductService {

  static Future<int> addProduct(Product product) async {
    final db = await DatabaseService.getDatabase();
    return await db.insert('products', product.toMap());
  }

  static Future<List<Product>> fetchProducts() async {
    final db = await DatabaseService.getDatabase();
    final result = await db.query('products');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  static Future<int> deleteProduct(int productId) async {
    final db = await DatabaseService.getDatabase();
    return await db.delete('products', where: 'id = ?', whereArgs: [productId]);
  }

  static Future<int> updateProductStock(int productId, int newStock) async {
    final db = await DatabaseService.getDatabase();
    return await db.update(
      'products',
      {'stock': newStock},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

}
