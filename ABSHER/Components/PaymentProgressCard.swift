//
//  PaymentProgressCard.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct PaymentProgressCard: View {
    let paidAmount: Double
    let totalAmount: Double
    
    private var remainingAmount: Double {
        max(totalAmount - paidAmount, 0)
    }
    
    private var paidPercentage: Double {
        guard totalAmount > 0 else { return 0 }
        return paidAmount / totalAmount
    }
    
    private var remainingPercentage: Double {
        guard totalAmount > 0 else { return 0 }
        return 1 - paidPercentage
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            HStack {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("تقدم الدفعات")
                        .font(.absherHeadline)
                        .foregroundColor(.absherTextPrimary)
                    
                    Text("تابع ما تم دفعه والمتبقي بسهولة.")
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                }
            }
            
            ProgressView(value: paidAmount, total: totalAmount)
                .tint(.absherOrange)
            
            HStack(spacing: 24) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(formattedPercentage(paidPercentage)) مدفوع")
                        .font(.absherBody)
                        .foregroundColor(.absherMint)
                    
                    Text(formattedCurrency(paidAmount))
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(formattedPercentage(remainingPercentage)) متبقٍ")
                        .font(.absherBody)
                        .foregroundColor(.absherOrange)
                    
                    Text(formattedCurrency(remainingAmount))
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                }
            }
        }
        .padding(16)
        .absherCardStyle()
    }
    
    private func formattedCurrency(_ amount: Double) -> String {
        let formatted = PaymentProgressCard.currencyFormatter.string(from: NSNumber(value: amount)) ?? "\(Int(amount))"
        return "\(formatted) ريال"
    }
    
    private func formattedPercentage(_ value: Double) -> String {
        PaymentProgressCard.percentageFormatter.string(from: NSNumber(value: value)) ?? "0٪"
    }
    
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
}

#Preview {
    PaymentProgressCard(paidAmount: 50, totalAmount: 200)
        .padding()
        .background(Color.absherBackground)
        .environment(\.layoutDirection, .rightToLeft)
}

