import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../localStorage/local.dart';
import '../../../../modelClass/ServicesProviderResModel.dart';
import '../../../../modelClass/order_res_model.dart';
import '../../../../modelClass/serviceReponseModel.dart';
import '../../../../repo/repo_collection.dart';

class BookingScreenController extends GetxController {
  int selectedTab = 0;
  bool isLoading = false;

  List<OrderResModel> pendingOrders = [];
  List<ServiceProviderRes> pendingOrdersUserDetails = [];
  List<ServiceResponseModel> pendingOrdersServiceDetails = [];
  List<OrderResModel> completedOrders = [];
  List<ServiceProviderRes> completedOrdersUserDetails = [];
  List<ServiceResponseModel> completedOrdersServiceDetails = [];
  List<OrderResModel> calcleOrders = [];
  List<ServiceProviderRes> calcleOrdersUserDetails = [];
  List<ServiceResponseModel> calcleOrdersServiceDetails = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllBookings();
  }

  void setSelectedTab({required int value}) {
    selectedTab = value;
    update();
  }

  Future<void> getAllBookings() async {
    isLoading = true;
    update();
    String myUid = await LocalStorage.getUserId();
    try {
      Stream<QuerySnapshot> getData = FirebaseFirestore.instance
          .collection('Orders') // Replace with your actual collection name
          .where("userId", isEqualTo: myUid) // Filter based on the user ID
          .snapshots(); // Real-time data

      getData.listen((event) async {
        // Clear existing data
        pendingOrders.clear();
        completedOrders.clear();
        completedOrdersUserDetails.clear();
        pendingOrdersUserDetails.clear();
        calcleOrders.clear();
        calcleOrdersUserDetails.clear();
        pendingOrdersServiceDetails.clear();
        calcleOrdersServiceDetails.clear();
        completedOrdersServiceDetails.clear();

        // Process the documents from the event
        for (var element in event.docs) {
          OrderResModel orderResModel = OrderResModel.fromJson(element.data() as Map<String, dynamic>);
          print("======>${orderResModel.toJson()}");
          ServiceProviderRes serviceProviderRes = await getServiceProviderData(
              serviceProviderId: orderResModel.serviceProviderId ?? "");
          ServiceResponseModel serviceResponseModel =
          await getServiceData(serviceId: orderResModel.subServiceId ?? "");
          print("Services Is :${orderResModel.status!}");
          print("user Id is ${myUid}");
          // Classify orders by status
          if (orderResModel.status == "Pending" || orderResModel.status == "Accepted") {
            pendingOrders.add(orderResModel);
            pendingOrdersUserDetails.add(serviceProviderRes);
            pendingOrdersServiceDetails.add(serviceResponseModel);
          } else if (orderResModel.status == "Completed") {
            completedOrders.add(orderResModel);
            completedOrdersUserDetails.add(serviceProviderRes);
            completedOrdersServiceDetails.add(serviceResponseModel);
          } else {
            calcleOrders.add(orderResModel);
            calcleOrdersUserDetails.add(serviceProviderRes);
            calcleOrdersServiceDetails.add(serviceResponseModel);
          }
        }

        // Update loading state after processing the data
        isLoading = false;
        update();
      }, onError: (error) {
        // Handle stream errors
        print("Error fetching data: $error");
        isLoading = false;
        update();
      });
    } catch (error) {
      // Handle query initialization errors
      print("Error setting up stream: $error");
      isLoading = false;
      update();
    }
  }


  Future<ServiceProviderRes> getServiceProviderData(
      {required String serviceProviderId}) async {
    DocumentSnapshot dd =
    await serviceProviderUserCollection.doc(serviceProviderId).get();
    ServiceProviderRes serviceProviderRes =
    ServiceProviderRes.formMap(dd.data() as Map<String, dynamic>);
    return serviceProviderRes;
  }

  Future<ServiceResponseModel> getServiceData(
      {required String serviceId}) async {
    DocumentSnapshot dd = await servicesCollection.doc(serviceId).get();
    ServiceResponseModel serviceResponseModel =
    ServiceResponseModel.fromMap(dd.data() as Map<String, dynamic>);
    return serviceResponseModel;
  }
}
