# Platform Code Audit

## Overview
This document provides an audit of platform-specific code and conditional compilation patterns used throughout the codebase.

## Statistics

- **Total files with conditional compilation:** 35
- **iOS-specific blocks:** ~150
- **macOS-specific blocks:** ~56
- **Platform detection utilities:** `PlatformDetection.swift`, `PlatformUI.swift`

## Conditional Compilation Patterns

### Standard Pattern
```swift
#if os(iOS)
    // iOS-specific code
#elseif os(macOS)
    // macOS-specific code
#else
    // Fallback or error
#endif
```

### Common Patterns Found

#### 1. List Styles
**Location:** Multiple view files
**Pattern:**
```swift
#if os(iOS)
.listStyle(.insetGrouped)
#else
.listStyle(.sidebar)
#endif
```

#### 2. Platform-Specific Imports
**Location:** Managers, Utilities
**Pattern:**
```swift
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
```

#### 3. System APIs
**Location:** PlatformUI.swift, SystemSettingsManager.swift
**Pattern:**
```swift
#if os(iOS)
UIApplication.shared.open(url)
#elseif os(macOS)
NSWorkspace.shared.open(url)
#endif
```

## Platform-Specific Code Locations

### iOS-Only Features
- Haptic feedback (`HapticManager.swift`)
- UIKit-specific UI components
- iOS-specific navigation patterns

### macOS-Only Features
- AppKit-specific UI components
- File picker dialogs
- Window management

### Shared Features
- Core data models
- Business logic
- View models
- Most utilities

## Recommendations

### 1. Use PlatformDetection Utility
Replace inline platform checks with `PlatformDetection`:

**Before:**
```swift
#if os(iOS)
let isIOS = true
#else
let isIOS = false
#endif
```

**After:**
```swift
let isIOS = PlatformDetection.isIOS
```

### 2. Centralize Platform-Specific Code
Group platform-specific implementations in:
- `PlatformUI.swift` - UI utilities
- `PlatformDetection.swift` - Detection utilities
- Platform-specific managers when needed

### 3. Document Platform Differences
Add comments explaining why code differs:
```swift
#if os(iOS)
// iOS uses insetGrouped for better visual hierarchy
.listStyle(.insetGrouped)
#else
// macOS uses sidebar for native macOS appearance
.listStyle(.sidebar)
#endif
```

## Validation

Run platform code validation:
```bash
./scripts/validate-platform-code.sh
```

This checks for:
- Missing `#else` blocks
- Unguarded platform-specific imports
- Platform-specific API usage without guards

## Maintenance

### Regular Audits
- Review conditional compilation quarterly
- Update platform detection utilities
- Consolidate duplicate patterns

### Adding New Platform Code
1. Check if pattern already exists
2. Use existing utilities when possible
3. Add to platform detection if reusable
4. Document platform differences
5. Update this audit document
