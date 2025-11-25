import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_app/controllers/auth_controller.dart';
import 'package:todolist_app/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
    _initApp();
  }

  Future<void> _initApp() async {
    await _authController.tryAutoLogin();

    // Kasih delay dikit biar splash kelihatan
    await Future.delayed(const Duration(milliseconds: 500));

    final hasSession =
        _authController.accessToken.isNotEmpty && _authController.user != null;

    if (hasSession) {
      Get.offAllNamed(AppRoutes.mainnav);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.checklist_rounded, size: 64),
            SizedBox(height: 16),
            Text(
              'Todo List App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
