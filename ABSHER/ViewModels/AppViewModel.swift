import Foundation
import SwiftUI
import Combine

@MainActor
class AppViewModel: ObservableObject {
    @Published var currentScreen: Screen = .splash
    @Published var isLoading: Bool = false
    @Published var totalFeeAmount: Double
    @Published private(set) var paidAmount: Double = 0
    @Published var selectedPaymentAmount: Double
    @Published private(set) var verificationSnapshot: LicenseVerificationSnapshot?
    @Published private(set) var verificationState: VerificationState = .idle
    @Published var selectedServiceType: ServiceType = .drivingLicenseRenewal
    @Published var nationalIdDocument: DigitalDocument?
    
    enum Screen {
        case splash
        case home
        case review
        case confirmation
        case dependents
    }
    
    var paidPercentage: Double {
        guard totalFeeAmount > 0 else { return 0 }
        return paidAmount / totalFeeAmount
    }
    
    var remainingAmount: Double {
        max(totalFeeAmount - paidAmount, 0)
    }
    
    var remainingPercentage: Double {
        guard totalFeeAmount > 0 else { return 0 }
        return 1 - paidPercentage
    }
    
    private let verificationProvider: LicenseVerificationProviding
    private let userProfile: UserProfile
    private let verificationCacheInterval: TimeInterval = 15 * 60
    
    enum VerificationState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }
    
    // MARK: - Init
    
    init(
        totalFeeAmount: Double = MockDataService.shared.serviceDetails.feeAmount,
        verificationProvider: LicenseVerificationProviding = TawakkalnaMockVerificationService(),
        userProfile: UserProfile = MockDataService.shared.userProfile,
        nationalIdDocument: DigitalDocument? = DigitalDocument.mockDocuments.first(where: { $0.type == .nationalID })
    ) {
        self.totalFeeAmount = totalFeeAmount
        self.verificationProvider = verificationProvider
        self.userProfile = userProfile
        self.selectedPaymentAmount = totalFeeAmount
        self.nationalIdDocument = nationalIdDocument
    }
    
    // MARK: - Navigation Methods
    
    func navigateToHome() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .home
        }
        
        Task {
            await fetchVerification(force: false)
        }
    }
    
    func navigateToReview(serviceType: ServiceType = .drivingLicenseRenewal) {
        selectedServiceType = serviceType
        if remainingAmount > 0 {
            if selectedPaymentAmount <= 0 || selectedPaymentAmount > remainingAmount {
                selectedPaymentAmount = remainingAmount
            }
        } else {
            selectedPaymentAmount = totalFeeAmount
        }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .review
        }
    }
    
    /// Returns ServiceDetails based on the selected service type
    var currentServiceDetails: ServiceDetails {
        switch selectedServiceType {
        case .drivingLicenseRenewal:
            return ServiceDetails(
                serviceTitle: "تجديد رخصة القيادة",
                beneficiaryStatus: "يوجد مخالفات مرورية",
                fees: "٢٬٧٠٠ ريال",
                paymentMethod: "جاهز للدفع عبر سداد",
                requirementsStatus: "جميع المتطلبات جاهزة وموثقة",
                medicalCheckStatus: "الفحص الطبي تم التحقق منه",
                timeSavings: 25,
                feeAmount: 2700
            )
        case .nationalIdRenewal:
            // National ID renewal is FREE if renewed on time
            // Late fee of 100 SAR applies if document has expired
            let isLate = nationalIdDocument?.status == .expired
            let lateFeeAmount: Double = isLate ? 100 : 0
            return ServiceDetails(
                serviceTitle: "تجديد الهوية الوطنية",
                beneficiaryStatus: isLate ? "متأخر - يوجد رسوم تأخير" : "لا توجد مخالفات",
                fees: isLate ? "١٠٠ ريال (رسوم تأخير)" : "مجاني",
                paymentMethod: isLate ? "جاهز للدفع عبر سداد" : "لا يوجد رسوم",
                requirementsStatus: "جميع المتطلبات جاهزة وموثقة",
                medicalCheckStatus: "غير مطلوب",
                timeSavings: 15,
                feeAmount: lateFeeAmount,
                baseFee: 0,
                lateFee: lateFeeAmount,
                isLate: isLate
            )
        case .passportRenewal:
            return ServiceDetails(
                serviceTitle: "تجديد جواز السفر",
                beneficiaryStatus: "لا توجد مخالفات",
                fees: "٣٠٠ ريال",
                paymentMethod: "جاهز للدفع عبر سداد",
                requirementsStatus: "جميع المتطلبات جاهزة وموثقة",
                medicalCheckStatus: "غير مطلوب",
                timeSavings: 20,
                feeAmount: 300
            )
        case .dependents:
            return MockDataService.shared.serviceDetails
        }
    }
    
    func navigateToDependents() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .dependents
        }
    }
    
    func approveService() {
        let payableAmount = min(max(selectedPaymentAmount, 0), remainingAmount)
        guard payableAmount > 0 else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isLoading = true
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            withAnimation(.easeInOut(duration: 0.3)) {
                applyPayment(amount: payableAmount)
            }
        }
    }
    
    /// Approve a free service (no payment required)
    func approveFreeService() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isLoading = true
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            withAnimation(.easeInOut(duration: 0.3)) {
                isLoading = false
                currentScreen = .confirmation
            }
        }
    }
    
    private func applyPayment(amount: Double) {
        let previousSelection = selectedPaymentAmount
        paidAmount = min(totalFeeAmount, paidAmount + amount)
        isLoading = false
        
        if remainingAmount <= 0 {
            currentScreen = .confirmation
            selectedPaymentAmount = totalFeeAmount
        } else {
            currentScreen = .home
            selectedPaymentAmount = min(previousSelection, remainingAmount)
            if selectedPaymentAmount <= 0 {
                selectedPaymentAmount = remainingAmount
            }
        }
    }
    
    func resetDemo() {
        withAnimation(.easeInOut(duration: 0.3)) {
            paidAmount = 0
            selectedPaymentAmount = totalFeeAmount
            currentScreen = .splash
            verificationSnapshot = nil
            verificationState = .idle
        }
    }
    
    func updateTotalFeeAmount(_ amount: Double) {
        totalFeeAmount = amount
        paidAmount = min(paidAmount, totalFeeAmount)
        let remaining = max(totalFeeAmount - paidAmount, 0)
        if remaining > 0 {
            selectedPaymentAmount = min(max(selectedPaymentAmount, 0), remaining)
            if selectedPaymentAmount == 0 {
                selectedPaymentAmount = remaining
            }
        } else {
            selectedPaymentAmount = totalFeeAmount
        }
    }
    
    func ensureVerificationFreshness() {
        Task {
            await fetchVerification(force: false)
        }
    }
    
    func refreshVerification() {
        Task {
            await fetchVerification(force: true)
        }
    }
    
    // MARK: - Verification
    
    private func fetchVerification(force: Bool) async {
        if verificationState == .loading { return }
        
        if !force, let snapshot = verificationSnapshot {
            let elapsed = Date().timeIntervalSince(snapshot.fetchedAt)
            if elapsed < verificationCacheInterval {
                verificationState = .loaded
                return
            }
        }
        
        verificationState = .loading
        
        do {
            let snapshot = try await verificationProvider.fetchLicenseVerification(for: userProfile.idNumber)
            verificationSnapshot = snapshot
            verificationState = .loaded
        } catch {
            verificationState = .failed(error.localizedDescription)
        }
    }
}
