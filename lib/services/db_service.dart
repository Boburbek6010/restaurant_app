import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'restaurant_app.db');

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            stock INTEGER NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 0
          );
        ''');

        await db.execute('''
          CREATE TABLE tables (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            isAvailable INTEGER NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tableId INTEGER NOT NULL,
            totalCost REAL NOT NULL,
            timestamp TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE order_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId INTEGER NOT NULL,
            productId INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            FOREIGN KEY (orderId) REFERENCES orders (id),
            FOREIGN KEY (productId) REFERENCES products (id)
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE products ADD COLUMN quantity INTEGER DEFAULT 0');
        }
      },
    );

    return _database!;
  }

  static Future<void> closeDatabase() async {
    final db = await getDatabase();
    await db.close();
  }
}
