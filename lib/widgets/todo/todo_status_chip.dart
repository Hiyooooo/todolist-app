import 'package:flutter/material.dart';

class TodoStatusChip extends StatelessWidget {
  final String status;

  const TodoStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (status) {
      case 'in_progress':
        label = 'In Progress';
        color = Colors.blue;
        break;
      case 'completed':
        label = 'Completed';
        color = Colors.green;
        break;
      default:
        label = 'Pending';
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
