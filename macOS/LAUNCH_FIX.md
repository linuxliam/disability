# App Launch Fix

## Problem
The app builds successfully but crashes on launch with:
```
*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', 
reason: 'bundleProxyForCurrentProcess is nil'
```

## Root Cause
1. **NotificationManager** was accessing `UNUserNotificationCenter.current()` during initialization
2. This requires a proper macOS app bundle, which doesn't exist when running as a Swift Package executable
3. The initialization happened in `init()` which runs before the app is fully ready

## Fixes Applied

### 1. NotificationManager - Deferred Initialization
- Changed from immediate initialization to lazy initialization
- Added `initialize()` method that's called when the app is ready
- Added check to skip initialization when running as executable (not app bundle)

### 2. DataManager - Deferred Model Container Setup
- Changed from Task in init() to lazy initialization
- Added `ensureModelContainer()` method
- Model container is created on first access

## How to Run the App

### Option 1: As Xcode Project (Recommended)
The app needs to run as a proper macOS app bundle, not as a Swift Package executable.

1. **Create Xcode Project:**
   - Open Xcode
   - Create new macOS App project
   - Add all Swift files to the project
   - Set Bundle Identifier in project settings
   - Build and run from Xcode

2. **Why this is needed:**
   - SwiftUI macOS apps require app bundle structure
   - App bundles provide proper Info.plist and entitlements
   - System APIs (notifications, file dialogs) require app bundle context

### Option 2: Build App Bundle from Swift Package
If you want to use Swift Package Manager, you need to create an app bundle wrapper.

## Testing the Fix

After the fixes:
1. The app should no longer crash on launch
2. NotificationManager will initialize safely when the app is ready
3. DataManager will create the model container on first use

## Additional Notes

- The app checks if it's running as an executable vs app bundle
- When running as executable, certain features (notifications, bundle resources) are gracefully skipped
- For full functionality, run as a proper macOS app bundle from Xcode

