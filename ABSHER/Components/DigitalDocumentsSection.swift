//
//  DigitalDocumentsSection.swift
//  ABSHER
//
//  Created by Kiro AI
//

import SwiftUI

struct DigitalDocumentsSection: View {
    let documents: [DigitalDocument]
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Section header
            HStack {
                Button(action: {}) {
                    Text("عرض الكل")
                        .font(.absherCaption)
                        .foregroundColor(.absherGreen)
                }
                
                Spacer()
                
                Text("وثائقي الرقمية")
                    .font(.absherHeadline)
                    .foregroundColor(.absherTextPrimary)
            }
            
            // Horizontal scrolling document cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(documents) { document in
                        DocumentCard(document: document)
                    }
                }
            }
            
            // Info text
            Text("يمكنك عرض جميع وثائقك الرقمية")
                .font(.absherSmall)
                .foregroundColor(.absherTextSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct DocumentCard: View {
    let document: DigitalDocument
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // Icon
            Image(systemName: iconName)
                .font(.system(size: 32))
                .foregroundColor(document.color)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            // Title
            Text(document.title)
                .font(.absherBody)
                .foregroundColor(.absherTextPrimary)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            // Status
            if let daysRemaining = document.daysRemaining,
               document.status == .expiringSoon {
                Text("متبقي \(daysRemaining) يومًا")
                    .font(.absherSmall)
                    .foregroundColor(.absherOrange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.absherOrange.opacity(0.15))
                    .cornerRadius(4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } else if document.status == .expired {
                Text("انتهت")
                    .font(.absherSmall)
                    .foregroundColor(.red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(width: 100, height: 120)
        .padding(12)
        .absherCardStyle()
    }
    
    private var iconName: String {
        switch document.type {
        case .nationalID:
            return "person.text.rectangle"
        case .passport:
            return "book.closed"
        case .license:
            return "car"
        }
    }
}

#Preview {
    DigitalDocumentsSection(documents: DigitalDocument.mockDocuments)
        .padding()
        .background(Color.absherBackground)
        .environment(\.layoutDirection, .rightToLeft)
}
