class ServiceDetails {
  final String serviceTitle;
  final String beneficiaryStatus;
  final String fees;
  final String paymentMethod;
  final String requirementsStatus;
  final String medicalCheckStatus;
  final int timeSavings;
  final double feeAmount;
  final double baseFee;
  final double lateFee;
  final bool isLate;

  ServiceDetails({
    required this.serviceTitle,
    required this.beneficiaryStatus,
    required this.fees,
    required this.paymentMethod,
    required this.requirementsStatus,
    required this.medicalCheckStatus,
    required this.timeSavings,
    required this.feeAmount,
    double? baseFee,
    this.lateFee = 0,
    this.isLate = false,
  }) : baseFee = baseFee ?? feeAmount;

  static ServiceDetails get mock => ServiceDetails(
        serviceTitle: 'تجديد رخصة القيادة',
        beneficiaryStatus: 'يوجد مخالفات مرورية',
        fees: '٢٬٧٠٠ ريال',
        paymentMethod: 'جاهز للدفع عبر سداد',
        requirementsStatus: 'جميع المتطلبات جاهزة وموثقة',
        medicalCheckStatus: 'الفحص الطبي تم التحقق منه',
        timeSavings: 25,
        feeAmount: 2700,
      );
}
