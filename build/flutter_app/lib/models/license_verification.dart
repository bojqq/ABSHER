enum VerificationItemType {
  requirements,
  medicalExam,
}

extension VerificationItemTypeExtension on VerificationItemType {
  String get title {
    switch (this) {
      case VerificationItemType.requirements:
        return 'المتطلبات';
      case VerificationItemType.medicalExam:
        return 'الفحص الطبي';
    }
  }
}

enum VerificationStatusState {
  verified,
  missing,
  failed,
}

extension VerificationStatusStateExtension on VerificationStatusState {
  String get localizedLabel {
    switch (this) {
      case VerificationStatusState.verified:
        return 'تم التحقق';
      case VerificationStatusState.missing:
        return 'ناقص';
      case VerificationStatusState.failed:
        return 'تعذر التحقق';
    }
  }
}

class VerificationProof {
  final VerificationItemType id;
  final String headline;
  final String detail;
  final String sourceSystem;
  final String referenceCode;
  final DateTime lastSynced;
  final VerificationStatusState status;

  VerificationProof({
    required this.id,
    required this.headline,
    required this.detail,
    required this.sourceSystem,
    required this.referenceCode,
    required this.lastSynced,
    required this.status,
  });

  String get lastSyncedRelativeString {
    final now = DateTime.now();
    final difference = now.difference(lastSynced);
    
    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}

class LicenseVerificationSnapshot {
  final String nationalID;
  final DateTime fetchedAt;
  final List<VerificationProof> items;

  LicenseVerificationSnapshot({
    required this.nationalID,
    required this.fetchedAt,
    required this.items,
  });

  VerificationProof? item(VerificationItemType type) {
    try {
      return items.firstWhere((item) => item.id == type);
    } catch (_) {
      return null;
    }
  }
}
