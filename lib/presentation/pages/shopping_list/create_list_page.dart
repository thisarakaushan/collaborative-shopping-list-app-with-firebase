// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import '../../controllers/shopping_list_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

class CreateListPage extends GetView<ShoppingListController> {
  const CreateListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.createList),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: controller.createListFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.create,
                    size: AppDimensions.iconSizeLarge,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  Text(
                    AppStrings.createList,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeTitle,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    AppStrings.welcomeMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeSubtitle,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge * 2),
                  CustomTextField(
                    controller: controller.titleController,
                    hintText: 'List Title',
                    prefixIcon: Icons.title,
                    validator: controller.validateTitle,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  CustomTextField(
                    controller: controller.descriptionController,
                    hintText: 'Description (optional)',
                    prefixIcon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  Obx(
                    () => CustomButton(
                      text: AppStrings.createList,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.createShoppingList,
                      backgroundColor: AppColors.primary,
                      height: AppDimensions.buttonHeight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
