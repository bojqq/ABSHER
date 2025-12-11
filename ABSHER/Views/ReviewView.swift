//
//  ReviewView.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct ReviewView: View {
    @ObservedObject var viewModel: AppViewModel
    let serviceDetails: ServiceDetails
    let userProfile: UserProfile
    @State private var isBooked: Bool = false
    
    var body: some View {
        ZStack {
            // Dark background
            Color.absherBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation bar
                navigationBar
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // License header card
                        licenseHeaderCard
                        
                        // Service detail sections
                        beneficiaryStatusSection
                        feeBreakdownSection
                        feesSection
                        
                        if viewModel.remainingAmount > 0 {
                            splitPaymentSection
                        }
                        
                        requirementsSection
                        medicalCheckSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 100) // Space for button
                }
                
                Spacer()
            }
            
            // Approve button at bottom
            VStack {
                Spacer()
                approveButton
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .onAppear {
            viewModel.updateTotalFeeAmount(serviceDetails.feeAmount)
            viewModel.ensureVerificationFreshness()
        }
    }
    
    // MARK: - Navigation Bar
    
    private var navigationBar: some View {
        HStack {
            Spacer()
            
            Text(serviceDetails.serviceTitle)
                .font(.absherHeadline)
                .foregroundColor(.absherTextPrimary)
            
            Spacer()
            
            Button(action: {
                viewModel.currentScreen = .home
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.absherGreen)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.absherCardBackground)
    }

    
    // MARK: - License Header
    
    private var licenseHeaderCard: some View {
        LicenseHeaderCard(
            profile: userProfile,
            serviceTitle: serviceDetails.serviceTitle
        )
    }
    
    // MARK: - Beneficiary Status Section
    
    private var beneficiaryStatusSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            HStack(spacing: 12) {
                Text(serviceDetails.beneficiaryStatus)
                    .font(.absherBody)
                    .foregroundColor(.absherTextPrimary)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.absherOrange)
            }
            
            Text("حالة المستفيد")
                .font(.absherCaption)
                .foregroundColor(.absherTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(16)
        .absherCardStyle()
    }
    
    // MARK: - Fee Breakdown Section
    
    private var feeBreakdownSection: some View {
        VStack(alignment: .trailing, spacing: 16) {
            Text("تفاصيل الرسوم")
                .font(.absherHeadline)
                .foregroundColor(.absherTextPrimary)
            
            VStack(alignment: .trailing, spacing: 12) {
                // Base fee row
                HStack {
                    Text(serviceDetails.baseFee == 0 ? "مجاني" : formattedCurrency(serviceDetails.baseFee))
                        .font(.absherBody)
                        .foregroundColor(serviceDetails.baseFee == 0 ? .absherGreen : .absherTextPrimary)
                    Spacer()
                    Text(serviceDetails.serviceTitle)
                        .font(.absherBody)
                        .foregroundColor(.absherTextSecondary)
                }
                
                // Late fee row (only show if there's a late fee)
                if serviceDetails.isLate && serviceDetails.lateFee > 0 {
                    HStack {
                        Text(formattedCurrency(serviceDetails.lateFee))
                            .font(.absherBody)
                            .foregroundColor(.absherOrange)
                        Spacer()
                        Text("رسوم تأخير")
                            .font(.absherBody)
                            .foregroundColor(.absherTextSecondary)
                    }
                }
                
                Divider()
                    .background(Color.absherTextSecondary.opacity(0.3))
                
                HStack {
                    Text(serviceDetails.feeAmount == 0 ? "مجاني" : formattedCurrency(serviceDetails.feeAmount))
                        .font(.absherHeadline)
                        .foregroundColor(serviceDetails.feeAmount == 0 ? .absherGreen : .absherMint)
                    Spacer()
                    Text("المجموع")
                        .font(.absherBody)
                        .foregroundColor(.absherTextPrimary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(16)
        .absherCardStyle()
    }
    
    // MARK: - Fees Section
    
    private var feesSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            HStack(spacing: 12) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(serviceDetails.fees)
                        .font(.absherHeadline)
                        .foregroundColor(.absherTextPrimary)
                    
                    Text(serviceDetails.paymentMethod)
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                }
                
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.absherMint)
            }
            
            Text("الرسوم")
                .font(.absherCaption)
                .foregroundColor(.absherTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(16)
        .absherCardStyle()
    }
    
    // MARK: - Split Payment Section
    
    private var splitPaymentSection: some View {
        VStack(alignment: .trailing, spacing: 16) {
            VStack(alignment: .trailing, spacing: 4) {
                Text("قسّم دفعتك كما يناسبك")
                    .font(.absherHeadline)
                    .foregroundColor(.absherTextPrimary)
                
                Text("اختر مبلغًا بين ٠ ريال والمتبقي لديك من الرسوم.")
                    .font(.absherCaption)
                    .foregroundColor(.absherTextSecondary)
            }
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("المبلغ المختار")
                    .font(.absherCaption)
                    .foregroundColor(.absherTextSecondary)
                
                Text("\(formattedCurrency(viewModel.selectedPaymentAmount)) (\(formattedPercentage(selectedPaymentPercentage)))")
                    .font(.absherHeadline)
                    .foregroundColor(.absherMint)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Slider(
                value: Binding(
                    get: { min(viewModel.selectedPaymentAmount, viewModel.remainingAmount) },
                    set: { newValue in
                        viewModel.selectedPaymentAmount = newValue
                    }
                ),
                in: 0...viewModel.remainingAmount,
                step: 10
            )
            .tint(.absherOrange)
            
            HStack {
                Text(formattedCurrency(0))
                    .font(.absherCaption)
                    .foregroundColor(.absherTextSecondary)
                
                Spacer()
                
                Text("المتبقي \(formattedCurrency(viewModel.remainingAmount))")
                    .font(.absherCaption)
                    .foregroundColor(.absherTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(16)
        .absherCardStyle()
    }
    
    // MARK: - Requirements Section
    
    private var requirementsSection: some View {
        VerificationStatusCard(
            title: VerificationItemType.requirements.title,
            iconName: "doc.text.fill",
            accentColor: .absherLightGreen,
            fallbackHeadline: serviceDetails.requirementsStatus,
            proof: viewModel.verificationSnapshot?.item(for: .requirements),
            state: viewModel.verificationState,
            refreshAction: viewModel.refreshVerification
        )
    }
    
    // MARK: - Medical Check Section
    
    private var medicalCheckSection: some View {
        VerificationStatusCard(
            title: VerificationItemType.medicalExam.title,
            iconName: "heart.text.square.fill",
            accentColor: .absherGreen,
            fallbackHeadline: serviceDetails.medicalCheckStatus,
            proof: viewModel.verificationSnapshot?.item(for: .medicalExam),
            state: viewModel.verificationState,
            refreshAction: viewModel.refreshVerification
        )
    }
    
    // MARK: - Approve Button
    
    private var approveButton: some View {
        Button(action: {
            if isBooked {
                // Already booked, do nothing or navigate
                return
            }
            
            if serviceDetails.feeAmount == 0 {
                // For free services, show booked state then navigate
                withAnimation(.easeInOut(duration: 0.3)) {
                    isBooked = true
                }
                // Navigate to confirmation after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    viewModel.approveFreeService()
                }
            } else {
                viewModel.approveService()
            }
        }) {
            if viewModel.isLoading {
                HStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .absherBackground))
                    
                    Text("جار المعالجة...")
                        .font(.absherHeadline)
                        .foregroundColor(.absherBackground)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.absherMint)
                .cornerRadius(12)
            } else if isBooked {
                // Show booked confirmation
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.absherBackground)
                    
                    Text("تم الحجز ✓")
                        .font(.absherHeadline)
                        .foregroundColor(.absherBackground)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.absherGreen)
                .cornerRadius(12)
            } else if serviceDetails.feeAmount == 0 {
                Text("تأكيد التجديد مجاناً")
                    .absherPrimaryButton()
            } else {
                Text("دفع \(formattedCurrency(viewModel.selectedPaymentAmount)) الآن")
                    .absherPrimaryButton()
            }
        }
        .disabled(viewModel.isLoading || isBooked || (serviceDetails.feeAmount > 0 && (viewModel.selectedPaymentAmount <= 0 || viewModel.remainingAmount <= 0)))
    }
}

// MARK: - Verification Status View

private struct VerificationStatusCard: View {
    let title: String
    let iconName: String
    let accentColor: Color
    let fallbackHeadline: String
    let proof: VerificationProof?
    let state: AppViewModel.VerificationState
    let refreshAction: () -> Void
    
    private static let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            HStack(spacing: 12) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(proof?.headline ?? fallbackHeadline)
                        .font(.absherBody)
                        .foregroundColor(.absherTextPrimary)
                    
                    Text(subtitleText)
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                }
                
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(accentColor)
            }
            
            if let proof = proof {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(proof.detail)
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                        .multilineTextAlignment(.trailing)
                    
                    Text("المصدر: \(proof.sourceSystem) • \(formatted(date: proof.lastSynced))")
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                    
                    Text("المرجع: \(proof.referenceCode)")
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            } else {
                cardFallbackContent
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(16)
        .overlay(alignment: .topLeading) {
            statusBadge
        }
        .absherCardStyle()
    }
    
    @ViewBuilder
    private var cardFallbackContent: some View {
        switch state {
        case .loading:
            HStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
                Text("جارٍ التحقق من \(title)...")
                    .font(.absherCaption)
                    .foregroundColor(.absherTextSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        case .failed(let message):
            VStack(alignment: .trailing, spacing: 8) {
                Text(message)
                    .font(.absherCaption)
                    .foregroundColor(.absherOrange)
                
                Button("إعادة المحاولة") {
                    refreshAction()
                }
                .font(.absherCaption)
                .foregroundColor(.absherGreen)
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var statusBadge: some View {
        if let proof = proof {
            Text(proof.status.localizedLabel)
                .font(.absherCaption)
                .foregroundColor(accentColor)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(accentColor.opacity(0.15))
                .cornerRadius(8)
        }
    }
    
    private var subtitleText: String {
        if let proof = proof {
            return "تمت مزامنتها آليًا من \(proof.sourceSystem)"
        } else {
            return title
        }
    }
    
    private func formatted(date: Date) -> String {
        VerificationStatusCard.timestampFormatter.string(from: date)
    }
}

private extension ReviewView {
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    private static let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ar")
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    private var selectedPaymentPercentage: Double {
        guard viewModel.totalFeeAmount > 0 else { return 0 }
        return viewModel.selectedPaymentAmount / viewModel.totalFeeAmount
    }
    
    private func formattedCurrency(_ amount: Double) -> String {
        let formatted = ReviewView.currencyFormatter.string(from: NSNumber(value: amount)) ?? "\(Int(amount))"
        return "\(formatted) ريال"
    }
    
    private func formattedPercentage(_ value: Double) -> String {
        ReviewView.percentageFormatter.string(from: NSNumber(value: value)) ?? "0٪"
    }
}
#Preview {
    ReviewView(
        viewModel: AppViewModel(),
        serviceDetails: .mock,
        userProfile: .mock
    )
}
