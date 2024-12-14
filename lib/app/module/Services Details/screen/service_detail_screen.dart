import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/constraints/appColor.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../../../FirebaseServices/chat_service.dart';
import '../../../../constraints/extension.dart';
import '../../../../localStorage/local.dart';
import '../../../../modelClass/ServicesProviderResModel.dart';
import '../../../../modelClass/rating_res_model.dart';
import '../../../../modelClass/serviceReponseModel.dart';
import '../../../routes/app_pages.dart';
import '../../MessegeScreen/Controller/Messge_Screen_controller.dart';
import '../../MessegeScreen/Widgets/DateFormetUtil.dart';
import '../../home/controller/homecontroller.dart';
import '../controller/service_detail_screen_controller.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  ServiceDetailController serviceDetailController =
      Get.put(ServiceDetailController());
  final ServiceResponseModel serviceResponseModel = Get.arguments;
  final HomeScreenController homeScreenController = Get.put(HomeScreenController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceDetailController.getReviewData(
        serviceResponseModel: serviceResponseModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ServiceDetailController>(
        builder: (controller) {
          return Container(
            width: 100.w,
            height: 100.h,
            child: Stack(
              children: [
                SizedBox(
                  width: 100.w,
                  height: 100.h,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 34.h,
                              width: 100.w,
                              child: CarouselSlider.builder(
                                itemCount: serviceResponseModel.images.length,
                                itemBuilder: (context, index, realIndex) {
                                  return Container(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          serviceResponseModel.images[index],
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          loadingEffect(
                                        height: 34.h,
                                        width: 100.w,
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  height: 34.h,
                                  aspectRatio: 0.7,
                                  viewportFraction: 1,
                                  autoPlay: true,
                                  onPageChanged: (index, reason) {
                                    controller.setSelectedPosterImageIndex(
                                        value: index);
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 30,
                              child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: AppColor.whiteColor,
                                  )),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    serviceResponseModel.images.length,
                                    (index) => controller
                                                .selectedPosterImageIndex ==
                                            index
                                        ? Container(
                                            width: 7.w,
                                            height: 6,
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xffc992fc),
                                                      AppColor.appColor
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                          )
                                        : CircleAvatar(
                                            radius: 3,
                                            backgroundColor:
                                                Colors.white.withOpacity(0.8),
                                          ).paddingSymmetric(horizontal: 1.w)),
                              ),
                            )
                          ],
                        ),
                        0.7.h.addHSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: "${serviceResponseModel.serviceName}"
                                  .boldOpenSans(
                                      textOverflow: TextOverflow.ellipsis,
                                      fontColor: AppColor.blackColor,
                                      fontSize: 20.sp),
                            ),
                            IconButton(
                              onPressed: () async {
                                String userid = await LocalStorage.getUserId();
                                await homeScreenController.saveBy(
                                    serviceResponseModel.serviceIds, userid);
                              },
                              icon: SvgPicture.asset(
                                  serviceResponseModel.savedBy!.contains(
                                          homeScreenController.uid.value)
                                      ? "assets/images/svg/bookmark_fill.svg"
                                      : "assets/images/svg/bookmark.svg",
                                  color: AppColor.appColor,
                                  width: 5.w),
                            ),
                          ],
                        ).paddingOnly(left: 2.w),
                        1.2.h.addHSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            "${serviceResponseModel.userName}".boldOpenSans(
                                fontColor: AppColor.appColor, fontSize: 15.sp),
                            3.w.addWSpace(),
                            Image.asset(
                              "assets/images/rating.png",
                              width: 4.w,
                            ),
                            1.w.addWSpace(),
                            "${serviceResponseModel.averageRating} (${serviceResponseModel.totalRating} reviews)"
                                .mediumOpenSans(
                                    fontSize: 15.sp,
                                    fontColor: Colors.black.withOpacity(0.8))
                          ],
                        ).paddingSymmetric(horizontal: 2.w),
                        1.2.h.addHSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xfff4ecff),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: "${serviceResponseModel.categoryName}"
                                    .semiOpenSans(
                                        fontColor: AppColor.appColor, fontSize: 15.sp),
                              ).paddingSymmetric(
                                  horizontal: 3.w, vertical: 0.5.h),
                            ),
                            3.w.addWSpace(),
                            SvgPicture.asset(
                              "assets/images/svg/marker.svg",
                              width: 4.w,
                              color: AppColor.appColor,
                            ),
                            1.w.addWSpace(),
                            Flexible(
                              child: serviceResponseModel.address
                                  .mediumOpenSans(
                                      fontColor: Colors.black.withOpacity(0.6),
                                      fontSize: 14.sp,
                                      maxLine: 1,
                                      textOverflow: TextOverflow.ellipsis),
                            )
                          ],
                        ).paddingSymmetric(horizontal: 2.w),
                        2.5.h.addHSpace(),
                        Row(
                          children: [
                            "\$20".extraBoldOpenSans(
                                fontColor: AppColor.appColor, fontSize: 20.sp),
                            1.w.addWSpace(),
                            "(Min Price)".mediumOpenSans(
                                fontColor: Colors.black.withOpacity(0.6),
                                fontSize: 16.sp,
                                maxLine: 1,
                                textOverflow: TextOverflow.ellipsis)
                          ],
                        ).paddingSymmetric(horizontal: 2.w),
                        1.h.addHSpace(),
                        0.2
                            .h
                            .appDivider(color: Colors.black.withOpacity(0.05))
                            .paddingSymmetric(horizontal: 2.w),
                        1.h.addHSpace(),
                        "About me"
                            .boldOpenSans(
                                fontColor: AppColor.blackColor, fontSize: 16.sp)
                            .paddingSymmetric(horizontal: 2.w),
                        1.h.addHSpace(),
                        ReadMoreText(
                          '${serviceResponseModel.description}',
                          trimLines: 3,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '  Show more',
                          trimExpandedText: '  Show less',
                          style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: "OpenSans"),
                          lessStyle: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.appColor,
                              fontFamily: "OpenSans"),
                          moreStyle: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.appColor,
                              fontFamily: "OpenSans"),
                        ).paddingSymmetric(horizontal: 2.w),
                        Row(
                          children: [
                            2.w.addWSpace(),
                            Image.asset(
                              "assets/images/rating.png",
                              width: 20,
                            ),
                            2.w.addWSpace(),
                            "${controller.total == 0 ? 0.0 : (controller.totalReview / controller.total).toStringAsFixed(1)} (${controller.total} Reviews)"
                                .boldOpenSans(
                                    fontColor: Colors.black, fontSize: 16.sp),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  Get.toNamed(Routes.showReviewScreen);
                                },
                                icon: "See All".semiOpenSans(
                                    fontSize: 16.sp, fontColor: AppColor.appColor))
                          ],
                        ),
                        1.h.addHSpace(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                controller.ratingsType.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.setReviewFilter(index: index);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: controller.selectedRating == index
                                          ? AppColor.appColor
                                          : Colors.transparent,
                                      border:
                                          Border.all(color: AppColor.appColor, width: 2),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.star,
                                          color:
                                              controller.selectedRating == index
                                                  ? Colors.white
                                                  : Colors.grey,
                                          size: 19),
                                      2.w.addWSpace(),
                                      "${controller.ratingsType[index]}"
                                          .semiOpenSans(
                                              fontColor:
                                                  controller.selectedRating ==
                                                          index
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 15.sp),
                                    ],
                                  ).paddingSymmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                ).paddingSymmetric(horizontal: 2.w),
                              );
                            }),
                          ),
                        ),
                        controller.selectedRatings.isEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  5.h.addHSpace(),
                                  Center(
                                    child: "No Review Found".mediumOpenSans(
                                        fontColor: Colors.grey,
                                        fontSize: 16.sp),
                                  )
                                ],
                              )
                            : Column(
                                children: List.generate(
                                    controller.selectedRatings.length, (index) {
                                  return reviewContainer(
                                          ratingResModel:
                                              controller.selectedRatings[index])
                                      .paddingSymmetric(vertical: 1.h);
                                }),
                              ),
                        8.h.addHSpace(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  left: 10,
                  child: roundCornurButton(
                      onTap: () async {
                        String myUid = await LocalStorage.getUserId();
                        String roomId = "";
                        Map result = await ChatService.isChatRoomExist(
                            myUid, serviceResponseModel.userId);

                        if (!result['isExist']) {
                          await ChatService.createRoom(
                              secondUserId: serviceResponseModel.userId);
                          roomId = "${myUid}-${serviceResponseModel.userId}";
                        } else {
                          roomId = result['chatRoomId'];
                        }
                        ServiceProviderRes serviceProviderRes =
                            await ChatScreenController.getServiceProviderData(
                                userId: serviceResponseModel.userId);
                        Get.toNamed(Routes.CHATSCREEN, arguments: {
                          "roomId": roomId,
                          "userName": serviceResponseModel.userName,
                          "userId": serviceResponseModel.userId,
                          "serviceProviderRes": serviceProviderRes,
                        });
                      },
                      text: "Message",
                      textColor: Colors.white,
                      color: AppColor.appColor),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget reviewContainer({required RatingResModel ratingResModel}) {
  return Container(
    width: 100.w,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(200)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: CachedNetworkImage(
                    imageUrl: ratingResModel.profileImage, fit: BoxFit.cover),
              ),
            ),
            3.w.addWSpace(),
            ratingResModel.userName
                .boldOpenSans(fontSize: 17.sp, fontColor: Colors.black),
            const Spacer(),
            Container(
              height: 35,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColor.appColor, width: 2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.star,
                    color: AppColor.appColor,
                    size: 19,
                  ),
                  "${ratingResModel.ratings}"
                      .semiOpenSans(fontColor: AppColor.appColor, fontSize: 14.sp)
                ],
              ).paddingSymmetric(horizontal: 1.w),
            )
          ],
        ),
        1.h.addHSpace(),
        "${ratingResModel.description}"
            .mediumOpenSans(fontSize: 17.sp, fontColor: Colors.black),
        1.h.addHSpace(),
        DateFormatUtil.formatTimeAgo(ratingResModel.createdAt)
            .mediumOpenSans(fontSize: 13.sp, fontColor: Colors.grey),
      ],
    ).paddingSymmetric(horizontal: 3.w, vertical: 1.h),
  );
}
