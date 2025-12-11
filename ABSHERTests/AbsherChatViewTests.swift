//
//  AbsherChatViewTests.swift
//  ABSHERTests
//
//  Created by Kiro AI
//

import Testing
import SwiftUI
@testable import ABSHER

struct AbsherChatViewTests {
    
    @Test func viewInitializesCorrectly() async throws {
        // Test that AbsherChatView can be initialized without errors
        let chatView = AbsherChatView()
        #expect(chatView != nil)
    }
    
    @Test func greetingTextMatchesExpected() async throws {
        // Test that the greeting text constant matches "مرحبا إلياس"
        // Requirements: 2.1
        let expectedGreeting = "مرحبا إلياس"
        #expect(AbsherChatView.greetingText == expectedGreeting)
    }
}
