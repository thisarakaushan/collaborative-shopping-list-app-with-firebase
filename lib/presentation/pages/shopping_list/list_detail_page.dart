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
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/loading_widget.dart';

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
        title: Text(
          shoppingList.title,
          style: TextStyle(
            fontSize: AppDimensions.textSizeTitle,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 2,
        shadowColor: AppColors.textSecondary.withOpacity(0.2),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: AppDimensions.iconSizeMedium,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.paddingMedium),
            child: CustomButton(
              text: 'Share',
              icon: Icons.share,
              onPressed: () {
                Get.snackbar(
                  'Invite Code',
                  'Share this code: ${shoppingList.inviteCode}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.primary,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(AppDimensions.paddingMedium),
                  borderRadius: AppDimensions.cardBorderRadius,
                );
              },
              height: AppDimensions.buttonHeight,
              backgroundColor: AppColors.accent,
              textColor: AppColors.textPrimary,
              borderRadius: AppDimensions.cardBorderRadius,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(AppDimensions.paddingMedium),
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.accent.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(
                AppDimensions.cardBorderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textSecondary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    shoppingList.title,
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeTitle,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
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
                        height: 1.3,
                      ),
                    ),
                  ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSmall,
                        vertical: AppDimensions.paddingSmall / 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardBorderRadius / 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: AppDimensions.iconSizeMedium,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppDimensions.paddingSmall / 2),
                          Text(
                            '${shoppingList.memberIds.length} members',
                            style: TextStyle(
                              fontSize: AppDimensions.textSizeBody,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMedium),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSmall,
                        vertical: AppDimensions.paddingSmall / 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardBorderRadius / 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: AppDimensions.iconSizeMedium,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: AppDimensions.paddingSmall / 2),
                          Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(shoppingList.updatedAt),
                            style: TextStyle(
                              fontSize: AppDimensions.textSizeBody,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Trigger a refresh of the stream
                listItemController.repository.getListItems(shoppingList.id);
              },
              color: AppColors.primary,
              child: StreamBuilder<List<ListItemModel>>(
                stream: listItemController.repository.getListItems(
                  shoppingList.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget(
                      message: 'Loading items...',
                      size: AppDimensions.iconSizeLarge,
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: AppDimensions.iconSizeLarge,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: AppDimensions.paddingMedium),
                          Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(
                              fontSize: AppDimensions.textSizeSubtitle,
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDimensions.paddingMedium),
                          CustomButton(
                            text: 'Retry',
                            onPressed: () {
                              listItemController.repository.getListItems(
                                shoppingList.id,
                              );
                            },
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            height: AppDimensions.buttonHeight,
                            borderRadius: AppDimensions.cardBorderRadius,
                          ),
                        ],
                      ),
                    );
                  }
                  final items = snapshot.data ?? [];
                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: AppDimensions.iconSizeLarge,
                              color: AppColors.textSecondary,
                            ),
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
                          const SizedBox(height: AppDimensions.paddingMedium),
                          CustomButton(
                            text: 'Add Your First Item',
                            icon: Icons.add,
                            onPressed: () => _showAddItemDialog(
                              context,
                              listItemController,
                              shoppingList.id,
                            ),
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            height: AppDimensions.buttonHeight,
                            borderRadius: AppDimensions.cardBorderRadius,
                          ),
                        ],
                      ),
                    );
                  }
                  final pendingItems = items
                      .where((item) => !item.isBought)
                      .toList();
                  final boughtItems = items
                      .where((item) => item.isBought)
                      .toList();
                  return ListView(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    children: [
                      if (pendingItems.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMedium,
                            vertical: AppDimensions.paddingSmall,
                          ),
                          child: Text(
                            'Pending Items',
                            style: TextStyle(
                              fontSize: AppDimensions.textSizeSubtitle,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        ...pendingItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return AnimatedOpacity(
                            opacity: 1.0,
                            duration: Duration(
                              milliseconds: 300 + (index * 100),
                            ),
                            child: ListItemCard(
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
                            ),
                          );
                        }).toList(),
                        const Divider(
                          height: AppDimensions.paddingLarge,
                          thickness: 1,
                        ),
                      ],
                      if (boughtItems.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMedium,
                            vertical: AppDimensions.paddingSmall,
                          ),
                          child: Text(
                            'Bought Items',
                            style: TextStyle(
                              fontSize: AppDimensions.textSizeSubtitle,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        ...boughtItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return AnimatedOpacity(
                            opacity: 1.0,
                            duration: Duration(
                              milliseconds: 300 + (index * 100),
                            ),
                            child: ListItemCard(
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
                            ),
                          );
                        }).toList(),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: CustomButton(
          text: 'Add Item',
          icon: Icons.add,
          onPressed: () =>
              _showAddItemDialog(context, listItemController, shoppingList.id),
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          height: AppDimensions.buttonHeight,
          borderRadius: AppDimensions.cardBorderRadius,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
          ),
          elevation: 8,
          backgroundColor: AppColors.cardBackground,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Form(
              key: controller.addItemFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Item',
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeTitle,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
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
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomButton(
                          text: controller.imageUrl.value.isEmpty
                              ? 'Add Image (optional)'
                              : controller.imageUrl.value == 'uploading'
                              ? 'Uploading...'
                              : 'Change Image',
                          icon: Icons.image,
                          onPressed: controller.imageUrl.value == 'uploading'
                              ? null
                              : () async {
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
                          isOutlined: true,
                          backgroundColor: AppColors.primary,
                          textColor: AppColors.primary,
                          height: AppDimensions.buttonHeight,
                          borderRadius: AppDimensions.cardBorderRadius,
                        ),
                        if (controller.imageUrl.value.isNotEmpty &&
                            controller.imageUrl.value != 'uploading')
                          Padding(
                            padding: const EdgeInsets.only(
                              top: AppDimensions.paddingSmall,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.cardBorderRadius,
                              ),
                              child: Image.network(
                                controller.imageUrl.value,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 100,
                                      width: 100,
                                      color: AppColors.background,
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: AppColors.textSecondary,
                                        size: AppDimensions.iconSizeMedium,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: 'Cancel',
                        onPressed: () => Get.back(),
                        isOutlined: true,
                        backgroundColor: AppColors.textSecondary,
                        textColor: AppColors.textSecondary,
                        height: AppDimensions.buttonHeight,
                        borderRadius: AppDimensions.cardBorderRadius,
                      ),
                      const SizedBox(width: AppDimensions.paddingMedium),
                      CustomButton(
                        text: 'Add',
                        onPressed: () => controller.addListItem(listId),
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                        height: AppDimensions.buttonHeight,
                        borderRadius: AppDimensions.cardBorderRadius,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
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
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
          ),
          elevation: 8,
          backgroundColor: AppColors.cardBackground,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Form(
              key: controller.editItemFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Item',
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeTitle,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
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
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomButton(
                          text: controller.imageUrl.value.isEmpty
                              ? 'Add Image (optional)'
                              : controller.imageUrl.value == 'uploading'
                              ? 'Uploading...'
                              : 'Change Image',
                          icon: Icons.image,
                          onPressed: controller.imageUrl.value == 'uploading'
                              ? null
                              : () async {
                                  final image = await Helpers.pickImage();
                                  if (image != null) {
                                    controller.imageUrl.value = 'uploading';
                                    final url = await Helpers.uploadItemImage(
                                      item.id,
                                      image,
                                    );
                                    if (url != null) {
                                      controller.imageUrl.value = url;
                                    }
                                  }
                                },
                          isOutlined: true,
                          backgroundColor: AppColors.primary,
                          textColor: AppColors.primary,
                          height: AppDimensions.buttonHeight,
                          borderRadius: AppDimensions.cardBorderRadius,
                        ),
                        if (controller.imageUrl.value.isNotEmpty &&
                            controller.imageUrl.value != 'uploading')
                          Padding(
                            padding: const EdgeInsets.only(
                              top: AppDimensions.paddingSmall,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.cardBorderRadius,
                              ),
                              child: Image.network(
                                controller.imageUrl.value,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 100,
                                      width: 100,
                                      color: AppColors.background,
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: AppColors.textSecondary,
                                        size: AppDimensions.iconSizeMedium,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: 'Cancel',
                        onPressed: () => Get.back(),
                        isOutlined: true,
                        backgroundColor: AppColors.textSecondary,
                        textColor: AppColors.textSecondary,
                        height: AppDimensions.buttonHeight,
                        borderRadius: AppDimensions.cardBorderRadius,
                      ),
                      const SizedBox(width: AppDimensions.paddingMedium),
                      CustomButton(
                        text: 'Save',
                        onPressed: () => controller.updateListItem(item.id),
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                        height: AppDimensions.buttonHeight,
                        borderRadius: AppDimensions.cardBorderRadius,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }
}
