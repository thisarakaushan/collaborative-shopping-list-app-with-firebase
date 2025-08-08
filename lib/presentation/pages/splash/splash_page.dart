// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Services
import '../../../core/services/firebase_service.dart';

// Controllers
import '../../controllers/auth_controller.dart';

// Routes
import '../../../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // Alignment _alignment = Alignment.centerLeft;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Start animation
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _visible = true;
      });
    });

    // Continue with app initialization
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('[SplashPage] Initializing...');
      await Future.delayed(const Duration(seconds: 2)); // Let animation finish
      await Get.find<FirebaseService>().init();
      final authController = Get.find<AuthController>();
      final user = authController.authService.currentUser;
      if (user != null) {
        final isVerified = await authController.authService.isEmailVerified();
        if (isVerified) {
          await authController.loadUserData(user.uid);
          Get.offAllNamed(AppRoutes.DASHBOARD);
        } else {
          Get.offAllNamed(AppRoutes.VERIFY_EMAIL);
        }
      } else {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      print('[SplashPage] Initialization error: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize app. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: AnimatedScale(
                scale: _visible ? 1.1 : 0.9,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                child: Image.asset(
                  'assets/images/app_icon.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Shopping List',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Collaborate with friends and family',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
