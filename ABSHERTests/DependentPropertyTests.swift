//
//  DependentPropertyTests.swift
//  ABSHERTests
//
//  Created by Kiro AI
//

import Testing
@testable import ABSHER

struct DependentPropertyTests {
    
    // **Feature: dependent-alerts, Property 1: Dependent alert message contains required information**
    // **Validates: Requirements 1.2**
    @Test("Property 1: Dependent alert message contains required information", arguments: 0..<100)
    func dependentAlertMessageContainsRequiredInfo(iteration: Int) async throws {
        // Generate random Dependent instances
        let dependent = generateRandomDependent(seed: iteration)
        
        // Property: For any dependent with a name and days remaining,
        // the generated alert message SHALL contain both the dependent's name and the days remaining value
        let alertMessage = dependent.alertMessage
        
        #expect(alertMessage.contains(dependent.name), 
                "Alert message must contain the dependent's name")
        #expect(alertMessage.contains("\(dependent.daysRemaining)"), 
                "Alert message must contain the days remaining value")
        #expect(alertMessage.contains(dependent.relationship),
                "Alert message must contain the relationship")
        #expect(alertMessage.contains(dependent.serviceType),
                "Alert message must contain the service type")
    }
    
    // Helper function to generate random Dependent instances
    private func generateRandomDependent(seed: Int) -> Dependent {
        let names = ["حسام", "محمد", "فاطمة", "سارة", "أحمد", "نورة", "خالد", "ريم"]
        let relationships = ["ولدك", "ابنتك", "ابنك", "بنتك"]
        let serviceTypes = ["اصدار رخصة", "تجديد جواز", "تجديد هوية", "تجديد رخصة"]
        
        return Dependent(
            name: names[seed % names.count],
            relationship: relationships[seed % relationships.count],
            serviceType: serviceTypes[seed % serviceTypes.count],
            daysRemaining: (seed * 3) % 365 + 1  // 1-365 days
        )
    }
}
