import 'package:get/get.dart';
import 'package:todolist_app/bindings/calender_binding.dart';
import 'package:todolist_app/bindings/navigation_binding.dart';
import 'package:todolist_app/pages/auth/register_page.dart';
import 'package:todolist_app/pages/calender/calender_page.dart';
import 'package:todolist_app/pages/navigation/main_bottom_nav.dart';
import 'package:todolist_app/pages/profile/profile_page.dart';
import 'package:todolist_app/pages/splashscreen/splash_page.dart';
import 'package:todolist_app/routes/app_routes.dart';
import 'package:todolist_app/pages/auth/login_page.dart';
import 'package:todolist_app/pages/todo/todo_list_page.dart';
import 'package:todolist_app/pages/todo/todo_form_page.dart';
import 'package:todolist_app/bindings/todo_binding.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => SplashPage()),
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.register, page: () => RegisterPage()),
    GetPage(
      name: AppRoutes.mainnav,
      page: () => MainBottomNav(),
      bindings: [NavigationBinding(), TodoBinding(), CalenderBinding()],
    ),
    GetPage(
      name: AppRoutes.todos,
      page: () => TodoListPage(),
      binding: TodoBinding(),
    ),
    GetPage(
      name: AppRoutes.todoForm,
      page: () => TodoFormPage(),
      binding: TodoBinding(),
    ),
    GetPage(
      name: AppRoutes.calender,
      page: () => CalenderPage(),
      bindings: [CalenderBinding(), TodoBinding()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
      bindings: [TodoBinding()],
    ),
  ];
}
