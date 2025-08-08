// Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

// Firbase options
// import './firebase_options.dart';

class FirebaseService extends GetxService {
  static FirebaseService get to => Get.find();

  Future<FirebaseService> init() async {
    try {
      // await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
      await Firebase.initializeApp();
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
      );
      // Enable Firestore offline persistence
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
      );
      print('Firebase initialized successfully with App Check');
      return this;
    } catch (e) {
      print('Firebase initialization error: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize Firebase. Please check your connection and try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
}
