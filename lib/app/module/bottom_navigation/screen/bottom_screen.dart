import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sizer/sizer.dart';

import '../../../../constraints/appColor.dart';
import '../controller/bottom_navbar_contoller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavbarContoller>(
      init: BottomNavbarContoller(),
        builder: (controller) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.selectedPage,
              showUnselectedLabels: true,
              onTap: (value) {
                controller.setSelectedPage(value: value);
              },
              selectedItemColor: AppColor.appColor,
              unselectedItemColor: Colors.grey,
              unselectedLabelStyle:
              TextStyle(color: Colors.grey, fontSize: 12.sp),

              items: List.generate(
                4,
                    (index) => BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    controller.iconList[index]["unselectedIcon"]!,
                    width: 20,
                    color: Colors.grey,
                  ),
                  label: controller.iconList[index]["label"]!,
                  activeIcon: SvgPicture.asset(
                    controller.iconList[index]["selectedIcon"]!,
                    width: 20,
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            body: controller.screens[controller.selectedPage],
          );
        }
    );
  }
}
