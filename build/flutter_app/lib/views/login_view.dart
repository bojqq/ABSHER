import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/app_view_model.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';
import '../extensions/view_modifiers.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _stayLoggedIn = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AbsherColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top navigation bar with back button
              const SizedBox(height: 8),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(''),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Dual logos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAbsherLogo(),
                  const SizedBox(width: 24),
                  _buildMinistryLogo(),
                ],
              ),
              const SizedBox(height: 32),
              // Login title
              Text(
                'تسجيل الدخول إلى أبشر',
                style: AbsherFonts.title.copyWith(color: AbsherColors.textPrimary),
              ),
              const SizedBox(height: 24),
              // Login form fields
              _buildFormFields(),
              const SizedBox(height: 32),
              // Login button
              ElevatedButton(
                style: AbsherPrimaryButtonStyle.style,
                onPressed: () {
                  context.read<AppViewModel>().login();
                },
                child: const Text('تسجيل الدخول'),
              ),
              const SizedBox(height: 16),
              // Forgot password link
              TextButton(
                onPressed: () {},
                child: Text(
                  'نسيت كلمة المرور',
                  style: AbsherFonts.body.copyWith(color: AbsherColors.mint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAbsherLogo() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: AbsherColors.green,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'أبشر',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMinistryLogo() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: AbsherColors.background,
        shape: BoxShape.circle,
        border: Border.all(color: AbsherColors.green, width: 2),
      ),
      child: const Center(
        child: Text(
          'وزارة الداخلية',
          style: TextStyle(
            color: AbsherColors.green,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Username field
        Text(
          'اسم المستخدم أو رقم الهوية',
          style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _usernameController,
          style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            filled: true,
            fillColor: AbsherColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AbsherColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AbsherColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AbsherColors.mint),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Password field
        Text(
          'كلمة المرور',
          style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: true,
          style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'أدخل كلمة المرور',
            hintStyle: AbsherFonts.body.copyWith(color: AbsherColors.textSecondary),
            filled: true,
            fillColor: AbsherColors.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AbsherColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AbsherColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AbsherColors.mint),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Stay logged in checkbox
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'عدم تسجيل الخروج',
              style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  _stayLoggedIn = !_stayLoggedIn;
                });
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _stayLoggedIn ? AbsherColors.mint : AbsherColors.cardBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AbsherColors.cardBorder),
                ),
                child: _stayLoggedIn
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AbsherColors.background,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
