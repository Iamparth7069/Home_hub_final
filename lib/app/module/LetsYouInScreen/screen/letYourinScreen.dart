import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/constraints/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constraints/appAssets.dart';
import '../../../../constraints/appColor.dart';
import '../../../routes/app_pages.dart';
import '../controller/lets_you_in_controller.dart';



class LetsYouInScreen extends StatelessWidget {
  LetsYouInScreen({super.key});
  final Lets_You_in_controller controllers = Get.put(Lets_You_in_controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.h.addHSpace(),
            Center(
              child: AspectRatio(
                aspectRatio: 20 / 12,
                child: SvgPicture.asset(
                  height: 50,
                  AppAssets.loginLogo,
                ),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Center(
                child: ReadexPro("Let's you in")
                    .boldReadex(fontSize: 50, fontColor: Colors.black)),
            SizedBox(
              height: 1.h,
            ),
            createLoginButton(imagePath: "assets/images/facebookLogo.png", onPressed: () async {

              // await controllers.signInWithFacebook();
              // bool? facebook = await controllers.facebookLogin();
              // if (facebook!) {
              //   // Get.offAllNamed(Routes.homeScreen);
              // } else {
              //   Get.snackbar("Error", "Facebook sign-in failed}");
              // }
            },
                text: "Continue with Facebook",
                color: Colors.blueAccent,
                borderColor: Colors.white),
            SizedBox(
              height: 2.h,
            ),

            createLoginButton(imagePath: "assets/images/google.png", onPressed: () async {
              var login = await controllers.signInWithGoogle();
              if (login is UserCredential) {
                // Get.offAllNamed(Routes.homeScreen);
              } else if (login is String) {
                Get.snackbar("Error", "Google sign-in failed: ${login}");
              } else {
                Get.snackbar("Google sign-in failed", "please try again ");
              }
            },
                text: "Continue with Google",
                borderColor: Colors.white),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(height: 3.h),
            // Divider below Apple button
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    flex: 2,
                  ),
                  Expanded(flex: 1, child: Center(child: Text("Or"))),
                  Expanded(
                    flex: 2,
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            // Or Row with Text widgets
            Obx(
                  () => controllers.isLoading.value
                  ? LoadingAnimationWidget.hexagonDots(
                  color: AppColor.appColor, size: 5.h)
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MaterialButton(
                  onPressed: () {
                    Get.toNamed(Routes.LOGIN);
                  },
                  color: AppColor.lightBlue,
                  height: 26,
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  minWidth: double.infinity,
                  child: Center(
                      child: Text(
                        "Sign in with password",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "Don't have an account?".mediumReadex(fontColor: Colors.grey),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.REGISTER);
                    },
                    child: "Sign up".mediumReadex(fontColor: AppColor.lightBlue))
              ],
            )
          ],
        ),
      ),
    );
  }
}
