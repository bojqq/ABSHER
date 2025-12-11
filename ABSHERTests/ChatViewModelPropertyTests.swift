//
//  ChatViewModelPropertyTests.swift
//  ABSHERTests
//
//  Created by Kiro AI
//

import Testing
import Foundation
@testable import ABSHER

struct ChatViewModelPropertyTests {
    
    // **Feature: absher-llm-integration, Property 1: Suggestion chips match proactive alerts**
    // **Validates: Requirements 1.1**
    @Test("Property 1: Suggestion chips match proactive alerts", arguments: 0..<100)
    @MainActor
    func suggestionChipsMatchProactiveAlerts(iteration: Int) async throws {
        // Generate random list of proactive alerts
        let alerts = generateRandomAlerts(seed: iteration)
        
        // Create ChatViewModel with the alerts provider
        let mlxService = MLXService()
        let viewModel = ChatViewModel(mlxService: mlxService, alertsProvider: { alerts })
        
        // Load suggestions
        viewModel.loadSuggestions()
        
        // Property: For any list of proactive alerts, the generated suggestion chips
        // SHALL have a one-to-one correspondence with the alerts, preserving alert data
        
        // Verify count matches (one-to-one correspondence)
        #expect(viewModel.suggestions.count == alerts.count,
                "Suggestion count (\(viewModel.suggestions.count)) should match alert count (\(alerts.count))")
        
        // Verify each suggestion preserves its corresponding alert
        for (index, suggestion) in viewModel.suggestions.enumerated() {
            let originalAlert = alerts[index]
            
            #expect(suggestion.alert == originalAlert,
                    "Suggestion at index \(index) should preserve the original alert")
            
            // Verify display text contains the alert title
            #expect(suggestion.displayText.contains(originalAlert.title),
                    "Suggestion display text should contain alert title '\(originalAlert.title)'")
        }
    }
    
    // Test empty alerts case
    @Test("Empty alerts produce empty suggestions")
    @MainActor
    func emptyAlertsProduceEmptySuggestions() async throws {
        let mlxService = MLXService()
        let viewModel = ChatViewModel(mlxService: mlxService, alertsProvider: { [] })
        
        viewModel.loadSuggestions()
        
        #expect(viewModel.suggestions.isEmpty,
                "Empty alerts should produce empty suggestions")
    }

    
    // **Feature: absher-llm-integration, Property 5: Message submission triggers processing**
    // **Validates: Requirements 5.1, 5.3**
    @Test("Property 5: Message submission triggers processing", arguments: 0..<100)
    @MainActor
    func messageSubmissionTriggersProcessing(iteration: Int) async throws {
        // Generate random non-empty message text
        let messageText = generateRandomMessageText(seed: iteration)
        
        // Skip empty messages (they should not trigger processing)
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        // Create ChatViewModel
        let mlxService = MLXService()
        try await mlxService.loadModel(modelPath: Bundle.main.bundlePath) // Use any valid path
        
        let viewModel = ChatViewModel(mlxService: mlxService, alertsProvider: { [] })
        
        // Set input text
        viewModel.inputText = messageText
        
        // Record initial state
        let initialMessageCount = viewModel.messages.count
        
        // Send message
        viewModel.sendMessage()
        
        // Property: For any non-empty message text, submitting SHALL add the message
        // to the chat and set the processing state to true
        
        // Verify message was added
        #expect(viewModel.messages.count == initialMessageCount + 1,
                "Message count should increase by 1 after sending")
        
        // Verify the added message is a user message with correct content
        let addedMessage = viewModel.messages.last
        #expect(addedMessage?.isUser == true,
                "Added message should be a user message")
        #expect(addedMessage?.content == messageText.trimmingCharacters(in: .whitespacesAndNewlines),
                "Added message content should match input text")
        
        // Verify processing state is set
        #expect(viewModel.isProcessing == true,
                "isProcessing should be true after sending message")
        
        // Verify input was cleared
        #expect(viewModel.inputText.isEmpty,
                "Input text should be cleared after sending")
    }
    
    // **Feature: absher-llm-integration, Property 3: Deep link navigation preserves context**
    // **Validates: Requirements 3.1, 3.2**
    @Test("Property 3: Deep link navigation preserves context", arguments: 0..<100)
    @MainActor
    func deepLinkNavigationPreservesContext(iteration: Int) async throws {
        // Generate random deep link
        let deepLink = generateRandomDeepLink(seed: iteration)
        
        // Create ChatViewModel
        let mlxService = MLXService()
        let viewModel = ChatViewModel(mlxService: mlxService, alertsProvider: { [] })
        
        // Handle deep link tap
        let resultDestination = viewModel.handleDeepLinkTap(deepLink)
        
        // Property: For any deep link with a valid service type, tapping the link
        // SHALL navigate to the correct service page with the service context preserved
        
        // Verify navigation destination matches expected based on service type
        let expectedDestination: NavigationDestination = switch deepLink.serviceType {
        case .dependents:
            .dependents
        case .drivingLicenseRenewal, .passportRenewal, .nationalIdRenewal:
            .review
        }
        
        #expect(resultDestination == expectedDestination,
                "Navigation destination should match expected for service type \(deepLink.serviceType)")
    }
    
    // Test that empty messages don't trigger processing
    @Test("Empty messages don't trigger processing")
    @MainActor
    func emptyMessagesDontTriggerProcessing() async throws {
        let mlxService = MLXService()
        let viewModel = ChatViewModel(mlxService: mlxService, alertsProvider: { [] })
        
        // Test empty string
        viewModel.inputText = ""
        viewModel.sendMessage()
        #expect(viewModel.messages.isEmpty, "Empty string should not add message")
        #expect(viewModel.isProcessing == false, "Empty string should not trigger processing")
        
        // Test whitespace only
        viewModel.inputText = "   \n\t  "
        viewModel.sendMessage()
        #expect(viewModel.messages.isEmpty, "Whitespace-only should not add message")
        #expect(viewModel.isProcessing == false, "Whitespace-only should not trigger processing")
    }
    
    // **Feature: dependent-alerts, Property 3: Dependent deep link navigates to dependents destination**
    // **Validates: Requirements 2.1**
    @Test("Property 3: Dependent deep link navigates to dependents destination", arguments: 0..<100)
    @MainActor
    func dependentDeepLinkNavigatesToDependents(iteration: Int) async throws {
        // Generate random deep link with dependents service type
        let deepLink = generateRandomDependentDeepLink(seed: iteration)
        
        // Create ChatViewModel
        let mlxService = MLXService()
        let viewModel = ChatViewModel(mlxService: mlxService, alertsProvider: { [] })
        
        // Handle deep link tap
        let destination = viewModel.handleDeepLinkTap(deepLink)
        
        // Property: For any deep link with service type `dependents`,
        // handling the deep link tap SHALL return the dependents navigation destination
        
        #expect(destination == .dependents,
                "Deep link with dependents service type should navigate to .dependents destination")
    }
    
    // **Feature: dependent-alerts, Property 4: Proactive alert deep link navigates to dashboard**
    // **Validates: Requirements 2.2**
    @Test("Property 4: Proactive alert deep link navigates to dashboard", arguments: 0..<100)
    @MainActor
    func proactiveAlertDeepLinkNavigatesToDashboard(iteration: Int) async throws {
        // Generate random deep link with proactive alert service type
        let deepLink = generateRandomProactiveAlertDeepLink(seed: iteration)
        
        // Create ChatViewModel
        let mlxService = MLXService()
        let viewModel = ChatViewModel(mlxService: mlxService, alertsProvider: { [] })
        
        // Handle deep link tap
        let destination = viewModel.handleDeepLinkTap(deepLink)
        
        // Property: For any deep link with service type drivingLicenseRenewal, passportRenewal,
        // or nationalIdRenewal, handling the deep link tap SHALL return the review/dashboard destination
        
        #expect(destination == .review,
                "Deep link with proactive alert service type (\(deepLink.serviceType)) should navigate to .review destination")
        
        // Verify the service type is one of the proactive alert types
        let proactiveTypes: [ServiceType] = [.drivingLicenseRenewal, .passportRenewal, .nationalIdRenewal]
        #expect(proactiveTypes.contains(deepLink.serviceType),
                "Service type should be a proactive alert type")
    }
    
    // **Feature: dependent-alerts, Property 2: Dependent alert messages have navigation deep links**
    // **Validates: Requirements 1.1, 1.3**
    @Test("Property 2: Dependent alert messages have navigation deep links", arguments: 0..<100)
    @MainActor
    func dependentAlertMessagesHaveDeepLinks(iteration: Int) async throws {
        // Generate random dependent
        let dependent = generateRandomDependent(seed: iteration)
        
        // Create ChatViewModel
        let mlxService = MLXService()
        let viewModel = ChatViewModel(mlxService: mlxService, alertsProvider: { [] })
        
        // Create dependent alert message
        let alertMessage = viewModel.createDependentAlertMessage(for: dependent)
        
        // Property: For any dependent alert message created by the system,
        // the message SHALL have a non-nil deep link with service type `dependents`
        
        // Verify deep link is not nil
        #expect(alertMessage.deepLink != nil,
                "Dependent alert message should have a non-nil deep link")
        
        // Verify deep link service type is dependents
        #expect(alertMessage.deepLink?.serviceType == .dependents,
                "Deep link service type should be .dependents")
        
        // Verify the message is a bot message (not user)
        #expect(alertMessage.isUser == false,
                "Dependent alert should be a bot message")
        
        // Verify the message content contains the dependent's alert message
        #expect(alertMessage.content == dependent.alertMessage,
                "Message content should match dependent's alert message")
    }
    
    // MARK: - Helper Functions
    
    /// Generates a random list of proactive alerts for testing
    private func generateRandomAlerts(seed: Int) -> [ProactiveAlert] {
        // Vary the count based on seed (0 to 5 alerts)
        let count = seed % 6
        
        guard count > 0 else { return [] }
        
        return (0..<count).map { index in
            generateRandomAlert(seed: seed + index)
        }
    }
    
    /// Generates a single random ProactiveAlert
    private func generateRandomAlert(seed: Int) -> ProactiveAlert {
        let icons = [
            "bell.fill",
            "exclamationmark.triangle.fill",
            "megaphone.fill",
            "dot.circle.fill",
            "alarm.fill"
        ]
        let titles = [
            "تنبيه استباقي",
            "إشعار مهم",
            "تذكير",
            "رخصة قيادتك على وشك الانتهاء",
            "جواز سفرك يحتاج للتجديد",
            "هويتك الوطنية تنتهي قريباً",
            "موعد الفحص الطبي",
            "تجديد الإقامة",
            "Alert Title \(seed)",
            "🚗 رخصة",
            String(repeating: "أ", count: min(50, seed % 50 + 1))
        ]
        let serviceTypes = ["تجديد رخصة القيادة", "تجديد جواز السفر", "تجديد الهوية"]
        let messages = [
            "رخصة قيادتك على وشك الانتهاء",
            "جواز سفرك يحتاج للتجديد",
            "هويتك الوطنية تنتهي قريباً"
        ]
        let actionTexts = [
            "اضغط للموافقة والدفع الآن",
            "اضغط للتجديد",
            "موافقة وإتمام"
        ]
        
        return ProactiveAlert(
            iconName: icons[seed % icons.count],
            title: titles[seed % titles.count],
            serviceType: serviceTypes[seed % serviceTypes.count],
            daysRemaining: (seed * 7) % 90 + 1,
            message: messages[seed % messages.count],
            actionText: actionTexts[seed % actionTexts.count]
        )
    }
    
    /// Generates a random DeepLink for testing
    private func generateRandomDeepLink(seed: Int) -> DeepLink {
        let serviceTypes = ServiceType.allCases
        let titles = [
            "تجديد رخصة القيادة",
            "تجديد جواز السفر",
            "تجديد الهوية الوطنية",
            "Renew Driving License",
            "Renew Passport",
            "Service \(seed)"
        ]
        let alertIds: [String?] = [
            UUID().uuidString,
            "alert-\(seed)",
            nil
        ]
        
        return DeepLink(
            serviceType: serviceTypes[seed % serviceTypes.count],
            title: titles[seed % titles.count],
            alertId: alertIds[seed % alertIds.count]
        )
    }
    
    /// Generates a random DeepLink with dependents service type for testing Property 3
    private func generateRandomDependentDeepLink(seed: Int) -> DeepLink {
        let titles = [
            "ولدك حسام باقي له 45 يوم على اصدار رخصة",
            "ابنتك نورة باقي لها 30 يوم على تجديد جواز السفر",
            "ابنك محمد باقي له 15 يوم على تجديد الهوية",
            "Dependent Alert \(seed)",
            String(repeating: "تابع", count: min(10, seed % 10 + 1))
        ]
        let alertIds: [String?] = [
            UUID().uuidString,
            "dependent-\(seed)",
            nil
        ]
        
        return DeepLink(
            serviceType: .dependents,
            title: titles[seed % titles.count],
            alertId: alertIds[seed % alertIds.count]
        )
    }
    
    /// Generates a random DeepLink with proactive alert service type for testing Property 4
    private func generateRandomProactiveAlertDeepLink(seed: Int) -> DeepLink {
        // Only proactive alert service types (not dependents)
        let proactiveServiceTypes: [ServiceType] = [
            .drivingLicenseRenewal,
            .passportRenewal,
            .nationalIdRenewal
        ]
        let titles = [
            "تجديد رخصة القيادة",
            "تجديد جواز السفر",
            "تجديد الهوية الوطنية",
            "Renew Driving License",
            "Renew Passport",
            "Renew National ID",
            "Service \(seed)"
        ]
        let alertIds: [String?] = [
            UUID().uuidString,
            "alert-\(seed)",
            nil
        ]
        
        return DeepLink(
            serviceType: proactiveServiceTypes[seed % proactiveServiceTypes.count],
            title: titles[seed % titles.count],
            alertId: alertIds[seed % alertIds.count]
        )
    }
    
    /// Generates random message text for testing
    private func generateRandomMessageText(seed: Int) -> String {
        let messages = [
            "مرحباً",
            "أريد تجديد رخصة القيادة",
            "ما هي الخدمات المتاحة؟",
            "Hello",
            "I need help with my license",
            "عندي سؤال عن التنبيه الاستباقي",
            "🚗 رخصة",
            String(repeating: "أ", count: min(100, seed % 100 + 1)),
            "Message \(seed)",
            "   trimmed message   ",
            "multi\nline\nmessage"
        ]
        
        return messages[seed % messages.count]
    }
    
    /// Generates a random Dependent for testing
    private func generateRandomDependent(seed: Int) -> Dependent {
        let names = [
            "حسام",
            "محمد",
            "أحمد",
            "فاطمة",
            "نورة",
            "سارة",
            "عبدالله",
            "خالد"
        ]
        let relationships = [
            "ولدك",
            "ابنتك",
            "ابنك",
            "زوجتك"
        ]
        let serviceTypes = [
            "اصدار رخصة",
            "تجديد رخصة",
            "تجديد جواز السفر",
            "تجديد الهوية"
        ]
        
        // Generate days remaining between 1 and 90
        let daysRemaining = (seed % 90) + 1
        
        return Dependent(
            name: names[seed % names.count],
            relationship: relationships[seed % relationships.count],
            serviceType: serviceTypes[seed % serviceTypes.count],
            daysRemaining: daysRemaining
        )
    }
}
