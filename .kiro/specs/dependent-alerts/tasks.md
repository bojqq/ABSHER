# Implementation Plan

- [x] 1. Create Dependent model and extend ServiceType
  - [x] 1.1 Create Dependent model with id, name, relationship, serviceType, daysRemaining
    - Add computed property `alertMessage` for formatted display text
    - Include mock data for testing (حسام with 45 days remaining)
    - _Requirements: 1.2_
  - [x] 1.2 Write property test for Dependent alertMessage
    - **Property 1: Dependent alert message contains required information**
    - **Validates: Requirements 1.2**
  - [x] 1.3 Extend ServiceType enum with dependents case
    - Add `case dependents = "dependents"` to ServiceType enum
    - _Requirements: 2.1_

- [x] 2. Extend ChatViewModel to generate dependent alerts
  - [x] 2.1 Add method to create dependent alert message
    - Create `createDependentAlertMessage(for:)` method
    - Return ChatMessage with deep link to dependents
    - _Requirements: 1.1, 1.3_
  - [x] 2.2 Write property test for dependent alert deep links
    - **Property 2: Dependent alert messages have navigation deep links**
    - **Validates: Requirements 1.1, 1.3**
  - [x] 2.3 Update generateResponse to add dependent alert after main response
    - After adding bot response, check for active dependent alerts
    - Add dependent alert message if available
    - _Requirements: 1.1_

- [x] 3. Extend navigation for dependent and proactive alerts
  - [x] 3.1 Update handleDeepLinkTap to return navigation destination
    - Return `.dependents` for dependents service type
    - Return `.review` for proactive alert service types
    - _Requirements: 2.1, 2.2_
  - [x] 3.2 Write property test for dependent navigation
    - **Property 3: Dependent deep link navigates to dependents destination**
    - **Validates: Requirements 2.1**
  - [x] 3.3 Write property test for proactive alert navigation
    - **Property 4: Proactive alert deep link navigates to dashboard**
    - **Validates: Requirements 2.2**

- [x] 4. Extend AppViewModel with dependents navigation
  - [x] 4.1 Add Screen.dependents case to AppViewModel
    - Add `case dependents` to Screen enum
    - _Requirements: 2.1_
  - [x] 4.2 Add navigateToDependents method
    - Implement navigation to dependents screen
    - _Requirements: 2.1_

- [x] 5. Create DependentsView
  - [x] 5.1 Create DependentsView with dependent list display
    - Show list of dependents with names and service statuses
    - Display days remaining prominently for each dependent
    - Include back navigation
    - _Requirements: 3.1, 3.2, 3.3_
  - [x] 5.2 Write property test for dependents page rendering
    - **Property 5: Dependents page displays all dependent information**
    - **Validates: Requirements 3.1, 3.2**

- [x] 6. Update AbsherChatView navigation handling
  - [x] 6.1 Update handleDeepLinkNavigation for dependents
    - Handle `.dependents` service type navigation
    - Call appViewModel.navigateToDependents() for dependent alerts
    - Keep existing behavior for proactive alerts (navigate to review)
    - _Requirements: 2.1, 2.2, 2.3_

- [x] 7. Wire up DependentsView in main app flow
  - [x] 7.1 Add DependentsView case to ContentView
    - Handle Screen.dependents in ContentView switch
    - Display DependentsView when navigating to dependents
    - _Requirements: 2.1_

- [x] 8. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
