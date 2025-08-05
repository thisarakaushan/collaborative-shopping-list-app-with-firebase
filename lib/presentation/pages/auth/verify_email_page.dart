// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import '../../controllers/auth_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';

class VerifyEmailPage extends GetView<AuthController> {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.email, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Verify Your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A verification email has been sent to ${controller.authService.currentUser?.email ?? "your email"}. Please check your inbox and verify your email.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              Obx(
                () => CustomButton(
                  text: 'Check Verification',
                  isLoading: controller.isLoading.value,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
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
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );

                        // Sign out the user so they can login again
                        await controller.authService.signOut();

                        controller.clearControllers(); // clear fields if needed
                        Get.offAllNamed('/login');
                      } else {
                        Get.snackbar(
                          'Info',
                          'Email not yet verified. Please check your inbox.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to check verification: $e',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                    } finally {
                      controller.isLoading.value = false;
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Resend Verification Email',
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                onPressed: () async {
                  try {
                    controller.isLoading.value = true;
                    await controller.authService.resendVerificationEmail();
                    Get.snackbar(
                      'Success',
                      'Verification email resent!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to resend verification email: $e',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                  } finally {
                    controller.isLoading.value = false;
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already verified? '),
                  TextButton(
                    onPressed: () {
                      controller.clearControllers();
                      Get.offAllNamed('/login');
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
