import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/app_view_model.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';
import '../extensions/view_modifiers.dart';

class ConfirmationView extends StatelessWidget {
  final int timeSavings;

  const ConfirmationView({
    super.key,
    required this.timeSavings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AbsherColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              // Large green checkmark icon
              const Icon(
                Icons.check_circle,
                size: 100,
                color: AbsherColors.green,
              ),
              const SizedBox(height: 32),
              // Success message
              Text(
                '✅ تم تجديد رخصتك بنجاح',
                style: AbsherFonts.title.copyWith(color: AbsherColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Time savings highlight
              Text(
                'لقد وفرت $timeSavings دقيقة',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AbsherColors.mint,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'من البحث وإدخال البيانات والتنقل بين الخدمات',
                  style: AbsherFonts.body.copyWith(color: AbsherColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              // Email message
              Text(
                'التفاصيل في بريدك',
                style: AbsherFonts.caption.copyWith(color: AbsherColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Reset button
              ElevatedButton(
                style: AbsherPrimaryButtonStyle.style,
                onPressed: () {
                  context.read<AppViewModel>().resetDemo();
                },
                child: const Text('العودة للرئيسية'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
