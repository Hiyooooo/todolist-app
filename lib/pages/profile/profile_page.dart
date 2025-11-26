import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_app/controllers/auth_controller.dart';
import 'package:todolist_app/controllers/todo_controller.dart';
import 'package:todolist_app/widgets/profile/profile_header.dart';
import 'package:todolist_app/widgets/profile/profile_todo_stats_section.dart';
import 'package:todolist_app/widgets/profile/profile_logout_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final todoController = Get.find<TodoController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Obx(() {
          final name = authController.displayName;
          final email = authController.displayEmail;
          final username = authController.displayUsername;

          const memberSinceText = 'unknown';

          final stats = todoController.todoStats;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(
                  name: name,
                  username: username,
                  email: email,
                  memberSinceText: memberSinceText,
                ),
                const SizedBox(height: 24),
                ProfileTodoStatsSection(stats: stats),
                const SizedBox(height: 32),
                ProfileLogoutButton(onLogout: authController.logout),
              ],
            ),
          );
        }),
      ),
    );
  }
}
