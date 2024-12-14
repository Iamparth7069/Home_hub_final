import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constraints/extension.dart';
import '../../../routes/app_pages.dart';

class ForgetScreenController extends GetxController{

  TextEditingController email = TextEditingController();
  Future<void> checkUserAndSendResetLink(String email) async {
    final usersCollection = FirebaseFirestore.instance.collection('User');
    final querySnapshot = await usersCollection.where('email', isEqualTo: email).get();
    if(querySnapshot.docs.isNotEmpty){
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then(
              (value) {
            Get.offAllNamed(Routes.LOGIN);
          },
        );
        showMessege(
            title: "Hurray", messege: "Password Reset Link Sent to Your Email");
        print("Password reset email sent.");

      } on FirebaseAuthException catch (e) {
        print("Failed to send password reset email: ${e.message}");
        showMessege(
            title: "Opps! Somethingg Went Wrong",
            messege: "Please Try After Some time");
        // Handle errors, maybe show a dialog to the user
      }
    }else{
      print("No user associated with this email.");
      showMessege(
          title: "Opps! Somethingg Went Wrong",
          messege: "User Not Fount with this Email");

    }
  }
}