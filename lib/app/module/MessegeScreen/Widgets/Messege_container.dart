import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/app/module/MessegeScreen/OfferResModel.dart';
import 'package:home_hub_final/constraints/extension.dart';
import 'package:home_hub_final/modelClass/OfferModel.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../constraints/appColor.dart';
import '../../../../modelClass/ServicesProviderResModel.dart';
import '../../../../modelClass/text_chat_res_model.dart';
import '../../Payment Screen/controller/payment_controller.dart';

Widget messegeContainer(
    {required BuildContext context,
      required bool isMe,
      required TextChatResModel textChatResModel}) {
  return isMe
      ? Container(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(top: 10, left: 70),
      child: ClipPath(
        clipper: LowerNipMessageClipper(MessageType.send),
        child: Container(
          padding:
          EdgeInsets.only(left: 5.w, top: 10, bottom: 25, right: 5.w),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff9b56ff),
                Color(0xff7413ff),
              ])),
          child: Text(
            textChatResModel.msg,
            style: TextStyle(
              fontSize: 16.5.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  )
      : Container(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(right: 70, top: 10),
      child: ClipPath(
        clipper: UpperNipMessageClipper(MessageType.receive),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFE1E1E2),
          ),
          child: Text(
            textChatResModel.msg,
            style: TextStyle(
              fontSize: 16.5.sp,
            ),
          ),
        ),
      ),
    ),
  );
}

// Future<void> getServiceData({required String serviceId})async{
//   DocumentSnapshot data=await servicesCollection.doc(serviceId).get();
//
//   ServiceResponseModel serviceResponseModel=ServiceResponseModel.fromMap(data.data() as Map<String,dynamic>);
//   return serviceResponseModel;
// }

Widget offerContainer(
    {required BuildContext context,
      required String offerId,
      required String roomId,
      required OfferModel offerResModel,
      required ServiceProviderRes serviceProviderRes}) {
  List<TextEditingController> textEditingController =
  List.generate(4, (index) => TextEditingController());
  return Container(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(right: 80, top: 10),
      child: ClipPath(
        clipper: UpperNipMessageClipper(MessageType.receive),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFE1E1E2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${offerResModel.description}",
                style: TextStyle(fontSize: 16.5.sp),
              ),
              1.h.addHSpace(),
              Row(
                children: [
                  Image.asset(
                    "assets/images/dollar.png",
                    width: 4.5.w,
                  ),
                  2.w.addWSpace(),
                  Text(
                    "Price : ₹",
                    style: TextStyle(fontSize: 16.5.sp),
                  ),
                  Text(
                    " ${offerResModel.price}",
                    style: TextStyle(fontSize: 16.5.sp),
                  ),
                ],
              ),
              0.5.h.addHSpace(),
              Row(
                children: [
                  Image.asset(
                    "assets/images/stopwatch.png",
                    width: 4.5.w,
                  ),
                  2.w.addWSpace(),
                  Text(
                    "Complete At :",
                    style: TextStyle(fontSize: 16.5.sp),
                  ),
                  Text(
                    " ${DateFormat('dd-MM-yyyy').format(offerResModel.daysToWork)}",
                    style: TextStyle(fontSize: 16.5.sp),
                  ),
                ],
              ),
              0.5.h.addHSpace(),
              Row(
                children: [
                  Image.asset(
                    "assets/images/repair-tool.png",
                    width: 4.5.w,
                  ),
                  2.w.addWSpace(),
                  Text(
                    "Service :",
                    style: TextStyle(fontSize: 16.5.sp),
                  ),
                  Flexible(
                    child: Text(
                      " ${offerResModel.serviceName}",overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.5.sp),
                    ),
                  ),
                ],
              ),
              1.h.addHSpace(),
              1.0.appDivider(color: Colors.white),
              1.h.addHSpace(),
              offerResModel.status == "pending"
                  ? GestureDetector(
                onTap: () {
                  log("Offer Accepted");
                  showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    // scrollControlDisabledMaxHeightRatio: 500,
                    isScrollControlled: true,
                    builder: (context) {
                      return addressSheet(
                          textEditing: textEditingController,
                          offerResModel: offerResModel,
                          serviceProviderRes: serviceProviderRes,
                          offerId: offerId,
                          roomId: roomId,
                          context: context);
                    },
                  );
                },
                child: Container(
                  width: 100.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(colors: [
                      Color(0xff9b56ff),
                      Color(0xff7413ff),
                    ]),
                  ),
                  child: Center(
                    child: "Order Now".semiOpenSans(
                        fontColor: Colors.white, fontSize: 16.sp),
                  ),
                ),
              )
                  : Container(
                width: 100.w,
                height: 5.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey),
                child: Center(
                  child: "Order ${offerResModel.status}".semiOpenSans(
                      fontColor: Colors.white, fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget addressSheet(
    {required OfferModel offerResModel,
      required String offerId,
      required String roomId,
      required List<TextEditingController> textEditing,
      required BuildContext context,
      required ServiceProviderRes serviceProviderRes}) {
  PaymentController paymentController = Get.put(PaymentController());

  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SizedBox(
      width: 100.w,
      height: 50.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          3.h.addHSpace(),
          "Address".mediumOpenSans(fontSize: 18.sp, fontColor: Colors.black),
          0.5.h.addHSpace(),
          TextFormField(
            controller: textEditing[0],
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter Address";
              }
              return null;
            },
            decoration: InputDecoration(
                hintText: "Line no 1",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          1.h.addHSpace(),
          TextFormField(
            controller: textEditing[1],
            decoration: InputDecoration(
                hintText: "Line no 2",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          2.h.addHSpace(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "City".mediumOpenSans(
                        fontSize: 17.sp, fontColor: Colors.black),
                    0.8.h.addHSpace(),
                    TextFormField(
                      controller: textEditing[2],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter City";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "Surat",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
              ),
              3.w.addWSpace(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "State".mediumOpenSans(
                        fontSize: 17.sp, fontColor: Colors.black),
                    0.8.h.addHSpace(),
                    TextFormField(
                      controller: textEditing[3],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter State";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: "Gujarat",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: SwipeButton(
                  width: 200,
                  activeTrackColor: AppColor.lightPurple,
                  activeThumbColor: AppColor.appColor,
                  inactiveTrackColor: Colors.green,
                  height: 7.h,
                  inactiveThumbColor: Colors.black,
                  child: const Text(
                    "Swipe to Pay",
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                  onSwipe: () {
                    if (textEditing[0].text.isEmpty) {
                      showMessege(
                          title: "Something Went Wrong",
                          messege: "Please Enter Address ");
                    } else if (textEditing[2].text.trim().isEmpty) {
                      showMessege(
                          title: "Something Went Wrong",
                          messege: "Please Enter City ");
                    } else if (textEditing[3].text.trim().isEmpty) {
                      showMessege(
                          title: "Something Went Wrong",
                          messege: "Please Enter State ");
                    } else {
                      String address =
                          "${textEditing[0].text.trim()} , ${textEditing[1].text.trim()} , ${textEditing[2].text.trim()} , ${textEditing[3].text.trim()}";
                      paymentController.getPayment(
                          offerResModel: offerResModel,
                          serviceProviderRes: serviceProviderRes,
                          offerId: offerId,
                          address: address,
                          roomId: roomId);
                      Get.back();
                    }
                  },
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 4.w),
          2.h.addHSpace(),
        ],
      ).paddingSymmetric(horizontal: 2.w),
    ),
  );
}
