import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../FirebaseServices/count_service.dart';
import '../../../routes/app_pages.dart';
import '../../home/screen/Service_Container.dart';
import '../Controller/SavedListController.dart';

class SaveAllItems extends StatelessWidget {
  SaveAllItems({Key? key}) : super(key: key);
  final SavedListController _controller = Get.put(SavedListController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Saved Item",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if (_controller.documents.isEmpty) {
          return Center(
            child: Text("No saved items found"),
          );
        } else {
          return RefreshIndicator(
            onRefresh: _controller.loadSavedItem,
            child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: _controller.documents.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    CountService.setCounting(
                        serviceProviderId: _controller
                            .documents[index].userId);
                    Get.toNamed(
                        Routes.ServiceDetiailsScreen,
                        arguments: _controller
                            .documents[index]);
                  },
                  child: ServiceContainer(
                    serviceResponseModel: _controller.documents[index],
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
