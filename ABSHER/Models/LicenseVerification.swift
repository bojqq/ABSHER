import Foundation

enum VerificationItemType: String, CaseIterable {
    case requirements
    case medicalExam
    
    var title: String {
        switch self {
        case .requirements:
            return "المتطلبات"
        case .medicalExam:
            return "الفحص الطبي"
        }
    }
}

enum VerificationStatusState {
    case verified
    case missing
    case failed
    
    var localizedLabel: String {
        switch self {
        case .verified:
            return "تم التحقق"
        case .missing:
            return "ناقص"
        case .failed:
            return "تعذر التحقق"
        }
    }
}

struct VerificationProof: Identifiable {
    let id: VerificationItemType
    let headline: String
    let detail: String
    let sourceSystem: String
    let referenceCode: String
    let lastSynced: Date
    let status: VerificationStatusState
    
    var lastSyncedRelativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: lastSynced, relativeTo: Date())
    }
}

struct LicenseVerificationSnapshot {
    let nationalID: String
    let fetchedAt: Date
    let items: [VerificationProof]
    
    func item(for type: VerificationItemType) -> VerificationProof? {
        items.first { $0.id == type }
    }
}

