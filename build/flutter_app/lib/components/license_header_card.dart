import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';
import '../extensions/view_modifiers.dart';

class LicenseHeaderCard extends StatelessWidget {
  final UserProfile profile;
  final String serviceTitle;

  const LicenseHeaderCard({
    super.key,
    required this.profile,
    required this.serviceTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // License banner
          Container(
            height: 76,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AbsherColors.green, AbsherColors.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: const Center(
              child: Icon(Icons.directions_car, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          // Info section
          Text(
            serviceTitle,
            style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      profile.name,
                      style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.idNumber,
                      style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Profile image
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AbsherColors.green, AbsherColors.lightGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AbsherColors.cardBorder),
                ),
                child: const Icon(Icons.person, size: 24, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Chips row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AbsherColors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Driving License',
                  style: AbsherFonts.caption.copyWith(color: AbsherColors.green),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AbsherColors.cardBorder.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'SA',
                  style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
