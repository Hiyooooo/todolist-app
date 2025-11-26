import 'package:get/get.dart';
import 'package:todolist_app/pages/calender/calender_page.dart';
import 'package:todolist_app/pages/profile/profile_page.dart';
import 'package:todolist_app/pages/todo/todo_list_page.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(index) {
    selectedIndex.value = index;
  }

  final pages = [TodoListPage(), CalenderPage(), ProfilePage()];
}
