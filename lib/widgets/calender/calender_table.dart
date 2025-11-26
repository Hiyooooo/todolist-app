import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:todolist_app/controllers/calender_controller.dart';
import 'package:todolist_app/models/todo_model.dart';

class CalendarTable extends StatelessWidget {
  final CalenderController calenderController;

  const CalendarTable({super.key, required this.calenderController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TableCalendar<TodoModel>(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: calenderController.focusedDay.value,
        calendarFormat: calenderController.calendarFormat.value,
        selectedDayPredicate: (day) =>
            isSameDay(calenderController.selectedDay.value, day),

        eventLoader: (day) => calenderController.getTodosForDay(day),

        onDaySelected: calenderController.onDaySelected,
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
      ),
    );
  }
}
