import 'package:get/get.dart';
import 'package:todolist_app/routes/app_routes.dart';
import 'package:todolist_app/pages/auth/login_page.dart';
import 'package:todolist_app/pages/todo/todo_list_page.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final pages = <GetPage>[
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.todos, page: () => const TodoListPage()),
  ];
}
