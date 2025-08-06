// Pckages
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File image, String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      Get.snackbar(
        'Error',
        'Failed to upload image',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  Future<void> deleteImage(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      print('Image deletion error: $e');
    }
  }
}
