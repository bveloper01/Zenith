import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix_enhanced/controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg',
              height: 60,
              width: 200,
              color: Colors.red,
            ),
          ),
        );
      } else {
        if (authController.user.value != null) {
          Future.delayed(Duration.zero, () => Get.offAllNamed('/home'));
        } else {
          Future.delayed(Duration.zero, () => Get.offAllNamed('/login'));
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg',
              height: 60,
              width: 200,
              color: Colors.red,
            ),
          ),
        );
      }
    });
  }
}
