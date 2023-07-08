import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  final String title;
  final String message;
  AppSnackBar({
    required this.title,
    required this.message,
  });

  void normalSnackBar() {
    Get.snackbar(title, message);
  }

  void errorSnackBar() {
    Get.back();
    Get.snackbar(title, message,
        backgroundColor: Colors.red.shade700, colorText: Colors.white);
  }
}
