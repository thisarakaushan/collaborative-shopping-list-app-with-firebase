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

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  key: controller.loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedScale(
                        scale: 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          width: AppDimensions.iconSizeLarge,
                          height: AppDimensions.iconSizeLarge,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.shopping_cart,
                            size: AppDimensions.iconSizeLarge,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      Text(
                        'Shopping List',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeTitle,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Text(
                        'Collaborate with friends and family',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeSubtitle,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge * 2),
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
                      const SizedBox(height: AppDimensions.paddingSmall),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Get.toNamed('/forgot-password'),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      Obx(
                        () => CustomButton(
                          text: 'Login',
                          isLoading: controller.isLoading.value,
                          onPressed: controller.login,
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
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: AppDimensions.textSizeBody,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed('/register'),
                            child: Text(
                              'Register',
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
