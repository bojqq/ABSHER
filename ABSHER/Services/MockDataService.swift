//
//  MockDataService.swift
//  ABSHER
//
//  Created by Kiro AI
//

import Foundation

class MockDataService {
    static let shared = MockDataService()
    
    private init() {}
    
    let userProfile: UserProfile = .mock
    let documents: [DigitalDocument] = DigitalDocument.mockDocuments
    let proactiveAlert: ProactiveAlert = .mock
    let serviceDetails: ServiceDetails = .mock
    let dependents: [Dependent] = [
        Dependent.mock,
        Dependent(
            name: "سارة",
            relationship: "ابنتك",
            serviceType: "تجديد هوية",
            daysRemaining: 27
        )
    ]
}
