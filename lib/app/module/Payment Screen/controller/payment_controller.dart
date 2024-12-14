import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/app/module/MessegeScreen/OfferResModel.dart';
import 'package:home_hub_final/modelClass/OfferModel.dart';

import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../FirebaseServices/repo.dart';
import '../../../../constraints/extension.dart';
import '../../../../localStorage/local.dart';
import '../../../../modelClass/ServicesProviderResModel.dart';
import '../../../../modelClass/order_res_model.dart';
import '../../../../modelClass/transectionResModel.dart';
import '../../../../modelClass/user_res_model.dart';

class PaymentController extends GetxController {
  Razorpay _razorpay = Razorpay();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
  }

  late OfferModel offerData;
  late ServiceProviderRes serviceProviderRes;
  late UserResModel data;
  late String offerId;
  late String roomId;
  late String address;
  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    print("=========>${response.message}");
    print("=========>${response.code}");
    print("=========>${response.error}");
    if (response.error!["reason"] == "payment_cancelled") {
      showMessege(messege: "Payment was cancelled", title: "Error");
    } else {
      showMessege(
          messege: "Some Error while getting Payment Please try again",
          title: "Error");
    }
    // showAlertDialog(context, "Payment Failed",
    //     "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    // print(response.data.toString());
    // showAlertDialog(
    //     context, "Payment Successful", "Payment ID: ${response.data}");

    print("=====>${response.orderId}");
    print("=====>${response.paymentId}");
    print("=====>${response.data}");
    TransectionResModel transectionResModel = TransectionResModel(
        from: data.uId,
        to: serviceProviderRes.Uid ?? "",
        status: "Confirmed",
        transectionId: response.paymentId ?? "",
        time: DateTime.now(),
        type: 'Payment',
        amount: '${offerData.price}');
    transectionCollection
        .doc(response.paymentId)
        .set(transectionResModel.toMap());
    Map<String, dynamic> emptyMap = {};
    DocumentReference dd = await orderCollection.add(emptyMap);
    DateTime currentDate = DateTime.now();
    OrderResModel orderResModel = OrderResModel(
        createdAt: currentDate,
        completeDate: offerData.daysToWork,
        orderId: dd.id,
        paymentStatus: "Completed",
        serviceProviderId: serviceProviderRes.Uid,
        userId: data.uId,
        status: "Pending",
        serviceName: offerData.serviceName,
        subServiceId: offerData.sId,
        amount: offerData.price,
        offerId: offerId,
        address: address,
        transactionId: response.paymentId);
    await orderCollection.doc(dd.id).set(orderResModel.toJson());
    chatRoomCollection
        .doc(roomId)
        .collection("messages")
        .doc(offerId)
        .update({"status": "Confirmed"});

    ///Code FOr update Wallet info in firebase for admin
    DocumentSnapshot adminDD = await FirebaseFirestore.instance
        .collection("Admin")
        .doc("adminData")
        .get();
    Map<String, dynamic> adminData = adminDD.data() as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection("Admin")
        .doc("adminData")
        .update({"wallet": adminData["wallet"] + offerData.price});
    showMessege(
        messege: "Your Order Is Booked Successfully", title: "Congratulation");
  }

  Future<void> getPayment(
      {required OfferModel offerResModel,
        required String offerId,
        required String roomId,
        required String address,
        required ServiceProviderRes serviceProviderRes}) async {
    data = await LocalStorage.getUserData();
    offerData = offerResModel;
    this.offerId = offerId;
    this.roomId = roomId;
    this.address = address;
    this.serviceProviderRes = serviceProviderRes;
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': offerResModel.price * 100,
      'name': 'Home Hub',
      'description': offerResModel.serviceName,
      'retry': {'enabled': true, 'max_count': 2},
      'send_sms_hash': true,
      'prefill': {'contact': data.phoneNumber, 'email': data.email},
    };
    _razorpay.open(options);
  }

  @override
  void onClose() {
    super.onClose();
    _razorpay.clear();
  }
}
