# Implementation Plan

- [x] 1. Create AbsherChatView with Gemini-inspired demo UI
  - [x] 1.1 Create AbsherChatView.swift with white background and gradient green greeting "مرحبا إلياس"
    - Implement centered greeting with LinearGradient green text
    - Add placeholder input field at bottom
    - Add close button (X) in top-left corner
    - Use RTL layout direction
    - _Requirements: 2.1, 2.2, 2.3, 3.1_

- [x] 2. Add chat icon to TopNavigationBar and integrate with HomeView
  - [x] 2.1 Modify TopNavigationBar to include chat icon button with callback
    - Add optional `onChatTapped` callback parameter
    - Add chat icon button using SF Symbol `bubble.left.and.bubble.right.fill`
    - Position chat icon to the left of settings icon
    - _Requirements: 1.1_
  - [x] 2.2 Update HomeView to manage chat sheet presentation
    - Add `@State` variable for sheet presentation
    - Pass callback to TopNavigationBar
    - Present AbsherChatView as sheet when chat icon is tapped
    - _Requirements: 1.2_

- [x] 2.3 Write unit tests for AbsherChatView
    - Test view initializes correctly
    - Test greeting text content matches "مرحبا إلياس"
    - _Requirements: 2.1_

- [x] 3. Final Checkpoint
  - Ensure all tests pass, ask the user if questions arise.
