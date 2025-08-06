// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Repositories
import '../../data/repositories/list_item_repository.dart';

// Utils
import '../../core/utils/validators.dart';
import '../../core/utils/helpers.dart';

class ListItemController extends GetxController {
  final ListItemRepository repository = ListItemRepository();
  final GlobalKey<FormState> addItemFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> editItemFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString imageUrl = ''.obs;

  @override
  void onClose() {
    nameController.dispose();
    quantityController.dispose();
    super.onClose();
  }

  String? validateItemName(String? value) => Validators.validateItemName(value);

  String? validateQuantity(String? value) => Validators.validateQuantity(value);

  Future<void> addListItem(String listId) async {
    if (!addItemFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final listItem = await repository.addListItem(
        listId: listId,
        name: nameController.text.trim(),
        quantity: int.parse(quantityController.text.trim()),
      );

      // Handle image upload
      if (imageUrl.value.isNotEmpty) {
        final image = await Helpers.pickImage();
        if (image != null) {
          final uploadedUrl = await Helpers.uploadItemImage(listItem.id, image);
          if (uploadedUrl != null) {
            await repository.updateListItem(
              itemId: listItem.id,
              imageUrl: uploadedUrl,
            );
          }
        }
      }

      nameController.clear();
      quantityController.clear();
      imageUrl.value = '';
      Get.back();
      Get.snackbar(
        'Success',
        'Item added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateListItem(
    String itemId, {
    String? name,
    int? quantity,
    String? imageUrl,
  }) async {
    if (!editItemFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      await repository.updateListItem(
        itemId: itemId,
        name: name ?? nameController.text.trim(),
        quantity: quantity ?? int.parse(quantityController.text.trim()),
        imageUrl: '',
      );

      if (imageUrl != null && imageUrl.isNotEmpty) {
        final image = await Helpers.pickImage();
        if (image != null) {
          final uploadedUrl = await Helpers.uploadItemImage(itemId, image);
          if (uploadedUrl != null) {
            await repository.updateListItem(
              itemId: itemId,
              imageUrl: uploadedUrl,
            );
          }
        }
      }

      nameController.clear();
      quantityController.clear();
      this.imageUrl.value = '';
      Get.back();
      Get.snackbar(
        'Success',
        'Item updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleItemBought(String itemId, bool isBought) async {
    try {
      isLoading.value = true;
      await repository.toggleItemBought(itemId, isBought);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteListItem(String itemId) async {
    try {
      isLoading.value = true;
      await repository.deleteListItem(itemId);
      Get.snackbar(
        'Success',
        'Item deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
