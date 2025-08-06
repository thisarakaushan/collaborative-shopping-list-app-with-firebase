// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Models
import '../models/list_item_model.dart';

// Services
import '../../core/services/auth_service.dart';

class ListItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService.to;
  final Uuid _uuid = const Uuid();

  Future<ListItemModel> addListItem({
    required String listId,
    required String name,
    required int quantity,
  }) async {
    final currentUser = _authService.currentUser!;
    final itemId = _uuid.v4();

    final listItem = ListItemModel(
      id: itemId,
      listId: listId,
      name: name,
      quantity: quantity,
      isBought: false,
      addedBy: currentUser.uid,
      addedByName: currentUser.displayName ?? 'Unknown',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore.collection('list_items').doc(itemId).set(listItem.toMap());
    await _firestore.collection('shopping_lists').doc(listId).update({
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });

    return listItem;
  }

  Stream<List<ListItemModel>> getListItems(String listId) {
    return _firestore
        .collection('list_items')
        .where('listId', isEqualTo: listId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ListItemModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> updateListItem({
    required String itemId,
    String? name,
    int? quantity,
    bool? isBought,
    String? imageUrl,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };

    if (name != null) updates['name'] = name;
    if (quantity != null) updates['quantity'] = quantity;
    if (isBought != null) updates['isBought'] = isBought;
    if (imageUrl != null) updates['imageUrl'] = imageUrl;

    await _firestore.collection('list_items').doc(itemId).update(updates);

    final itemDoc = await _firestore.collection('list_items').doc(itemId).get();
    if (itemDoc.exists) {
      final listId = itemDoc.data()!['listId'];
      await _firestore.collection('shopping_lists').doc(listId).update({
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<void> deleteListItem(String itemId) async {
    final itemDoc = await _firestore.collection('list_items').doc(itemId).get();
    String? listId;
    if (itemDoc.exists) {
      listId = itemDoc.data()!['listId'];
    }

    await _firestore.collection('list_items').doc(itemId).delete();

    if (listId != null) {
      await _firestore.collection('shopping_lists').doc(listId).update({
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<void> toggleItemBought(String itemId, bool isBought) async {
    await updateListItem(itemId: itemId, isBought: isBought);
  }
}
