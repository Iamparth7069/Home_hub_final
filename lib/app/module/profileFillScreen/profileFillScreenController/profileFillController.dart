import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../localStorage/local.dart';
import '../../../../modelClass/user_res_model.dart';
import '../../../../repo/repo_collection.dart';
import '../../../routes/app_pages.dart';

class ProfileFillController extends GetxController{

  ImagePicker imagePicker = ImagePicker();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  File? image;
  bool isSendData = false;
  String? email;
  String? password;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null) {
      email = Get.arguments['email'];
      password = Get.arguments['password'];
      print("Email is ${email}");
    }
  }

  Future<void> pickImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    image = File(file!.path);
    update();
  }
  void changeSendDataValue({required bool value}) {
    isSendData = value;
    update();
  }
  Future<dynamic> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      update();

      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password provided is too weak.');
        return e.code.toString();
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'The account already exists for that email.');
        return e.code.toString();
      } else {
        Get.snackbar('Error', 'Error registering user: ${e.message}');
        return e.code.toString();
      }
    } catch (e) {
      Get.snackbar('Error', 'Error registering user: $e');

      update();
      return "Catech ${e.toString()}";
    }
  }


  Future<void> sedProfileData(UserCredential user) async {
    try {
      String imageUrl = await sendProfileImage(userId: user.user!.uid);
      UserResModel userModel = UserResModel(
          firstName: fNameController.text,
          lastName: lNameController.text,
          phoneNumber: phoneNumberController.text,
          address: addressController.text,
          email: email ?? "",
          uId: user.user!.uid,
          profileImage: imageUrl,
          fcmToken: '');
      await userCollection.doc(userModel.uId).set(userModel.toMap());
      await LocalStorage.sendUserData(userResModel: userModel);

      Get.offAllNamed(Routes.LOGIN);
      isSendData = false;
      update();
    } on FirebaseException catch (firebaseEx) {
      // Handle Firestore-specific errors
      debugPrint("FirebaseException: ${firebaseEx.message}");
      isSendData = false;
      update();
    } on Exception catch (ex) {
      // Handle other types of exceptions
      debugPrint("An error occurred: ${ex.toString()}");
      isSendData = false;
      update();
    }
  }


  Future<String> sendProfileImage({required String userId}) async {
    try {
      isSendData = true;
      update();
      // Create a reference to the Firebase Storage location
      final storageRef = FirebaseStorage.instance.ref();
      // Define the path in the Storage where you want to save the image
      final imageRef = storageRef.child("profileImage/$userId.jpg");

      // Upload the file to Firebase Storage

      if (image != null) {
        final uploadTask = imageRef.putFile(image!);
        // Wait for the upload to complete
        final snapshot = await uploadTask;

        // Get the URL of the uploaded file
        final imageUrl = await snapshot.ref.getDownloadURL();

        return imageUrl;
      } else {
        return "";
      }
    } on FirebaseException catch (e) {
      // Handle any errors
      print(e.toString());
      isSendData = false;
      update();
      return "";
    }
  }

}