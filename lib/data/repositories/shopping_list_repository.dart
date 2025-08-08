// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Models
import '../models/shopping_list_model.dart';

// Services
import '../../core/services/auth_service.dart';

class ShoppingListRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService.to;
  final Uuid _uuid = const Uuid();

  Future<ShoppingListModel> createShoppingList({
    required String title,
    required String description,
  }) async {
    final currentUser = _authService.currentUser!;
    final listId = _uuid.v4();
    final inviteCode = _generateInviteCode();

    final shoppingList = ShoppingListModel(
      id: listId,
      title: title,
      description: description,
      ownerId: currentUser.uid,
      ownerName: currentUser.displayName ?? 'Unknown',
      memberIds: [currentUser.uid],
      memberNames: [currentUser.displayName ?? 'Unknown'],
      inviteCode: inviteCode,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    print('Creating list with memberIds: ${shoppingList.memberIds}');
    await _firestore
        .collection('shopping_lists')
        .doc(listId)
        .set(shoppingList.toMap());

    return shoppingList;
  }

  Future<ShoppingListModel?> joinShoppingListByInviteCode(
    String inviteCode,
  ) async {
    final currentUser = _authService.currentUser!;

    // Search for list with matching inviteCode
    final querySnapshot = await _firestore
        .collection('shopping_lists')
        .where('inviteCode', isEqualTo: inviteCode)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) throw Exception('Invalid invite code');

    final doc = querySnapshot.docs.first;
    final sl = ShoppingListModel.fromMap(doc.data());

    if (sl.memberIds.contains(currentUser.uid)) return sl;

    final updatedMemberIds = [...sl.memberIds, currentUser.uid];
    final updatedMemberNames = [
      ...sl.memberNames,
      currentUser.displayName ?? 'Unknown',
    ];

    await doc.reference.update({
      'memberIds': updatedMemberIds,
      'memberNames': updatedMemberNames,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });

    return sl.copyWith(
      memberIds: updatedMemberIds,
      memberNames: updatedMemberNames,
      updatedAt: DateTime.now(),
    );
  }

  Stream<List<ShoppingListModel>> getUserShoppingLists() {
    final currentUser = _authService.currentUser!;
    print('Fetching lists for user: ${currentUser.uid}');
    return _firestore
        .collection('shopping_lists')
        .where('memberIds', arrayContains: currentUser.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .handleError((e) {
          print('Firestore query error: $e');
          throw e;
        })
        .map((snapshot) {
          final lists = snapshot.docs
              .map((doc) => ShoppingListModel.fromMap(doc.data()))
              .toList();
          print('Fetched ${lists.length} lists');
          return lists;
        });
  }

  Stream<ShoppingListModel?> getShoppingListById(String listId) {
    return _firestore
        .collection('shopping_lists')
        .doc(listId)
        .snapshots()
        .map(
          (doc) => doc.exists ? ShoppingListModel.fromMap(doc.data()!) : null,
        );
  }

  Future<void> leaveShoppingList(String listId) async {
    final currentUser = _authService.currentUser!;
    final doc = await _firestore.collection('shopping_lists').doc(listId).get();

    if (!doc.exists) return;

    final shoppingList = ShoppingListModel.fromMap(doc.data()!);

    if (shoppingList.ownerId == currentUser.uid) {
      await deleteShoppingList(listId);
      return;
    }

    final updatedMemberIds = shoppingList.memberIds
        .where((id) => id != currentUser.uid)
        .toList();
    final updatedMemberNames = List<String>.from(shoppingList.memberNames);
    final userIndex = shoppingList.memberIds.indexOf(currentUser.uid);
    if (userIndex != -1 && userIndex < updatedMemberNames.length) {
      updatedMemberNames.removeAt(userIndex);
    }

    await _firestore.collection('shopping_lists').doc(listId).update({
      'memberIds': updatedMemberIds,
      'memberNames': updatedMemberNames,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> deleteShoppingList(String listId) async {
    final currentUser = _authService.currentUser!;
    final doc = await _firestore.collection('shopping_lists').doc(listId).get();

    if (!doc.exists) return;

    final shoppingList = ShoppingListModel.fromMap(doc.data()!);

    if (shoppingList.ownerId != currentUser.uid) {
      throw Exception('Only the owner can delete this list');
    }

    final itemsSnapshot = await _firestore
        .collection('list_items')
        .where('listId', isEqualTo: listId)
        .get();

    final batch = _firestore.batch();
    for (final itemDoc in itemsSnapshot.docs) {
      batch.delete(itemDoc.reference);
    }

    batch.delete(_firestore.collection('shopping_lists').doc(listId));
    await batch.commit();
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(6, (index) => chars[random % chars.length]).join();
  }
}

extension ShoppingListModelExtension on ShoppingListModel {
  ShoppingListModel copyWith({
    String? id,
    String? title,
    String? description,
    String? ownerId,
    String? ownerName,
    List<String>? memberIds,
    List<String>? memberNames,
    String? inviteCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShoppingListModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      memberIds: memberIds ?? this.memberIds,
      memberNames: memberNames ?? this.memberNames,
      inviteCode: inviteCode ?? this.inviteCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
