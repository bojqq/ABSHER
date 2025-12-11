# Design Document: Absher LLM Integration with MLX

## Overview

This feature integrates a local LLM (Sci 3) with the Absher iOS app using Apple's MLX framework via the mlx-swift-chat package. The chatbot displays proactive alerts as suggestion chips, processes user queries through on-device inference, and provides deep links to navigate to relevant service pages.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      AbsherChatView                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Greeting    │  │ Suggestion  │  │ Chat Messages       │ │
│  │ Section     │  │ Chips       │  │ (with Deep Links)   │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    ChatViewModel                            │
│  - messages: [ChatMessage]                                  │
│  - suggestions: [SuggestionChip]                           │
│  - isLoading: Bool                                          │
│  - sendMessage(text:)                                       │
│  - handleSuggestionTap(alert:)                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    MLXService                               │
│  - model: LLMModel                                          │
│  - isModelLoaded: Bool                                      │
│  - loadModel()                                              │
│  - generate(prompt:) -> AsyncStream<String>                │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    MLX Framework                            │
│  - On-device inference                                      │
│  - Token streaming                                          │
└─────────────────────────────────────────────────────────────┘
```

## Components and Interfaces

### 1. MLXService

Handles model loading and inference using mlx-swift.

```swift
import MLX
import MLXLLM

@MainActor
class MLXService: ObservableObject {
    @Published var isModelLoaded = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var model: LLMModel?
    private var tokenizer: Tokenizer?
    
    func loadModel(modelPath: String) async throws
    func generate(prompt: String) -> AsyncThrowingStream<String, Error>
    func unloadModel()
}
```

### 2. ChatMessage Model

Represents a message in the chat conversation.

```swift
struct ChatMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    let deepLink: DeepLink?
}

struct DeepLink: Codable, Equatable {
    let serviceType: ServiceType
    let title: String
    let alertId: String?
}

enum ServiceType: String, Codable {
    case drivingLicenseRenewal = "driving_license_renewal"
    case passportRenewal = "passport_renewal"
    case nationalIdRenewal = "national_id_renewal"
}
```

### 3. SuggestionChip Model

Represents a tappable suggestion based on proactive alerts.

```swift
struct SuggestionChip: Identifiable, Equatable {
    let id: UUID
    let alert: ProactiveAlert
    let displayText: String
    
    static func fromAlert(_ alert: ProactiveAlert) -> SuggestionChip
    static func formatDisplayText(alertTitle: String) -> String
}
```

### 4. ChatViewModel

Manages chat state and coordinates between UI and MLX service.

```swift
@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var suggestions: [SuggestionChip] = []
    @Published var isProcessing = false
    @Published var inputText = ""
    
    private let mlxService: MLXService
    private let alertsProvider: () -> [ProactiveAlert]
    
    func loadSuggestions()
    func sendMessage()
    func handleSuggestionTap(_ chip: SuggestionChip)
    func handleDeepLinkTap(_ deepLink: DeepLink) -> ServiceType
}
```

### 5. Updated AbsherChatView

Enhanced chat view with suggestions and message display.

```swift
struct AbsherChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            // Messages list
            ScrollView {
                // Greeting
                // Suggestion chips (if any)
                // Chat messages with deep links
            }
            // Input bar
        }
    }
}
```

## Data Models

### ChatMessage JSON Schema

```json
{
    "id": "uuid-string",
    "content": "message text",
    "isUser": true,
    "timestamp": "2025-12-11T10:30:00Z",
    "deepLink": {
        "serviceType": "driving_license_renewal",
        "title": "تجديد رخصة القيادة",
        "alertId": "alert-uuid"
    }
}
```

### Proactive Alert to Suggestion Mapping

```
ProactiveAlert {
    title: "رخصة قيادتك على وشك الانتهاء"
    daysRemaining: 45
    serviceType: .drivingLicense
}
    ↓
SuggestionChip {
    displayText: "عندك إشعار من التنبيه الاستباقي: رخصة قيادتك على وشك الانتهاء"
    alert: ProactiveAlert
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property Reflection

After analyzing the prework, the following consolidations were made:
- Properties 6.1, 6.2, 6.3 are consolidated into a single round-trip property
- Properties 3.1 and 3.2 are consolidated (navigation with context)
- Properties 5.2 and 5.3 are consolidated (response display with loading state)

### Properties

**Property 1: Suggestion chips match proactive alerts**
*For any* list of proactive alerts, the generated suggestion chips SHALL have a one-to-one correspondence with the alerts, preserving alert data.
**Validates: Requirements 1.1**

**Property 2: Suggestion chip formatting**
*For any* proactive alert with a title, the formatted suggestion chip display text SHALL contain "عندك إشعار من التنبيه الاستباقي" prefix followed by the alert title.
**Validates: Requirements 1.2**

**Property 3: Deep link navigation preserves context**
*For any* deep link with a valid service type, tapping the link SHALL navigate to the correct service page with the service context preserved.
**Validates: Requirements 3.1, 3.2**

**Property 4: Token streaming order**
*For any* LLM generation, tokens SHALL be streamed in sequential order without gaps or reordering.
**Validates: Requirements 4.3**

**Property 5: Message submission triggers processing**
*For any* non-empty message text, submitting SHALL add the message to the chat and set the processing state to true.
**Validates: Requirements 5.1, 5.3**

**Property 6: Chat message round-trip serialization**
*For any* valid ChatMessage, serializing to JSON then deserializing SHALL produce an equivalent ChatMessage object.
**Validates: Requirements 6.1, 6.2, 6.3**

## Error Handling

| Error Condition | Handling Strategy |
|----------------|-------------------|
| Model fails to load | Display error message, disable chat input, show retry button |
| Model file not found | Show setup instructions with model path |
| Inference timeout | Cancel generation, show timeout message |
| Memory pressure | Unload model, show memory warning |
| Invalid deep link | Log error, show generic error toast |

## Testing Strategy

### Unit Testing

- Test ChatMessage initialization and properties
- Test SuggestionChip creation from ProactiveAlert
- Test DeepLink parsing and service type mapping
- Test ChatViewModel state transitions

### Property-Based Testing

Using Swift's swift-testing framework with custom generators:

**Test Framework:** swift-testing with custom property test helpers

**Configuration:** Each property test runs minimum 100 iterations

**Generators:**
- `ChatMessageGenerator`: Generates random ChatMessage instances
- `ProactiveAlertGenerator`: Generates random ProactiveAlert instances  
- `DeepLinkGenerator`: Generates random DeepLink instances

**Property Tests:**
1. Suggestion chip generation property
2. Suggestion chip formatting property
3. Deep link navigation property
4. Token streaming order property
5. Message submission property
6. ChatMessage serialization round-trip property

Each property-based test MUST be tagged with: `**Feature: absher-llm-integration, Property {number}: {property_text}**`
