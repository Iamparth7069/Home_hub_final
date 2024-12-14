import 'package:cloud_firestore/cloud_firestore.dart';


import '../modelClass/ServicesProviderResModel.dart';
import '../repo/repo_collection.dart';

class CountService {
  static Future<void> setCounting({required String serviceProviderId}) async {
    DocumentSnapshot dd =
        await serviceProviderUserCollection.doc(serviceProviderId).get();

    ServiceProviderRes serviceProviderRes =
        ServiceProviderRes.formMap(dd.data() as Map<String, dynamic>);

    int clicks = serviceProviderRes.clicks + 1;
    await serviceProviderUserCollection
        .doc(serviceProviderId)
        .update({'clicks': clicks});
  }
}
