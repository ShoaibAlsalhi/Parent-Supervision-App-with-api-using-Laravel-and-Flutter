import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_supervision/presentation/cubits/auth/auth_cubit.dart';
import 'package:parent_supervision/presentation/cubits/auth/auth_state.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text,
        'Mobile App', // اسم الجهاز الافتراضي مؤقتاً
      );
    }
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
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('تم تسجيل الدخول بنجاح!'),
                    backgroundColor: Colors.green),
              );
              // سننتقل إلى شاشة الـ Dashboard
              context.go('/dashboard');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // شعار التطبيق (مؤقتاً أيقونة)
                      const Icon(Icons.security, size: 80, color: Color(0xFF1E40AF)),
                      const SizedBox(height: 24),
                      const Text(
                        'مرحباً بك مجدداً',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'قم بتسجيل الدخول لمتابعة أجهزة العائلة',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        label: 'البريد الإلكتروني',
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        validator: (value) =>
                        value!.isEmpty ? 'يرجى إدخال البريد الإلكتروني' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'كلمة المرور',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        controller: _passwordController,
                        validator: (value) =>
                        value!.isEmpty ? 'يرجى إدخال كلمة المرور' : null,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading ? null : _submitLogin,
                          child: state is AuthLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('تسجيل الدخول'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}