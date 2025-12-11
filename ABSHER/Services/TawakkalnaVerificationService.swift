import Foundation

protocol LicenseVerificationProviding {
    func fetchLicenseVerification(for nationalID: String) async throws -> LicenseVerificationSnapshot
}

enum TawakkalnaAdapterError: LocalizedError {
    case sessionExpired
    case upstreamUnavailable
    
    var errorDescription: String? {
        switch self {
        case .sessionExpired:
            return "انتهت صلاحية الجلسة مع توكلنا."
        case .upstreamUnavailable:
            return "خدمة التحقق غير متاحة مؤقتاً."
        }
    }
}

final class TawakkalnaMockVerificationService: LicenseVerificationProviding {
    private let simulatedLatency: UInt64 = 850_000_000 // 0.85s
    private let referenceFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyy-HHmm"
        return formatter
    }()
    
    func fetchLicenseVerification(for nationalID: String) async throws -> LicenseVerificationSnapshot {
        try await Task.sleep(nanoseconds: simulatedLatency)
        
        let now = Date()
        
        let requirementsProof = VerificationProof(
            id: .requirements,
            headline: "جميع المتطلبات جاهزة وموثقة",
            detail: "تمت مزامنة الوثائق من توكلنا دون الحاجة لأي إدخال يدوي.",
            sourceSystem: "توكلنا",
            referenceCode: "DOC-\(referenceFormatter.string(from: now))",
            lastSynced: now.addingTimeInterval(-300),
            status: .verified
        )
        
        let medicalProof = VerificationProof(
            id: .medicalExam,
            headline: "الفحص الطبي تم التحقق منه",
            detail: "تم استلام النتيجة الرقمية من العيادة المعتمدة عبر توكلنا.",
            sourceSystem: "توكلنا",
            referenceCode: "MED-\(referenceFormatter.string(from: now))",
            lastSynced: now.addingTimeInterval(-120),
            status: .verified
        )
        
        return LicenseVerificationSnapshot(
            nationalID: nationalID,
            fetchedAt: now,
            items: [requirementsProof, medicalProof]
        )
    }
}

