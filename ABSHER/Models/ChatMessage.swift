//
//  ChatMessage.swift
//  ABSHER
//
//  Created by Kiro AI
//

import Foundation

/// Represents the type of service for deep linking
enum ServiceType: String, Codable, Equatable, CaseIterable {
    case drivingLicenseRenewal = "driving_license_renewal"
    case passportRenewal = "passport_renewal"
    case nationalIdRenewal = "national_id_renewal"
    case dependents = "dependents"
}

/// Represents a clickable link within a chat message that navigates to a specific app screen
struct DeepLink: Codable, Equatable {
    let serviceType: ServiceType
    let title: String
    let alertId: String?
    
    init(serviceType: ServiceType, title: String, alertId: String? = nil) {
        self.serviceType = serviceType
        self.title = title
        self.alertId = alertId
    }
}

/// Represents a message in the chat conversation (user or bot)
struct ChatMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    let deepLink: DeepLink?
    
    init(id: UUID = UUID(), content: String, isUser: Bool, timestamp: Date = Date(), deepLink: DeepLink? = nil) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
        self.deepLink = deepLink
    }
    
    /// Creates a user message
    static func userMessage(_ content: String) -> ChatMessage {
        ChatMessage(content: content, isUser: true)
    }
    
    /// Creates a bot message
    static func botMessage(_ content: String, deepLink: DeepLink? = nil) -> ChatMessage {
        ChatMessage(content: content, isUser: false, deepLink: deepLink)
    }
}
