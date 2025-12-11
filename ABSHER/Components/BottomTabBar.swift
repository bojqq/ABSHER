//
//  BottomTabBar.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct BottomTabBar: View {
    var body: some View {
        HStack(spacing: 0) {
            TabItem(
                icon: "ellipsis",
                label: "خدمات أخرى",
                isActive: false
            )
            
            TabItem(
                icon: "person.2.fill",
                label: "عمالي",
                isActive: false
            )
            
            TabItem(
                icon: "person.3.fill",
                label: "عائلتي",
                isActive: false
            )
            
            TabItem(
                icon: "list.bullet.rectangle",
                label: "خدماتي",
                isActive: false
            )
            
            TabItem(
                icon: "house.fill",
                label: "الرئيسية",
                isActive: true
            )
        }
        .frame(height: 83)
        .background(Color.absherCardBackground)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.absherCardBorder),
            alignment: .top
        )
    }
}

struct TabItem: View {
    let icon: String
    let label: String
    let isActive: Bool
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isActive ? .absherGreen : .absherTextSecondary)
                
                Text(label)
                    .font(.absherSmall)
                    .foregroundColor(isActive ? .absherGreen : .absherTextSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    BottomTabBar()
        .environment(\.layoutDirection, .rightToLeft)
}
