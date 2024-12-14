import '../modelClass/serviceReponseModel.dart';
import '../repo/repo_collection.dart';

class LoadService {
  static Stream<List<ServiceResponseModel>> getAllServicesStream() {
    return servicesCollection
        .limit(5)
        .where("serviceStatus", isEqualTo: "available")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ServiceResponseModel.fromMap(
        doc.data() as Map<String, dynamic>))
        .toList());
  }


  static Stream<List<ServiceResponseModel>> getSecondStream() {
    return servicesCollection
        .limit(5)
        .where("serviceStatus", isEqualTo: "available")
        // .orderBy("average_rating", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ServiceResponseModel.fromMap(
        doc.data() as Map<String, dynamic>))
        .toList());
  }
}
