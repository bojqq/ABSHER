//
//  UserProfileCard.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct UserProfileCard: View {
    let profile: UserProfile
    
    var body: some View {
        HStack(spacing: 12) {
            avatarView
            
            // User info
            VStack(alignment: .trailing, spacing: 4) {
                Text(profile.name)
                    .font(.absherHeadline)
                    .foregroundColor(.absherTextPrimary)
                
                Text("رقم الهوية: ****")
                    .font(.absherCaption)
                    .foregroundColor(.absherTextSecondary)
            }
            
            Spacer()
            
            // Navigation chevron (left side in RTL)
            Image(systemName: "chevron.left")
                .foregroundColor(.absherTextSecondary)
                .font(.system(size: 14))
        }
        .padding(16)
        .absherCardStyle()
    }
    
    @ViewBuilder
    private var avatarView: some View {
        if let portrait = Image.absherAsset(fileName: profile.profileImage ?? "") {
            portrait
                .resizable()
                .scaledToFill()
                .frame(width: 54, height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.absherGreen.opacity(0.5), lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
        } else {
            Circle()
                .fill(Color.absherGreen.opacity(0.3))
                .frame(width: 54, height: 54)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.absherGreen)
                        .font(.system(size: 24, weight: .semibold))
                )
        }
    }
}

#Preview {
    UserProfileCard(profile: .mock)
        .padding()
        .background(Color.absherBackground)
        .environment(\.layoutDirection, .rightToLeft)
}
