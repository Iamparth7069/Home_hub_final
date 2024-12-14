import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/constraints/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../../FirebaseServices/count_service.dart';
import '../../../../constraints/appColor.dart';
import '../../../routes/app_pages.dart';
import '../../Services Provider /Screen/services_provider.dart';
import '../controller/homecontroller.dart';
import 'Service_Container.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> services = ["All", "Cleaning", "Repairing", "Painting"];
  final HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return controller.userLoadData
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.hexagonDots(
                  color: AppColor.appColor, size: 5.h),
            ],
          ),
        )
            : Scaffold(
          appBar: AppBar(
            leading: ClipOval(
              child: CachedNetworkImage(
                imageUrl: controller.userData.value.profileImage,
                fit: BoxFit.cover,
                width: 60.0,
                // Set the width and height to create a perfect circle
                height: 60.0,
                placeholder: (context, url) =>
                    LoadingAnimationWidget.hexagonDots(
                        color: AppColor.appColor, size: 5.h),
              ),
            ),
            bottom: PreferredSize(
                preferredSize: Size(100.w, 1.h), child: SizedBox()),
            actions: [
              GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.savedAll);
                  },
                  child: SvgPicture.asset(
                    "assets/images/svg/bookmark.svg",
                    height: 3.h,
                  )),
              2.w.addWSpace()
            ],
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Good Morning".mediumOpenSans(
                    fontSize: 16.sp, fontColor: AppColor.greyColor),
                "${controller.userData.value.firstName + " " + controller.userData.value.lastName}"
                    .extraBoldOpenSans(
                    fontSize: 16.sp, fontColor: Colors.black),
              ],
            ),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    2.h.addHSpace(),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 30.h,
                        aspectRatio: 0.8,
                        viewportFraction: 1,
                        autoPlay: true,
                      ),
                      items: List.generate(
                          controller.offerDAta.length,
                              (index) => Container(
                            width: 95.w,
                            height: 22.h,
                            decoration: BoxDecoration(
                              color: Color(int.parse(controller
                                  .offerDAta[index].color
                                  .toString())),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 3.h,
                                  bottom: 1.5.h,
                                  left: 3.w,
                                  child: SizedBox(
                                    width: 50.w,
                                    height: 25.h,
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          (controller.offerDAta[index]
                                              .discount ??
                                              "")
                                              .boldOpenSans(
                                              fontColor: Colors.white,
                                              fontSize: 30.sp),
                                          (controller.offerDAta[index]
                                              .title ??
                                              "")
                                              .boldOpenSans(
                                              fontColor: Colors.white,
                                              fontSize: 20.sp),
                                          (controller.offerDAta[index]
                                              .discription ??
                                              "")
                                              .semiOpenSans(
                                              maxLines: 2,
                                              textOverflow:
                                              TextOverflow
                                                  .ellipsis,
                                              fontColor: Colors.white,
                                              fontSize: 14.sp),
                                        ]),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 3.w,
                                  child: SizedBox(
                                    height: 22.h,
                                    width: 40.w,
                                    child: CachedNetworkImage(
                                      imageUrl: controller
                                          .offerDAta[index].image ??
                                          "",
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ).paddingSymmetric(
                              horizontal: 2.w, vertical: 1.h)),
                    ),
                    2.h.addHSpace(),
                    Row(
                      children: [
                        "Services".boldOpenSans(
                            fontSize: 16.sp, fontColor: AppColor.blackColor),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.allServices);
                          },
                          child: "See All".boldOpenSans(
                              fontSize: 16.sp, fontColor: AppColor.appColor),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 2.w),
                    2.h.addHSpace(),
                  SizedBox(
                    height: 22.5.h,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.servicesList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 0,
                        crossAxisCount: 4,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(30), // To match the circular container
                          onTap: () {
                            // Add navigation or functionality here
                            Get.to(Service_Provider(controller.servicesList[index].servicesName));
                            // if(controller.servicesList.length == 8){
                            //   Get.toNamed(Routes.allServices);
                            // }else{
                            //
                            // }
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 50.0, // Increased size for better visuals
                                height: 50.0,
                                decoration: BoxDecoration(

                                  shape: BoxShape.circle,
                                  color: AppColor.lightPurple,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3), // Subtle shadow
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                      offset: Offset(0, 3), // Shadow position
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: controller.servicesList[index].images,
                                      fit: BoxFit.cover,
                                      color: AppColor.appColor,
                                      width: 40.0, // Adjusted for proper scaling
                                      height: 40.0,
                                      placeholder: (context, url) => Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5), // Spacing between image and text
                              "${controller.servicesList[index].servicesName}".semiOpenSans(
                                fontColor: AppColor.blackColor,
                                fontSize: 15.sp,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  2.h.addHSpace(),
                    Row(
                      children: [
                        "Most Popular Services".boldOpenSans(
                            fontSize: 16.sp, fontColor: AppColor.blackColor),
                        const Spacer( ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.allServices);
                          },
                          child: "See All".boldOpenSans(
                              fontSize: 16.sp, fontColor: AppColor.appColor),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 2.w),
                    3.h.addHSpace(),
                    controller.isServicesLoading
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : Column(
                      children: List.generate(
                          controller.servicesData.length,
                              (index) => GestureDetector(
                              onTap: () {
                                CountService.setCounting(
                                    serviceProviderId: controller
                                        .servicesData[index].userId);
                                Get.toNamed(Routes.ServiceDetiailsScreen,
                                    arguments:
                                    controller.servicesData[index]);
                              },
                              child: ServiceContainer(
                                serviceResponseModel:
                                controller.servicesData[index],
                              ).paddingOnly(bottom: 2.h))),
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
