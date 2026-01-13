# Build Documentation

## Overview
This document provides instructions for building the Disability Advocacy app for both iOS and macOS platforms.

## Prerequisites

- Xcode 15.0 or later
- macOS 14.0 or later
- Swift 5.9 or later
- Command Line Tools installed

## Quick Start

### Build All Platforms
```bash
./scripts/build-all-platforms.sh
```

### Build iOS Only
```bash
xcodebuild -project DisabilityAdvocacy.xcodeproj \
  -target "DisabilityAdvocacy-iOS" \
  -sdk iphonesimulator \
  -configuration Debug \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build
```

### Build macOS Only
```bash
xcodebuild -project DisabilityAdvocacy.xcodeproj \
  -target "DisabilityAdvocacy-macOS" \
  -sdk macosx \
  -configuration Debug \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## Build Configurations

### Debug Configuration
- Optimizations disabled (`-Onone`)
- Debug symbols included
- Assertions enabled
- Used for development and testing

### Release Configuration
- Full optimizations (`-Owholemodule`)
- Debug symbols stripped
- Assertions disabled
- Used for production builds

## Platform-Specific Considerations

### iOS
- **Deployment Target:** iOS 18.0
- **Supported Platforms:** iPhone, iPad (iOS Simulator)
- **Architectures:** arm64
- **SDK:** iphonesimulator (for simulator builds)

### macOS
- **Deployment Target:** macOS 15.0
- **Supported Platforms:** macOS
- **Architectures:** arm64, x86_64
- **SDK:** macosx

## Build Scripts

### `scripts/build-all-platforms.sh`
Builds both iOS and macOS targets sequentially.

**Usage:**
```bash
./scripts/build-all-platforms.sh [Debug|Release]
```

**Features:**
- Builds both platforms
- Generates build reports
- Validates build success
- Exits with error code if any build fails

### `scripts/validate-build.sh`
Validates that all targets compile successfully.

**Usage:**
```bash
./scripts/validate-build.sh
```

**Checks:**
- All targets compile
- Info.plist files exist
- No compilation errors
- Reports warnings

### `scripts/build-status.sh`
Generates build status report with timing information.

**Usage:**
```bash
./scripts/build-status.sh
```

## Troubleshooting

### Common Build Issues

#### Code Signing Errors
**Problem:** `CodeSign failed with a nonzero exit code`

**Solution:** For simulator builds, disable code signing:
```bash
CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
```

#### Missing SDK
**Problem:** `SDK 'iphonesimulator' cannot be located`

**Solution:** Install the iOS Simulator SDK via Xcode:
```bash
xcodebuild -downloadPlatform iOS
```

#### Build Directory Issues
**Problem:** Build artifacts in wrong location

**Solution:** Clean build directory:
```bash
rm -rf build DerivedData
xcodebuild clean
```

#### Platform-Specific Code Errors
**Problem:** Code that works on one platform fails on another

**Solution:** Use conditional compilation:
```swift
#if os(iOS)
    // iOS-specific code
#elseif os(macOS)
    // macOS-specific code
#endif
```

### Build Performance

#### Faster Builds
- Use incremental builds (don't clean unless necessary)
- Build only the target you need
- Use `-j` flag for parallel compilation (default in Xcode)

#### Build Time Optimization
- Disable code signing for simulator builds
- Use Debug configuration for development
- Only build for active architecture (`ONLY_ACTIVE_ARCH = YES`)

## Build Output Locations

### iOS
- **Simulator:** `build/Debug-iphonesimulator/DisabilityAdvocacy-iOS.app`
- **Device:** `build/Debug-iphoneos/DisabilityAdvocacy-iOS.app`

### macOS
- **App Bundle:** `build/Debug/DisabilityAdvocacy-macOS.app`

## Xcode Build Settings

Build settings are configured in:
- `Config/Debug.xcconfig` - Debug configuration
- `Config/Release.xcconfig` - Release configuration
- `Config/iOS.xcconfig` - iOS platform settings
- `Config/macOS.xcconfig` - macOS platform settings

## Continuous Integration

Builds are automated via GitHub Actions. See [CI_CD.md](CI_CD.md) for details.

## Additional Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Xcode Build System Guide](https://developer.apple.com/documentation/xcode/build-settings-reference)
