import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_final/constraints/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../constraints/appAssets.dart';
import '../../../../constraints/appColor.dart';
import '../../../routes/app_pages.dart';
import '../controller/register_controller.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final RegisterController _registerController = Get.put(RegisterController());
  final _globel = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              key: _globel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.w.addHSpace(),
                  Center(
                      child: Lottie.asset("assets/lottie/reistration.json",
                          width: 60.w)),
                  5.h.addHSpace(),
                  "Create your Account".mediumRoboto(
                    fontColor: Colors.black,
                    fontSize: 40,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextFormField(
                    controller: _registerController.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || !AppAssets.isvalidemail(value)) {
                        return "Enter the Valid Email";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextFormField(
                    controller: _registerController.passwordController,
                    validator: (value) {
                      if (value == null || !AppAssets.isvalidpassword(value)) {
                        return "Enter the validPassword";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(MdiIcons.formTextboxPassword),
                        suffixIcon: const Icon(Icons.remove_red_eye_sharp)),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Obx(
                        () => _registerController.isLoading.value
                        ? LoadingAnimationWidget.hexagonDots(
                        color: AppColor.appColor, size: 5.h)
                        : appButton(
                        onTap: () async {
                          if (_globel.currentState!.validate()) {

                            // check Email password in firebase ;
                            bool checkEmail = await _registerController.checkEmail();
                            print("The check Email $checkEmail");
                            if(checkEmail){
                              //profile fill
                              Get.toNamed(Routes.FillFormScreen,arguments: {
                                "email" : _registerController.emailController.text.toString().trim(),
                                "password" : _registerController.passwordController.text.toString().trim()
                              });
                            }else{
                              Get.snackbar("email Invalid", "Please Check the email");
                            }

                          }
                        },
                        text: "Sign up"),
                  ),

                  SizedBox(
                    height: 3.h,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         flex: 2,
                  //         child: Divider(
                  //           thickness: 2,
                  //           color: Colors.grey,
                  //         ),
                  //       ),
                  //       SizedBox(width: 3.w),
                  //       // Adding space between the divider and text
                  //       Expanded(
                  //         flex: 3,
                  //         child: Text(
                  //           "or continue with",
                  //           maxLines: 1,
                  //           overflow: TextOverflow.ellipsis,
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             fontSize: 16, // Adjust font size as needed
                  //             color: Colors
                  //                 .black, // Change text color if necessary
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(width: 3.w),
                  //       // Adding space between the text and divider
                  //       Expanded(
                  //         flex: 2,
                  //         child: Divider(
                  //           thickness: 2,
                  //           color: Colors.grey,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       customSquareButton(
                  //           icon: Icons.facebook,
                  //           onTap: () {},
                  //           color: Colors.blue,
                  //           iconSize: 4.h),
                  //       customSquareButton(
                  //           icon: FontAwesomeIcons.google,
                  //           onTap: () async {
                  //             var login =
                  //                 await _registerController.signIngoogle();
                  //             print(login);
                  //             if (login is UserCredential) {
                  //               Get.offAllNamed(Routes.homeScreen);
                  //             } else if (login is String) {
                  //               Get.snackbar("Error", "${login.toString()}");
                  //             } else {
                  //               Get.snackbar(
                  //                   "Undefined Error", "${login.toString()}");
                  //             }
                  //           },
                  //           iconSize: 4.h),
                  //       customSquareButton(
                  //           icon: Icons.apple, onTap: () {}, iconSize: 4.h)
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "Already have an account?"
                          .mediumRoboto(fontSize: 14, fontColor: Colors.grey),
                      SizedBox(
                        width: 1.w,
                      ),
                      InkWell(
                          onTap: () {
                            Get.offNamed(Routes.LOGIN);
                          },
                          child: "Sign in"
                              .boldRoboto(fontColor: AppColor.lightBlue, fontSize: 15))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
