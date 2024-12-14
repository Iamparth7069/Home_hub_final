import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/constraints/extension.dart';

import 'package:sizer/sizer.dart';

import '../../../../constraints/appColor.dart';
import '../Controller/BookingScreenController.dart';
import '../Widget/booking_cart.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  BookingScreenController bookingScreenController = Get.put(BookingScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingScreenController>(
      builder: (controller) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: "My Bookings"
                  .boldOpenSans(fontColor: AppColor.blackColor, fontSize: 18.sp),
              actions: [
                SvgPicture.asset(
                  "assets/images/svg/more.svg",
                  width: 6.w,
                ),
                5.w.addWSpace()
              ],
              bottom: TabBar(
                labelStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppColor.appColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans"),
                unselectedLabelStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans"),
                onTap: (value) {
                  controller.setSelectedTab(value: value);
                },
                splashBorderRadius: const BorderRadius.all(Radius.circular(5)),
                tabs: const [
                  Tab(
                    text: "Upcoming",
                  ),
                  Tab(
                    text: "Completed",
                  ),
                  Tab(
                    text: "Cancelled",
                  ),
                ],
              ),
            ),
            body: GetBuilder<BookingScreenController>(
              builder: (controller) {
                return TabBarView(children: [
                  controller.isLoading == true
                      ? ListView.builder(
                    itemBuilder: (context, index) => loadingEffect(
                        width: 100.w, height: 25.h, radius: 20)
                        .paddingSymmetric(vertical: 1.h, horizontal: 2.w),
                  )
                      : controller.pendingOrders.isEmpty
                      ? Center(
                    child: "No Data Found".semiOpenSans(),
                  )
                      : ListView.builder(
                    padding: EdgeInsets.only(top: 2.h),
                    itemCount: controller.pendingOrders.length,
                    itemBuilder: (context, index) {
                      return BookingCart(
                        statusColor: AppColor.appColor,
                        status:
                        controller.pendingOrders[index].status!,
                        serviceProviderRes: controller
                            .pendingOrdersUserDetails[index],
                        orderResModel:
                        controller.pendingOrders[index],
                        serviceResponseModel: controller
                            .pendingOrdersServiceDetails[index],
                      ).paddingOnly(
                          bottom: 2.h, left: 2.w, right: 2.w);
                    },
                  ),
                  controller.isLoading == true
                      ? ListView.builder(
                    itemBuilder: (context, index) => loadingEffect(
                        width: 100.w, height: 25.h, radius: 20)
                        .paddingSymmetric(vertical: 1.h, horizontal: 2.w),
                  )
                      : controller.completedOrders.isEmpty
                      ? Center(
                    child: "No Data Found".semiOpenSans(),
                  )
                      : ListView.builder(
                    padding: EdgeInsets.only(top: 2.h),
                    itemCount: controller.completedOrders.length,
                    itemBuilder: (context, index) {
                      return BookingCart(
                        statusColor: Colors.green,
                        status: 'Completed',
                        serviceProviderRes: controller
                            .completedOrdersUserDetails[index],
                        orderResModel:
                        controller.completedOrders[index],
                        serviceResponseModel: controller
                            .completedOrdersServiceDetails[index],
                      ).paddingOnly(
                          bottom: 2.h, left: 2.w, right: 2.w);
                    },
                  ),
                  controller.isLoading == true
                      ? ListView.builder(
                    itemBuilder: (context, index) => loadingEffect(
                        width: 100.w, height: 25.h, radius: 20)
                        .paddingSymmetric(vertical: 1.h, horizontal: 2.w),
                  )
                      : controller.calcleOrders.isEmpty
                      ? Center(
                    child: "No Data Found".semiOpenSans(),
                  )
                      : ListView.builder(
                    padding: EdgeInsets.only(top: 2.h),
                    itemCount: controller.calcleOrders.length,
                    itemBuilder: (context, index) {
                      return BookingCart(
                        statusColor: Colors.red,
                        status: 'Cancelled',
                        serviceResponseModel: controller
                            .calcleOrdersServiceDetails[index],
                        orderResModel: controller.calcleOrders[index],
                        serviceProviderRes:
                        controller.calcleOrdersUserDetails[index],
                      ).paddingOnly(
                          bottom: 2.h, left: 2.w, right: 2.w);
                    },
                  ),
                ]);
              },
            ),
          ),
        );
      },
    );
  }
}
