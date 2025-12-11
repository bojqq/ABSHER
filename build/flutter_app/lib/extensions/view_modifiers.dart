import 'package:flutter/material.dart';
import 'color_absher.dart';

class AbsherCardDecoration extends BoxDecoration {
  AbsherCardDecoration()
      : super(
          color: AbsherColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AbsherColors.cardBorder, width: 1),
        );
}

class ProactiveAlertCardDecoration extends BoxDecoration {
  ProactiveAlertCardDecoration()
      : super(
          gradient: LinearGradient(
            colors: [
              AbsherColors.orange.withOpacity(0.3),
              AbsherColors.cardBackground,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AbsherColors.orange, width: 2),
          boxShadow: [
            BoxShadow(
              color: AbsherColors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
}

class AbsherPrimaryButtonStyle {
  static ButtonStyle get style => ElevatedButton.styleFrom(
        backgroundColor: AbsherColors.mint,
        foregroundColor: AbsherColors.background,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      );
}
