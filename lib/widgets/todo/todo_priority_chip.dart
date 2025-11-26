import 'package:flutter/material.dart';

class TodoPriorityChip extends StatelessWidget {
  final String priority;

  const TodoPriorityChip({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (priority) {
      case 'high':
        label = 'High';
        color = Colors.red;
        break;
      case 'low':
        label = 'Low';
        color = Colors.green;
        break;
      default:
        label = 'Medium';
        color = Colors.orange;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
