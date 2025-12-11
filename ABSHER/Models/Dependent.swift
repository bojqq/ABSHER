//
//  Dependent.swift
//  ABSHER
//
//  Created by Kiro AI
//

import Foundation

/// Represents a dependent (تابع) family member with upcoming service deadlines
struct Dependent: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let relationship: String  // e.g., "ولدك", "ابنتك"
    let serviceType: String   // e.g., "اصدار رخصة"
    let daysRemaining: Int
    
    /// Formatted alert message for display in chat
    var alertMessage: String {
        "\(relationship) \(name) باقي له \(daysRemaining) يوم على \(serviceType)"
    }
    
    init(id: UUID = UUID(), name: String, relationship: String, serviceType: String, daysRemaining: Int) {
        self.id = id
        self.name = name
        self.relationship = relationship
        self.serviceType = serviceType
        self.daysRemaining = daysRemaining
    }
    
    /// Mock data for testing (حسام with 180 days remaining)
    static let mock = Dependent(
        name: "حسام",
        relationship: "ولدك",
        serviceType: "اصدار رخصة",
        daysRemaining: 180
    )
}
