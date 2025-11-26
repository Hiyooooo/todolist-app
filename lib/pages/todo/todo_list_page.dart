import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/controllers/auth_controller.dart';
import 'package:todolist_app/controllers/todo_controller.dart';
import 'package:todolist_app/routes/app_routes.dart';
import 'package:todolist_app/widgets/todo/todo_filter_bar.dart';
import 'package:todolist_app/widgets/todo/todo_groupedlist_body.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>();
    final authController = Get.find<AuthController>();
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final user = authController.user;
          final name = user?.name ?? 'User';
          return Text('Hi, $name 👋');
        }),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TodoFilterBar(controller: todoController),
            const Divider(height: 1),
            Expanded(
              child: TodoGroupedListBody(
                controller: todoController,
                dateFormat: dateFormat,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.todoForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
