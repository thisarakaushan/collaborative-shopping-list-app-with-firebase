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
    await Get.putAsync(() => FirebaseService().init());

    // First register AuthService before AuthController
    Get.put(AuthService());

    // Register AuthController
    Get.put(AuthController());
  }
}
