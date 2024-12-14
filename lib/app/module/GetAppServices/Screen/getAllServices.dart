import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_final/app/module/GetAppServices/Screen/serchHeader.dart';
import 'package:sizer/sizer.dart';

import '../../../../FirebaseServices/count_service.dart';
import '../../../../modelClass/serviceReponseModel.dart';
import '../../../routes/app_pages.dart';
import '../../home/screen/Service_Container.dart';
import '../Controller/getAllServicesController.dart';


class GetAllService extends StatefulWidget {
  const GetAllService({Key? key}) : super(key: key);

  @override
  State<GetAllService> createState() => _GetAllServiceState();
}

class _GetAllServiceState extends State<GetAllService> {
  final GetAllServicesController getAllServicesController =
      Get.put(GetAllServicesController());

  bool showSearchOptions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<GetAllServicesController>(
          builder: (controller) {
            List<ServiceResponseModel> service = [];
            if (controller.isSearch) {
              service.clear();
              service = controller.filterData;
            } else {
              service.clear();
              service = controller.servicesData;
            }
            return CustomScrollView(
              slivers: [
                const SliverAppBar(
                  title: Text(
                    "Services",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                  floating: true,
                  elevation: 0,
                ),
                SliverPersistentHeader(
                  delegate: SearchHeaderDelegate(
                    showSearchOptions: showSearchOptions,
                    onDragDown: () {
                      setState(() {
                        showSearchOptions = true;
                      });
                    },
                  ),
                  pinned: true,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          CountService.setCounting(
                              serviceProviderId: service[index].userId);
                          Get.toNamed(Routes.ServiceDetiailsScreen,
                              arguments: service[index]);
                        },
                        child: ServiceContainer(
                          serviceResponseModel: service[index],
                        ).paddingOnly(bottom: 2.h),
                      );
                    },
                    childCount: service.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
