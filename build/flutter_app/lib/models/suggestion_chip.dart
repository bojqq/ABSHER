import 'package:uuid/uuid.dart';
import 'proactive_alert.dart';

/// Represents a tappable suggestion based on proactive alerts
class SuggestionChip {
  final String id;
  final ProactiveAlert alert;
  final String displayText;

  SuggestionChip({
    String? id,
    required this.alert,
    required this.displayText,
  }) : id = id ?? const Uuid().v4();

  /// Arabic prefix for proactive alert suggestions
  static const String arabicPrefix = 'عندك إشعار من التنبيه الاستباقي';

  /// Creates a SuggestionChip from a ProactiveAlert
  static SuggestionChip fromAlert(ProactiveAlert alert) {
    return SuggestionChip(
      alert: alert,
      displayText: formatDisplayText(alertTitle: alert.title),
    );
  }

  /// Formats the display text with Arabic prefix and alert title
  static String formatDisplayText({required String alertTitle}) {
    return '$arabicPrefix: $alertTitle';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionChip &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          alert == other.alert &&
          displayText == other.displayText;

  @override
  int get hashCode => id.hashCode ^ alert.hashCode ^ displayText.hashCode;
}
