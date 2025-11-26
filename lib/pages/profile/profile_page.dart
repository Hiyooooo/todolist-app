import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/controllers/auth_controller.dart';
import 'package:todolist_app/controllers/todo_controller.dart';
import 'package:todolist_app/models/todo_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final todoController = Get.find<TodoController>();
    final dateFormat = DateFormat(
      'dd MMM yyyy',
    ); // belum dipakai, boleh dipakai nanti kalau ada "member since" beneran

    print('Auth hash profile ${authController.hashCode}');

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Obx(() {
          // Ambil user dari AuthController
          final user = authController.user;
          final name = user?.name ?? 'User';
          final email = user?.email ?? '-';

          // Username simple: ambil dari email sebelum '@'
          final username = _buildUsername(email, fallback: 'user');

          // Untuk sekarang, karena AuthUser tidak punya createdAt,
          // kita tampilkan teks default saja.
          const memberSinceText = 'unknown';

          // Ambil todos dari TodoController untuk statistik
          final List<TodoModel> todos = todoController.todos;
          final stats = _buildTodoStats(todos);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== USER HEADER =====
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAvatar(name),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@$username',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Member since $memberSinceText',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ===== TODO STATS =====
                Text(
                  'Todo Statistics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatRow('Total', stats.total),
                    _buildStatRow('Pending', stats.pending),
                    _buildStatRow('In Progress', stats.inProgress),
                    _buildStatRow('Completed', stats.completed),
                    _buildStatRow('Overdue', stats.overdue),
                  ],
                ),

                const SizedBox(height: 32),

                // ===== LOGOUT BUTTON =====
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      authController.logout();
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Avatar lingkaran dengan inisial nama
  Widget _buildAvatar(String name) {
    final initial = (name.isNotEmpty ? name[0] : 'U').toUpperCase();
    return CircleAvatar(
      radius: 30,
      child: Text(
        initial,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Baris statistik sederhana: label + angka
  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Bentuk username sederhana dari email.
  /// Contoh: hiyoo@example.com -> hiyoo
  String _buildUsername(String? email, {String fallback = 'user'}) {
    if (email == null || email.isEmpty || !email.contains('@')) {
      return fallback;
    }
    return email.split('@').first;
  }
}

/// Model stats sederhana (client-side)
class _TodoStats {
  final int total;
  final int pending;
  final int inProgress;
  final int completed;
  final int overdue;

  const _TodoStats({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.overdue,
  });
}

/// Hitung statistik todo dari list yang sudah ada di client
_TodoStats _buildTodoStats(List<TodoModel> todos) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  int pending = 0;
  int inProgress = 0;
  int completed = 0;
  int overdue = 0;

  for (final t in todos) {
    if (t.status == 'pending') pending++;
    if (t.status == 'in_progress') inProgress++;
    if (t.status == 'completed') completed++;

    if (t.dueDate != null && t.status != 'completed') {
      final due = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      if (due.isBefore(today)) {
        overdue++;
      }
    }
  }

  return _TodoStats(
    total: todos.length,
    pending: pending,
    inProgress: inProgress,
    completed: completed,
    overdue: overdue,
  );
}
