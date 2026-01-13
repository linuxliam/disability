# Fix: FavoritesView Cannot Find in Scope

## Problem
Error: `Cannot find 'FavoritesView' in scope` at `AppTheme.swift:140:34`

## Root Cause
The `FavoritesView.swift` file exists but may not be included in the Xcode project build target, preventing it from being compiled and available to other files.

## Solution

### Option 1: Add File to Xcode Project (Recommended)
1. Open `DisabilityAdvocacy.xcodeproj` in Xcode
2. Right-click on `Shared/Views/Main/` folder
3. Select "Add Files to DisabilityAdvocacy..."
4. Navigate to `Shared/Views/Main/FavoritesView.swift`
5. Ensure "Copy items if needed" is unchecked
6. Ensure "Add to targets: DisabilityAdvocacy-iOS" and "DisabilityAdvocacy-macOS" are checked
7. Click "Add"

### Option 2: Verify File is in Target
1. Select `FavoritesView.swift` in Xcode
2. Open File Inspector (right panel)
3. Under "Target Membership", ensure both iOS and macOS targets are checked

### Option 3: Clean and Rebuild
1. Product → Clean Build Folder (Shift+Cmd+K)
2. Product → Build (Cmd+B)

## Verification
After adding the file:
- Build should succeed
- `FavoritesView` should be accessible in `AppTheme.swift`
- Navigation to favorites should work

