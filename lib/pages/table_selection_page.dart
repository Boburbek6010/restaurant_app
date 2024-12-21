import 'package:flutter/material.dart';
import '../models/table_model.dart';
import '../services/table_service.dart';

class TableSelectionPage extends StatefulWidget {
  @override
  _TableSelectionPageState createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends State<TableSelectionPage> {
  List<TableModel> tables = [];

  @override
  void initState() {
    super.initState();
    _fetchTables();
  }

  Future<void> _fetchTables() async {
    final fetchedTables = await TableService.fetchTables();
    setState(() {
      tables = fetchedTables;
    });
  }

  Future<void> _addTable() async {
    String tableName = '';
    String category = 'Main Hall';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить стол'), // "Add Table"
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Название стола'), // "Table Name"
                onChanged: (value) {
                  tableName = value;
                },
              ),
              DropdownButtonFormField(
                value: category,
                items: ['Main Hall', 'VIP']
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                ))
                    .toList(),
                onChanged: (value) {
                  category = value as String;
                },
                decoration: InputDecoration(labelText: 'Категория'), // "Category"
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Отмена'), // "Cancel"
            ),
            TextButton(
              onPressed: () async {
                if (tableName.isNotEmpty) {
                  await TableService.addTable(
                    TableModel(
                      id: null,
                      name: tableName,
                      category: category,
                      isAvailable: true,
                    ),
                  );
                  Navigator.pop(context);
                  _fetchTables();
                }
              },
              child: Text('Добавить'), // "Add"
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeTable(int tableId) async {
    await TableService.deleteTable(tableId);
    _fetchTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выбор'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: tables.length,
        itemBuilder: (context, index) {
          final table = tables[index];
          return GestureDetector(
            onLongPress: () => _removeTable(table.id!), // Remove on long press
            onTap: () {
              Navigator.pushNamed(context, '/products', arguments: table);
            },
            child: _buildTableCard(table),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addTable, // Add table
      ),
    );
  }

  Widget _buildTableCard(TableModel table) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            table.isAvailable ? Icons.event_seat : Icons.event_busy,
            color: table.isAvailable ? Colors.blue : Colors.red,
            size: 30,
          ),
          SizedBox(height: 10),
          Text(
            table.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
