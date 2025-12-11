//
//  SuggestionChipPropertyTests.swift
//  ABSHERTests
//
//  Created by Kiro AI
//

import Testing
import Foundation
@testable import ABSHER

struct SuggestionChipPropertyTests {
    
    // **Feature: absher-llm-integration, Property 2: Suggestion chip formatting**
    // **Validates: Requirements 1.2**
    @Test("Property 2: Suggestion chip formatting", arguments: 0..<100)
    func suggestionChipFormatting(iteration: Int) async throws {
        // Generate random ProactiveAlert instances
        let alert = generateRandomAlert(seed: iteration)
        
        // Create suggestion chip from alert
        let chip = SuggestionChip.fromAlert(alert)
        
        // Property: For any proactive alert with a title, the formatted suggestion chip
        // display text SHALL contain "عندك إشعار من التنبيه الاستباقي" prefix followed by the alert title
        let expectedPrefix = SuggestionChip.arabicPrefix
        
        #expect(chip.displayText.hasPrefix(expectedPrefix), 
                "Display text should start with Arabic prefix '\(expectedPrefix)'")
        #expect(chip.displayText.contains(alert.title), 
                "Display text should contain the alert title '\(alert.title)'")
        
        // Verify the exact format: "prefix: title"
        let expectedFormat = "\(expectedPrefix): \(alert.title)"
        #expect(chip.displayText == expectedFormat, 
                "Display text should be '\(expectedFormat)' but was '\(chip.displayText)'")
        
        // Verify the chip preserves the original alert
        #expect(chip.alert == alert, "Chip should preserve the original alert")
    }
    
    // Test that formatDisplayText static method works correctly
    @Test("formatDisplayText produces correct format", arguments: 0..<100)
    func formatDisplayTextProducesCorrectFormat(iteration: Int) async throws {
        let titles = generateRandomTitles(seed: iteration)
        
        for title in titles {
            let formattedText = SuggestionChip.formatDisplayText(alertTitle: title)
            
            // Property: formatted text must contain prefix and title
            #expect(formattedText.hasPrefix(SuggestionChip.arabicPrefix),
                    "Formatted text should start with Arabic prefix")
            #expect(formattedText.contains(title),
                    "Formatted text should contain the title")
        }
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
        let titles = [
            "تنبيه استباقي",
            "إشعار مهم",
            "تذكير",
            "رخصة قيادتك على وشك الانتهاء",
            "جواز سفرك يحتاج للتجديد",
            "هويتك الوطنية تنتهي قريباً",
            "موعد الفحص الطبي",
            "تجديد الإقامة",
            "Alert Title",  // English title
            "🚗 رخصة",  // With emoji
            String(repeating: "أ", count: 50)  // Long title
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
    
    // Helper function to generate random titles
    private func generateRandomTitles(seed: Int) -> [String] {
        [
            "تنبيه استباقي",
            "رخصة قيادتك على وشك الانتهاء",
            "Alert \(seed)",
            "إشعار رقم \(seed)",
            String(repeating: "ت", count: (seed % 20) + 1)
        ]
    }
}
