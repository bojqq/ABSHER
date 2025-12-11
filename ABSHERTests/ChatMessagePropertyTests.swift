//
//  ChatMessagePropertyTests.swift
//  ABSHERTests
//
//  Created by Kiro AI
//

import Testing
import Foundation
@testable import ABSHER

struct ChatMessagePropertyTests {
    
    // **Feature: absher-llm-integration, Property 6: Chat message round-trip serialization**
    // **Validates: Requirements 6.1, 6.2, 6.3**
    @Test("Property 6: Chat message round-trip serialization", arguments: 0..<100)
    func chatMessageRoundTripSerialization(iteration: Int) async throws {
        // Generate random ChatMessage instances
        let originalMessage = generateRandomChatMessage(seed: iteration)
        
        // Serialize to JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try encoder.encode(originalMessage)
        
        // Deserialize back to ChatMessage
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedMessage = try decoder.decode(ChatMessage.self, from: jsonData)
        
        // Property: For any valid ChatMessage, serializing to JSON then deserializing
        // SHALL produce an equivalent ChatMessage object
        #expect(decodedMessage.id == originalMessage.id, "ID should be preserved after round-trip")
        #expect(decodedMessage.content == originalMessage.content, "Content should be preserved after round-trip")
        #expect(decodedMessage.isUser == originalMessage.isUser, "isUser should be preserved after round-trip")
        #expect(decodedMessage.deepLink == originalMessage.deepLink, "DeepLink should be preserved after round-trip")
        
        // Verify timestamp is preserved (within 1 second tolerance due to ISO8601 precision)
        let timeDifference = abs(decodedMessage.timestamp.timeIntervalSince(originalMessage.timestamp))
        #expect(timeDifference < 1.0, "Timestamp should be preserved after round-trip (within 1 second)")
    }
    
    // Helper function to generate random ChatMessage instances
    private func generateRandomChatMessage(seed: Int) -> ChatMessage {
        let contents = [
            "مرحباً، كيف يمكنني مساعدتك؟",
            "أريد تجديد رخصة القيادة",
            "عندك إشعار من التنبيه الاستباقي",
            "تم إرسال طلبك بنجاح",
            "يرجى التحقق من البيانات",
            "Hello, how can I help you?",
            "I want to renew my driving license",
            "Your request has been submitted",
            "",  // Edge case: empty content
            "🚗 رخصة القيادة",  // Edge case: emoji
            String(repeating: "أ", count: 1000)  // Edge case: long content
        ]
        
        let isUser = seed % 2 == 0
        let content = contents[seed % contents.count]
        
        // Generate deep link for some messages (bot messages only)
        let deepLink: DeepLink? = if !isUser && seed % 3 == 0 {
            generateRandomDeepLink(seed: seed)
        } else {
            nil
        }
        
        return ChatMessage(
            id: UUID(),
            content: content,
            isUser: isUser,
            timestamp: Date().addingTimeInterval(Double(seed * -60)), // Vary timestamps
            deepLink: deepLink
        )
    }
    
    // Helper function to generate random DeepLink instances
    private func generateRandomDeepLink(seed: Int) -> DeepLink {
        let serviceTypes = ServiceType.allCases
        let titles = [
            "تجديد رخصة القيادة",
            "تجديد جواز السفر",
            "تجديد الهوية الوطنية",
            "Renew Driving License",
            "Renew Passport"
        ]
        let alertIds: [String?] = [
            UUID().uuidString,
            "alert-123",
            nil
        ]
        
        return DeepLink(
            serviceType: serviceTypes[seed % serviceTypes.count],
            title: titles[seed % titles.count],
            alertId: alertIds[seed % alertIds.count]
        )
    }
}
