import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:todolist_app/controllers/calender_controller.dart';

class CalendarSelectedDayHeader extends StatelessWidget {
  final CalenderController calenderController;

  const CalendarSelectedDayHeader({
    super.key,
    required this.calenderController,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Obx(() {
      final day = calenderController.selectedDay.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Tugas pada ${dateFormat.format(day)}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      );
    });
  }
}
