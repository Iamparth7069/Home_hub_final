import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

import 'app/module/MessegeScreen/Controller/Messge_Screen_controller.dart';
import 'app/routes/app_pages.dart';
import 'constraints/appColor.dart';
import 'firebase_options.dart';
import 'package:sizer/sizer.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  await Firebase.initializeApp(name: 'homehub', options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            color: AppColor.whiteColor,
            debugShowCheckedModeBanner: false,
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
          );
        }
    );
  }
}



