// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Controllers
import '../../controllers/list_item_controller.dart';
import '../../controllers/shopping_list_controller.dart';

// Models
import '../../../data/models/shopping_list_model.dart';
import '../../../data/models/list_item_model.dart';

// Widgets
import '../../widgets/custom_text_field.dart';
import '../../widgets/list_item_card.dart';

// Constants
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

// Utils
import '../../../core/utils/helpers.dart';

class ListDetailPage extends StatelessWidget {
  const ListDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShoppingListModel shoppingList = Get.arguments as ShoppingListModel;
    final ListItemController listItemController =
        Get.find<ListItemController>();
    // ignore: unused_local_variable
    final ShoppingListController shoppingListController =
        Get.find<ShoppingListController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(shoppingList.title),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Get.snackbar(
                'Invite Code',
                'Share this code: ${shoppingList.inviteCode}',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            color: AppColors.cardBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shoppingList.title,
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeTitle,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (shoppingList.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppDimensions.paddingSmall,
                    ),
                    child: Text(
                      shoppingList.description,
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeSubtitle,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: AppDimensions.iconSizeMedium,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Text(
                      '${shoppingList.memberIds.length} members',
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeBody,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMedium),
                    Icon(
                      Icons.access_time,
                      size: AppDimensions.iconSizeMedium,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Text(
                      DateFormat('MMM dd, yyyy').format(shoppingList.updatedAt),
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeBody,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ListItemModel>>(
              stream: listItemController.repository.getListItems(
                shoppingList.id,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: AppColors.error),
                    ),
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list,
                          size: AppDimensions.iconSizeLarge,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        Text(
                          'No items in this list',
                          style: TextStyle(
                            fontSize: AppDimensions.textSizeTitle,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListItemCard(
                      item: item,
                      onToggleBought: (isBought) => listItemController
                          .toggleItemBought(item.id, isBought),
                      onEdit: () => _showEditItemDialog(
                        context,
                        listItemController,
                        item,
                      ),
                      onDelete: () =>
                          listItemController.deleteListItem(item.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () =>
            _showAddItemDialog(context, listItemController, shoppingList.id),
      ),
    );
  }

  void _showAddItemDialog(
    BuildContext context,
    ListItemController controller,
    String listId,
  ) {
    controller.nameController.clear();
    controller.quantityController.text = '1';
    controller.imageUrl.value = '';
    Get.dialog(
      AlertDialog(
        title: const Text('Add Item'),
        content: Form(
          key: controller.addItemFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: controller.nameController,
                hintText: 'Item Name',
                prefixIcon: Icons.shopping_bag,
                validator: controller.validateItemName,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              CustomTextField(
                controller: controller.quantityController,
                hintText: 'Quantity',
                prefixIcon: Icons.numbers,
                keyboardType: TextInputType.number,
                validator: controller.validateQuantity,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              TextButton(
                onPressed: () async {
                  final image = await Helpers.pickImage();
                  if (image != null) {
                    controller.imageUrl.value = 'uploading';
                    final url = await Helpers.uploadItemImage(
                      'temp_${DateTime.now().millisecondsSinceEpoch}',
                      image,
                    );
                    if (url != null) {
                      controller.imageUrl.value = url;
                    }
                  }
                },
                child: Obx(
                  () => Text(
                    controller.imageUrl.value.isEmpty
                        ? 'Add Image (optional)'
                        : controller.imageUrl.value == 'uploading'
                        ? 'Uploading...'
                        : 'Image Selected',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => controller.addListItem(listId),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(
    BuildContext context,
    ListItemController controller,
    ListItemModel item,
  ) {
    controller.nameController.text = item.name;
    controller.quantityController.text = item.quantity.toString();
    controller.imageUrl.value = item.imageUrl ?? '';
    Get.dialog(
      AlertDialog(
        title: const Text('Edit Item'),
        content: Form(
          key: controller.editItemFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: controller.nameController,
                hintText: 'Item Name',
                prefixIcon: Icons.shopping_bag,
                validator: controller.validateItemName,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              CustomTextField(
                controller: controller.quantityController,
                hintText: 'Quantity',
                prefixIcon: Icons.numbers,
                keyboardType: TextInputType.number,
                validator: controller.validateQuantity,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              TextButton(
                onPressed: () async {
                  final image = await Helpers.pickImage();
                  if (image != null) {
                    controller.imageUrl.value = 'uploading';
                    final url = await Helpers.uploadItemImage(item.id, image);
                    if (url != null) {
                      controller.imageUrl.value = url;
                    }
                  }
                },
                child: Obx(
                  () => Text(
                    controller.imageUrl.value.isEmpty
                        ? 'Add Image (optional)'
                        : controller.imageUrl.value == 'uploading'
                        ? 'Uploading...'
                        : 'Image Selected',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => controller.updateListItem(item.id),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
