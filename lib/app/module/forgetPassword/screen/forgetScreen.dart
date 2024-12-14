import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/constraints/extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../constraints/appAssets.dart';
import '../controller/forgetScreenController.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ForgetScreenController>(
        init: ForgetScreenController(),
        builder: (controller) {
          return SafeArea(child: SingleChildScrollView(
            child: Column(
              children: [
                10.h.addHSpace(),
                Center(
                  child: SvgPicture.asset(
                    "assets/images/svg/forgot.svg",
                    width: 70.w,
                  ),
                ),
                5.h.addHSpace(),
                Center(
                    child: "Forgot Password".boldOpenSans(
                        fontColor: Colors.black, fontSize: 20.sp)),
                5.h.addHSpace(),
                TextFormField(
                  controller: controller.email,
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
                ).paddingSymmetric(horizontal: 2.w),

                30.h.addHSpace(),
                appButton(
                    onTap: () {
                      controller.checkUserAndSendResetLink(
                          controller.email.text.trim());
                    },
                    text: "Send Otp")

              ],
            ),
          ));
        },
      ),
    );
  }
}
