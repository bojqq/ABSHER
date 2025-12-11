//
//  DigitalDocument.swift
//  ABSHER
//
//  Created by Kiro AI
//

import Foundation
import SwiftUI

struct DigitalDocument: Identifiable {
    let id: UUID
    let type: DocumentType
    let title: String
    let status: DocumentStatus
    let color: Color
    let daysRemaining: Int?
    
    enum DocumentType {
        case nationalID
        case passport
        case license
    }
    
    enum DocumentStatus {
        case valid
        case expiringSoon
        case expired
    }
    
    static let mockDocuments: [DigitalDocument] = [
        DigitalDocument(
            id: UUID(),
            type: .nationalID,
            title: "هوية مواطن",
            status: .valid,
            color: .green,
            daysRemaining: nil
        ),
        DigitalDocument(
            id: UUID(),
            type: .passport,
            title: "جواز السفر",
            status: .valid,
            color: .purple,
            daysRemaining: nil
        ),
        DigitalDocument(
            id: UUID(),
            type: .license,
            title: "رخصة",
            status: .expiringSoon,
            color: .red,
            daysRemaining: 45
        )
    ]
    
    /// Mock expired National ID for testing late fee scenario
    static let expiredNationalID = DigitalDocument(
        id: UUID(),
        type: .nationalID,
        title: "هوية مواطن",
        status: .expired,
        color: .red,
        daysRemaining: nil
    )
}
