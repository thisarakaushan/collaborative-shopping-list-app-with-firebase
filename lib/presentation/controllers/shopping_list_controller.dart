// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Repository
import '../../data/repositories/shopping_list_repository.dart';

// Utils
import '../../core/utils/validators.dart';

class ShoppingListController extends GetxController {
  final ShoppingListRepository _repository = ShoppingListRepository();
  final GlobalKey<FormState> createListFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> joinListFormKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController inviteCodeController = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    inviteCodeController.dispose();
    super.onClose();
  }

  String? validateTitle(String? value) => Validators.validateTitle(value);

  String? validateInviteCode(String? value) =>
      Validators.validateInviteCode(value);

  Future<void> createShoppingList() async {
    if (!createListFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final shoppingList = await _repository.createShoppingList(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
      );
      titleController.clear();
      descriptionController.clear();
      Get.back();
      Get.snackbar(
        'Success',
        'List "${shoppingList.title}" created! Invite code: ${shoppingList.inviteCode}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.toNamed('/list-detail', arguments: shoppingList);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinShoppingList() async {
    if (!joinListFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final inviteCode = inviteCodeController.text
          .trim(); // Now acting as List ID input
      final shoppingList = await _repository.joinShoppingListByInviteCode(
        inviteCode,
      );

      if (shoppingList != null) {
        inviteCodeController.clear();
        Get.back();
        Get.snackbar(
          'Success',
          'Joined "${shoppingList.title}" successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed('/list-detail', arguments: shoppingList);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
