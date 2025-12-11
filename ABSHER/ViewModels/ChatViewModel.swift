//
//  ChatViewModel.swift
//  ABSHER
//
//  Created by Kiro AI
//

import Foundation
import Combine

/// Navigation destination for deep link handling
/// Requirements: 2.1, 2.2
enum NavigationDestination: Equatable {
    case dependents   // Navigate to dependents page
    case review       // Navigate to review/dashboard page
}

/// ViewModel for managing chat state and coordinating between UI and MLX service
/// Handles message display, suggestion chips, and LLM interactions
@MainActor
class ChatViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// Chat messages in the conversation
    @Published var messages: [ChatMessage] = []
    
    /// Suggestion chips derived from proactive alerts
    @Published var suggestions: [SuggestionChip] = []
    
    /// Indicates whether the LLM is currently processing a request
    @Published var isProcessing = false
    
    /// Current text in the input field
    @Published var inputText = ""
    
    // MARK: - Dependencies
    
    /// MLX service for LLM inference
    let mlxService: MLXService
    
    /// Provider function for proactive alerts
    private let alertsProvider: () -> [ProactiveAlert]
    
    // MARK: - Initialization
    
    /// Creates a new ChatViewModel with the specified dependencies
    /// - Parameters:
    ///   - mlxService: The MLX service for LLM inference
    ///   - alertsProvider: A closure that provides the current proactive alerts
    init(mlxService: MLXService, alertsProvider: @escaping () -> [ProactiveAlert]) {
        self.mlxService = mlxService
        self.alertsProvider = alertsProvider
    }

    
    // MARK: - Suggestion Management
    
    /// Loads suggestion chips from proactive alerts
    /// Converts ProactiveAlert items to SuggestionChip items
    /// Requirements: 1.1, 1.3
    func loadSuggestions() {
        let alerts = alertsProvider()
        
        // Handle empty alerts case - display greeting without suggestions
        guard !alerts.isEmpty else {
            suggestions = []
            return
        }
        
        // Convert each alert to a suggestion chip
        suggestions = alerts.map { SuggestionChip.fromAlert($0) }
    }
    
    // MARK: - Message Handling
    
    /// Sends the current input text as a message
    /// Requirements: 5.1, 5.2, 5.3
    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        // Add user message to chat
        let userMessage = ChatMessage.userMessage(text)
        messages.append(userMessage)
        
        // Clear input and set processing state
        inputText = ""
        isProcessing = true
        
        // Generate response from LLM
        Task {
            await generateResponse(for: text, alertContext: nil)
        }
    }
    
    /// Handles tap on a suggestion chip
    /// Requirements: 2.1, 5.1, 5.2, 5.3
    /// - Parameter chip: The tapped suggestion chip
    func handleSuggestionTap(_ chip: SuggestionChip) {
        // Create context message from the suggestion
        let contextText = chip.displayText
        
        // Add user message to chat
        let userMessage = ChatMessage.userMessage(contextText)
        messages.append(userMessage)
        
        // Set processing state
        isProcessing = true
        
        // Generate response with alert context
        Task {
            await generateResponse(for: contextText, alertContext: chip.alert)
        }
    }
    
    // MARK: - Deep Link Navigation
    
    /// Handles tap on a deep link in a chat message
    /// Requirements: 2.1, 2.2
    /// - Parameter deepLink: The tapped deep link
    /// - Returns: The navigation destination based on service type
    func handleDeepLinkTap(_ deepLink: DeepLink) -> NavigationDestination {
        switch deepLink.serviceType {
        case .dependents:
            return .dependents
        case .drivingLicenseRenewal, .passportRenewal, .nationalIdRenewal:
            return .review
        }
    }
    
    // MARK: - Dependent Alerts
    
    /// Creates a dependent alert message for display in chat
    /// Requirements: 1.1, 1.3
    /// - Parameter dependent: The dependent to create an alert message for
    /// - Returns: A ChatMessage with the dependent's alert and a deep link to dependents page
    func createDependentAlertMessage(for dependent: Dependent) -> ChatMessage {
        let deepLink = DeepLink(
            serviceType: .dependents,
            title: dependent.alertMessage,
            alertId: dependent.id.uuidString
        )
        return ChatMessage.botMessage(dependent.alertMessage, deepLink: deepLink)
    }
    
    /// Gets the active dependent alert (mock data for now)
    /// - Returns: A Dependent if there's an active alert, nil otherwise
    func getActiveDependentAlert() -> Dependent? {
        return Dependent.mock
    }

    
    // MARK: - Private Methods
    
    /// Generates a response from the LLM for the given prompt
    /// Requirements: 1.1 (dependent alerts after proactive alert response)
    /// - Parameters:
    ///   - prompt: The user's message or suggestion text
    ///   - alertContext: Optional proactive alert context for deep link generation
    private func generateResponse(for prompt: String, alertContext: ProactiveAlert?) async {
        var responseText = ""
        
        do {
            // Stream tokens from MLX service
            for try await token in mlxService.generate(prompt: prompt) {
                responseText += token
            }
            
            // Create deep link - either from alert context or by detecting service-related queries
            let deepLink: DeepLink? = if let alert = alertContext {
                createDeepLink(from: alert)
            } else {
                detectAndCreateDeepLink(from: prompt)
            }
            
            // Add bot response to messages
            let botMessage = ChatMessage.botMessage(responseText, deepLink: deepLink)
            messages.append(botMessage)
            
            // After adding bot response, check for active dependent alerts
            // and add dependent alert message if available (Requirements: 1.1)
            if alertContext != nil, let dependent = getActiveDependentAlert() {
                let dependentAlertMessage = createDependentAlertMessage(for: dependent)
                messages.append(dependentAlertMessage)
            }
            
        } catch {
            // Handle generation error
            let errorMessage = ChatMessage.botMessage(
                "عذراً، حدث خطأ أثناء معالجة طلبك. يرجى المحاولة مرة أخرى."
            )
            messages.append(errorMessage)
        }
        
        isProcessing = false
    }
    
    /// Creates a deep link from a proactive alert
    /// - Parameter alert: The proactive alert to create a deep link from
    /// - Returns: A DeepLink for navigation to the relevant service page
    private func createDeepLink(from alert: ProactiveAlert) -> DeepLink {
        // Map alert service type to ServiceType enum
        let serviceType: ServiceType = switch alert.serviceType {
        case "تجديد رخصة القيادة":
            .drivingLicenseRenewal
        case "تجديد جواز السفر":
            .passportRenewal
        case "تجديد الهوية":
            .nationalIdRenewal
        default:
            .drivingLicenseRenewal
        }
        
        return DeepLink(
            serviceType: serviceType,
            title: alert.title,
            alertId: nil
        )
    }
    
    /// Detects service-related queries and creates appropriate deep links
    /// This allows the chatbot to provide navigation links even without explicit alert context
    /// - Parameter prompt: The user's message text
    /// - Returns: A DeepLink if a service-related query is detected, nil otherwise
    private func detectAndCreateDeepLink(from prompt: String) -> DeepLink? {
        let lowercasedPrompt = prompt.lowercased()
        
        // Detect driving license related queries
        if lowercasedPrompt.contains("رخصة") || 
           lowercasedPrompt.contains("القيادة") ||
           lowercasedPrompt.contains("license") ||
           lowercasedPrompt.contains("driving") ||
           lowercasedPrompt.contains("اجدد") ||
           lowercasedPrompt.contains("تجديد") {
            return DeepLink(
                serviceType: .drivingLicenseRenewal,
                title: "تجديد رخصة القيادة",
                alertId: nil
            )
        }
        
        // Detect passport related queries
        if lowercasedPrompt.contains("جواز") || 
           lowercasedPrompt.contains("السفر") ||
           lowercasedPrompt.contains("passport") {
            return DeepLink(
                serviceType: .passportRenewal,
                title: "تجديد جواز السفر",
                alertId: nil
            )
        }
        
        // Detect national ID related queries
        if lowercasedPrompt.contains("هوية") || 
           lowercasedPrompt.contains("الوطنية") ||
           lowercasedPrompt.contains("national id") {
            return DeepLink(
                serviceType: .nationalIdRenewal,
                title: "تجديد الهوية الوطنية",
                alertId: nil
            )
        }
        
        return nil
    }
}
