import 'package:flutter/material.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';
import '../extensions/view_modifiers.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Section header
        Text(
          'الوصول السريع',
          style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
        ),
        const SizedBox(height: 12),
        // My Vehicles card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AbsherCardDecoration(),
          child: Row(
            children: [
              const Icon(Icons.chevron_left, color: AbsherColors.textSecondary, size: 14),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'مركباتي',
                    style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'عرض التفاصيل، تجديد الوثائق والمزيد',
                    style: AbsherFonts.small.copyWith(color: AbsherColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              const Icon(Icons.directions_car, color: AbsherColors.green, size: 28),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Service cards grid
        Row(
          children: [
            Expanded(child: _ServiceCard(icon: Icons.description, title: 'خدمات التوثيق')),
            const SizedBox(width: 12),
            Expanded(child: _ServiceCard(icon: Icons.flight, title: 'أبشر سفر')),
          ],
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ServiceCard({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: AbsherColors.green),
          const SizedBox(height: 12),
          Text(
            title,
            style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
