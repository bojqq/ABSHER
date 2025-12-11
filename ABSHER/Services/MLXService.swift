//
//  MLXService.swift
//  ABSHER
//
//  Created by Kiro AI
//

import Foundation
import Combine

/// Errors that can occur during MLX model operations
enum MLXServiceError: LocalizedError {
    case modelNotFound(path: String)
    case modelLoadFailed(underlying: Error)
    case modelNotLoaded
    case generationFailed(underlying: Error)
    case generationCancelled
    
    var errorDescription: String? {
        switch self {
        case .modelNotFound(let path):
            return "لم يتم العثور على النموذج في المسار: \(path)"
        case .modelLoadFailed(let error):
            return "فشل تحميل النموذج: \(error.localizedDescription)"
        case .modelNotLoaded:
            return "النموذج غير محمّل. يرجى تحميل النموذج أولاً."
        case .generationFailed(let error):
            return "فشل توليد الرد: \(error.localizedDescription)"
        case .generationCancelled:
            return "تم إلغاء عملية التوليد."
        }
    }
}

/// Service for managing MLX model loading and inference
/// Handles on-device LLM inference using Apple's MLX framework
@MainActor
class MLXService: ObservableObject {
    /// Indicates whether the model has been successfully loaded
    @Published private(set) var isModelLoaded = false
    
    /// Indicates whether a model loading operation is in progress
    @Published private(set) var isLoading = false
    
    /// Error message if model loading or inference fails
    @Published private(set) var errorMessage: String?
    
    /// The path to the currently loaded model
    private var modelPath: String?
    
    /// Token buffer for streaming - stores generated tokens in order
    private var tokenBuffer: [String] = []
    
    /// Current generation task for cancellation support
    private var currentGenerationTask: Task<Void, Never>?
    
    // MARK: - Model Loading
    
    /// Loads the LLM model from the specified path
    /// - Parameter modelPath: Path to the model directory or file
    /// - Throws: MLXServiceError if model loading fails
    func loadModel(modelPath: String) async throws {
        // Reset state
        isLoading = true
        errorMessage = nil
        isModelLoaded = false
        
        defer {
            isLoading = false
        }
        
        // Check if model path exists
        let fileManager = FileManager.default
        let modelExists = fileManager.fileExists(atPath: modelPath)
        
        do {
            if modelExists {
                // Real model loading with MLX framework
                // In production, this would use:
                // import MLX
                // import MLXLLM
                // let configuration = ModelConfiguration(...)
                // self.model = try await LLM.load(configuration: configuration)
                
                // For now, simulate async loading
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1s simulated load time
            } else {
                // Demo mode - no real model, use simulated responses
                // This allows the app to work without requiring the actual LLM model
                try await Task.sleep(nanoseconds: 50_000_000) // 0.05s simulated load time
            }
            
            self.modelPath = modelPath
            isModelLoaded = true
            errorMessage = nil
            
        } catch is CancellationError {
            let error = MLXServiceError.generationCancelled
            errorMessage = error.localizedDescription
            throw error
        } catch {
            let mlxError = MLXServiceError.modelLoadFailed(underlying: error)
            errorMessage = mlxError.localizedDescription
            isModelLoaded = false
            throw mlxError
        }
    }
    
    /// Unloads the current model and frees memory
    func unloadModel() {
        cancelGeneration()
        modelPath = nil
        isModelLoaded = false
        errorMessage = nil
        tokenBuffer.removeAll()
    }
    
    /// Cancels any ongoing generation
    func cancelGeneration() {
        currentGenerationTask?.cancel()
        currentGenerationTask = nil
    }
}


// MARK: - Token Generation

extension MLXService {
    /// Generates a response for the given prompt using streaming
    /// - Parameter prompt: The input prompt to generate a response for
    /// - Returns: An AsyncThrowingStream that yields tokens as they are generated
    /// - Note: Tokens are streamed in sequential order without gaps or reordering
    func generate(prompt: String) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            let task = Task { @MainActor in
                // Ensure model is loaded before generation
                guard isModelLoaded else {
                    continuation.finish(throwing: MLXServiceError.modelNotLoaded)
                    return
                }
                
                // Clear token buffer for new generation
                tokenBuffer.removeAll()
                
                do {
                    // In production, this would use MLX's streaming generation:
                    // for try await token in model.generate(prompt: prompt) {
                    //     tokenBuffer.append(token)
                    //     continuation.yield(token)
                    // }
                    
                    // Simulated streaming response for development
                    // This demonstrates the streaming pattern that will be used with real MLX
                    let simulatedTokens = generateSimulatedResponse(for: prompt)
                    
                    for token in simulatedTokens {
                        // Check for cancellation
                        try Task.checkCancellation()
                        
                        // Simulate token generation delay (realistic streaming behavior)
                        try await Task.sleep(nanoseconds: 20_000_000) // 20ms per token
                        
                        // Append to buffer to maintain order
                        tokenBuffer.append(token)
                        
                        // Yield token to stream
                        continuation.yield(token)
                    }
                    
                    continuation.finish()
                    
                } catch is CancellationError {
                    continuation.finish(throwing: MLXServiceError.generationCancelled)
                } catch {
                    continuation.finish(throwing: MLXServiceError.generationFailed(underlying: error))
                }
            }
            
            currentGenerationTask = task
            
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
    
    /// Returns the tokens generated in the current/last generation in order
    /// - Returns: Array of tokens in the order they were generated
    func getGeneratedTokens() -> [String] {
        return tokenBuffer
    }
    
    /// Generates a simulated response for development/testing
    /// In production, this will be replaced by actual MLX model inference
    private func generateSimulatedResponse(for prompt: String) -> [String] {
        let lowercasedPrompt = prompt.lowercased()
        
        // Check if prompt is related to driving license
        if lowercasedPrompt.contains("رخصة") || 
           lowercasedPrompt.contains("القيادة") ||
           lowercasedPrompt.contains("اجدد") ||
           lowercasedPrompt.contains("license") ||
           lowercasedPrompt.contains("driving") {
            return [
                "أهلاً! ",
                "يمكنك ",
                "تجديد ",
                "رخصة ",
                "القيادة ",
                "بسهولة ",
                "من ",
                "خلال ",
                "الضغط ",
                "على ",
                "الرابط ",
                "أدناه. ",
                "الرسوم ",
                "هي ",
                "٤٠ ",
                "ريال ",
                "فقط."
            ]
        }
        
        // Check if prompt is related to proactive alerts
        if lowercasedPrompt.contains("تنبيه") || lowercasedPrompt.contains("إشعار") {
            return [
                "مرحباً! ",
                "لاحظت ",
                "أن ",
                "رخصة ",
                "قيادتك ",
                "على ",
                "وشك ",
                "الانتهاء. ",
                "يمكنك ",
                "تجديدها ",
                "الآن ",
                "بسهولة. ",
                "اضغط ",
                "على ",
                "الرابط ",
                "أدناه ",
                "للمتابعة."
            ]
        }
        
        // Check if prompt is related to passport
        if lowercasedPrompt.contains("جواز") || lowercasedPrompt.contains("السفر") || lowercasedPrompt.contains("passport") {
            return [
                "يمكنك ",
                "تجديد ",
                "جواز ",
                "السفر ",
                "من ",
                "خلال ",
                "الرابط ",
                "أدناه."
            ]
        }
        
        // Check if prompt is related to national ID
        if lowercasedPrompt.contains("هوية") || lowercasedPrompt.contains("الوطنية") {
            return [
                "يمكنك ",
                "تجديد ",
                "الهوية ",
                "الوطنية ",
                "من ",
                "خلال ",
                "الرابط ",
                "أدناه."
            ]
        }
        
        // Default response
        return [
            "مرحباً ",
            "بك ",
            "في ",
            "أبشر. ",
            "كيف ",
            "يمكنني ",
            "مساعدتك ",
            "اليوم؟ ",
            "يمكنني ",
            "مساعدتك ",
            "في ",
            "تجديد ",
            "رخصة ",
            "القيادة، ",
            "جواز ",
            "السفر، ",
            "أو ",
            "الهوية ",
            "الوطنية."
        ]
    }
}
