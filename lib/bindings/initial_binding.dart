// Packages
import 'package:get/get.dart';

// Services
import '../../core/services/firebase_service.dart';
import '../../core/services/auth_service.dart';

// Controllers
import '../../presentation/controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Initialize FirebaseService and await its completion
    await Get.putAsync(() => FirebaseService().init(), permanent: true);

    /**
     * Using permanent: true ensures AuthController won’t be disposed when navigating away from pages.
     * 
     */
    // First register AuthService before AuthController
    Get.put(AuthService(), permanent: true);

    // Register AuthController
    Get.put(AuthController(), permanent: true);
  }
}
