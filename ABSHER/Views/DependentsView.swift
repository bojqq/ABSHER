//
//  DependentsView.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

/// View displaying the list of user's dependents and their service statuses
/// Requirements: 3.1, 3.2, 3.3
struct DependentsView: View {
    @ObservedObject var viewModel: AppViewModel
    
    /// List of dependents to display
    let dependents: [Dependent]
    
    var body: some View {
        ZStack {
            // Dark background
            Color.absherBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation bar with back button
                navigationBar
                
                // Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Header section
                        headerSection
                        
                        // Dependents list
                        if dependents.isEmpty {
                            emptyStateView
                        } else {
                            ForEach(dependents) { dependent in
                                DependentCard(dependent: dependent)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    // MARK: - Navigation Bar
    
    /// Navigation bar with back button (Requirements: 3.3)
    private var navigationBar: some View {
        HStack {
            Spacer()
            
            Text("التابعين")
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
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack(spacing: 12) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("إدارة التابعين")
                        .font(.absherTitle)
                        .foregroundColor(.absherTextPrimary)
                    
                    Text("متابعة خدمات أفراد العائلة")
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                }
                
                Image(systemName: "person.2.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.absherMint)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(16)
        .absherCardStyle()
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 48))
                .foregroundColor(.absherTextSecondary)
            
            Text("لا يوجد تابعين")
                .font(.absherHeadline)
                .foregroundColor(.absherTextPrimary)
            
            Text("لم يتم العثور على تابعين مسجلين")
                .font(.absherCaption)
                .foregroundColor(.absherTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .absherCardStyle()
    }
}


// MARK: - Dependent Card

/// Card displaying individual dependent information
/// Requirements: 3.1, 3.2
struct DependentCard: View {
    let dependent: Dependent
    
    /// Color based on urgency of days remaining
    private var urgencyColor: Color {
        if dependent.daysRemaining <= 7 {
            return .red
        } else if dependent.daysRemaining <= 30 {
            return .absherOrange
        } else {
            return .absherMint
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Top row: Name and relationship
            HStack(spacing: 12) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(dependent.name)
                        .font(.absherHeadline)
                        .foregroundColor(.absherTextPrimary)
                    
                    Text(dependent.relationship)
                        .font(.absherCaption)
                        .foregroundColor(.absherTextSecondary)
                }
                
                // Avatar icon
                Circle()
                    .fill(Color.absherPurple.opacity(0.3))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.absherPurple)
                    )
            }
            
            Divider()
                .background(Color.absherTextSecondary.opacity(0.3))
            
            // Service type row
            HStack {
                Text(dependent.serviceType)
                    .font(.absherBody)
                    .foregroundColor(.absherTextPrimary)
                
                Spacer()
                
                Text("نوع الخدمة")
                    .font(.absherCaption)
                    .foregroundColor(.absherTextSecondary)
            }
            
            // Days remaining row (displayed prominently - Requirements: 3.2)
            HStack {
                HStack(spacing: 4) {
                    Text("\(dependent.daysRemaining)")
                        .font(.absherTitle)
                        .foregroundColor(urgencyColor)
                    
                    Text("يوم")
                        .font(.absherBody)
                        .foregroundColor(urgencyColor)
                }
                
                Spacer()
                
                Text("الأيام المتبقية")
                    .font(.absherCaption)
                    .foregroundColor(.absherTextSecondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(urgencyColor.opacity(0.15))
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(16)
        .absherCardStyle()
    }
}

// MARK: - Preview

#Preview {
    DependentsView(
        viewModel: AppViewModel(),
        dependents: [
            Dependent.mock,
            Dependent(
                name: "سارة",
                relationship: "ابنتك",
                serviceType: "تجديد هوية",
                daysRemaining: 27
            ),
            Dependent(
                name: "محمد",
                relationship: "ابنك",
                serviceType: "تجديد هوية",
                daysRemaining: 5
            )
        ]
    )
}
