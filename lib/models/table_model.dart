class TableModel {
  final int? id;
  final String name;
  final String category;
  final bool isAvailable;

  TableModel({
    required this.id,
    required this.name,
    required this.category,
    required this.isAvailable,
  });

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      isAvailable: map['isAvailable'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'isAvailable': isAvailable ? 1 : 0,
    };
  }
}
