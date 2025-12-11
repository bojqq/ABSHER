# Design Document: Absher Chatbot UI Demo

## Overview

This feature adds a Gemini-inspired chatbot UI demo to the Absher app. The implementation focuses on the visual presentation layer only, with LLM integration planned for a future phase. The design emphasizes a clean, minimal interface with Arabic RTL support and a personalized greeting.

## Architecture

The feature follows the existing MVVM pattern used throughout the app:

```
┌─────────────────┐     ┌──────────────────┐
│ TopNavigationBar│────▶│ AbsherChatView   │
│ (chat icon)     │     │ (demo UI)        │
└─────────────────┘     └──────────────────┘
        │
        ▼
┌─────────────────┐
│   HomeView      │
│ (sheet state)   │
└─────────────────┘
```

- **TopNavigationBar**: Modified to include chat icon button with callback
- **HomeView**: Manages sheet presentation state for AbsherChatView
- **AbsherChatView**: New standalone view for the chatbot demo UI

## Components and Interfaces

### 1. Chat Icon Button (in TopNavigationBar)

- SF Symbol: `bubble.left.and.bubble.right.fill`
- Position: Left of the settings icon in header
- Action: Triggers callback to present AbsherChatView

```swift
// TopNavigationBar modification
struct TopNavigationBar: View {
    var onChatTapped: (() -> Void)? = nil
    // ... existing code with new chat button
}
```

### 2. AbsherChatView

- **Greeting Section**: Centered "مرحبا إلياس" with gradient green text
- **Background**: White/light clean background
- **Input Area**: Text field at bottom (non-functional for demo)
- **Close Button**: X button in top-left to dismiss the view

```swift
struct AbsherChatView: View {
    @Environment(\.dismiss) var dismiss
    // Greeting with gradient, input field, close button
}
```

### 3. HomeView Integration

- State variable to control sheet presentation
- Pass callback to TopNavigationBar for chat icon tap

## Data Models

No new data models required for this UI-only demo.

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

Based on the prework analysis, all acceptance criteria for this feature are UI-specific examples involving:

- Presence of UI elements (chat icon, greeting text, input field, close button)
- UI state transitions (sheet presentation/dismissal)
- Visual styling (gradient, background color, positioning)

These are discrete UI behaviors rather than universal properties that hold across ranges of inputs.

**No property-based tests required** - all acceptance criteria are example-based UI tests or visual design requirements.

## Error Handling

- If the chat view fails to present, the app continues normally
- Input field is disabled/placeholder for demo (no error states needed)
- Close button always dismisses the sheet gracefully

## Testing Strategy

### Unit Testing

- Verify AbsherChatView initializes correctly
- Verify greeting text content matches expected value "مرحبا إلياس"
- Verify TopNavigationBar callback is triggered when chat icon is tapped

### UI Testing (Example-based)

- Test chat icon exists in TopNavigationBar
- Test tapping chat icon presents the chat view as sheet
- Test close button dismisses the chat view
- Test greeting text is displayed with correct content
- Test input field is present at bottom of chat view

No property-based testing library is required for this feature as all acceptance criteria are example-based UI tests.
