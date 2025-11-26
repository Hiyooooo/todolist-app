import 'package:flutter/material.dart';
import 'package:todolist_app/controllers/todo_controller.dart';
import 'package:todolist_app/widgets/profile/profile_stat_row.dart';

class ProfileTodoStatsSection extends StatelessWidget {
  final TodoStats stats;

  const ProfileTodoStatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Todo Statistics',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ProfileStatRow(label: 'Total', value: stats.total),
        ProfileStatRow(label: 'Pending', value: stats.pending),
        ProfileStatRow(label: 'In Progress', value: stats.inProgress),
        ProfileStatRow(label: 'Completed', value: stats.completed),
        ProfileStatRow(label: 'Overdue', value: stats.overdue),
      ],
    );
  }
}
