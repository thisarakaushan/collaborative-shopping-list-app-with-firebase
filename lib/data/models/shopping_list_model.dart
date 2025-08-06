class ShoppingListModel {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final String ownerName;
  final List<String> memberIds;
  final List<String> memberNames;
  final String inviteCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShoppingListModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.ownerName,
    required this.memberIds,
    required this.memberNames,
    required this.inviteCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShoppingListModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
      memberNames: List<String>.from(map['memberNames'] ?? []),
      inviteCode: map['inviteCode'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'memberIds': memberIds,
      'memberNames': memberNames,
      'inviteCode': inviteCode,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
}
