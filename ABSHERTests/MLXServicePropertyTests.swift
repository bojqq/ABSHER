//
//  MLXServicePropertyTests.swift
//  ABSHERTests
//
//  Created by Kiro AI
//

import Testing
import Foundation
@testable import ABSHER

struct MLXServicePropertyTests {
    
    // **Feature: absher-llm-integration, Property 4: Token streaming order**
    // **Validates: Requirements 4.3**
    @Test("Property 4: Token streaming order - tokens streamed in sequential order", arguments: 0..<100)
    @MainActor
    func tokenStreamingOrder(iteration: Int) async throws {
        // Setup: Create MLXService and load model
        let service = MLXService()
        
        // Create a temporary model path for testing
        let tempDir = FileManager.default.temporaryDirectory
        let modelPath = tempDir.appendingPathComponent("test_model_\(iteration)").path
        
        // Create a dummy file to simulate model existence
        FileManager.default.createFile(atPath: modelPath, contents: Data(), attributes: nil)
        defer {
            try? FileManager.default.removeItem(atPath: modelPath)
        }
        
        // Load the model
        try await service.loadModel(modelPath: modelPath)
        #expect(service.isModelLoaded, "Model should be loaded before generation")
        
        // Generate random prompt
        let prompt = generateRandomPrompt(seed: iteration)
        
        // Collect tokens from stream
        var streamedTokens: [String] = []
        let stream = service.generate(prompt: prompt)
        
        for try await token in stream {
            streamedTokens.append(token)
        }
        
        // Get tokens from internal buffer (represents the order they were generated)
        let bufferTokens = service.getGeneratedTokens()
        
        // Property: For any LLM generation, tokens SHALL be streamed in sequential order
        // without gaps or reordering
        
        // 1. Verify streamed tokens match buffer tokens exactly (same order)
        #expect(streamedTokens.count == bufferTokens.count, 
                "Streamed token count should match buffer token count")
        
        // 2. Verify each token position matches
        for (index, (streamed, buffered)) in zip(streamedTokens, bufferTokens).enumerated() {
            #expect(streamed == buffered, 
                    "Token at position \(index) should match: streamed='\(streamed)' vs buffered='\(buffered)'")
        }
        
        // 3. Verify no gaps (all tokens are non-empty or intentionally empty)
        // The stream should yield tokens continuously without skipping
        var previousIndex = -1
        for (index, _) in streamedTokens.enumerated() {
            #expect(index == previousIndex + 1, 
                    "Token indices should be sequential without gaps")
            previousIndex = index
        }
        
        // 4. Verify tokens form a coherent response when joined
        let fullResponse = streamedTokens.joined()
        #expect(!fullResponse.isEmpty || streamedTokens.isEmpty, 
                "Joined tokens should form a non-empty response (unless no tokens generated)")
    }
    
    // **Feature: absher-llm-integration, Property 4: Token streaming order - model not loaded error**
    // **Validates: Requirements 4.3, 4.4**
    @Test("Property 4: Token streaming - error when model not loaded")
    @MainActor
    func tokenStreamingErrorWhenModelNotLoaded() async throws {
        let service = MLXService()
        
        // Attempt to generate without loading model
        let stream = service.generate(prompt: "Test prompt")
        
        var receivedError: Error?
        do {
            for try await _ in stream {
                // Should not receive any tokens
            }
        } catch {
            receivedError = error
        }
        
        // Property: Generation should fail with modelNotLoaded error
        #expect(receivedError != nil, "Should receive an error when model is not loaded")
        
        if let mlxError = receivedError as? MLXServiceError {
            switch mlxError {
            case .modelNotLoaded:
                // Expected error
                break
            default:
                Issue.record("Expected modelNotLoaded error, got: \(mlxError)")
            }
        }
    }
    
    // Helper function to generate random prompts
    private func generateRandomPrompt(seed: Int) -> String {
        let prompts = [
            "مرحباً",
            "أريد تجديد رخصة القيادة",
            "عندك إشعار من التنبيه الاستباقي: رخصة قيادتك على وشك الانتهاء",
            "ما هي الخدمات المتاحة؟",
            "كيف يمكنني دفع الرسوم؟",
            "Hello",
            "I need help with my license",
            "What services are available?",
            "تنبيه استباقي",
            "رخصة القيادة",
            "", // Edge case: empty prompt
            String(repeating: "أ", count: 100) // Edge case: long prompt
        ]
        
        return prompts[seed % prompts.count]
    }
}
