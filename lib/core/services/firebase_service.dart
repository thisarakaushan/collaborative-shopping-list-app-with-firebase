// Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

// Firbase options
import './firebase_options.dart';

class FirebaseService extends GetxService {
  static FirebaseService get to => Get.find();

  Future<FirebaseService> init() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
      );
      return this;
    } catch (e) {
      print('Firebase initialization error: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize Firebase. Please check your connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }
}
