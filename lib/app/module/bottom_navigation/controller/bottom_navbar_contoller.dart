import 'package:get/get.dart';

import '../../BookingScreen/Screen/Booking_Screen.dart';
import '../../MessegeScreen/Screen/Messege_Screen.dart';
import '../../ProfileScreen/Screen/profile_Screen.dart';
import '../../home/screen/homeScreen.dart';

class BottomNavbarContoller extends GetxController{
  int selectedPage = 0;

  void setSelectedPage({required int value}) {
    selectedPage = value;
    update();
  }

  List<Map<String, String>> iconList = [
    {
      "unselectedIcon": "assets/images/svg/home.svg",
      "selectedIcon": "assets/images/svg/home_fill.svg",
      "label": "Home"
    },
    {
      "unselectedIcon": "assets/images/svg/memo.svg",
      "selectedIcon": "assets/images/svg/memo_fill.svg",
      "label": "Bookings"
    },
    {
      "unselectedIcon": "assets/images/svg/messages.svg",
      "selectedIcon": "assets/images/svg/messages_fill.svg",
      "label": "Inbox"
    },
    {
      "unselectedIcon": "assets/images/svg/user.svg",
      "selectedIcon": "assets/images/svg/user_fill.svg",
      "label": "Profile"
    },
  ];


  List screens = [
     const HomeScreen(),
     const BookingScreen(),
     const MessegeScreen(),
      ProfileScreen(),
  ];


}