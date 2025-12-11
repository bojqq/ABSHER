import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/service_details.dart';
import '../models/license_verification.dart';
import '../models/digital_document.dart';
import '../models/user_profile.dart';
import '../services/mock_data_service.dart';
import '../services/tawakkalna_verification_service.dart';

enum Screen {
  splash,
  home,
  review,
  confirmation,
  dependents,
}

enum VerificationState {
  idle,
  loading,
  loaded,
  failed,
}

class AppViewModel extends ChangeNotifier {
  Screen _currentScreen = Screen.splash;
  bool _isLoading = false;
  double _totalFeeAmount;
  double _paidAmount = 0;
  double _selectedPaymentAmount;
  LicenseVerificationSnapshot? _verificationSnapshot;
  VerificationState _verificationState = VerificationState.idle;
  ServiceType _selectedServiceType = ServiceType.drivingLicenseRenewal;
  DigitalDocument? _nationalIdDocument;
  String? _verificationErrorMessage;

  final LicenseVerificationProviding _verificationProvider;
  final UserProfile _userProfile;
  static const _verificationCacheInterval = Duration(minutes: 15);

  Screen get currentScreen => _currentScreen;
  bool get isLoading => _isLoading;
  double get totalFeeAmount => _totalFeeAmount;
  double get paidAmount => _paidAmount;
  double get selectedPaymentAmount => _selectedPaymentAmount;
  LicenseVerificationSnapshot? get verificationSnapshot => _verificationSnapshot;
  VerificationState get verificationState => _verificationState;
  ServiceType get selectedServiceType => _selectedServiceType;
  DigitalDocument? get nationalIdDocument => _nationalIdDocument;
  String? get verificationErrorMessage => _verificationErrorMessage;

  double get paidPercentage {
    if (_totalFeeAmount <= 0) return 0;
    return _paidAmount / _totalFeeAmount;
  }

  double get remainingAmount => (_totalFeeAmount - _paidAmount).clamp(0, double.infinity);

  double get remainingPercentage {
    if (_totalFeeAmount <= 0) return 0;
    return 1 - paidPercentage;
  }

  AppViewModel({
    double? totalFeeAmount,
    LicenseVerificationProviding? verificationProvider,
    UserProfile? userProfile,
    DigitalDocument? nationalIdDocument,
  })  : _totalFeeAmount = totalFeeAmount ?? MockDataService.shared.serviceDetails.feeAmount,
        _verificationProvider = verificationProvider ?? TawakkalnaMockVerificationService(),
        _userProfile = userProfile ?? MockDataService.shared.userProfile,
        _nationalIdDocument = nationalIdDocument ?? DigitalDocument.mockDocuments.firstWhere(
              (doc) => doc.type == DocumentType.nationalID,
              orElse: () => DigitalDocument.mockDocuments.first,
            ),
        _selectedPaymentAmount = totalFeeAmount ?? MockDataService.shared.serviceDetails.feeAmount;

  set currentScreen(Screen value) {
    _currentScreen = value;
    notifyListeners();
  }

  set selectedPaymentAmount(double value) {
    _selectedPaymentAmount = value;
    notifyListeners();
  }

  // MARK: - Navigation Methods

  Future<void> navigateToHome() async {
    _currentScreen = Screen.home;
    notifyListeners();
    await _fetchVerification(force: false);
  }

  void navigateToReview({ServiceType serviceType = ServiceType.drivingLicenseRenewal}) {
    _selectedServiceType = serviceType;
    if (remainingAmount > 0) {
      if (_selectedPaymentAmount <= 0 || _selectedPaymentAmount > remainingAmount) {
        _selectedPaymentAmount = remainingAmount;
      }
    } else {
      _selectedPaymentAmount = _totalFeeAmount;
    }
    _currentScreen = Screen.review;
    notifyListeners();
  }

  ServiceDetails get currentServiceDetails {
    switch (_selectedServiceType) {
      case ServiceType.drivingLicenseRenewal:
        return ServiceDetails(
          serviceTitle: 'تجديد رخصة القيادة',
          beneficiaryStatus: 'يوجد مخالفات مرورية',
          fees: '٢٬٧٠٠ ريال',
          paymentMethod: 'جاهز للدفع عبر سداد',
          requirementsStatus: 'جميع المتطلبات جاهزة وموثقة',
          medicalCheckStatus: 'الفحص الطبي تم التحقق منه',
          timeSavings: 25,
          feeAmount: 2700,
        );
      case ServiceType.nationalIdRenewal:
        final isLate = _nationalIdDocument?.status == DocumentStatus.expired;
        final lateFeeAmount = isLate ? 100.0 : 0.0;
        return ServiceDetails(
          serviceTitle: 'تجديد الهوية الوطنية',
          beneficiaryStatus: isLate ? 'متأخر - يوجد رسوم تأخير' : 'لا توجد مخالفات',
          fees: isLate ? '١٠٠ ريال (رسوم تأخير)' : 'مجاني',
          paymentMethod: isLate ? 'جاهز للدفع عبر سداد' : 'لا يوجد رسوم',
          requirementsStatus: 'جميع المتطلبات جاهزة وموثقة',
          medicalCheckStatus: 'غير مطلوب',
          timeSavings: 15,
          feeAmount: lateFeeAmount,
          baseFee: 0,
          lateFee: lateFeeAmount,
          isLate: isLate,
        );
      case ServiceType.passportRenewal:
        return ServiceDetails(
          serviceTitle: 'تجديد جواز السفر',
          beneficiaryStatus: 'لا توجد مخالفات',
          fees: '٣٠٠ ريال',
          paymentMethod: 'جاهز للدفع عبر سداد',
          requirementsStatus: 'جميع المتطلبات جاهزة وموثقة',
          medicalCheckStatus: 'غير مطلوب',
          timeSavings: 20,
          feeAmount: 300,
        );
      case ServiceType.dependents:
        return MockDataService.shared.serviceDetails;
    }
  }

  void navigateToDependents() {
    _currentScreen = Screen.dependents;
    notifyListeners();
  }

  Future<void> approveService() async {
    final payableAmount = _selectedPaymentAmount.clamp(0.0, remainingAmount);
    if (payableAmount <= 0) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _applyPayment(payableAmount.toDouble());
  }

  Future<void> approveFreeService() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _isLoading = false;
    _currentScreen = Screen.confirmation;
    notifyListeners();
  }

  void _applyPayment(double amount) {
    final previousSelection = _selectedPaymentAmount;
    _paidAmount = (_paidAmount + amount).clamp(0.0, _totalFeeAmount);
    _isLoading = false;

    if (remainingAmount <= 0) {
      _currentScreen = Screen.confirmation;
      _selectedPaymentAmount = _totalFeeAmount;
    } else {
      _currentScreen = Screen.home;
      _selectedPaymentAmount = previousSelection.clamp(0.0, remainingAmount).toDouble();
      if (_selectedPaymentAmount <= 0) {
        _selectedPaymentAmount = remainingAmount.toDouble();
      }
    }
    notifyListeners();
  }

  void resetDemo() {
    _paidAmount = 0;
    _selectedPaymentAmount = _totalFeeAmount;
    _currentScreen = Screen.splash;
    _verificationSnapshot = null;
    _verificationState = VerificationState.idle;
    notifyListeners();
  }

  void updateTotalFeeAmount(double amount) {
    _totalFeeAmount = amount;
    _paidAmount = _paidAmount.clamp(0.0, _totalFeeAmount);
    final remaining = (_totalFeeAmount - _paidAmount).clamp(0.0, double.infinity);
    if (remaining > 0) {
      _selectedPaymentAmount = _selectedPaymentAmount.clamp(0.0, remaining).toDouble();
      if (_selectedPaymentAmount == 0) {
        _selectedPaymentAmount = remaining.toDouble();
      }
    } else {
      _selectedPaymentAmount = _totalFeeAmount;
    }
    notifyListeners();
  }

  void ensureVerificationFreshness() {
    _fetchVerification(force: false);
  }

  void refreshVerification() {
    _fetchVerification(force: true);
  }

  // MARK: - Verification

  Future<void> _fetchVerification({required bool force}) async {
    if (_verificationState == VerificationState.loading) return;

    if (!force && _verificationSnapshot != null) {
      final elapsed = DateTime.now().difference(_verificationSnapshot!.fetchedAt);
      if (elapsed < _verificationCacheInterval) {
        _verificationState = VerificationState.loaded;
        notifyListeners();
        return;
      }
    }

    _verificationState = VerificationState.loading;
    notifyListeners();

    try {
      final snapshot = await _verificationProvider.fetchLicenseVerification(_userProfile.idNumber);
      _verificationSnapshot = snapshot;
      _verificationState = VerificationState.loaded;
    } catch (e) {
      _verificationState = VerificationState.failed;
      _verificationErrorMessage = e.toString();
    }
    notifyListeners();
  }
}
