class ListItemModel {
  final String id;
  final String listId;
  final String name;
  final int quantity;
  final bool isBought;
  final String addedBy;
  final String addedByName;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ListItemModel({
    required this.id,
    required this.listId,
    required this.name,
    required this.quantity,
    required this.isBought,
    required this.addedBy,
    required this.addedByName,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ListItemModel.fromMap(Map<String, dynamic> map) {
    return ListItemModel(
      id: map['id'] ?? '',
      listId: map['listId'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 1,
      isBought: map['isBought'] ?? false,
      addedBy: map['addedBy'] ?? '',
      addedByName: map['addedByName'] ?? '',
      imageUrl: map['imageUrl'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listId': listId,
      'name': name,
      'quantity': quantity,
      'isBought': isBought,
      'addedBy': addedBy,
      'addedByName': addedByName,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
}
