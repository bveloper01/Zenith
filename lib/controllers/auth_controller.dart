import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  var obscureText = true.obs;
  var obscureText2 = true.obs;
  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void toggleObscureText2() {
    obscureText2.value = !obscureText2.value;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;

    ever(user, (_) {
      if (user.value != null) {
        _updateUserData();
      }
    });

    _auth.authStateChanges().listen((User? newUser) {
      user.value = newUser;
      isLoading.value = false;
    });
  }

  Future<void> _updateUserData() async {
    if (user.value != null) {
      await _firestore.collection('users').doc(user.value!.uid).set({
        'email': user.value!.email,
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/mood_detection');
    } catch (e) {
      Get.snackbar(
        'Error signing in',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/mood_detection');
    } catch (e) {
      Get.snackbar(
        'Error signing up',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}
