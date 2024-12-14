import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_final/constraints/extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../constraints/appColor.dart';
import '../../../../localStorage/local.dart';
import '../../../../modelClass/serviceReponseModel.dart';
import '../controller/homecontroller.dart';

class ServiceContainer extends StatefulWidget {
  const ServiceContainer({Key? key, required this.serviceResponseModel})
      : super(key: key);

  final ServiceResponseModel serviceResponseModel;

  @override
  State<ServiceContainer> createState() => _ServiceContainerState();
}

class _ServiceContainerState extends State<ServiceContainer> {
  final HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.90.h),
      child: Container(
        height: 19.h,
        width: 100.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.greyColor.withOpacity(0.1),
              offset: const Offset(2, 2),
              blurRadius: 4,
            )
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 5.w),
            Center(
              child: Container(
                height: 13.h,
                width: 30.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.serviceResponseModel.images[0],
                    fit: BoxFit.fill,
                    placeholder: (context, url) {
                      return loadingEffect(
                          height: 13.h, width: 30.w, radius: 20);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  1.h.addHSpace(),
                  "${widget.serviceResponseModel.userName}".mediumOpenSans(
                      fontColor: AppColor.blackColor.withOpacity(0.5),
                      fontSize: 16.sp),
                  0.2.h.addHSpace(),
                  "${widget.serviceResponseModel.serviceName}"
                      .extraBoldOpenSans(
                    fontColor: AppColor.blackColor,
                    textOverflow: TextOverflow.ellipsis,
                    maxLine: 2,
                    fontSize: 18.sp,
                  ),
                  0.7.h.addHSpace(),
                  "\$25".extraBoldOpenSans(
                      fontColor: AppColor.appColor, fontSize: 17.sp),
                  Spacer(),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/rating.png",
                        height: 1.5.h,
                      ),
                      0.2.w.addWSpace(),
                      "${widget.serviceResponseModel.averageRating}"
                          .mediumOpenSans(
                          fontColor: AppColor.blackColor.withOpacity(0.5),
                          fontSize: 16.sp),
                      2.w.addWSpace(),
                      Container(
                        height: 1.5.h,
                        width: 0.5.w,
                        color: AppColor.blackColor.withOpacity(0.5),
                      ),
                      2.w.addWSpace(),
                      "${widget.serviceResponseModel.totalRating} reviews"
                          .mediumOpenSans(
                          fontColor: AppColor.blackColor.withOpacity(0.5),
                          fontSize: 16.sp),
                    ],
                  ),
                  1.h.addHSpace(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
              child: InkWell(
                onTap: () async {
                  String userId = await LocalStorage.getUserId();
                  await homeScreenController.saveBy(
                    widget.serviceResponseModel.serviceIds,
                    userId,
                  );

                  setState(() {
                    // Toggle the saved status locally for immediate UI feedback
                    if (widget.serviceResponseModel.savedBy!
                        .contains(homeScreenController.uid.value)) {
                      widget.serviceResponseModel.savedBy!.remove(userId);
                    } else {
                      widget.serviceResponseModel.savedBy!.add(userId);
                    }
                  });
                },
                child: SvgPicture.asset(
                  widget.serviceResponseModel.savedBy!
                      .contains(homeScreenController.uid.value)
                      ? "assets/images/svg/bookmark_fill.svg"
                      : "assets/images/svg/bookmark.svg",
                  color: AppColor.appColor,
                  width: 5.w,
                ),
              ),
            ),
            SizedBox(width: 5.w),
          ],
        ),
      ),
    );
  }
}
