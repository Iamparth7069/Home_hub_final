import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_final/constraints/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constraints/appAssets.dart';
import '../../../../constraints/appColor.dart';
import '../controller/splash_screen_controller.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  SplashScreenController splashScreenController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.h,
            child: assetImage(AppAssets.appLogo),
          ),
          20.h.addHSpace(),
          LoadingAnimationWidget.hexagonDots(color: AppColor.appColor, size: 5.h),
          15.h.addHSpace(),
        ],
      ),
    );
  }
}
