import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/models/todo_model.dart';

class TodoDueReminder extends StatelessWidget {
  final TodoModel todo;
  final DateFormat dateFormat;

  const TodoDueReminder({
    super.key,
    required this.todo,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    if (todo.dueDate == null) {
      return const SizedBox.shrink();
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(
      todo.dueDate!.year,
      todo.dueDate!.month,
      todo.dueDate!.day,
    );

    final diff = due.difference(today).inDays;

    String text;
    Color color;

    if (todo.status == 'completed') {
      text = 'Selesai • Jatuh tempo ${dateFormat.format(due)}';
      color = Colors.green;
    } else if (diff < 0) {
      final daysLate = diff.abs();
      if (daysLate == 1) {
        text = 'Terlambat 1 hari (jatuh tempo ${dateFormat.format(due)})';
      } else {
        text =
            'Terlambat $daysLate hari (jatuh tempo ${dateFormat.format(due)})';
      }
      color = Colors.red;
    } else if (diff == 0) {
      text = 'Jatuh tempo hari ini';
      color = Colors.orange;
    } else if (diff == 1) {
      text = 'Jatuh tempo besok';
      color = Colors.orange;
    } else if (diff <= 3) {
      text = 'Jatuh tempo dalam $diff hari';
      color = Colors.orange;
    } else {
      text = 'Jatuh tempo ${dateFormat.format(due)}';
      color = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(Icons.alarm, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(text, style: TextStyle(fontSize: 12, color: color)),
          ),
        ],
      ),
    );
  }
}
