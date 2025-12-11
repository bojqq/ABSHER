import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/app_view_model.dart';
import '../services/mock_data_service.dart';
import '../extensions/color_absher.dart';
import '../components/top_navigation_bar.dart';
import '../components/user_profile_card.dart';
import '../components/proactive_alert_card.dart';
import '../components/payment_progress_card.dart';
import '../components/digital_documents_section.dart';
import '../components/quick_access_section.dart';
import '../components/bottom_tab_bar.dart';
import 'absher_chat_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _mockData = MockDataService.shared;

  void _showChatSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: AbsherChatView(
          proactiveAlerts: [_mockData.proactiveAlert],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AbsherColors.background,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      // Top Navigation Bar
                      TopNavigationBar(onChatTapped: _showChatSheet),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // User Profile Card
                            UserProfileCard(profile: _mockData.userProfile),
                            const SizedBox(height: 16),
                            // Proactive Alert Card
                            ProactiveAlertCard(
                              alert: _mockData.proactiveAlert,
                              onTap: () => viewModel.navigateToReview(),
                            ),
                            const SizedBox(height: 16),
                            // Payment Progress Card
                            if (viewModel.paidAmount > 0)
                              PaymentProgressCard(
                                paidAmount: viewModel.paidAmount,
                                totalAmount: viewModel.totalFeeAmount,
                              ),
                            if (viewModel.paidAmount > 0) const SizedBox(height: 16),
                            // Digital Documents Section
                            DigitalDocumentsSection(documents: _mockData.documents),
                            const SizedBox(height: 24),
                            // Quick Access Section
                            const QuickAccessSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom Tab Bar
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomTabBar(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
