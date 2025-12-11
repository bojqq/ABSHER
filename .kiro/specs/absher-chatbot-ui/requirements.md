# Requirements Document

## Introduction

This feature adds a demo chatbot UI to the Absher app, inspired by Gemini's design. The chatbot displays a greeting message "مرحبا إلياس" with a gradient green effect on a white background. A chat icon is added to the header, positioned to the left of the settings button. This is a UI-only demo; LLM integration will be added later.

## Glossary

- **Chatbot_UI**: The visual interface for the AI chat feature, displaying messages and input controls
- **Header**: The top navigation bar of the app containing icons and title (TopNavigationBar component)
- **Gradient_Text**: Text styled with a color gradient effect (green tones)
- **Chat_Sheet**: A modal presentation that slides up from the bottom to display the chat interface

## Requirements

### Requirement 1

**User Story:** As a user, I want to access the chatbot from the header, so that I can quickly start a conversation with the AI assistant.

#### Acceptance Criteria

1. WHEN the user views the home screen THEN the Chatbot_UI SHALL display a chat icon in the Header to the left of the settings icon
2. WHEN the user taps the chat icon THEN the Chatbot_UI SHALL present the chat view as a Chat_Sheet

### Requirement 2

**User Story:** As a user, I want to see a welcoming greeting when I open the chatbot, so that I feel the app is personalized.

#### Acceptance Criteria

1. WHEN the chat view opens THEN the Chatbot_UI SHALL display "مرحبا إلياس" as a centered greeting with Gradient_Text in green tones
2. WHEN the chat view opens THEN the Chatbot_UI SHALL display a white background following Gemini-style design
3. WHEN the chat view opens THEN the Chatbot_UI SHALL display a text input field at the bottom for future message entry

### Requirement 3

**User Story:** As a user, I want to close the chatbot and return to the main app, so that I can continue using other features.

#### Acceptance Criteria

1. WHEN the user taps a close button THEN the Chatbot_UI SHALL dismiss the Chat_Sheet and return to the previous screen
