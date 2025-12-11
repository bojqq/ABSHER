# Requirements Document

## Introduction

This feature adds support for dependent (تابعين) alerts in the Absher chatbot. When the chatbot displays a proactive alert response, it will also show a secondary message about dependents (e.g., "ولدك حسام باقي له ٤٥ يوم على اصدار رخصة"). Tapping on the dependent alert navigates to a Dependents Page, while tapping on the original proactive alert (تنبيه استباقي) navigates to the user's dashboard showing their driving license information.

## Glossary

- **Absher_Chatbot**: The conversational AI interface within the Absher app that provides proactive alerts and service assistance
- **Dependent_Alert**: A notification about a family member (تابع) who has an upcoming service deadline
- **Proactive_Alert**: A notification about the user's own upcoming service deadline
- **Dependents_Page**: A view displaying the list of user's dependents and their service statuses
- **Dashboard**: The main home view showing the user's own documents and license information
- **Deep_Link**: A clickable button within a chat message that navigates to a specific app screen

## Requirements

### Requirement 1

**User Story:** As a user, I want to see alerts about my dependents' upcoming service deadlines in the chat, so that I can manage their services proactively.

#### Acceptance Criteria

1. WHEN the Absher_Chatbot displays a proactive alert response THEN the Absher_Chatbot SHALL display an additional Dependent_Alert message below the main response
2. WHEN a Dependent_Alert is displayed THEN the Absher_Chatbot SHALL show the dependent's name and days remaining (e.g., "ولدك حسام باقي له ٤٥ يوم على اصدار رخصة")
3. WHEN a Dependent_Alert is displayed THEN the Absher_Chatbot SHALL include a clickable Deep_Link button for navigation

### Requirement 2

**User Story:** As a user, I want to navigate to different pages based on which alert I tap, so that I can quickly access the relevant information.

#### Acceptance Criteria

1. WHEN a user taps the Dependent_Alert Deep_Link THEN the Absher_Chatbot SHALL navigate to the Dependents_Page
2. WHEN a user taps the Proactive_Alert Deep_Link (تنبيه استباقي) THEN the Absher_Chatbot SHALL navigate to the Dashboard showing driving license information
3. WHEN navigation occurs THEN the Absher_Chatbot SHALL dismiss the chat view before displaying the target page

### Requirement 3

**User Story:** As a user, I want to see a dedicated page for my dependents, so that I can view and manage their service statuses.

#### Acceptance Criteria

1. WHEN the Dependents_Page is displayed THEN the system SHALL show a list of dependents with their names and service statuses
2. WHEN a dependent has an upcoming deadline THEN the Dependents_Page SHALL display the days remaining prominently
3. WHEN the Dependents_Page is displayed THEN the system SHALL provide navigation back to the previous screen
