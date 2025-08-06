// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Models
import '../../data/models/shopping_list_model.dart';

// Repositories
import '../../data/repositories/shopping_list_repository.dart';

// Controllers
import '../../presentation/controllers/auth_controller.dart';

// Constants
import '../../core/constants/app_colors.dart';

class DashboardController extends GetxController {
  final ShoppingListRepository shoppingListRepository =
      ShoppingListRepository();
  final AuthController _authController = Get.find<AuthController>();
  final RxBool isLoading = false.obs;

  void goToCreateList() {
    Get.toNamed('/create-list');
  }

  void goToJoinList() {
    Get.toNamed('/join-list');
  }

  void goToListDetail(ShoppingListModel shoppingList) {
    Get.toNamed('/list-detail', arguments: shoppingList);
  }

  Future<void> leaveList(ShoppingListModel shoppingList) async {
    try {
      isLoading.value = true;
      final isOwner =
          shoppingList.ownerId == _authController.currentUser.value?.uid;
      await Get.dialog(
        AlertDialog(
          title: Text(isOwner ? 'Delete List' : 'Leave List'),
          content: Text(
            isOwner
                ? 'Are you sure you want to delete "${shoppingList.title}"? This action cannot be undone.'
                : 'Are you sure you want to leave "${shoppingList.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                await shoppingListRepository.leaveShoppingList(shoppingList.id);
                Get.snackbar(
                  'Success',
                  isOwner
                      ? 'List deleted successfully'
                      : 'Left the list successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                );
              },
              child: Text(
                isOwner ? 'Delete' : 'Leave',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _authController.logout();
  }
}
