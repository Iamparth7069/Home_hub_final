import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../localStorage/local.dart';
import '../../../routes/app_pages.dart';


class SplashScreenController extends GetxController {
  String displayText = '';
  int index = 0;
  final String _fullText = 'Help Harbor';

  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() async {
    // Delayed navigation for splash screen effect
    await Future.delayed(const Duration(seconds: 3));

    // Retrieve values from local storage
    final box = GetStorage();
    final isOnboarded = box.read(LocalStorage.onBodding) ?? false; // Check if onboarding is completed
    final userId = box.read(LocalStorage.uid); // Check if user is logged in

    if (userId == null) {
      // User is not logged in
      if (!isOnboarded) {
        // Navigate to onboarding screen if not completed
        Get.offAllNamed(Routes.ONBODDINGSCREEN);
      } else {
        // Navigate to login screen if onboarding is completed
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      // User is logged in, navigate to bottom navigation bar
      Get.offAllNamed(Routes.bottomNavBar);
    }
  }

}
