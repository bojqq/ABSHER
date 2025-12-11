import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/app_view_model.dart';
import '../services/mock_data_service.dart';
import 'splash_view.dart';
import 'home_view.dart';
import 'review_view.dart';
import 'confirmation_view.dart';
import 'dependents_view.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          child: _buildScreen(viewModel),
        );
      },
    );
  }

  Widget _buildScreen(AppViewModel viewModel) {
    switch (viewModel.currentScreen) {
      case Screen.splash:
        return const SplashView(key: ValueKey('splash'));
      case Screen.home:
        return HomeView(key: const ValueKey('home'));
      case Screen.review:
        return ReviewView(
          key: const ValueKey('review'),
          serviceDetails: viewModel.currentServiceDetails,
          userProfile: MockDataService.shared.userProfile,
        );
      case Screen.confirmation:
        return ConfirmationView(
          key: const ValueKey('confirmation'),
          timeSavings: MockDataService.shared.serviceDetails.timeSavings,
        );
      case Screen.dependents:
        return DependentsView(
          key: const ValueKey('dependents'),
          dependents: MockDataService.shared.dependents,
        );
    }
  }
}
