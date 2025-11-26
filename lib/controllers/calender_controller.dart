// lib/controllers/calender_controller.dart
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist_app/controllers/todo_controller.dart';
import 'package:todolist_app/models/todo_model.dart';

class CalenderController extends GetxController {
  final TodoController _todoController = Get.find<TodoController>();

  // format kalender (month / twoWeeks / week)
  final calendarFormat = CalendarFormat.month.obs;

  // tanggal yang lagi difokuskan di kalender
  final focusedDay = DateTime.now().obs;

  // tanggal yang dipilih user
  late final Rx<DateTime> selectedDay;

  CalenderController() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    selectedDay = today.obs;
    focusedDay.value = today;
  }

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  /// handler saat user pilih tanggal di kalender
  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = _normalize(selected);
    focusedDay.value = focused;
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }

  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
  }

  /// Ambil todos yang dueDate-nya sama dengan [day] (tanggal saja).
  List<TodoModel> getTodosForDay(DateTime day) {
    final dateOnly = _normalize(day);
    return _todoController.todos.where((t) {
      if (t.dueDate == null) return false;
      final due = _normalize(t.dueDate!);
      return due == dateOnly;
    }).toList();
  }
}
