import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_app/controllers/todo_controller.dart';
import 'package:todolist_app/widgets/common/app_textfield.dart';

class TodoFilterBar extends StatelessWidget {
  final TodoController controller;

  const TodoFilterBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final statusValue = controller.statusFilter.value;
      final priorityValue = controller.priorityFilter.value;
      final sortByValue = controller.sortBy.value;
      final sortOrderValue = controller.sortOrder.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            AppTextField(
              label: 'Cari berdasarkan judul',
              hint: 'Cari todo...',
              prefixIcon: Icons.search,
              isDense: true,
              onChanged: controller.updateSearchQuery,
            ),
            const SizedBox(height: 8),

            // FILTER BAR (status & priority)
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: statusValue,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: 'in_progress',
                        child: Text('In Progress'),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text('Completed'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateStatusFilter(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: priorityValue,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'low', child: Text('Low')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'high', child: Text('High')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.updatePriorityFilter(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // SORT BAR (sort by & order)
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: sortByValue,
                    decoration: const InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'createdAt',
                        child: Text('Created At'),
                      ),
                      DropdownMenuItem(
                        value: 'dueDate',
                        child: Text('Due Date'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateSortBy(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: sortOrderValue,
                    decoration: const InputDecoration(
                      labelText: 'Order',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'desc', child: Text('Desc')),
                      DropdownMenuItem(value: 'asc', child: Text('Asc')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateSortOrder(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
