# ABSHER Flutter App

A 1:1 Flutter translation of the ABSHER iOS SwiftUI app.

## Project Structure

```
lib/
├── main.dart                    # App entry point (ABSHERApp.swift)
├── extensions/
│   ├── color_absher.dart        # Color+Absher.swift
│   ├── font_absher.dart         # Font+Absher.swift
│   └── view_modifiers.dart      # ViewModifiers.swift
├── models/
│   ├── chat_message.dart        # ChatMessage.swift
│   ├── dependent.dart           # Dependent.swift
│   ├── digital_document.dart    # DigitalDocument.swift
│   ├── license_verification.dart # LicenseVerification.swift
│   ├── proactive_alert.dart     # ProactiveAlert.swift
│   ├── service_details.dart     # ServiceDetails.swift
│   ├── suggestion_chip.dart     # SuggestionChip.swift
│   └── user_profile.dart        # UserProfile.swift
├── services/
│   ├── mlx_service.dart         # MLXService.swift
│   ├── mock_data_service.dart   # MockDataService.swift
│   └── tawakkalna_verification_service.dart # TawakkalnaVerificationService.swift
├── view_models/
│   ├── app_view_model.dart      # AppViewModel.swift
│   └── chat_view_model.dart     # ChatViewModel.swift
├── views/
│   ├── absher_chat_view.dart    # AbsherChatView.swift
│   ├── confirmation_view.dart   # ConfirmationView.swift
│   ├── content_view.dart        # ContentView.swift
│   ├── dependents_view.dart     # DependentsView.swift
│   ├── home_view.dart           # HomeView.swift
│   ├── loading_view.dart        # LoadingView.swift
│   ├── login_view.dart          # LoginView.swift
│   └── review_view.dart         # ReviewView.swift
└── components/
    ├── bottom_tab_bar.dart      # BottomTabBar.swift
    ├── digital_documents_section.dart # DigitalDocumentsSection.swift
    ├── license_header_card.dart # LicenseHeaderCard.swift
    ├── payment_progress_card.dart # PaymentProgressCard.swift
    ├── proactive_alert_card.dart # ProactiveAlertCard.swift
    ├── quick_access_section.dart # QuickAccessSection.swift
    ├── top_navigation_bar.dart  # TopNavigationBar.swift
    └── user_profile_card.dart   # UserProfileCard.swift
```

## Getting Started

1. Install Flutter SDK
2. Run `flutter pub get`
3. Download Tajawal font and place in `fonts/` directory
4. Run `flutter run`

## Features

- Login flow with loading animation
- Home view with proactive alerts
- Digital documents section
- Payment progress tracking
- Service review with Tawakkalna verification
- AI Chat with deep link navigation
- Dependents management
- RTL Arabic support
