import 'package:flutter/material.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AbsherColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Absher logo
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
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
              ),
              const Spacer(),
              // Service availability text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'خدمات متوفرة على مدار الساعة طوال الأسبوع',
                  style: AbsherFonts.body.copyWith(color: AbsherColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Loading indicator
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: AbsherColors.mint,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'جار التحميل...',
                style: AbsherFonts.body.copyWith(color: AbsherColors.textSecondary),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
