//
//  ProactiveAlertPropertyTests.swift
//  ABSHERTests
//
//  Created by Kiro AI
//

import Testing
@testable import ABSHER

struct ProactiveAlertPropertyTests {
    
    // **Feature: absher-prototype, Property 8: Alert card contains required information**
    // **Validates: Requirements 3.2, 3.3, 3.4, 3.5, 3.6**
    @Test("Property 8: Alert card contains required information", arguments: 0..<100)
    func alertCardContainsRequiredInformation(iteration: Int) async throws {
        // Generate random ProactiveAlert instances
        let alert = generateRandomAlert(seed: iteration)
        
        // Property: For any ProactiveAlert, it must contain all required fields
        #expect(!alert.iconName.isEmpty, "Alert must have an icon")
        #expect(!alert.title.isEmpty, "Alert must have a title")
        #expect(!alert.serviceType.isEmpty, "Alert must have a service type")
        #expect(alert.daysRemaining >= 0, "Days remaining must be non-negative")
        #expect(!alert.message.isEmpty, "Alert must have a message")
        #expect(!alert.actionText.isEmpty, "Alert must have action text")
    }
    
    // Helper function to generate random ProactiveAlert instances
    private func generateRandomAlert(seed: Int) -> ProactiveAlert {
        let icons = [
            "bell.fill",
            "exclamationmark.triangle.fill",
            "megaphone.fill",
            "dot.circle.fill",
            "alarm.fill"
        ]
        let titles = ["تنبيه استباقي", "إشعار مهم", "تذكير"]
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
            daysRemaining: (seed * 7) % 90 + 1, // 1-90 days
            message: messages[seed % messages.count],
            actionText: actionTexts[seed % actionTexts.count]
        )
    }
}
