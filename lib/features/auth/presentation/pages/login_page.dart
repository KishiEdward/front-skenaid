// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/google_sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.loginWithEmail(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );
    if (!mounted) return;
    _handleLoginResult(ok, auth);
  }

  Future<void> _loginGoogle() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.loginWithGoogle();
    if (!mounted) return;
    _handleLoginResult(ok, auth);
  }

  void _handleLoginResult(bool ok, AuthProvider auth) {
    if (ok) {
      Navigator.pushReplacementNamed(context, AppRouter.dashboard);
    } else if (auth.status == AuthStatus.emailNotVerified) {
      Navigator.pushReplacementNamed(context, AppRouter.verifyEmail);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Login gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Masuk ke akun...',
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Selamat Datang!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masuk untuk melanjutkan belanja',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 40),

                  CustomTextField(
                    label: 'Email',
                    hint: 'contoh@email.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: const Icon(Icons.email_outlined),
                    validator: (v) => (v?.isEmpty ?? true)
                        ? 'Wajib diisi'
                        : (!EmailValidator.validate(v!)
                              ? 'Format salah'
                              : null),
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Kata Sandi',
                    hint: '••••••••',
                    controller: _passCtrl,
                    obscureText: !_showPass,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPass ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _showPass = !_showPass),
                    ),
                    validator: (v) =>
                        (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (val) =>
                                  setState(() => _rememberMe = val!),
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Ingat saya',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed:
                            () {},
                        child: const Text(
                          'Lupa kata sandi?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    label: 'Masuk',
                    onPressed: _loginEmail,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'atau lanjutkan dengan',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  GoogleSignInButton(
                    onPressed: _loginGoogle,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun? ',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRouter.register),
                        child: const Text(
                          'Daftar sekarang',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
