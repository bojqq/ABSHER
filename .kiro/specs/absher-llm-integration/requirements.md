# Requirements Document

## Introduction

This feature integrates a local LLM (Sci 3, 16GB RAM requirement) with the Absher iOS app using Apple's MLX framework. The chatbot displays proactive alerts (التنبيه الاستباقي) as suggestion chips when the user enters the chat. When the user taps a suggestion, the LLM responds with a clickable link that navigates to the relevant service page (e.g., driving license renewal payment page).

## Glossary

- **LLM**: Large Language Model - the Sci 3 model trained for Absher-specific interactions
- **MLX**: Apple's machine learning framework for running models efficiently on Apple Silicon
- **MLXSwift**: Swift bindings for MLX framework enabling on-device LLM inference
- **Proactive_Alert**: A notification about upcoming deadlines or required actions (التنبيه الاستباقي)
- **Suggestion_Chip**: A tappable UI element displayed as a quick action suggestion in the chat
- **Chat_Message**: A message displayed in the chat conversation (user or bot)
- **Deep_Link**: A clickable link within a chat message that navigates to a specific app screen
- **Payment_Page**: The service detail screen for paying fees (e.g., رخصة القيادة renewal)

## Requirements

### Requirement 1

**User Story:** As a user, I want to see proactive alert suggestions when I open the chatbot, so that I am immediately aware of important notifications.

#### Acceptance Criteria

1. WHEN the user opens the chat view THEN the Chatbot SHALL display active Proactive_Alert items as Suggestion_Chip elements below the greeting
2. WHEN Proactive_Alert items exist THEN the Chatbot SHALL format each Suggestion_Chip with text "عندك إشعار من التنبيه الاستباقي" and the alert title
3. WHEN no Proactive_Alert items exist THEN the Chatbot SHALL display the greeting without Suggestion_Chip elements

### Requirement 2

**User Story:** As a user, I want to tap a proactive alert suggestion to get more details, so that I can take action on important notifications.

#### Acceptance Criteria

1. WHEN the user taps a Suggestion_Chip THEN the Chatbot SHALL send the alert context to the LLM for processing
2. WHEN the LLM processes a Proactive_Alert query THEN the Chatbot SHALL display a Chat_Message with a Deep_Link to the relevant service page
3. WHEN the LLM generates a response THEN the Chatbot SHALL include the alert details and a call-to-action in Arabic

### Requirement 3

**User Story:** As a user, I want to tap a link in the chatbot response to navigate directly to the service page, so that I can complete the required action quickly.

#### Acceptance Criteria

1. WHEN the user taps a Deep_Link in a Chat_Message THEN the Chatbot SHALL navigate to the corresponding Payment_Page
2. WHEN navigating to Payment_Page THEN the Chatbot SHALL pass the relevant service context (e.g., driving license renewal)
3. WHEN the Deep_Link is tapped THEN the Chatbot SHALL dismiss the chat view and display the Payment_Page

### Requirement 4

**User Story:** As a developer, I want to integrate MLX framework for local LLM inference, so that the chatbot can run the Sci 3 model on-device.

#### Acceptance Criteria

1. WHEN the app initializes THEN the MLXSwift service SHALL load the Sci 3 model into memory
2. WHEN the LLM receives a prompt THEN the MLXSwift service SHALL generate a response using on-device inference
3. WHEN the model generates text THEN the MLXSwift service SHALL stream tokens to the chat UI for display
4. IF the model fails to load THEN the MLXSwift service SHALL display an error message and disable chat functionality

### Requirement 5

**User Story:** As a user, I want to send text messages to the chatbot, so that I can ask questions and get assistance.

#### Acceptance Criteria

1. WHEN the user types a message and submits THEN the Chatbot SHALL send the message to the LLM for processing
2. WHEN the LLM generates a response THEN the Chatbot SHALL display the response as a Chat_Message
3. WHEN the LLM is processing THEN the Chatbot SHALL display a loading indicator

### Requirement 6

**User Story:** As a developer, I want to serialize and deserialize chat messages, so that conversation history can be persisted and restored.

#### Acceptance Criteria

1. WHEN a Chat_Message is created THEN the system SHALL serialize the message to JSON format
2. WHEN JSON data is loaded THEN the system SHALL deserialize it back to Chat_Message objects
3. WHEN serializing then deserializing a Chat_Message THEN the system SHALL produce an equivalent message object

</content>
