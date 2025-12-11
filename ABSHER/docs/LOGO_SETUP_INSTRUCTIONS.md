# Logo Setup Instructions

## Image Files to Add

You need to add two PNG image files to the Xcode asset catalog:

### 1. Absher Logo (absher.png)
- **Location**: `ABSHER/Assets.xcassets/AbsherLogo.imageset/absher.png`
- **Usage**: Main Absher logo used in:
  - Home screen top navigation bar
  - Loading screen
  - All screens after login (except login screen itself)
- **Recommended size**: 300x100 pixels (or similar aspect ratio)

### 2. Ministry Logo (ministry.png)
- **Location**: `ABSHER/Assets.xcassets/MinistryLogo.imageset/ministry.png`
- **Usage**: Absher logo with Saudi Ministry emblem used in:
  - Login screen only
- **Recommended size**: 300x300 pixels (or similar square/portrait aspect ratio)

## How to Add the Images

### Option 1: Using Finder
1. Locate your `absher.png` file
2. Copy it to: `ABSHER/Assets.xcassets/AbsherLogo.imageset/absher.png`
3. Locate your `ministry.png` file
4. Copy it to: `ABSHER/Assets.xcassets/MinistryLogo.imageset/ministry.png`

### Option 2: Using Terminal
```bash
# From the project root directory
cp /path/to/your/absher.png ABSHER/Assets.xcassets/AbsherLogo.imageset/absher.png
cp /path/to/your/ministry.png ABSHER/Assets.xcassets/MinistryLogo.imageset/ministry.png
```

### Option 3: Using Xcode
1. Open the project in Xcode
2. In the Project Navigator, expand `ABSHER` → `Assets.xcassets`
3. You should see `AbsherLogo` and `MinistryLogo` entries
4. Click on `AbsherLogo`
5. Drag and drop your `absher.png` file into the 1x slot
6. Click on `MinistryLogo`
7. Drag and drop your `ministry.png` file into the 1x slot

## Verification

After adding the images:
1. Build and run the app
2. Check the login screen - you should see the ministry logo (with emblem)
3. Log in and check the home screen - you should see the absher logo (without emblem) in the top navigation bar
4. The loading screen should also show the absher logo

## Code Changes Made

The following files have been updated to use the new logos:

1. **LoginView.swift** - Uses `MinistryLogo` (ministry.png with emblem)
2. **TopNavigationBar.swift** - Uses `AbsherLogo` (absher.png without emblem)
3. **LoadingView.swift** - Uses `AbsherLogo` (absher.png without emblem)

All other screens (Review, Confirmation) don't display any logos, as per requirements.
