import 'package:flutter/material.dart';
import '../models/proactive_alert.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';
import '../extensions/view_modifiers.dart';

class ProactiveAlertCard extends StatelessWidget {
  final ProactiveAlert alert;
  final VoidCallback onTap;

  const ProactiveAlertCard({
    super.key,
    required this.alert,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ProactiveAlertCardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header with icon and title
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  alert.title,
                  style: AbsherFonts.headline.copyWith(color: AbsherColors.orange),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.notifications, color: AbsherColors.orange, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            // Service message
            Text(
              alert.message,
              style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 12),
            // Call to action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.chevron_left, color: AbsherColors.orange, size: 14),
                Text(
                  alert.actionText,
                  style: AbsherFonts.body.copyWith(
                    color: AbsherColors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
