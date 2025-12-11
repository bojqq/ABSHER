class ProactiveAlert {
  final String iconName;
  final String title;
  final String serviceType;
  final int daysRemaining;
  final String message;
  final String actionText;

  ProactiveAlert({
    required this.iconName,
    required this.title,
    required this.serviceType,
    required this.daysRemaining,
    required this.message,
    required this.actionText,
  });

  static ProactiveAlert get mock => ProactiveAlert(
        iconName: 'bell.fill',
        title: 'تنبيه استباقي',
        serviceType: 'تجديد رخصة القيادة',
        daysRemaining: 180,
        message: 'رخصة قيادتك على وشك الانتهاء خلال 180 يومًا',
        actionText: 'اضغط للموافقة والدفع الآن',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProactiveAlert &&
          runtimeType == other.runtimeType &&
          iconName == other.iconName &&
          title == other.title &&
          serviceType == other.serviceType &&
          daysRemaining == other.daysRemaining &&
          message == other.message &&
          actionText == other.actionText;

  @override
  int get hashCode =>
      iconName.hashCode ^
      title.hashCode ^
      serviceType.hashCode ^
      daysRemaining.hashCode ^
      message.hashCode ^
      actionText.hashCode;
}
