import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/controllers/todo_controller.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/routes/app_routes.dart';
import 'package:todolist_app/widgets/todo/todo_due_reminder.dart';
import 'package:todolist_app/widgets/todo/todo_priority_chip.dart';
import 'package:todolist_app/widgets/todo/todo_status_chip.dart';

class TodoListItem extends StatelessWidget {
  final TodoModel todo;
  final DateFormat dateFormat;

  const TodoListItem({super.key, required this.todo, required this.dateFormat});

  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>();
    final isCompleted = todo.status == 'completed';

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        todoController.deleteTodo(todo.id);
      },
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
          onPressed: () => todoController.toggleComplete(todo),
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
            TodoDueReminder(todo: todo, dateFormat: dateFormat),
          ],
        ),
        onTap: () {
          Get.toNamed(AppRoutes.todoForm, arguments: todo);
        },
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hapus Todo'),
            content: const Text('Yakin ingin menghapus todo ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
