import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todolist_app/controllers/calender_controller.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/routes/app_routes.dart';
import 'package:todolist_app/widgets/todo/todo_status_chip.dart';
import 'package:todolist_app/widgets/todo/todo_priority_chip.dart';

class CalendarTodoList extends StatelessWidget {
  final CalenderController calenderController;

  const CalendarTodoList({super.key, required this.calenderController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final DateTime day = calenderController.selectedDay.value;
      final List<TodoModel> todosForDay = calenderController.getTodosForDay(
        day,
      );

      if (todosForDay.isEmpty) {
        return const Center(
          child: Text(
            'Tidak ada tugas hari ini.\n'
            'Klik + untuk membuat tugasmu.',
            textAlign: TextAlign.center,
          ),
        );
      }

      return ListView.builder(
        itemCount: todosForDay.length,
        itemBuilder: (context, index) {
          final todo = todosForDay[index];
          final isCompleted = todo.status == 'completed';

          return ListTile(
            leading: Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.green : Colors.grey,
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todo.description != null && todo.description!.isNotEmpty)
                  Text(todo.description!),
                const SizedBox(height: 4),
                Row(
                  children: [
                    TodoStatusChip(status: todo.status),
                    const SizedBox(width: 8),
                    TodoPriorityChip(priority: todo.priority),
                  ],
                ),
              ],
            ),
            onTap: () {
              Get.toNamed(AppRoutes.todoForm, arguments: todo);
            },
          );
        },
      );
    });
  }
}
