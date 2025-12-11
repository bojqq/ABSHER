//
//  TopNavigationBar.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct TopNavigationBar: View {
    var onChatTapped: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side in RTL (notification bell)
            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .foregroundColor(.absherGreen)
                    .font(.system(size: 20))
            }
            
            // Settings icon
            Button(action: {}) {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.absherGreen)
                    .font(.system(size: 20))
            }
            
            // Chat icon (positioned to the left of settings in RTL, which means after settings in code)
            Button(action: {
                onChatTapped?()
            }) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .foregroundColor(.absherGreen)
                    .font(.system(size: 20))
            }
            
            Spacer()
            
            // Right side in RTL (Absher logo)
            HStack(spacing: 8) {
                Image("AbsherLogo")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    TopNavigationBar()
        .background(Color.absherBackground)
        .environment(\.layoutDirection, .rightToLeft)
}
