// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import '../../controllers/auth_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

// Constants
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Create Account',
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
                  key: controller.registerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedScale(
                        scale: 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Icon(
                          Icons.person_add,
                          size: AppDimensions.iconSizeLarge,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeTitle,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Text(
                        'Join the collaborative shopping experience',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeSubtitle,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge * 2),
                      CustomTextField(
                        controller: controller.displayNameController,
                        hintText: 'Full Name',
                        prefixIcon: Icons.person,
                        validator: (value) =>
                            controller.validateDisplayName(value),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => controller.validateEmail(value),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      Obx(
                        () => CustomTextField(
                          controller: controller.passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock,
                          obscureText: controller.isPasswordHidden.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordHidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          validator: (value) =>
                              controller.validatePassword(value),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      Obx(
                        () => CustomTextField(
                          controller: controller.confirmPasswordController,
                          hintText: 'Confirm Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: controller.isConfirmPasswordHidden.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordHidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.textSecondary,
                            ),
                            onPressed:
                                controller.toggleConfirmPasswordVisibility,
                          ),
                          validator: (value) =>
                              controller.validateConfirmPassword(value),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      Obx(
                        () => CustomButton(
                          text: 'Create Account',
                          isLoading: controller.isLoading.value,
                          onPressed: controller.register,
                          backgroundColor: AppColors.primary,
                          textColor: Colors.white,
                          height: AppDimensions.buttonHeight,
                          borderRadius: AppDimensions.cardBorderRadius,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: AppDimensions.textSizeBody,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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
