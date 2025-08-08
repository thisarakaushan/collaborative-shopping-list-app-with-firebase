// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import '../../controllers/auth_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';

// Constants
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class VerifyEmailPage extends GetView<AuthController> {
  const VerifyEmailPage({super.key});

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Icon(
                    Icons.email,
                    size: AppDimensions.iconSizeLarge,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                Text(
                  'Verify Your Email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeTitle,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  'A verification email has been sent to ${controller.authService.currentUser?.email ?? "your email"}. Please check your inbox and verify your email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeSubtitle,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.paddingLarge * 2),
                Obx(
                  () => CustomButton(
                    text: 'Check Verification',
                    isLoading: controller.isLoading.value,
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    height: AppDimensions.buttonHeight,
                    borderRadius: AppDimensions.cardBorderRadius,
                    onPressed: () async {
                      try {
                        controller.isLoading.value = true;
                        final isVerified = await controller.authService
                            .isEmailVerified();
                        if (isVerified) {
                          Get.snackbar(
                            'Verified',
                            'Email verified! Please login to continue.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.success,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(
                              AppDimensions.paddingMedium,
                            ),
                            borderRadius: AppDimensions.cardBorderRadius,
                          );
                          await controller.authService.signOut();
                          controller.clearControllers();
                          Get.offAllNamed('/login');
                        } else {
                          Get.snackbar(
                            'Info',
                            'Email not yet verified. Please check your inbox.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.primary,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(
                              AppDimensions.paddingMedium,
                            ),
                            borderRadius: AppDimensions.cardBorderRadius,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Failed to check verification: $e',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.error,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(
                            AppDimensions.paddingMedium,
                          ),
                          borderRadius: AppDimensions.cardBorderRadius,
                          duration: const Duration(seconds: 3),
                        );
                      } finally {
                        controller.isLoading.value = false;
                      }
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                CustomButton(
                  text: 'Resend Verification Email',
                  backgroundColor: AppColors.secondary,
                  textColor: Colors.white,
                  height: AppDimensions.buttonHeight,
                  borderRadius: AppDimensions.cardBorderRadius,
                  onPressed: () async {
                    try {
                      controller.isLoading.value = true;
                      await controller.authService.resendVerificationEmail();
                      Get.snackbar(
                        'Success',
                        'Verification email resent!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.success,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(
                          AppDimensions.paddingMedium,
                        ),
                        borderRadius: AppDimensions.cardBorderRadius,
                        duration: const Duration(seconds: 3),
                      );
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to resend verification email: $e',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.error,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(
                          AppDimensions.paddingMedium,
                        ),
                        borderRadius: AppDimensions.cardBorderRadius,
                        duration: const Duration(seconds: 3),
                      );
                    } finally {
                      controller.isLoading.value = false;
                    }
                  },
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already verified? ',
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeBody,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.clearControllers();
                        Get.offAllNamed('/login');
                      },
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
    );
  }
}
