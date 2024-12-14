import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/constraints/extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../constraints/appAssets.dart';
import '../../../../constraints/appColor.dart';
import '../../../../constraints/appString.dart';
import '../controller/onboddingScreenController.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<Onboddingscreencontroller>(
        init: Onboddingscreencontroller(),
        builder: (controller) {
         return Column(
           children: [
              SizedBox(
                height: 80.h,
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    controller.changePageIndex(value);
                  },
                  children: [
                    _page1(),
                    _page2(),
                    _page3(),
                  ],
                ),
              ),
             Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: List.generate(
                 3,
                     (index) {
                   return Container(
                     width: controller.currentPageIndex == index ? 10.w : 2.w,
                     height: 1.h,
                     decoration: BoxDecoration(
                       color: controller.currentPageIndex == index
                           ? AppColor.appColor
                           : AppColor.greyColor.withOpacity(0.2),
                       borderRadius: BorderRadius.circular(
                           controller.currentPageIndex == index ? 10 : 20),
                     ),
                   ).paddingSymmetric(horizontal: 1.w);
                 },
               ),
             ),
             8.h.addHSpace(),
             appButton(
               fontSize: 20,
               color: AppColor.lightBlue,
               text: controller.currentPageIndex == 2 ? "Get Started" : "Next",
               onTap: () {
                 controller.navigateToPage();
               },
             ),
           ],
         );
      },),
    );
  }

  Widget _page1() {
    return Column(
      children: [
        7.h.addHSpace(),
        SizedBox(
          height: 40.h,
          width: 100.w,
          child: assetImage(AppAssets.onBording1, fit: BoxFit.fitWidth),
        ),
        4.h.addHSpace(),
        AppString.onBording1.boldReadex(
            fontColor: AppColor.blackColor, fontSize: 25.sp, textAlign: TextAlign.center)
      ],
    );
  }

  Widget _page2() {
    return Column(
      children: [
        7.h.addHSpace(),
        SizedBox(
          height: 40.h,
          width: 80.w,
          child: assetImage(AppAssets.onBording2, fit: BoxFit.fitWidth),
        ),
        4.h.addHSpace(),
        AppString.onBording2.boldReadex(fontColor: AppColor.blackColor, fontSize: 25.sp, textAlign: TextAlign.center)
      ],
    );
  }

  Widget _page3() {
    return Column(
      children: [
        7.h.addHSpace(),
        SizedBox(
          height: 40.h,
          width: 80.w,
          child: assetImage(AppAssets.onBording3, fit: BoxFit.fitWidth),
        ),
        4.h.addHSpace(),
        AppString.onBording3.boldReadex(fontColor: AppColor.blackColor, fontSize: 25.sp, textAlign: TextAlign.center)
      ],
    );
  }

}
