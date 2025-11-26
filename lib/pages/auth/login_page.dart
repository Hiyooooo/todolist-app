import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_app/controllers/auth_controller.dart';
import 'package:todolist_app/routes/app_routes.dart';
import 'package:todolist_app/widgets/common/app_textfield.dart';
import 'package:todolist_app/widgets/common/app_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthController _authController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Obx(() {
              final isLoading = _authController.isLoading.value;
              final error = _authController.errorMessage.value;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Todo App Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Email
                  AppTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'masukkan email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  AppTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),

                  if (error.isNotEmpty) ...[
                    Text(error, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                  ],

                  // Button Login
                  AppButton.primary(
                    label: isLoading ? 'Logging in...' : 'Login',
                    onPressed: isLoading
                        ? null
                        : () {
                            _authController.onLoginPressed(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          },
                  ),
                  const SizedBox(height: 16),

                  // Link ke register
                  AppButton.text(
                    label: 'Belum punya akun? Daftar',
                    onPressed: () {
                      Get.toNamed(AppRoutes.register);
                    },
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
