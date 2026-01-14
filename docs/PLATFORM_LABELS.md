# Platform Labels Guide

## Overview

This project uses platform-specific labels to categorize issues and pull requests based on which platforms they affect. This helps with:
- **Organization**: Quickly identify platform-specific work
- **Planning**: Allocate resources for platform-specific features
- **Testing**: Ensure proper testing on the correct platforms
- **Documentation**: Track platform-specific improvements

## Available Labels

### `platform:ios`
**Color:** Green (#0E8A16)  
**Description:** iOS-specific feature or issue

**Use when:**
- Feature only works on iOS
- Issue only affects iOS
- Uses iOS-specific APIs (UIKit, iOS-specific frameworks)
- Requires iOS-specific testing
- Examples: Haptic feedback, iOS navigation patterns, TestFlight setup

### `platform:macos`
**Color:** Blue (#1D76DB)  
**Description:** macOS-specific feature or issue

**Use when:**
- Feature only works on macOS
- Issue only affects macOS
- Uses macOS-specific APIs (AppKit, NSWorkspace, NSOpenPanel, etc.)
- Requires macOS-specific testing
- Examples: File operations, share sheet, window management, menu bar

### `platform:shared`
**Color:** Purple (#5319E7)  
**Description:** Shared feature across iOS and macOS

**Use when:**
- Feature works on both platforms
- Issue affects both platforms
- Uses shared SwiftUI code
- Requires testing on both platforms
- Examples: Core data models, business logic, shared UI components

## Usage Guidelines

### When Creating Issues

1. **Identify the platform scope:**
   - If it's iOS-only → use `platform:ios`
   - If it's macOS-only → use `platform:macos`
   - If it works on both → use `platform:shared`

2. **Multiple platforms:**
   - You can add multiple platform labels if a feature has platform-specific implementations
   - Example: A feature with shared core but platform-specific UI would have both `platform:shared` and `platform:ios`/`platform:macos`

3. **Conditional compilation:**
   - If code uses `#if os(iOS)` or `#if os(macOS)`, it's likely platform-specific
   - Tag accordingly

### When Creating Pull Requests

1. **Tag based on changes:**
   - If PR only touches iOS-specific code → `platform:ios`
   - If PR only touches macOS-specific code → `platform:macos`
   - If PR touches shared code → `platform:shared`

2. **Mixed PRs:**
   - If a PR touches both platform-specific and shared code, use multiple labels
   - Example: `platform:shared` + `platform:ios` + `platform:macos`

## Platform-Specific Code Locations

### iOS-Specific
- `iOS/` directory
- `Shared/Managers/HapticManager.swift` (iOS-only)
- UIKit imports and usage
- iOS-specific navigation patterns
- TestFlight configuration

### macOS-Specific
- `macOS/` directory
- `macOS/AdvocacyApp.entitlements`
- AppKit imports and usage
- `NSOpenPanel`, `NSSavePanel`, `NSSharingService`
- Window management
- Menu bar integration

### Shared
- `Shared/` directory (most files)
- SwiftUI views (unless platform-specific)
- Core data models
- Business logic
- ViewModels
- Most utilities

## Examples

### Example 1: iOS Haptic Feedback
**Issue:** #25 - Implement iOS Haptic Feedback  
**Labels:** `platform:ios`, `feature`, `enhancement`  
**Reason:** Haptic feedback is iOS-only (uses UIKit APIs)

### Example 2: macOS File Operations
**Issue:** #26 - Implement macOS File Operations  
**Labels:** `platform:macos`, `feature`  
**Reason:** Uses `NSOpenPanel` and `NSSavePanel` (macOS-only APIs)

### Example 3: Unified Search
**Issue:** #22 - Implement Unified Search Functionality  
**Labels:** `platform:shared`, `feature`  
**Reason:** Search works on both iOS and macOS using shared SwiftUI code

## Finding Platform-Specific Issues

### Using GitHub CLI
```bash
# List all iOS-specific issues
gh issue list --label "platform:ios"

# List all macOS-specific issues
gh issue list --label "platform:macos"

# List all shared issues
gh issue list --label "platform:shared"
```

### Using GitHub Web Interface
1. Go to Issues
2. Click "Labels" filter
3. Select `platform:ios`, `platform:macos`, or `platform:shared`

## Best Practices

1. **Always tag platform-specific issues** - Makes it easier to find and prioritize
2. **Update labels when scope changes** - If an issue expands to multiple platforms, update labels
3. **Use in combination with other labels** - Platform labels work well with `feature`, `bug`, `enhancement`, etc.
4. **Document platform differences** - In issue descriptions, note why something is platform-specific
5. **Review before closing** - Ensure platform-specific issues are tested on the correct platform

## Related Documentation

- [Platform Code Audit](PLATFORM_AUDIT.md) - Detailed audit of platform-specific code
- [macOS Improvements](macOS/IMPROVEMENTS.md) - macOS-specific features and improvements
- [Build Documentation](BUILD.md) - Platform-specific build instructions
