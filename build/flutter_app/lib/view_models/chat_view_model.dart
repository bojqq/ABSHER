import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/proactive_alert.dart';
import '../models/suggestion_chip.dart';
import '../models/dependent.dart';
import '../services/mlx_service.dart';

/// Navigation destination for deep link handling
enum NavigationDestination {
  dependents,
  review,
}

/// ViewModel for managing chat state and coordinating between UI and MLX service
class ChatViewModel extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  List<SuggestionChip> _suggestions = [];
  bool _isProcessing = false;
  String _inputText = '';

  final MLXService mlxService;
  final List<ProactiveAlert> Function() alertsProvider;

  List<ChatMessage> get messages => _messages;
  List<SuggestionChip> get suggestions => _suggestions;
  bool get isProcessing => _isProcessing;
  String get inputText => _inputText;

  set inputText(String value) {
    _inputText = value;
    notifyListeners();
  }

  ChatViewModel({
    required this.mlxService,
    required this.alertsProvider,
  });

  // MARK: - Suggestion Management

  void loadSuggestions() {
    final alerts = alertsProvider();

    if (alerts.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }

    _suggestions = alerts.map((alert) => SuggestionChip.fromAlert(alert)).toList();
    notifyListeners();
  }

  // MARK: - Message Handling

  Future<void> sendMessage() async {
    final text = _inputText.trim();
    if (text.isEmpty) return;

    final userMessage = ChatMessage.userMessage(text);
    _messages.add(userMessage);

    _inputText = '';
    _isProcessing = true;
    notifyListeners();

    await _generateResponse(text, alertContext: null);
  }

  Future<void> handleSuggestionTap(SuggestionChip chip) async {
    final contextText = chip.displayText;

    final userMessage = ChatMessage.userMessage(contextText);
    _messages.add(userMessage);

    _isProcessing = true;
    notifyListeners();

    await _generateResponse(contextText, alertContext: chip.alert);
  }

  // MARK: - Deep Link Navigation

  NavigationDestination handleDeepLinkTap(DeepLink deepLink) {
    switch (deepLink.serviceType) {
      case ServiceType.dependents:
        return NavigationDestination.dependents;
      case ServiceType.drivingLicenseRenewal:
      case ServiceType.passportRenewal:
      case ServiceType.nationalIdRenewal:
        return NavigationDestination.review;
    }
  }

  // MARK: - Dependent Alerts

  ChatMessage createDependentAlertMessage(Dependent dependent) {
    final deepLink = DeepLink(
      serviceType: ServiceType.dependents,
      title: dependent.alertMessage,
      alertId: dependent.id,
    );
    return ChatMessage.botMessage(dependent.alertMessage, deepLink: deepLink);
  }

  Dependent? getActiveDependentAlert() {
    return Dependent.mock;
  }

  // MARK: - Private Methods

  Future<void> _generateResponse(String prompt, {ProactiveAlert? alertContext}) async {
    String responseText = '';

    try {
      await for (final token in mlxService.generate(prompt)) {
        responseText += token;
      }

      final deepLink = alertContext != null
          ? _createDeepLink(alertContext)
          : _detectAndCreateDeepLink(prompt);

      final botMessage = ChatMessage.botMessage(responseText, deepLink: deepLink);
      _messages.add(botMessage);

      if (alertContext != null) {
        final dependent = getActiveDependentAlert();
        if (dependent != null) {
          final dependentAlertMessage = createDependentAlertMessage(dependent);
          _messages.add(dependentAlertMessage);
        }
      }
    } catch (e) {
      final errorMessage = ChatMessage.botMessage(
        'عذراً، حدث خطأ أثناء معالجة طلبك. يرجى المحاولة مرة أخرى.',
      );
      _messages.add(errorMessage);
    }

    _isProcessing = false;
    notifyListeners();
  }

  DeepLink _createDeepLink(ProactiveAlert alert) {
    ServiceType serviceType;
    switch (alert.serviceType) {
      case 'تجديد رخصة القيادة':
        serviceType = ServiceType.drivingLicenseRenewal;
        break;
      case 'تجديد جواز السفر':
        serviceType = ServiceType.passportRenewal;
        break;
      case 'تجديد الهوية':
        serviceType = ServiceType.nationalIdRenewal;
        break;
      default:
        serviceType = ServiceType.drivingLicenseRenewal;
    }

    return DeepLink(
      serviceType: serviceType,
      title: alert.title,
      alertId: null,
    );
  }

  DeepLink? _detectAndCreateDeepLink(String prompt) {
    final lowercasedPrompt = prompt.toLowerCase();

    if (lowercasedPrompt.contains('رخصة') ||
        lowercasedPrompt.contains('القيادة') ||
        lowercasedPrompt.contains('license') ||
        lowercasedPrompt.contains('driving') ||
        lowercasedPrompt.contains('اجدد') ||
        lowercasedPrompt.contains('تجديد')) {
      return DeepLink(
        serviceType: ServiceType.drivingLicenseRenewal,
        title: 'تجديد رخصة القيادة',
        alertId: null,
      );
    }

    if (lowercasedPrompt.contains('جواز') ||
        lowercasedPrompt.contains('السفر') ||
        lowercasedPrompt.contains('passport')) {
      return DeepLink(
        serviceType: ServiceType.passportRenewal,
        title: 'تجديد جواز السفر',
        alertId: null,
      );
    }

    if (lowercasedPrompt.contains('هوية') ||
        lowercasedPrompt.contains('الوطنية') ||
        lowercasedPrompt.contains('national id')) {
      return DeepLink(
        serviceType: ServiceType.nationalIdRenewal,
        title: 'تجديد الهوية الوطنية',
        alertId: null,
      );
    }

    return null;
  }
}
