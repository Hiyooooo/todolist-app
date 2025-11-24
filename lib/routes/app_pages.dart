import 'package:get/get.dart';
import 'package:todolist_app/pages/auth/register_page.dart';
import 'package:todolist_app/routes/app_routes.dart';
import 'package:todolist_app/pages/auth/login_page.dart';
import 'package:todolist_app/pages/todo/todo_list_page.dart';
import 'package:todolist_app/pages/todo/todo_form_page.dart';
import 'package:todolist_app/bindings/auth_binding.dart';
import 'package:todolist_app/bindings/todo_binding.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
      binding: AuthBinding(),
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
  ];
}
