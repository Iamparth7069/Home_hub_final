import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/constraints/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../constraints/appAssets.dart';
import '../../../../constraints/appColor.dart';
import '../../../../constraints/appTextStyle.dart';
import '../../../routes/app_pages.dart';
import '../controller/logincontroller.dart';


class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController authController = Get.put(LoginController());

  final _globel = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                  SizedBox(
                    height: 1.w,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_outlined,
                        size: 3.h,
                      ),
                    ),
                  ),
                  5.h.addHSpace(),
                  Center(
                      child: Lottie.asset("assets/lottie/login.json",
                          width: 70.w,height: 20.h),),
                  "Login to your Account".mediumRoboto(
                    fontColor: Colors.black,
                    fontSize: 40,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || !AppAssets.isvalidemail(value)) {
                        return "Enter the Valid Email";
                      } else {
                        return null;
                      }
                    },
                    controller: authController.emailController,
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
                    controller: authController.passwordController,
                    validator: (value) {
                      if (value == null || !AppAssets.isvalidpassword(value)) {
                        return "Enter the validPassword";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(MdiIcons.formTextboxPassword),
                        suffixIcon: const Icon(Icons.remove_red_eye_sharp)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                           Get.toNamed(Routes.FORGETSCREEN);
                        },
                        icon: "Forgot Password?".semiOpenSans(
                            fontColor: AppColor.appColor, fontSize: 17.sp)),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Obx(
                        () => authController.isLoading.value
                        ? LoadingAnimationWidget.hexagonDots(
                        color: AppColor.appColor, size: 5.h)
                        : appButton(
                          fontSize: 17,
                        onTap: () {
                          if (_globel.currentState!.validate()) {
                            authController.signInWithEmailAndPassword();
                          } else {
                            print("Error");
                          }
                        },
                        text: "Sign In"),
                  ),

                  const SizedBox(height: 10,),
                  Row(
                      children: <Widget>[
                        const Expanded(
                          child: Divider(
                              color: AppColor.dividerColor,
                              thickness: 1
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Or",
                            style: AppStyle.textStyleOutfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColor.midTextColor,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                              color: AppColor.dividerColor,
                              thickness: 1
                          ),
                        ),
                      ]
                  ),
                  const SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      // controller.signInWithGoogle();
                    },
                    child: Container(
                      width: Get.width,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AppColor.lineDarkBoarderColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Image(
                            image: AssetImage(AppAssets.google),
                            height: 24.0,
                            width: 24.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Continue with Google",
                              style: AppStyle.textStyleOutfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.mainTextColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "Don't have an account?"
                          .mediumRoboto(fontSize: 14, fontColor: Colors.grey),
                      SizedBox(
                        width: 1.w,
                      ),
                      InkWell(
                          onTap: () {
                             Get.offAllNamed(Routes.REGISTER);
                          },
                          child: "Sign up"
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
