import '../models/user_profile.dart';
import '../models/digital_document.dart';
import '../models/proactive_alert.dart';
import '../models/service_details.dart';
import '../models/dependent.dart';

class MockDataService {
  static final MockDataService shared = MockDataService._();

  MockDataService._();

  final UserProfile userProfile = UserProfile.mock;
  final List<DigitalDocument> documents = DigitalDocument.mockDocuments;
  final ProactiveAlert proactiveAlert = ProactiveAlert.mock;
  final ServiceDetails serviceDetails = ServiceDetails.mock;
  final List<Dependent> dependents = [
    Dependent.mock,
    Dependent(
      name: 'سارة',
      relationship: 'ابنتك',
      serviceType: 'تجديد هوية',
      daysRemaining: 27,
    ),
  ];
}
