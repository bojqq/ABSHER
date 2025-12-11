import 'package:uuid/uuid.dart';

/// Represents the type of service for deep linking
enum ServiceType {
  drivingLicenseRenewal,
  passportRenewal,
  nationalIdRenewal,
  dependents,
}

extension ServiceTypeExtension on ServiceType {
  String get rawValue {
    switch (this) {
      case ServiceType.drivingLicenseRenewal:
        return 'driving_license_renewal';
      case ServiceType.passportRenewal:
        return 'passport_renewal';
      case ServiceType.nationalIdRenewal:
        return 'national_id_renewal';
      case ServiceType.dependents:
        return 'dependents';
    }
  }
}

/// Represents a clickable link within a chat message that navigates to a specific app screen
class DeepLink {
  final ServiceType serviceType;
  final String title;
  final String? alertId;

  DeepLink({
    required this.serviceType,
    required this.title,
    this.alertId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeepLink &&
          runtimeType == other.runtimeType &&
          serviceType == other.serviceType &&
          title == other.title &&
          alertId == other.alertId;

  @override
  int get hashCode => serviceType.hashCode ^ title.hashCode ^ alertId.hashCode;
}

/// Represents a message in the chat conversation (user or bot)
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final DeepLink? deepLink;

  ChatMessage({
    String? id,
    required this.content,
    required this.isUser,
    DateTime? timestamp,
    this.deepLink,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  /// Creates a user message
  static ChatMessage userMessage(String content) {
    return ChatMessage(content: content, isUser: true);
  }

  /// Creates a bot message
  static ChatMessage botMessage(String content, {DeepLink? deepLink}) {
    return ChatMessage(content: content, isUser: false, deepLink: deepLink);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          content == other.content &&
          isUser == other.isUser;

  @override
  int get hashCode => id.hashCode ^ content.hashCode ^ isUser.hashCode;
}
