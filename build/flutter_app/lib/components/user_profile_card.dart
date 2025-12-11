import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';
import '../extensions/view_modifiers.dart';

class UserProfileCard extends StatelessWidget {
  final UserProfile profile;

  const UserProfileCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Row(
        children: [
          const Icon(Icons.chevron_left, color: AbsherColors.textSecondary, size: 14),
          const Spacer(),
          // User info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                profile.name,
                style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'رقم الهوية: ****',
                style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AbsherColors.green, AbsherColors.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AbsherColors.green.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}
