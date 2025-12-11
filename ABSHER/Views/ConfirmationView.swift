//
//  ConfirmationView.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct ConfirmationView: View {
    @ObservedObject var viewModel: AppViewModel
    let timeSavings: Int
    
    var body: some View {
        ZStack {
            // Dark background
            Color.absherBackground
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Large green checkmark icon
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.absherGreen)
                
                // Success message
                Text("✅ تم تجديد رخصتك بنجاح")
                    .font(.absherTitle)
                    .foregroundColor(.absherTextPrimary)
                    .multilineTextAlignment(.center)
                
                // Time savings highlight
                VStack(spacing: 16) {
                    // Prominent time savings
                    Text("لقد وفرت \(timeSavings) دقيقة")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.absherMint)
                        .multilineTextAlignment(.center)
                    
                    // Subtitle
                    Text("من البحث وإدخال البيانات والتنقل بين الخدمات")
                        .font(.absherBody)
                        .foregroundColor(.absherTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    // Email message
                    Text("التفاصيل في بريدك")
                        .font(.absherCaption)
                        .foregroundColor(.absherTextMuted)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
                .padding(.top, 24)
                
                Spacer()
                
                // Reset button
                Button(action: {
                    viewModel.resetDemo()
                }) {
                    Text("العودة للرئيسية")
                        .absherPrimaryButton()
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 16)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    ConfirmationView(
        viewModel: AppViewModel(),
        timeSavings: 25
    )
}
