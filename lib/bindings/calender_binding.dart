import 'package:get/get.dart';
import 'package:todolist_app/controllers/calender_controller.dart';

class CalenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalenderController>(() => CalenderController());
  }
}
