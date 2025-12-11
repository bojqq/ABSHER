//
//  QuickAccessSection.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct QuickAccessSection: View {
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Section header
            Text("الوصول السريع")
                .font(.absherHeadline)
                .foregroundColor(.absherTextPrimary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            // My Vehicles card
            HStack(spacing: 12) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.absherTextSecondary)
                    .font(.system(size: 14))
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("مركباتي")
                        .font(.absherBody)
                        .foregroundColor(.absherTextPrimary)
                    
                    Text("عرض التفاصيل، تجديد الوثائق والمزيد")
                        .font(.absherSmall)
                        .foregroundColor(.absherTextSecondary)
                }
                
                Image(systemName: "car.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.absherGreen)
            }
            .padding(16)
            .absherCardStyle()
            
            // Service cards grid
            HStack(spacing: 12) {
                ServiceCard(
                    icon: "doc.text.fill",
                    title: "خدمات التوثيق"
                )
                
                ServiceCard(
                    icon: "airplane",
                    title: "أبشر سفر"
                )
            }
        }
    }
}

struct ServiceCard: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(.absherGreen)
            
            Text(title)
                .font(.absherBody)
                .foregroundColor(.absherTextPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .padding(16)
        .absherCardStyle()
    }
}

#Preview {
    QuickAccessSection()
        .padding()
        .background(Color.absherBackground)
        .environment(\.layoutDirection, .rightToLeft)
}
