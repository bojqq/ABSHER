//
//  ProactiveAlertCard.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct ProactiveAlertCard: View {
    let alert: ProactiveAlert
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Header with icon and title
            HStack(spacing: 8) {
                Spacer()
                
                Text(alert.title)
                    .font(.absherHeadline)
                    .foregroundColor(.absherOrange)
                
                Image(systemName: alert.iconName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.absherOrange)
            }
            
            // Service message
            Text(alert.message)
                .font(.absherBody)
                .foregroundColor(.absherTextPrimary)
                .multilineTextAlignment(.trailing)
            
            // Call to action
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.absherOrange)
                    .font(.system(size: 14))
                
                Spacer()
                
                Text(alert.actionText)
                    .font(.absherBody)
                    .foregroundColor(.absherOrange)
                    .fontWeight(.semibold)
            }
        }
        .padding(16)
        .proactiveAlertCardStyle()
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    ProactiveAlertCard(alert: .mock, onTap: {})
        .padding()
        .background(Color.absherBackground)
        .environment(\.layoutDirection, .rightToLeft)
}
