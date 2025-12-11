# Requirements Document

## Introduction

The ABSHER Proactive Assistant Prototype demonstrates the PSA (Proactive Services API) feature integrated into the authentic Absher app interface. The prototype replicates the real Absher app's dark theme design and adds a "Sticky Alert Card" for proactive service notifications. The alert card appears on the main home screen after login, positioned between the user profile section and the "وثائقي الرقمية" (Digital Documents) section. This prototype showcases the 96% time savings by reducing a 30-minute multi-step process to a single approval action.

## Glossary

- **PSA (Proactive Services API)**: The intelligent system that monitors user data and prepares services proactively
- **Sticky Alert Card**: A prominent notification banner showing an upcoming service requirement
- **Review Screen**: The screen displaying pre-filled service information ready for one-click approval
- **وثائقي الرقمية**: Digital Documents section showing ID, passport, license cards
- **الوصول السريع**: Quick Access section with service shortcuts
- **Mock Login**: Simulated authentication for demo purposes (no real backend)

## Requirements

### Requirement 1: Mock Login Screen

**User Story:** As a demo viewer, I want to see an authentic Absher login screen, so that the prototype feels like the real app.

#### Acceptance Criteria

1. WHEN the app launches THEN the system SHALL display a login screen matching Absher's dark theme design
2. WHEN the login screen loads THEN the system SHALL display the Absher logo with Saudi emblem
3. WHEN the login screen loads THEN the system SHALL display "تسجيل الدخول إلى أبشر" title
4. WHEN the login screen loads THEN the system SHALL display username/ID field with label "اسم المستخدم أو رقم الهوية"
5. WHEN the login screen loads THEN the system SHALL display password field with label "كلمة المرور"
6. WHEN the login screen loads THEN the system SHALL display "عدم تسجيل الخروج" checkbox option
7. WHEN the login screen loads THEN the system SHALL display a prominent "تسجيل الدخول" button
8. WHEN the user taps login THEN the system SHALL show loading indicator "جار التحميل..." and navigate to home

### Requirement 2: Home Screen Layout (Post-Login)

**User Story:** As a demo viewer, I want to see the authentic Absher home screen with the proactive alert integrated, so that I can understand how the PSA feature fits into the existing app.

#### Acceptance Criteria

1. WHEN the user logs in THEN the system SHALL display the home screen with dark theme (#1C1C1E background)
2. WHEN the home screen loads THEN the system SHALL display the top navigation bar with notification bell and settings icons
3. WHEN the home screen loads THEN the system SHALL display the user profile card with name and ID number (blurred/masked)
4. WHEN the home screen loads THEN the system SHALL display the Proactive Alert Card below the profile card
5. WHEN the home screen loads THEN the system SHALL display "وثائقي الرقمية" section with document cards below the alert
6. WHEN the home screen loads THEN the system SHALL display "الوصول السريع" section with quick access cards
7. WHEN the home screen loads THEN the system SHALL display bottom tab bar with الرئيسية, خدماتي, عائلتي, عمالي, خدمات أخرى

### Requirement 3: Proactive Alert Card (Sticky Alert)

**User Story:** As a demo viewer, I want to see a prominent proactive alert card that stands out on the home screen, so that I understand the PSA's anticipation value.

#### Acceptance Criteria

1. WHEN the home screen loads THEN the system SHALL display the Proactive Alert Card between profile and وثائقي الرقمية
2. WHEN the alert card is displayed THEN the system SHALL show a notification icon (🔔) with urgency styling
3. WHEN the alert card is displayed THEN the system SHALL show title "تنبيه استباقي" with accent color
4. WHEN the alert card is displayed THEN the system SHALL show message about license renewal in 45 days
5. WHEN the alert card is displayed THEN the system SHALL show "اضغط للموافقة والدفع الآن" call-to-action
6. WHEN the alert card is displayed THEN the system SHALL use a distinct card style (gradient or accent border) to stand out
7. WHEN the user taps the alert card THEN the system SHALL navigate to the Review Screen

### Requirement 4: Digital Documents Section

**User Story:** As a demo viewer, I want to see the authentic digital documents section, so that the prototype matches the real Absher experience.

#### Acceptance Criteria

1. WHEN the home screen loads THEN the system SHALL display "وثائقي الرقمية" section header with "عرض الكل" link
2. WHEN the section loads THEN the system SHALL display horizontal scrollable document cards
3. WHEN the section loads THEN the system SHALL display "هوية مواطن" (National ID) card with green styling
4. WHEN the section loads THEN the system SHALL display "جواز السفر" (Passport) card with purple styling
5. WHEN the section loads THEN the system SHALL display "رخصة" (License) card - this one shows "انتهت" (expired) status
6. WHEN the section loads THEN the system SHALL display info text about viewing all documents

### Requirement 5: Quick Access Section

**User Story:** As a demo viewer, I want to see the quick access section matching the real app, so that the prototype is authentic.

#### Acceptance Criteria

1. WHEN the home screen loads THEN the system SHALL display "الوصول السريع" section header
2. WHEN the section loads THEN the system SHALL display "مركباتي" card with car icon
3. WHEN the section loads THEN the system SHALL display service category cards in grid layout
4. WHEN the section loads THEN the system SHALL display "أبشر سفر" and "خدمات التوثيق" cards at bottom

### Requirement 6: Service Review Screen

**User Story:** As a demo viewer, I want to see a review screen with all pre-filled service information, so that I understand how the PSA prepares everything automatically.

#### Acceptance Criteria

1. WHEN the user taps the proactive alert THEN the system SHALL navigate to the review screen
2. WHEN the review screen loads THEN the system SHALL display "تجديد رخصة القيادة" as the service title
3. WHEN the review screen loads THEN the system SHALL display beneficiary status "خالٍ من المخالفات" with checkmark
4. WHEN the review screen loads THEN the system SHALL display fees section with amount ready for Sadad payment
5. WHEN the review screen loads THEN the system SHALL display requirements status "جميع المتطلبات جاهزة وموثقة"
6. WHEN the review screen loads THEN the system SHALL display medical check status "الفحص الطبي تم التحقق منه"
7. WHEN the review screen loads THEN the system SHALL display prominent "موافقة والدفع" button
8. WHEN the user taps approve THEN the system SHALL show brief loading and navigate to confirmation

### Requirement 7: Success Confirmation Screen

**User Story:** As a demo viewer, I want to see a success confirmation with time savings metrics, so that I understand the PSA's value proposition.

#### Acceptance Criteria

1. WHEN the user approves the service THEN the system SHALL display a full-screen success message
2. WHEN the confirmation loads THEN the system SHALL display "✅ تم تجديد رخصتك بنجاح" message
3. WHEN the confirmation loads THEN the system SHALL prominently display "لقد وفرت 25 دقيقة" time savings
4. WHEN the confirmation loads THEN the system SHALL display "من البحث وإدخال البيانات والتنقل بين الخدمات"
5. WHEN the confirmation loads THEN the system SHALL display "التفاصيل في بريدك" message
6. WHEN the confirmation loads THEN the system SHALL provide "العودة للرئيسية" button to reset demo

### Requirement 8: Visual Design Matching Absher

**User Story:** As a demo viewer, I want the prototype to visually match the real Absher app, so that it's presentation-ready.

#### Acceptance Criteria

1. WHEN any screen is displayed THEN the system SHALL use dark theme with #1C1C1E or similar dark background
2. WHEN any screen is displayed THEN the system SHALL use Absher green (#4CAF50 or similar) as accent color
3. WHEN any screen is displayed THEN the system SHALL use right-to-left layout for Arabic
4. WHEN cards are displayed THEN the system SHALL use rounded corners and subtle borders matching Absher style
5. WHEN the bottom tab bar is displayed THEN the system SHALL match Absher's tab bar design with icons and labels
6. WHEN text is displayed THEN the system SHALL use Arabic typography matching Absher's font style

### Requirement 9: Demo Reset and Flow

**User Story:** As a presenter, I want to easily reset the demo to show the complete flow multiple times.

#### Acceptance Criteria

1. WHEN the user is on confirmation screen THEN the system SHALL provide a way to return to login
2. WHEN the demo resets THEN the system SHALL return to the login screen
3. WHEN the demo runs again THEN the system SHALL show the same flow consistently
4. WHEN navigating THEN the system SHALL use smooth transitions matching iOS standards
5. WHEN loading states occur THEN the system SHALL show appropriate loading indicators
