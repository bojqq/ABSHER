//
//  ContentView.swift
//  ABSHER
//
//  Created by Ilyas MacBook Pro on 03/06/1447 AH.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        Group {
            switch viewModel.currentScreen {
            case .splash:
                SplashView(viewModel: viewModel)
                    .transition(.opacity)
            case .home:
                HomeView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                        removal: .opacity
                    ))
            case .review:
                ReviewView(
                    viewModel: viewModel,
                    serviceDetails: viewModel.currentServiceDetails,
                    userProfile: MockDataService.shared.userProfile
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .trailing).combined(with: .opacity)
                ))
            case .confirmation:
                ConfirmationView(
                    viewModel: viewModel,
                    timeSavings: MockDataService.shared.serviceDetails.timeSavings
                )
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .opacity
                ))
            case .dependents:
                DependentsView(
                    viewModel: viewModel,
                    dependents: MockDataService.shared.dependents
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .trailing).combined(with: .opacity)
                ))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: viewModel.currentScreen)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
