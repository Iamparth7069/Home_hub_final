import 'package:get/get_navigation/src/routes/get_route.dart';

import '../module/GetAllServices/Screen/SaveAllServices.dart';
import '../module/GetAppServices/Screen/getAllServices.dart';
import '../module/Invoice/invoice_screen.dart';
import '../module/LetsYouInScreen/screen/letYourinScreen.dart';
import '../module/MessegeScreen/Screen/Messege_Screen.dart';
import '../module/MessegeScreen/Screen/chat_screen.dart';
import '../module/ProfileScreen/Screen/transection_screen.dart';
import '../module/ReviewScreen/review_screen.dart';
import '../module/Services Details/screen/review_show_screen.dart';
import '../module/Services Details/screen/service_detail_screen.dart';
import '../module/bottom_navigation/screen/bottom_screen.dart';
import '../module/forgetPassword/screen/forgetScreen.dart';
import '../module/login/screen/loginScreen.dart';
import '../module/onbodding/screen/onbodding_screen.dart';
import '../module/profileFillScreen/screen/profileFillScreen.dart';
import '../module/register/screen/register.dart';
import '../module/splash/screen/splashScreen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.ONBODDINGSCREEN,
      page: () => const OnBordingScreen(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => Register(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => Login(),
    ),
    GetPage(
      name: _Paths.LETSUSSCREEN,
      page: () => LetsYouInScreen(),
    ),

    GetPage(
      name: _Paths.FillFormScreen,
      page: () => ProfileFillScreen(),
    ),
    GetPage(
      name: _Paths.FORGET,
      page: () => ForgetScreen(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => Register(),
    ),
    GetPage(
      name: _Paths.BOTTOMNAVBAR,
      page: () => BottomNavBar(),
    ),
    GetPage(
      name: _Paths.MmessgeScreen,
      page: () => MessegeScreen(),
    ),
    GetPage(
      name: _Paths.savedAll,
      page: () =>  SaveAllItems(),
    ),
    GetPage(
      name: _Paths.ServiceDetiailsScreen,
      page: () => const ServiceDetailsScreen(),
    ),
    GetPage(
      name: _Paths.allServices,
      page: () => const GetAllService(),
    ),
    GetPage(
      name: _Paths.showReviewScreen,
      page: () => const ShowReviewScreen(),
    ),
    GetPage(
      name: _Paths.CHATSCREEN,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: _Paths.InvoiceBill,
      page: () =>  InvoiceScreen(),
    ),
    GetPage(
      name: _Paths.transectionScreen,
      page: () => const TransectionScreen(),
    ),

    GetPage(
      name: _Paths.reviewScreen,
      page: () => const ReviewScreen(),
    ),

  ];
}
