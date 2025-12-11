import 'package:uuid/uuid.dart';

/// Represents a dependent (تابع) family member with upcoming service deadlines
class Dependent {
  final String id;
  final String name;
  final String relationship; // e.g., "ولدك", "ابنتك"
  final String serviceType; // e.g., "اصدار رخصة"
  final int daysRemaining;

  Dependent({
    String? id,
    required this.name,
    required this.relationship,
    required this.serviceType,
    required this.daysRemaining,
  }) : id = id ?? const Uuid().v4();

  /// Formatted alert message for display in chat
  String get alertMessage =>
      '$relationship $name باقي له $daysRemaining يوم على $serviceType';

  /// Mock data for testing (حسام with 180 days remaining)
  static Dependent get mock => Dependent(
        name: 'حسام',
        relationship: 'ولدك',
        serviceType: 'اصدار رخصة',
        daysRemaining: 180,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dependent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          relationship == other.relationship &&
          serviceType == other.serviceType &&
          daysRemaining == other.daysRemaining;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      relationship.hashCode ^
      serviceType.hashCode ^
      daysRemaining.hashCode;
}
