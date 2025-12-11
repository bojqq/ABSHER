import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/app_view_model.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 83,
      decoration: BoxDecoration(
        color: AbsherColors.cardBackground,
        border: Border(
          top: BorderSide(color: AbsherColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          _TabItem(
            icon: Icons.more_horiz,
            label: 'خدمات أخرى',
            isActive: false,
            onTap: () {},
          ),
          _TabItem(
            icon: Icons.engineering,
            label: 'عمالي',
            isActive: false,
            onTap: () {},
          ),
          _TabItem(
            icon: Icons.family_restroom,
            label: 'عائلتي',
            isActive: false,
            onTap: () {
              context.read<AppViewModel>().navigateToDependents();
            },
          ),
          _TabItem(
            icon: Icons.list_alt,
            label: 'خدماتي',
            isActive: false,
            onTap: () {},
          ),
          _TabItem(
            icon: Icons.home,
            label: 'الرئيسية',
            isActive: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AbsherColors.green : AbsherColors.textSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: AbsherFonts.small.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
