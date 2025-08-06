// Packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

// Services
import '../services/storage_service.dart';

class Helpers {
  static Future<XFile?> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static Future<String?> uploadItemImage(String itemId, XFile image) async {
    final storageService = StorageService.to;
    final path = 'list_items/$itemId.jpg';
    return await storageService.uploadImage(File(image.path), path);
  }

  static void showLoadingDialog() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
