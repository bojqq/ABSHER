//
//  HomeView.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showChatSheet = false
    private let mockData = MockDataService.shared
    
    /// Current proactive alerts to pass to chat view
    /// Requirements: 1.1 - Ensure alerts are loaded before chat opens
    private var proactiveAlerts: [ProactiveAlert] {
        [mockData.proactiveAlert]
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 24) {
                    // Top Navigation Bar
                    TopNavigationBar(onChatTapped: {
                        showChatSheet = true
                    })
                    
                    // User Profile Card
                    UserProfileCard(profile: mockData.userProfile)
                    
                    // Proactive Alert Card (positioned between profile and documents)
                    ProactiveAlertCard(alert: mockData.proactiveAlert) {
                        viewModel.navigateToReview()
                    }
                    
                    if viewModel.paidAmount > 0 {
                        PaymentProgressCard(
                            paidAmount: viewModel.paidAmount,
                            totalAmount: viewModel.totalFeeAmount
                        )
                    }
                    
                    // Digital Documents Section
                    DigitalDocumentsSection(documents: mockData.documents)
                    
                    // Quick Access Section
                    QuickAccessSection()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 100) // Space for bottom tab bar
            }
            
            // Bottom Tab Bar
            BottomTabBar()
        }
        .background(Color.absherBackground.ignoresSafeArea())
        .environment(\.layoutDirection, .rightToLeft)
        .sheet(isPresented: $showChatSheet) {
            // Pass proactive alerts to chat view (Requirements: 1.1)
            AbsherChatView(appViewModel: viewModel, proactiveAlerts: proactiveAlerts)
        }
    }
}

#Preview {
    HomeView(viewModel: AppViewModel())
}
