//
//  AbsherChatView.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct AbsherChatView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ChatViewModel
    @StateObject private var internalAppViewModel: AppViewModel
    private let externalAppViewModel: AppViewModel?
    
    // Greeting text constant for testing
    static let greetingText = "مرحبا إلياس"
    
    /// Computed property to get the active app view model
    private var appViewModel: AppViewModel {
        externalAppViewModel ?? internalAppViewModel
    }
    
    /// Initialize with an external AppViewModel and proactive alerts (used when presented from HomeView)
    /// - Parameters:
    ///   - appViewModel: The app view model for navigation
    ///   - proactiveAlerts: The proactive alerts to display as suggestion chips
    /// Requirements: 1.1 - Pass current proactive alerts to ChatViewModel
    init(appViewModel: AppViewModel, proactiveAlerts: [ProactiveAlert]) {
        self.externalAppViewModel = appViewModel
        _internalAppViewModel = StateObject(wrappedValue: AppViewModel())
        let mlxService = MLXService()
        // Capture alerts in closure to pass to ChatViewModel
        let alerts = { proactiveAlerts }
        _viewModel = StateObject(wrappedValue: ChatViewModel(mlxService: mlxService, alertsProvider: alerts))
    }
    
    /// Initialize with an external AppViewModel (convenience initializer using mock data)
    init(appViewModel: AppViewModel) {
        self.init(appViewModel: appViewModel, proactiveAlerts: [MockDataService.shared.proactiveAlert])
    }
    
    /// Initialize without parameters (for testing and previews)
    init() {
        self.externalAppViewModel = nil
        _internalAppViewModel = StateObject(wrappedValue: AppViewModel())
        let mlxService = MLXService()
        let alerts = { [MockDataService.shared.proactiveAlert] }
        _viewModel = StateObject(wrappedValue: ChatViewModel(mlxService: mlxService, alertsProvider: alerts))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top navigation bar
            topBar
            
            // Main content area
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        // Show greeting and suggestions when no messages
                        if viewModel.messages.isEmpty {
                            greetingSection
                            suggestionChipsSection
                        } else {
                            // Chat messages list
                            messagesListSection
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    // Scroll to bottom when new messages arrive
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Bottom input section
            bottomInputBar
            
            // Bottom branding bar
            brandingBar
        }
        .background(Color.white.ignoresSafeArea())
        .environment(\.layoutDirection, .rightToLeft)
        .onAppear {
            viewModel.loadSuggestions()
            // Load model for LLM inference
            Task {
                try? await viewModel.mlxService.loadModel(modelPath: "models/sci3")
            }
        }
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            // Chat/history icon (left)
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "rectangle.on.rectangle")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // User avatar (right)
            Circle()
                .fill(Color(hex: "#4285F4"))
                .frame(width: 32, height: 32)
                .overlay(
                    Text("إ")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Greeting Section
    private var greetingSection: some View {
        VStack(spacing: 8) {
            Spacer()
                .frame(height: 60)
            
            Text(Self.greetingText)
                .font(.system(size: 36, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.absherGreen, Color.absherLightGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text("كيف أقدر اساعدك؟")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            Spacer()
                .frame(height: 40)
        }
    }
    
    // MARK: - Suggestion Chips Section (6.1)
    private var suggestionChipsSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            if !viewModel.suggestions.isEmpty {
                ForEach(viewModel.suggestions) { chip in
                    suggestionChipButton(chip)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private func suggestionChipButton(_ chip: SuggestionChip) -> some View {
        Button(action: {
            viewModel.handleSuggestionTap(chip)
        }) {
            HStack(spacing: 8) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.absherOrange)
                
                Text(chip.displayText)
                    .font(.system(size: 14))
                    .foregroundColor(.absherTextPrimary)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.absherCardBackground)
            .cornerRadius(20)
        }
    }

    
    // MARK: - Messages List Section (6.2)
    private var messagesListSection: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.messages) { message in
                messageView(message)
                    .id(message.id)
            }
            
            // Show loading indicator when processing
            if viewModel.isProcessing {
                loadingIndicator
            }
        }
    }
    
    private func messageView(_ message: ChatMessage) -> some View {
        VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
            // Message bubble
            HStack {
                if message.isUser {
                    Spacer()
                }
                
                VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
                    Text(message.content)
                        .font(.system(size: 15))
                        .foregroundColor(message.isUser ? .white : .absherTextPrimary)
                        .multilineTextAlignment(message.isUser ? .trailing : .leading)
                    
                    // Deep link button if present (6.2)
                    if let deepLink = message.deepLink {
                        deepLinkButton(deepLink)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(message.isUser ? Color.absherGreen : Color.absherCardBackground)
                .cornerRadius(16)
                
                if !message.isUser {
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }
    
    // MARK: - Deep Link Button (6.2, 6.4)
    private func deepLinkButton(_ deepLink: DeepLink) -> some View {
        Button(action: {
            handleDeepLinkNavigation(deepLink)
        }) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 16))
                
                Text(deepLink.title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.absherMint)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.absherMint.opacity(0.15))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Deep Link Navigation (6.4)
    /// Handles navigation when user taps a deep link in a chat message
    /// Requirements: 2.1 - Dependent alert navigates to Dependents_Page
    /// Requirements: 2.2 - Proactive alert navigates to Dashboard
    /// Requirements: 2.3 - Dismiss chat view before displaying target page
    private func handleDeepLinkNavigation(_ deepLink: DeepLink) {
        let destination = viewModel.handleDeepLinkTap(deepLink)
        
        // Dismiss chat view (Requirements: 2.3)
        dismiss()
        
        // Navigate based on destination type (Requirements: 2.1, 2.2)
        switch destination {
        case .dependents:
            // Navigate to dependents page for dependent alerts (Requirements: 2.1)
            appViewModel.navigateToDependents()
        case .review:
            // Navigate to review/dashboard for proactive alerts (Requirements: 2.2)
            // Pass the service type from the deep link for dynamic service details
            appViewModel.navigateToReview(serviceType: deepLink.serviceType)
        }
    }
    
    // MARK: - Loading Indicator
    private var loadingIndicator: some View {
        HStack {
            HStack(spacing: 8) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .absherGreen))
                    .scaleEffect(0.8)
                
                Text("جاري الكتابة...")
                    .font(.system(size: 14))
                    .foregroundColor(.absherTextSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.absherCardBackground)
            .cornerRadius(16)
            
            Spacer()
        }
    }
    
    // MARK: - Bottom Input Bar (6.3)
    private var bottomInputBar: some View {
        HStack(spacing: 12) {
            // Input field with icons
            HStack(spacing: 8) {
                TextField("اسأل أبشر", text: $viewModel.inputText)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .disabled(viewModel.isProcessing)
                    .onSubmit {
                        viewModel.sendMessage()
                    }
                
                Spacer()
                
                // Send button (visible when there's text)
                if !viewModel.inputText.isEmpty {
                    Button(action: {
                        viewModel.sendMessage()
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.absherGreen)
                    }
                    .disabled(viewModel.isProcessing)
                } else {
                    // Microphone icon
                    Button(action: {}) {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    .disabled(true)
                    
                    // Camera icon
                    Button(action: {}) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    .disabled(true)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(hex: "#F1F3F4"))
            .cornerRadius(28)
            
            // Settings/equalizer button
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding(12)
                    .background(Color(hex: "#F1F3F4"))
                    .clipShape(Circle())
            }
            .disabled(true)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Branding Bar
    private var brandingBar: some View {
        HStack {
            // Absher logo and name
            HStack(spacing: 6) {
                Image(systemName: "sparkle")
                    .font(.system(size: 14))
                    .foregroundColor(Color.absherGreen)
                
                Text("أبشر")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

#Preview {
    AbsherChatView(appViewModel: AppViewModel())
}
