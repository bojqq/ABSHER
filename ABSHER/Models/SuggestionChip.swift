//
//  SuggestionChip.swift
//  ABSHER
//
//  Created by Kiro AI
//

import Foundation

/// Represents a tappable suggestion based on proactive alerts
struct SuggestionChip: Identifiable, Equatable {
    let id: UUID
    let alert: ProactiveAlert
    let displayText: String
    
    /// Arabic prefix for proactive alert suggestions
    static let arabicPrefix = "عندك إشعار من التنبيه الاستباقي"
    
    /// Creates a SuggestionChip from a ProactiveAlert
    /// - Parameter alert: The proactive alert to create a suggestion from
    /// - Returns: A new SuggestionChip with formatted display text
    static func fromAlert(_ alert: ProactiveAlert) -> SuggestionChip {
        SuggestionChip(
            id: UUID(),
            alert: alert,
            displayText: formatDisplayText(alertTitle: alert.title)
        )
    }
    
    /// Formats the display text with Arabic prefix and alert title
    /// - Parameter alertTitle: The title of the alert
    /// - Returns: Formatted display text with prefix
    static func formatDisplayText(alertTitle: String) -> String {
        "\(arabicPrefix): \(alertTitle)"
    }
}

// MARK: - ProactiveAlert Equatable conformance
extension ProactiveAlert: Equatable {
    static func == (lhs: ProactiveAlert, rhs: ProactiveAlert) -> Bool {
        lhs.iconName == rhs.iconName &&
        lhs.title == rhs.title &&
        lhs.serviceType == rhs.serviceType &&
        lhs.daysRemaining == rhs.daysRemaining &&
        lhs.message == rhs.message &&
        lhs.actionText == rhs.actionText
    }
}
