import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_app/controllers/auth_controller.dart';
import 'package:todolist_app/routes/app_routes.dart';
import 'package:todolist_app/widgets/common/app_textfield.dart';
import 'package:todolist_app/widgets/common/app_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthController _authController;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(AppRoutes.login);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Obx(() {
              final isLoading = _authController.isLoading.value;
              final error = _authController.errorMessage.value;

              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Buat Akun Baru',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name
                    AppTextField(
                      controller: _nameController,
                      label: 'Nama',
                      hint: 'Nama lengkap',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'email@contoh.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email wajib diisi';
                        }
                        if (!value.contains('@')) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'minimal 6 karakter',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    if (error.isNotEmpty) ...[
                      Text(error, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                    ],

                    // Button Daftar
                    AppButton.primary(
                      label: isLoading ? 'Mendaftarkan...' : 'Daftar',
                      onPressed: isLoading
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) return;

                              _authController.onRegisterPressed(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                            },
                    ),

                    const SizedBox(height: 16),

                    AppButton.text(
                      label: 'Sudah punya akun? Login',
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
