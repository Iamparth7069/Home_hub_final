import 'package:get_storage/get_storage.dart';

import '../modelClass/user_res_model.dart';

class LocalStorage {
  static final box = GetStorage();

  static String uid = "uId";
  static String userData = "userData";
  static String fcmToken = "fcmToken";
  static String otp = "otp";
  static String onBodding = "onBodding";

  static void clearAllData() {
    box.erase();
  }



  static Future<void> setOndogging({required bool bio}) async {
    await box.write(onBodding, bio);
  }

  static Future getOnbodding() async {
    return await box.read(onBodding);
  }

  static Future<void> sendUserId({required String userId}) async {
    await box.write(uid, userId);
    print("Set the User Id");
  }

  static Future getUserId() async {
    String userId = await box.read(uid);
    return userId;
  }

  static Future<void> sendUserData({required UserResModel userResModel}) async {
    await box.write(userData, userResModel.toMap());
  }

  static Future getUserData() async {
    Map<String, dynamic> user = await box.read(userData);
    UserResModel userResModel = UserResModel.fromMap(user);
    return userResModel;
  }

  static Future<void> sendFcmToken({required String fcm}) async {
    await box.write(fcmToken, fcm);
  }

  static Future getFcmToken() async {
    String fcm = await box.read(fcmToken);
    return fcm;
  }


}
