# Design Document

## Overview

The ABSHER Proactive Assistant Prototype replicates the authentic Absher app interface with a dark theme design and integrates the PSA (Proactive Services API) feature as a "Sticky Alert Card" on the home screen. The prototype includes a mock login flow, the main home screen with all sections matching the real app, and the proactive service flow (Alert → Review → Confirmation). The architecture uses SwiftUI with MVVM pattern for clean separation of concerns.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        iOS App Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   SwiftUI    │  │  ViewModels  │  │  Mock Data   │      │
│  │    Views     │◄─┤   (MVVM)     │◄─┤   Service    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### Screen Flow

```
┌──────────────┐
│  LoginView   │
│  (Mock Auth) │
└──────┬───────┘
       │ Login
       ▼
┌──────────────┐
│  LoadingView │
│  (جار التحميل)│
└──────┬───────┘
       │ 1.5s delay
       ▼
┌──────────────┐
│   HomeView   │
│ (Alert Card) │
└──────┬───────┘
       │ Tap Alert
       ▼
┌──────────────┐
│  ReviewView  │
│  (Details)   │
└──────┬───────┘
       │ Approve
       ▼
┌──────────────┐
│Confirmation  │
│  (Success)   │
└──────┬───────┘
       │ Reset
       ▼
┌──────────────┐
│  LoginView   │
└──────────────┘
```

## Components and Interfaces

### 1. Data Models

**UserProfile**
```swift
struct UserProfile {
    let name: String // "محمد عبدالله"
    let idNumber: String // "١١٢٩٣٤٥١٩٣"
    let profileImage: String? // Optional avatar
}
```

**DigitalDocument**
```swift
struct DigitalDocument: Identifiable {
    let id: UUID
    let type: DocumentType
    let title: String
    let status: DocumentStatus
    let color: Color
    
    enum DocumentType {
        case nationalID, passport, license
    }
    
    enum DocumentStatus {
        case valid, expiringSoon, expired
    }
}
```

**ProactiveAlert**
```swift
struct ProactiveAlert {
    let icon: String // "🔔"
    let title: String // "تنبيه استباقي"
    let serviceType: String // "تجديد رخصة القيادة"
    let daysRemaining: Int // 45
    let message: String
    let actionText: String // "اضغط للموافقة والدفع الآن"
}
```

**ServiceDetails**
```swift
struct ServiceDetails {
    let serviceTitle: String // "تجديد رخصة القيادة"
    let beneficiaryStatus: String // "خالٍ من المخالفات"
    let fees: String // "٢٠٠ ريال"
    let paymentMethod: String // "جاهز للدفع عبر سداد"
    let requirementsStatus: String // "جميع المتطلبات جاهزة وموثقة"
    let medicalCheckStatus: String // "الفحص الطبي تم التحقق منه"
    let timeSavings: Int // 25 minutes
}
```

### 2. View Models

**AppViewModel**
```swift
class AppViewModel: ObservableObject {
    @Published var currentScreen: Screen = .login
    @Published var isLoading: Bool = false
    
    enum Screen {
        case login
        case loading
        case home
        case review
        case confirmation
    }
    
    func login()
    func navigateToReview()
    func approveService()
    func resetDemo()
}
```

### 3. View Components

**LoginView**
- Absher logo with Saudi emblem
- Username/ID text field
- Password secure field
- "عدم تسجيل الخروج" checkbox
- "تسجيل الدخول" button
- "نسيت كلمة المرور" link

**LoadingView**
- Absher logo
- "خدمات متوفرة على مدار الساعة طوال الأسبوع" text
- Loading indicator with "جار التحميل..."

**HomeView**
- TopNavigationBar (bell, settings, logo)
- UserProfileCard
- **ProactiveAlertCard** ← NEW PSA FEATURE
- DigitalDocumentsSection
- QuickAccessSection
- BottomTabBar

**ProactiveAlertCard** (NEW)
```swift
struct ProactiveAlertCard: View {
    let alert: ProactiveAlert
    let onTap: () -> Void
    
    // Gradient background or accent border
    // 🔔 icon with "تنبيه استباقي" title
    // Service message about license renewal
    // Call-to-action text
    // Tap gesture for navigation
}
```

**ReviewView**
- Navigation bar with back button
- Service title card
- Status sections (beneficiary, fees, requirements, medical)
- "موافقة والدفع" button

**ConfirmationView**
- Success checkmark icon
- "تم تجديد رخصتك بنجاح" message
- Time savings highlight "لقد وفرت 25 دقيقة"
- "العودة للرئيسية" button

## Visual Design System

### Color Palette (Based on Screenshots)

**Background Colors**
```swift
extension Color {
    static let absherBackground = Color(hex: "#1C1C1E") // Main dark background
    static let absherCardBackground = Color(hex: "#2C2C2E") // Card backgrounds
    static let absherCardBorder = Color(hex: "#3C3C3E") // Subtle borders
}
```

**Accent Colors**
```swift
extension Color {
    static let absherGreen = Color(hex: "#4CAF50") // Primary green
    static let absherLightGreen = Color(hex: "#8BC34A") // Light green accents
    static let absherMint = Color(hex: "#A8E6CF") // Mint for buttons
    static let absherPurple = Color(hex: "#7C4DFF") // Passport card
    static let absherOrange = Color(hex: "#FF9500") // Alert/urgency
}
```

**Text Colors**
```swift
extension Color {
    static let absherTextPrimary = Color.white
    static let absherTextSecondary = Color(hex: "#8E8E93")
    static let absherTextMuted = Color(hex: "#636366")
}
```

### Typography

**Arabic Font Stack**
- Primary: SF Arabic (system)
- Fallback: Arabic system fonts

**Text Styles**
```swift
extension Font {
    static let absherTitle = Font.system(size: 24, weight: .bold)
    static let absherHeadline = Font.system(size: 18, weight: .semibold)
    static let absherBody = Font.system(size: 16, weight: .regular)
    static let absherCaption = Font.system(size: 14, weight: .regular)
    static let absherSmall = Font.system(size: 12, weight: .regular)
}
```

### Component Styles

**Cards**
```swift
struct AbsherCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.absherCardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.absherCardBorder, lineWidth: 1)
            )
    }
}
```

**Buttons**
```swift
struct AbsherPrimaryButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.absherHeadline)
            .foregroundColor(.absherBackground)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.absherMint)
            .cornerRadius(12)
    }
}
```

**Alert Card (Special Styling)**
```swift
struct ProactiveAlertCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [Color.absherOrange.opacity(0.3), Color.absherCardBackground],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.absherOrange, lineWidth: 2)
            )
            .shadow(color: Color.absherOrange.opacity(0.3), radius: 8, y: 4)
    }
}
```

### Layout Specifications

**Screen Padding**
- Horizontal: 16pt
- Top safe area: respected
- Bottom: tab bar height + safe area

**Card Spacing**
- Between sections: 24pt
- Between cards in section: 12pt
- Card internal padding: 16pt

**Document Cards (Horizontal Scroll)**
- Card width: 100pt
- Card height: 120pt
- Spacing: 12pt
- Corner radius: 12pt

**Bottom Tab Bar**
- Height: 83pt (including safe area)
- 5 tabs: الرئيسية, خدماتي, عائلتي, عمالي, خدمات أخرى
- Active tab: green icon and text
- Inactive: gray icon and text

## Home Screen Layout

```
┌─────────────────────────────────────────┐
│  🔔  ⚙️           [Logo]    أبشر        │ ← Top Nav
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐    │
│  │  [Avatar]  محمد عبدالله         │    │ ← Profile Card
│  │            رقم الهوية: ****     │    │
│  └─────────────────────────────────┘    │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐    │
│  │ 🔔 تنبيه استباقي                │    │ ← PROACTIVE ALERT
│  │ رخصة قيادتك على وشك الانتهاء    │    │    (NEW FEATURE)
│  │ خلال 45 يومًا                   │    │
│  │ اضغط للموافقة والدفع الآن ←     │    │
│  └─────────────────────────────────┘    │
├─────────────────────────────────────────┤
│  وثائقي الرقمية              عرض الكل  │ ← Section Header
│  ┌────┐ ┌────┐ ┌────┐                  │
│  │هوية│ │جواز│ │رخصة│  →               │ ← Document Cards
│  │مواطن│ │السفر│ │انتهت│                │    (Horizontal Scroll)
│  └────┘ └────┘ └────┘                  │
├─────────────────────────────────────────┤
│  الوصول السريع                          │ ← Section Header
│  ┌─────────────────────────────────┐    │
│  │ 🚗 مركباتي                      │    │ ← Quick Access Card
│  │ عرض التفاصيل، تجديد الوثائق...  │    │
│  └─────────────────────────────────┘    │
├─────────────────────────────────────────┤
│  ┌────────┐  ┌────────┐                │
│  │أبشر سفر│  │خدمات   │                │ ← Service Cards
│  │        │  │التوثيق │                │
│  └────────┘  └────────┘                │
├─────────────────────────────────────────┤
│ 🏠    📋    👨‍👩‍👧    👷    ⋯           │ ← Bottom Tab Bar
│الرئيسية خدماتي عائلتي عمالي خدمات أخرى │
└─────────────────────────────────────────┘
```



## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Navigation Properties

**Property 1: Login triggers navigation to home**
*For any* login button tap, the app should show loading indicator and then navigate to the home screen.
**Validates: Requirements 1.8**

**Property 2: Alert card tap triggers review navigation**
*For any* tap on the proactive alert card, the app should navigate to the review screen.
**Validates: Requirements 3.7, 6.1**

**Property 3: Approve button triggers confirmation navigation**
*For any* tap on the approve button, the app should show loading and navigate to the confirmation screen.
**Validates: Requirements 6.8**

**Property 4: Reset returns to login**
*For any* reset action from confirmation, the app should return to the login screen.
**Validates: Requirements 9.1, 9.2**

### Layout Properties

**Property 5: Alert card positioned correctly**
*For any* home screen display, the proactive alert card should appear between the profile card and the digital documents section.
**Validates: Requirements 3.1**

**Property 6: Dark theme applied**
*For any* displayed screen, the background should use the dark theme color (#1C1C1E or similar).
**Validates: Requirements 2.1, 8.1**

**Property 7: Right-to-left layout**
*For any* displayed screen, the layout should use right-to-left direction for Arabic content.
**Validates: Requirements 8.3**

### Content Properties

**Property 8: Alert card contains required information**
*For any* displayed alert card, it should contain the notification icon, title, service message, and call-to-action text.
**Validates: Requirements 3.2, 3.3, 3.4, 3.5, 3.6**

**Property 9: Review screen contains all service details**
*For any* displayed review screen, it should contain beneficiary status, fees, requirements status, and medical check status.
**Validates: Requirements 6.3, 6.4, 6.5, 6.6**

**Property 10: Confirmation shows time savings**
*For any* displayed confirmation screen, it should prominently display the time savings (25 minutes).
**Validates: Requirements 7.3, 7.4**

### Flow Consistency Properties

**Property 11: Demo flow is repeatable**
*For any* complete demo cycle (login → home → review → confirmation → reset), the flow should behave consistently each time.
**Validates: Requirements 9.3**

**Property 12: Transitions are smooth**
*For any* navigation between screens, transitions should complete smoothly without visual glitches.
**Validates: Requirements 9.4**

## Error Handling

Since this is a prototype with mock data and no backend:

**Navigation Errors**
- If navigation fails, remain on current screen
- Log error for debugging

**UI Errors**
- If layout issues occur, fall back to default SwiftUI behavior
- Ensure text is always readable

**Loading States**
- Show loading indicator during transitions
- Timeout after 3 seconds if stuck

## Testing Strategy

### Unit Testing

**Model Tests**
- UserProfile initialization
- DigitalDocument creation with all types
- ProactiveAlert formatting
- ServiceDetails completeness

**ViewModel Tests**
- Navigation state transitions
- Screen flow logic
- Reset functionality

### Property-Based Testing

Using SwiftCheck library with 100 iterations per test.

**Property Test Coverage**
- Navigation properties (Properties 1-4)
- Layout properties (Properties 5-7)
- Content properties (Properties 8-10)
- Flow properties (Properties 11-12)

### UI Testing

**Critical Flow Test**
1. Launch app → See login screen
2. Tap login → See loading → See home
3. Verify alert card is visible and positioned correctly
4. Tap alert → See review screen
5. Verify all service details are displayed
6. Tap approve → See loading → See confirmation
7. Verify time savings is displayed
8. Tap reset → Return to login
9. Repeat flow to verify consistency

### Manual Testing Checklist

- [ ] Login screen matches Absher design
- [ ] Loading screen shows correctly
- [ ] Home screen has all sections
- [ ] Alert card is prominent and positioned correctly
- [ ] Alert card is tappable
- [ ] Review screen shows all details
- [ ] Approve button works
- [ ] Confirmation shows time savings
- [ ] Reset returns to login
- [ ] All text is in Arabic
- [ ] RTL layout works correctly
- [ ] Dark theme is consistent
- [ ] Transitions are smooth
- [ ] Demo can run multiple times

## Implementation Notes

### SwiftUI Best Practices

**State Management**
- Use @StateObject for AppViewModel at app root
- Use @Published for screen state
- Minimize state to essential navigation

**Navigation**
- Use enum-based navigation with switch statement
- Avoid NavigationStack for simpler control
- Use withAnimation for smooth transitions

**Performance**
- Keep view hierarchy shallow
- Use lazy loading for document cards
- Avoid unnecessary re-renders

### Arabic Text Handling

**RTL Layout**
```swift
.environment(\.layoutDirection, .rightToLeft)
```

**Arabic Numerals**
```swift
let formatter = NumberFormatter()
formatter.locale = Locale(identifier: "ar_SA")
formatter.numberStyle = .decimal
```

### Mock Data Strategy

**Singleton Service**
```swift
class MockDataService {
    static let shared = MockDataService()
    
    let userProfile = UserProfile(...)
    let documents = [DigitalDocument(...), ...]
    let proactiveAlert = ProactiveAlert(...)
    let serviceDetails = ServiceDetails(...)
}
```

### Demo Presentation Tips

**Before Demo**
- Test on actual device
- Ensure good lighting
- Practice the flow
- Have backup device ready

**During Demo**
- Explain each screen
- Highlight the alert card
- Emphasize "one tap" approval
- Show time savings prominently

**Key Messages**
- "45 days advance notice"
- "Everything pre-filled"
- "One tap to approve"
- "25 minutes saved"
- "96% time reduction"
