import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:home_hub_final/app/module/ReviewScreen/review_screen_controller.dart';
import 'package:home_hub_final/constraints/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../constraints/appColor.dart';
import '../../../modelClass/ServicesProviderResModel.dart';
import '../../../modelClass/order_res_model.dart';
import '../../../modelClass/serviceReponseModel.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  ReviewScreenController reviewScreenController =
      Get.put(ReviewScreenController());
  OrderResModel orderResModel = Get.arguments["orderDetails"];
  ServiceProviderRes serviceProviderRes = Get.arguments["serviceProvider"];
  ServiceResponseModel serviceResponseModel = Get.arguments["serviceRes"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Review".boldOpenSans(fontColor: AppColor.blackColor, fontSize: 18.sp),
      ),
      body: GetBuilder<ReviewScreenController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                2.h.addHSpace(),
                "Ratings"
                    .boldOpenSans(fontColor: Colors.black, fontSize: 19.sp),
                2.h.addHSpace(),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          reviewScreenController.setRatingValue(value: rating);
                        },
                      ),
                      "${controller.rating}".semiOpenSans(fontColor: AppColor.appColor)
                    ],
                  ),
                ),
                3.h.addHSpace(),
                "What Do You Like Most ? "
                    .boldOpenSans(fontColor: Colors.black, fontSize: 19.sp),
                2.h.addHSpace(),
                SizedBox(
                  height: 21.h,
                  width: 100.w,
                  child: Wrap(
                    children: List.generate(
                        controller.likeMost.length,
                        (index) => GestureDetector(
                              onTap: () {
                                controller.setLikeMostValue(
                                    value: controller.likeMost[index]);
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: controller.selectedLikeMost.contains(
                                            controller.likeMost[index])
                                        ? AppColor.appColor
                                        : Colors.transparent,
                                    border: Border.all(color: AppColor.appColor),
                                    borderRadius: BorderRadius.circular(500)),
                                child: controller.likeMost[index]
                                    .semiOpenSans(
                                        fontSize: 14.sp,
                                        fontColor: controller.selectedLikeMost
                                                .contains(
                                                    controller.likeMost[index])
                                            ? Colors.white
                                            : Colors.black)
                                    .paddingSymmetric(
                                        horizontal: 3.w, vertical: 1.h),
                              ).paddingSymmetric(
                                  horizontal: 2.w, vertical: 1.h),
                            )),
                  ),
                ),
                3.h.addHSpace(),
                "Discription"
                    .boldOpenSans(fontColor: Colors.black, fontSize: 17.sp),
                2.h.addHSpace(),
                TextField(
                  controller: controller.discription,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Type Something"),
                ),
                10.h.addHSpace(),
                Center(
                    child: controller.isDataSend == true
                        ? LoadingAnimationWidget.hexagonDots(
                            color: AppColor.appColor, size: 5.h)
                        : appButton(
                            onTap: () {
                              if (controller.rating == 0.0) {
                                showMessege(
                                    title: "Something Went Wrong!",
                                    messege: "Please Give Rating First");
                              } else if (controller.selectedLikeMost.isEmpty) {
                                showMessege(
                                    title: "Something Went Wrong!",
                                    messege:
                                        "Please Select What Do You like Most");
                              } else {
                                controller
                                    .sendReviewData(
                                        orderResModel: orderResModel,
                                        serviceResponseModel:
                                            serviceResponseModel,
                                        serviceProviderRes: serviceProviderRes)
                                    .then(
                                  (value) {
                                    Get.back();
                                    showMessege(
                                        title: "Successful",
                                        messege: "Thanks For Give Review");
                                  },
                                );
                              }
                            },
                            text: "Submit")),
                2.h.addHSpace(),
              ],
            ).paddingSymmetric(horizontal: 2.w),
          );
        },
      ),
    );
  }
}
