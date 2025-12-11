//
//  SplashView.swift
//  ABSHER
//
//  Splash screen with Absher logo and green gradient effect
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var logoOpacity: Double = 0
    @State private var logoScale: Double = 0.8
    @State private var textOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Green gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.absherGreen,
                    Color.absherLightGreen
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Logo container with white background
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 180, height: 180)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 5)
                    
                    Image("AbsherLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 140, height: 140)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                // App name text
                VStack(spacing: 8) {
                    Text("أبشر")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Text("ABSHER")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .tracking(4)
                }
                .opacity(textOpacity)
            }
        }
        .onAppear {
            // Animate logo appearance
            withAnimation(.easeOut(duration: 0.8)) {
                logoOpacity = 1
                logoScale = 1
            }
            
            // Animate text with slight delay
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                textOpacity = 1
            }
            
            // Navigate to home after splash
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                viewModel.navigateToHome()
            }
        }
    }
}

#Preview {
    SplashView(viewModel: AppViewModel())
}
