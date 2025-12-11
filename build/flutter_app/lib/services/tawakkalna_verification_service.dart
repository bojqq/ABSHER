import 'package:intl/intl.dart';
import '../models/license_verification.dart';

abstract class LicenseVerificationProviding {
  Future<LicenseVerificationSnapshot> fetchLicenseVerification(
      String nationalID);
}

class TawakkalnaAdapterError implements Exception {
  final String message;
  TawakkalnaAdapterError(this.message);

  static TawakkalnaAdapterError sessionExpired() =>
      TawakkalnaAdapterError('انتهت صلاحية الجلسة مع توكلنا.');

  static TawakkalnaAdapterError upstreamUnavailable() =>
      TawakkalnaAdapterError('خدمة التحقق غير متاحة مؤقتاً.');

  @override
  String toString() => message;
}

class TawakkalnaMockVerificationService implements LicenseVerificationProviding {
  static const _simulatedLatency = Duration(milliseconds: 850);
  final _referenceFormatter = DateFormat('ddMMyy-HHmm');

  @override
  Future<LicenseVerificationSnapshot> fetchLicenseVerification(
      String nationalID) async {
    await Future.delayed(_simulatedLatency);

    final now = DateTime.now();

    final requirementsProof = VerificationProof(
      id: VerificationItemType.requirements,
      headline: 'جميع المتطلبات جاهزة وموثقة',
      detail: 'تمت مزامنة الوثائق من توكلنا دون الحاجة لأي إدخال يدوي.',
      sourceSystem: 'توكلنا',
      referenceCode: 'DOC-${_referenceFormatter.format(now)}',
      lastSynced: now.subtract(const Duration(minutes: 5)),
      status: VerificationStatusState.verified,
    );

    final medicalProof = VerificationProof(
      id: VerificationItemType.medicalExam,
      headline: 'الفحص الطبي تم التحقق منه',
      detail: 'تم استلام النتيجة الرقمية من العيادة المعتمدة عبر توكلنا.',
      sourceSystem: 'توكلنا',
      referenceCode: 'MED-${_referenceFormatter.format(now)}',
      lastSynced: now.subtract(const Duration(minutes: 2)),
      status: VerificationStatusState.verified,
    );

    return LicenseVerificationSnapshot(
      nationalID: nationalID,
      fetchedAt: now,
      items: [requirementsProof, medicalProof],
    );
  }
}
