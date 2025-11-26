// lib/pages/calender/calender_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:todolist_app/controllers/calender_controller.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/routes/app_routes.dart';

class CalenderPage extends StatelessWidget {
  const CalenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final calenderController = Get.find<CalenderController>();
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Kalender')),
      body: SafeArea(
        child: Column(
          children: [
            // ====== KALENDER ======
            Obx(() {
              return TableCalendar<TodoModel>(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: calenderController.focusedDay.value,
                calendarFormat: calenderController.calendarFormat.value,
                selectedDayPredicate: (day) =>
                    isSameDay(calenderController.selectedDay.value, day),

                // titik di tanggal yang punya todo
                eventLoader: (day) => calenderController.getTodosForDay(day),

                onDaySelected: (selectedDay, focusedDay) {
                  calenderController.onDaySelected(selectedDay, focusedDay);
                },
                onFormatChanged: calenderController.onFormatChanged,
                onPageChanged: calenderController.onPageChanged,

                calendarStyle: const CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                ),
              );
            }),

            const SizedBox(height: 8),

            // ====== JUDUL LIST HARI TERPILIH ======
            Obx(() {
              final day = calenderController.selectedDay.value;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tugas pada ${dateFormat.format(day)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),

            // ====== LIST TODO DI HARI TERPILIH ======
            Expanded(
              child: Obx(() {
                final day = calenderController.selectedDay.value;
                final todosForDay = calenderController.getTodosForDay(day);

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
                        isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
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
                          if (todo.description != null &&
                              todo.description!.isNotEmpty)
                            Text(todo.description!),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildStatusChip(todo.status),
                              const SizedBox(width: 8),
                              _buildPriorityChip(todo.priority),
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
              }),
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

  // ==== Helper chip (sama seperti di TodoList) ====

  Widget _buildStatusChip(String status) {
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

  Widget _buildPriorityChip(String priority) {
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
