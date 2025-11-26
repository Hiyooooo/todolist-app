import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_app/controllers/calender_controller.dart';
import 'package:todolist_app/widgets/calender/calender_table.dart';
import 'package:todolist_app/widgets/calender/calender_selected_day_header.dart';
import 'package:todolist_app/widgets/calender/calender_todo_list.dart';
import 'package:todolist_app/routes/app_routes.dart';

class CalenderPage extends StatelessWidget {
  const CalenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final calenderController = Get.find<CalenderController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Kalender')),
      body: SafeArea(
        child: Column(
          children: [
            // Kalender utama
            CalendarTable(calenderController: calenderController),
            const SizedBox(height: 8),

            // Judul hari yang dipilih
            CalendarSelectedDayHeader(calenderController: calenderController),

            // List todo untuk hari yang dipilih
            Expanded(
              child: CalendarTodoList(calenderController: calenderController),
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
}
