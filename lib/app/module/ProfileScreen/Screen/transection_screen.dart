import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/constraints/extension.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../Controller/transaction_screen_controller.dart';

class TransectionScreen extends StatefulWidget {
  const TransectionScreen({super.key});

  @override
  State<TransectionScreen> createState() => _TransectionScreenState();
}

class _TransectionScreenState extends State<TransectionScreen> {
  TransactionScreenController transactionScreenController =
      Get.put(TransactionScreenController());
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Transactions"
            .boldOpenSans(fontColor: Colors.black, fontSize: 20.sp),
      ),
      body: GetBuilder<TransactionScreenController>(
        builder: (controller) {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.myData.isEmpty) {
            return Center(
              child: "No Transaction Found".semiOpenSans(fontColor: Colors.black),
            );
          }

          return ListView.builder(
            itemCount: controller.myData.length,
            itemBuilder: (context, index) {
              // Safeguard against invalid index access
              final user = index < controller.userData.length
                  ? controller.userData[index]
                  : null;

              return ListTile(
                title: controller.myData[index].type == "Payment"
                    ? "Sent to ${user?.fname ?? "Unknown"} ${user?.lname ?? ""}"
                    .boldOpenSans(fontSize: 17.sp, fontColor: Colors.black)
                    : "Received"
                    .boldOpenSans(fontSize: 19.sp, fontColor: Colors.black),
                subtitle: "${DateFormat('d MMM yyyy, HH:mm a').format(controller.myData[index].time)}"
                    .mediumOpenSans(fontSize: 16.sp, fontColor: Colors.black26),
                trailing: controller.myData[index].type == "Payment"
                    ? "- ₹${controller.myData[index].amount}"
                    .boldOpenSans(fontSize: 18.5.sp, fontColor: Colors.red)
                    : "+ ₹${controller.myData[index].amount}"
                    .boldOpenSans(fontSize: 18.5.sp, fontColor: Colors.green),
              );
            },
          );
        },
      ),
    );
  }
}
