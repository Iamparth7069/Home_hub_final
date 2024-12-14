import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_final/constraints/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constraints/appColor.dart';
import '../../../../modelClass/user_res_model.dart';
import '../profileFillScreenController/profileFillController.dart';

class ProfileFillScreen extends StatefulWidget {
  const ProfileFillScreen({super.key});

  @override
  State<ProfileFillScreen> createState() => _ProfileFillScreenState();
}

class _ProfileFillScreenState extends State<ProfileFillScreen> {
  @override


  final formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Get.back, child: const Icon(Icons.arrow_back_rounded)),
        title: "Fill Your Profile"
            .boldOpenSans(fontColor: Colors.black, fontSize: 17.sp),
      ),
      body: GetBuilder<ProfileFillController>(
        init: ProfileFillController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: SizedBox(
                height: 85.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    2.h.addHSpace(),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xfff5f5f8),
                            radius: 15.w,
                            backgroundImage: controller.image != null
                                ? FileImage(controller.image as File)
                                : const AssetImage(
                                "assets/images/profile_image.jpg")
                            as ImageProvider,
                          ),
                          Positioned(
                            right: 3,
                            bottom: 3,
                            child: GestureDetector(
                              onTap: () {
                                controller.pickImage();
                              },
                              child: Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                    color: AppColor.appColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Center(
                                  child: Icon(Icons.edit,
                                      color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    6.h.addHSpace(),
                    customTextFormField(
                      hintText: "First Name",
                      textEditingController: controller.fNameController,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return "Please Enter First Name";
                        }
                      },
                    ),
                    2.h.addHSpace(),
                    customTextFormField(
                      hintText: "Last Name",
                      textEditingController: controller.lNameController,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return "Please Enter Last Name";
                        }
                      },
                    ),
                    2.h.addHSpace(),
                    customTextFormField(
                      hintText: "Phone Number",
                      data: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      textEditingController: controller.phoneNumberController,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return "Please Enter Phone Number";
                        } else if (p0!.length > 10) {
                          return "Please Enter Valid Phone Number";
                        }
                      },
                    ),
                    2.h.addHSpace(),
                    customTextFormField(
                        hintText: "Address",
                        textEditingController: controller.addressController,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return "Please Enter Address";
                          }
                        },
                        maxLines: 2),
                    const Spacer(),
                    controller.isSendData == true
                        ? LoadingAnimationWidget.hexagonDots(
                        color: AppColor.appColor, size: 5.h)
                        : appButton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            controller.changeSendDataValue(value: true);
                            var userData = await controller.registerWithEmailAndPassword(email: controller.email!, password: controller.password!);
                            if(userData is UserCredential){
                              await controller.sedProfileData(userData);
                            }

                          }
                        },
                        color: AppColor.appColor,
                        width: 90.w,
                        fontColor: Colors.white,
                        fontSize: 18.sp,
                        text: "Continue")
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
