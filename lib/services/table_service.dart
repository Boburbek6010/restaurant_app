import '../models/table_model.dart';
import 'db_service.dart';

class TableService {
  static Future<int> addTable(TableModel table) async {
    final db = await DatabaseService.getDatabase();
    return await db.insert('tables', table.toMap());
  }

  static Future<List<TableModel>> fetchTables() async {
    final db = await DatabaseService.getDatabase();
    final result = await db.query('tables');
    return result.map((map) => TableModel.fromMap(map)).toList();
  }

  static Future<int> deleteTable(int tableId) async {
    final db = await DatabaseService.getDatabase();
    return await db.delete('tables', where: 'id = ?', whereArgs: [tableId]);
  }

  static Future<int> updateTableAvailability(int tableId, bool isAvailable) async {
    final db = await DatabaseService.getDatabase();
    return await db.update(
      'tables',
      {'isAvailable': isAvailable ? 1 : 0},
      where: 'id = ?',
      whereArgs: [tableId],
    );
  }
}
