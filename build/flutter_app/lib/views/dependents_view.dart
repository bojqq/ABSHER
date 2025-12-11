import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/app_view_model.dart';
import '../models/dependent.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';
import '../extensions/view_modifiers.dart';

class DependentsView extends StatelessWidget {
  final List<Dependent> dependents;

  const DependentsView({
    super.key,
    required this.dependents,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AbsherColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Navigation bar
                _buildNavigationBar(viewModel),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Header section
                        _buildHeaderSection(),
                        const SizedBox(height: 16),
                        // Dependents list
                        if (dependents.isEmpty)
                          _buildEmptyStateView()
                        else
                          ...dependents.map((dependent) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _DependentCard(dependent: dependent),
                              )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationBar(AppViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: AbsherColors.cardBackground),
      child: Row(
        children: [
          IconButton(
            onPressed: () => viewModel.currentScreen = Screen.home,
            icon: const Icon(Icons.chevron_right, color: AbsherColors.green),
          ),
          Expanded(
            child: Text(
              'التابعين',
              style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'إدارة التابعين',
                  style: AbsherFonts.title.copyWith(color: AbsherColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'متابعة خدمات أفراد العائلة',
                  style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.people, color: AbsherColors.mint, size: 32),
        ],
      ),
    );
  }

  Widget _buildEmptyStateView() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: AbsherCardDecoration(),
      child: Column(
        children: [
          const Icon(
            Icons.person_off,
            size: 48,
            color: AbsherColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد تابعين',
            style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على تابعين مسجلين',
            style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _DependentCard extends StatelessWidget {
  final Dependent dependent;

  const _DependentCard({required this.dependent});

  Color get _urgencyColor {
    if (dependent.daysRemaining <= 7) {
      return Colors.red;
    } else if (dependent.daysRemaining <= 30) {
      return AbsherColors.orange;
    } else {
      return AbsherColors.mint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Top row: Name and relationship
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      dependent.name,
                      style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dependent.relationship,
                      style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Avatar icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AbsherColors.purple.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: AbsherColors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AbsherColors.textSecondary),
          const SizedBox(height: 12),
          // Service type row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dependent.serviceType,
                style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
              ),
              Text(
                'نوع الخدمة',
                style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Days remaining row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _urgencyColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '${dependent.daysRemaining}',
                      style: AbsherFonts.title.copyWith(color: _urgencyColor),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'يوم',
                      style: AbsherFonts.body.copyWith(color: _urgencyColor),
                    ),
                  ],
                ),
                Text(
                  'الأيام المتبقية',
                  style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
