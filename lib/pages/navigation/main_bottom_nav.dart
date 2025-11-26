import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:todolist_app/controllers/navigation_controller.dart';

class MainBottomNav extends StatelessWidget {
  MainBottomNav({super.key});

  final controller = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Column(
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(12, 12, 12, 6)),
            Expanded(child: controller.pages[controller.selectedIndex.value]),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist_rounded),
              label: "Todo",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: "Calender",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded),
              label: "Profile",
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
