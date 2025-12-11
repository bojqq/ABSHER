# Implementation Plan

- [x] 1. Project setup and folder structure
  - [x] 1.1 Create folder structure
    - Create folders: Models, Views, ViewModels, Services, Components, Extensions
    - Organize for clean MVVM architecture
    - _Requirements: All requirements depend on proper structure_
  
  - [x] 1.2 Create color and style extensions
    - Create Color+Absher extension with all Absher colors (background, card, green, mint, orange, purple)
    - Create Font+Absher extension with Arabic typography styles
    - Create ViewModifier extensions for card styles and button styles
    - _Requirements: 8.1, 8.2, 8.4_

- [x] 2. Data models
  - [x] 2.1 Create UserProfile model
    - Implement UserProfile struct with name, idNumber, profileImage
    - Add static mock property with Arabic name
    - _Requirements: 2.3_
  
  - [x] 2.2 Create DigitalDocument model
    - Implement DigitalDocument struct with id, type, title, status, color
    - Create DocumentType enum (nationalID, passport, license)
    - Create DocumentStatus enum (valid, expiringSoon, expired)
    - Add static mock array with هوية مواطن, جواز السفر, رخصة
    - _Requirements: 4.3, 4.4, 4.5_
  
  - [x] 2.3 Create ProactiveAlert model
    - Implement ProactiveAlert struct with icon, title, serviceType, daysRemaining, message, actionText
    - Add static mock property with Arabic text for license renewal alert
    - _Requirements: 3.2, 3.3, 3.4, 3.5_
  
  - [x] 2.4 Create ServiceDetails model
    - Implement ServiceDetails struct with serviceTitle, beneficiaryStatus, fees, paymentMethod, requirementsStatus, medicalCheckStatus, timeSavings
    - Add static mock property with all Arabic text
    - _Requirements: 6.2, 6.3, 6.4, 6.5, 6.6_
  
  - [x] 2.5 Write property test for alert content completeness
    - **Property 8: Alert card contains required information**
    - **Validates: Requirements 3.2, 3.3, 3.4, 3.5, 3.6**
  
  - [x] 2.6 Write property test for service details completeness
    - **Property 9: Review screen contains all service details**
    - **Validates: Requirements 6.3, 6.4, 6.5, 6.6**

- [x] 3. Mock data service
  - [x] 3.1 Create MockDataService
    - Implement singleton MockDataService class
    - Expose userProfile, documents, proactiveAlert, serviceDetails properties
    - Ensure all data uses Arabic text
    - _Requirements: 2.3, 3.1, 4.1, 6.2_

- [x] 4. App view model and navigation
  - [x] 4.1 Create AppViewModel
    - Implement AppViewModel as ObservableObject
    - Add @Published currentScreen property with Screen enum (login, loading, home, review, confirmation)
    - Add @Published isLoading property
    - _Requirements: 1.8, 3.7, 6.8, 9.1_
  
  - [x] 4.2 Implement navigation methods
    - Create login() method - sets loading, delays 1.5s, navigates to home
    - Create navigateToReview() method - navigates to review screen
    - Create approveService() method - sets loading, delays 0.5s, navigates to confirmation
    - Create resetDemo() method - returns to login screen
    - _Requirements: 1.8, 3.7, 6.8, 9.2_
  
  - [x] 4.3 Write property test for login navigation
    - **Property 1: Login triggers navigation to home**
    - **Validates: Requirements 1.8**
  
  - [x] 4.4 Write property test for alert navigation
    - **Property 2: Alert card tap triggers review navigation**
    - **Validates: Requirements 3.7, 6.1**
  
  - [x] 4.5 Write property test for approve navigation
    - **Property 3: Approve button triggers confirmation navigation**
    - **Validates: Requirements 6.8**
  
  - [x] 4.6 Write property test for reset
    - **Property 4: Reset returns to login**
    - **Validates: Requirements 9.1, 9.2**

- [x] 5. Login screen
  - [x] 5.1 Create LoginView
    - Design login screen with dark background (#1C1C1E)
    - Add "الرجوع" back button in top right
    - Add Absher logo with Saudi emblem (use SF Symbols or asset)
    - Add "تسجيل الدخول إلى أبشر" title
    - _Requirements: 1.1, 1.2, 1.3_
  
  - [x] 5.2 Add login form fields
    - Create username field with label "اسم المستخدم أو رقم الهوية"
    - Create password field with label "كلمة المرور" and "أدخل كلمة المرور" placeholder
    - Add "عدم تسجيل الخروج" checkbox with checkmark
    - Style fields with dark card background and rounded corners
    - _Requirements: 1.4, 1.5, 1.6_
  
  - [x] 5.3 Add login button and actions
    - Create "تسجيل الدخول" button with mint green background
    - Add "نسيت كلمة المرور" link below
    - Connect button to viewModel.login()
    - _Requirements: 1.7, 1.8_

- [x] 6. Loading screen
  - [x] 6.1 Create LoadingView
    - Design loading screen with dark background
    - Add Absher logo at top
    - Add "خدمات متوفرة على مدار الساعة طوال الأسبوع" text
    - Add loading indicator with "جار التحميل..." text
    - _Requirements: 1.8_

- [x] 7. Home screen
  - [x] 7.1 Create HomeView structure
    - Design home screen with dark background
    - Create ScrollView for content
    - Apply RTL layout direction
    - _Requirements: 2.1, 8.3_
  
  - [x] 7.2 Create TopNavigationBar component
    - Add notification bell icon (left side in RTL)
    - Add settings gear icon
    - Add Absher logo and "أبشر" text (right side in RTL)
    - Style with green accent for icons
    - _Requirements: 2.2_
  
  - [x] 7.3 Create UserProfileCard component
    - Design card with dark background and rounded corners
    - Add avatar placeholder
    - Add user name "محمد عبدالله" (or mock name)
    - Add masked ID number "رقم الهوية: ****"
    - Add navigation chevron
    - _Requirements: 2.3_
  
  - [x] 7.4 Create ProactiveAlertCard component
    - Design prominent card with orange gradient/border
    - Add 🔔 notification icon
    - Add "تنبيه استباقي" title with orange accent
    - Add message about license renewal in 45 days
    - Add "اضغط للموافقة والدفع الآن" call-to-action
    - Add tap gesture to trigger navigation
    - Position between profile card and documents section
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7_
  
  - [x] 7.5 Write property test for alert card position
    - **Property 5: Alert card positioned correctly**
    - **Validates: Requirements 3.1**
  
  - [x] 7.6 Create DigitalDocumentsSection component
    - Add "وثائقي الرقمية" section header with "عرض الكل" link
    - Create horizontal ScrollView for document cards
    - Create DocumentCard component with icon, title, status
    - Add "هوية مواطن" card (green)
    - Add "جواز السفر" card (purple)
    - Add "رخصة" card with "انتهت" expired status
    - Add info text about viewing all documents
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6_
  
  - [x] 7.7 Create QuickAccessSection component
    - Add "الوصول السريع" section header
    - Create "مركباتي" card with car icon and description
    - Create grid with "أبشر سفر" and "خدمات التوثيق" cards
    - _Requirements: 5.1, 5.2, 5.3, 5.4_
  
  - [x] 7.8 Create BottomTabBar component
    - Create tab bar with 5 tabs
    - Add icons and labels: الرئيسية, خدماتي, عائلتي, عمالي, خدمات أخرى
    - Highlight الرئيسية as active (green)
    - Style inactive tabs as gray
    - _Requirements: 2.7_

- [x] 8. Review screen
  - [x] 8.1 Create ReviewView structure
    - Design review screen with dark background
    - Add navigation bar with back button and title
    - Create ScrollView for content
    - _Requirements: 6.1, 6.2_
  
  - [x] 8.2 Create service detail sections
    - Create section card for beneficiary status with checkmark icon
    - Display "خالٍ من المخالفات" status
    - Create section card for fees with amount and Sadad info
    - Create section card for requirements status
    - Create section card for medical check status
    - _Requirements: 6.3, 6.4, 6.5, 6.6_
  
  - [x] 8.3 Create approve button
    - Design prominent "موافقة والدفع" button
    - Style with green background, full width
    - Add tap handler to trigger approveService()
    - Show loading indicator when processing
    - _Requirements: 6.7, 6.8_

- [ ] 9. Confirmation screen
  - [x] 9.1 Create ConfirmationView
    - Design full-screen success layout with dark background
    - Add large green checkmark icon
    - Display "✅ تم تجديد رخصتك بنجاح" message
    - _Requirements: 7.1, 7.2_
  
  - [x] 9.2 Add time savings highlight
    - Display "لقد وفرت 25 دقيقة" prominently with large font
    - Add subtitle "من البحث وإدخال البيانات والتنقل بين الخدمات"
    - Display "التفاصيل في بريدك" message
    - _Requirements: 7.3, 7.4, 7.5_
  
  - [x] 9.3 Add reset button
    - Create "العودة للرئيسية" button
    - Connect to viewModel.resetDemo()
    - _Requirements: 7.6, 9.1_
  
  - [x] 9.4 Write property test for time savings display
    - **Property 10: Confirmation shows time savings**
    - **Validates: Requirements 7.3, 7.4**

- [x] 10. App integration
  - [x] 10.1 Update ABSHERApp.swift
    - Create @StateObject for AppViewModel
    - Set up root view with screen switching
    - Apply RTL environment
    - Apply dark color scheme
    - _Requirements: 8.1, 8.3_
  
  - [x] 10.2 Implement screen routing
    - Add switch statement for currentScreen
    - Route to LoginView, LoadingView, HomeView, ReviewView, ConfirmationView
    - Pass viewModel to each view
    - Add smooth transitions with animation
    - _Requirements: 9.4_
  
  - [x] 10.3 Write property test for dark theme
    - **Property 6: Dark theme applied**
    - **Validates: Requirements 2.1, 8.1**
  
  - [x] 10.4 Write property test for RTL layout
    - **Property 7: Right-to-left layout**
    - **Validates: Requirements 8.3**

- [x] 11. Polish and refinements
  - [x] 11.1 Add smooth transitions
    - Configure SwiftUI transitions between screens
    - Add withAnimation for state changes
    - Ensure transitions feel smooth
    - _Requirements: 9.4_
  
  - [x] 11.2 Verify Arabic text rendering
    - Test all Arabic text displays correctly
    - Verify RTL layout on all screens
    - Check Arabic numerals where needed
    - _Requirements: 8.3, 8.6_
  
  - [x] 11.3 Test complete flow
    - Run through: Login → Loading → Home → Review → Confirmation → Reset
    - Verify all screens match Absher design
    - Test multiple demo cycles
    - _Requirements: 9.3_
  
  - [x] 11.4 Write property test for flow consistency
    - **Property 11: Demo flow is repeatable**
    - **Validates: Requirements 9.3**
  
  - [x] 11.5 Write property test for smooth transitions
    - **Property 12: Transitions are smooth**
    - **Validates: Requirements 9.4**

- [x] 12. Final checkpoint
  - Ensure all tests pass, ask the user if questions arise.
