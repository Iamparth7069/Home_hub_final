import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';



class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _firebaseFirestore = FirebaseFirestore.instance.collection("User");
  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? firebaseUser) {
      user.value = firebaseUser;
    });
  }




  Future<bool> checkEmail() async {
    isLoading(true);
    update();

    try {
      String email = emailController.text.toString().trim();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User') // Assuming your collection is named 'users'
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle the exception, e.g., log it or show a message to the user
      print("Error checking email: $e");
      return false; // Or handle it differently if needed
    } finally {
      isLoading(false);
      update();
    }
  }

}
