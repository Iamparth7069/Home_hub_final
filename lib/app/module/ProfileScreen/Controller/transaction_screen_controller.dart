import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


import '../../../../FirebaseServices/repo.dart';
import '../../../../localStorage/local.dart';
import '../../../../modelClass/ServicesProviderResModel.dart';
import '../../../../modelClass/transectionResModel.dart';

class TransactionScreenController extends GetxController {
  List<TransectionResModel> allData = [];
  List<TransectionResModel> myData = [];
  List<ServiceProviderRes?> userData = [];
  bool isLoading = false;
  @override
  onInit() {
    super.onInit();
    getAllData();
  }

  Future<void> getAllData() async {
    isLoading = true;
    update();
    String myUid = await LocalStorage.getUserId();

    Stream<QuerySnapshot> querySnapshot = transectionCollection.snapshots();
    querySnapshot.listen((event) async {
      allData.clear();
      myData.clear();
      userData.clear();

      for (var element in event.docs) {
        TransectionResModel transectionResModel =
        TransectionResModel.fromMap(element.data() as Map<String, dynamic>);
        allData.add(transectionResModel);

        if (transectionResModel.from == myUid) {
          myData.add(transectionResModel);

          // Fetch user data asynchronously
          ServiceProviderRes? user = await getServiceProviderData(id: transectionResModel.to);
          userData.add(user);
        } else if (transectionResModel.to == myUid) {
          myData.add(transectionResModel);
          userData.add(ServiceProviderRes(
            fname: "",
            lname: "",
            clicks: 0,
            Images: "",
            email: "",
            contectnumber: "",
            contectNumber2: "",
            address: "",
          ));
        }
      }

      isLoading = false;
      update();
    });
  }

  Future<ServiceProviderRes> getServiceProviderData({required String id}) async {
    try {
      DocumentSnapshot dd = await serviceProviderUserCollection.doc(id).get();
      ServiceProviderRes serviceProviderRes =
      ServiceProviderRes.formMap(dd.data() as Map<String, dynamic>);
      return serviceProviderRes;
    } catch (e) {
      // Return a default value in case of failure
      return ServiceProviderRes(
        fname: "Unknown",
        lname: "",
        clicks: 0,
        Images: "",
        email: "",
        contectnumber: "",
        contectNumber2: "",
        address: "",
      );
    }
  }

}
