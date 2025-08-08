// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import '../../controllers/shopping_list_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

// Constants
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class JoinListPage extends GetView<ShoppingListController> {
  const JoinListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ShoppingListController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Join Shopping List',
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
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.accent.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
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
                child: Form(
                  key: controller.joinListFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedScale(
                        scale: 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Icon(
                          Icons.group_add,
                          size: AppDimensions.iconSizeLarge,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      Text(
                        'Join Existing List',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeTitle,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Text(
                        'Enter the invite code shared with you',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeSubtitle,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge * 2),
                      CustomTextField(
                        controller: controller.inviteCodeController,
                        hintText: 'Invite Code (6 characters)',
                        prefixIcon: Icons.vpn_key,
                        validator: (value) =>
                            controller.validateInviteCode(value),
                        onChanged: (value) {
                          controller.inviteCodeController.text = value
                              .toUpperCase();
                          controller
                              .inviteCodeController
                              .selection = TextSelection.fromPosition(
                            TextPosition(
                              offset:
                                  controller.inviteCodeController.text.length,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      Obx(
                        () => CustomButton(
                          text: 'Join List',
                          isLoading: controller.isLoading.value,
                          onPressed: controller.joinShoppingList,
                          backgroundColor: AppColors.success,
                          textColor: Colors.white,
                          height: AppDimensions.buttonHeight,
                          borderRadius: AppDimensions.cardBorderRadius,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      CustomButton(
                        text: 'Cancel',
                        onPressed: () => Get.back(),
                        isOutlined: true,
                        backgroundColor: AppColors.textSecondary,
                        textColor: AppColors.textSecondary,
                        height: AppDimensions.buttonHeight,
                        borderRadius: AppDimensions.cardBorderRadius,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
