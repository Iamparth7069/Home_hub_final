import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constraints/LoadServices.dart';
import '../../../../localStorage/local.dart';
import '../../../../modelClass/offer_responce_model.dart';
import '../../../../modelClass/serviceReponseModel.dart';
import '../../../../modelClass/services.dart';
import '../../../../modelClass/user_res_model.dart';
import '../../../../repo/repo_collection.dart';

class HomeScreenController extends GetxController{
  TextEditingController searchController = TextEditingController();
  LocalStorage storage = LocalStorage();
  RxString uid = ''.obs;
  Rx<Services> services = Services(did: "", servicesName: "", createdAt: "", images: "").obs;
  bool userLoadData = false;
  bool isServicesLoading = false;
  Rx<UserResModel> userData = UserResModel(
      firstName: "",
      lastName: "",
      phoneNumber: "",
      address: "",
      email: "",
      uId: "",
      profileImage: "",
      fcmToken: "").obs;
  List<Services> servicesList = [];
  List<OfferResModel> offerDAta = [];
  bool isSaved = false;
  List<ServiceResponseModel> servicesData = [];
  int popularServicesIndex = 0;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserId();
    loadUserData();
    getAllOfferData();
    loadServicesData();
  }



  Future<void> getUserId() async {
    uid.value = await LocalStorage.getUserId();
    print("User Id ${uid.value}");
  }


  Future<void> loadServicesData() async {
    try {
      isServicesLoading = true;
      update();
      final dataStream = LoadService.getSecondStream();
      dataStream.listen((data) {
        servicesData = data; // Update services data

        print("Services Data ${servicesData}");
        print("DATA LENGTH: ${servicesData.length}");
        isServicesLoading = false; // Update loading state
        update(); // Notify UI only when new data is received
      });
    } catch (e) {
      isServicesLoading = false;
      print("Error loading services data: $e");
      update();
    }finally{
      isServicesLoading = false;
      update();
    }
  }







  Future<void> saveBy(String serviceIds, String userId) async {
    try {

      final docRef = servicesCollection.doc(serviceIds);

      // Use Firestore's array operations for efficient updates
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final savedByList = data['savedBy'] as List<dynamic>? ?? [];

        if (savedByList.contains(userId)) {
          // Remove user ID
          await docRef.update({
            'savedBy': FieldValue.arrayRemove([userId])
          });
          print("User removed from savedBy list.");
        } else {
          // Add user ID
          await docRef.update({
            'savedBy': FieldValue.arrayUnion([userId])
          });
          print("User added to savedBy list.");
        }
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print('Error saving or removing user ID: $e');
    } finally {
      update();
    }
  }




  Future<void> loadUserData() async {
    userLoadData = true;
    update(); // Notify UI once

    try {
      uid.value = await LocalStorage.getUserId();

      if (uid.value.isNotEmpty) {
        final userRef = FirebaseFirestore.instance.collection('User').doc(uid.value);

        // Listen to real-time updates
        userRef.snapshots().listen((snapshot) {
          if (snapshot.exists) {
            userData.value = UserResModel.fromMap(snapshot.data()!);
            print("User data updated.");
          } else {
            print("Data is empty");
          }
        });

        // Load categories
        servicesList = await loadCategory();
        print("Categories loaded: ${servicesList.length}");
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      userLoadData = false;
      update(); // Notify UI once when complete
    }
  }



  Future<List<Services>> loadCategory() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('servicesInfo').get();
      return querySnapshot.docs
          .map((doc) => Services.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  void getAllOfferData() {
    try {
      FirebaseFirestore.instance.collection('offers').snapshots().listen((event) {
        offerDAta = event.docs
            .map((doc) => OfferResModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        print("Offers loaded: ${offerDAta.length}");
        update();
      });
    } catch (e) {
      print("Error loading offers: $e");
    }
  }
}