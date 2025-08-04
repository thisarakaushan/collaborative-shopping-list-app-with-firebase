// Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  static FirebaseService get to => Get.find();

  Future<FirebaseService> init() async {
    await Firebase.initializeApp();
    return this;
  }
}
