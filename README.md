# Disability Advocacy App

A comprehensive cross-platform application designed to support disability advocacy, providing resources, community connections, events, and advocacy tools for both iOS and macOS.

[![CI/CD](https://github.com/linuxliam/disability/actions/workflows/ci-build-test-lint.yml/badge.svg)](https://github.com/linuxliam/disability/actions/workflows/ci-build-test-lint.yml)

## 📱 Platforms

- **iOS 18.0+** - Native iOS app with full SwiftUI support
- **macOS 15.0+** - Native macOS app with platform-specific optimizations

## ✨ Features

### 🏠 Home Dashboard
- Overview of resources, events, and community activity
- Quick access to featured content
- Statistics and recent updates
- Personalized recommendations

### 📚 Resource Library
- Comprehensive database of disability-related resources
- Categories: Legal Rights, Education, Employment, Healthcare, Technology, Community Support, Government Services, and Advocacy Organizations
- Advanced search and filter functionality
- Favorite resources for quick access
- Tags for easy discovery
- Native share sheet integration (macOS)

### 👥 Community Forum
- Discussion boards for various topics
- Support groups and resource sharing
- Community-driven content
- Categories: Discussion, Support, Resources, Events, Advocacy, General

### 📅 Events Calendar
- Upcoming workshops, conferences, webinars, rallies, and meetings
- Virtual and in-person event listings
- Accessibility information for each event
- Registration links
- Add to calendar functionality

### 🎯 Advocacy Tools
- Letter template generator
- Accommodation request builder
- Rights knowledge base
- Representative contact finder
- Accessibility complaint forms
- Resource sharing tools

### 📰 News & Updates
- Latest news about disability rights
- Policy updates
- Technology breakthroughs
- Community achievements

### ♿ Accessibility Features
- High contrast mode
- Large text support
- Customizable font sizes
- Reduced motion options
- Screen reader optimization
- Full VoiceOver support
- Keyboard navigation throughout
- Dynamic Type support

## 🏗️ Architecture

The app follows the **MVVM (Model-View-ViewModel)** architecture pattern with Swift 6 concurrency:

- **Models**: Data structures (`Resource`, `Event`, `CommunityPost`, `NewsArticle`, etc.)
- **Views**: SwiftUI views for each section (platform-specific where needed)
- **ViewModels**: Business logic and state management with `@MainActor` isolation
- **Managers**: Data persistence and management (`ResourcesManager`, `EventsManager`, etc.)
- **Utilities**: Shared utilities and helpers

### Swift 6 Concurrency
- Full `@MainActor` isolation for UI components
- Async/await throughout
- Proper concurrency safety with `nonisolated` initializers where needed

## 📁 Project Structure

```
DA/
├── iOS/                          # iOS-specific code
│   ├── AdvocacyApp.swift        # iOS app entry point
│   ├── Views/                   # iOS-specific views
│   ├── Info.plist               # iOS configuration
│   └── DisabilityAdvocacyTests/ # iOS tests
│
├── macOS/                        # macOS-specific code
│   ├── AdvocacyApp.swift        # macOS app entry point
│   ├── Views/                   # macOS-specific views
│   ├── Extensions/              # macOS extensions
│   ├── Managers/                # macOS managers (ShareManager, etc.)
│   ├── Info.plist               # macOS configuration
│   └── README.md                # macOS-specific docs
│
├── Shared/                       # Shared code for both platforms
│   ├── Models/                  # Data models
│   │   ├── Core/               # Core models (Resource, Event, etc.)
│   │   └── UI/                 # UI models (AppState, etc.)
│   ├── Views/                   # Shared SwiftUI views
│   │   ├── Main/               # Main feature views
│   │   ├── Components/         # Reusable components
│   │   ├── Settings/           # Settings views
│   │   └── Navigation/         # Navigation components
│   ├── ViewModels/              # ViewModels
│   ├── Managers/                # Data managers
│   ├── Utilities/               # Utility functions
│   └── Extensions/              # Swift extensions
│
├── Resources/                    # App resources
│   ├── Assets.xcassets/         # Images and assets
│   ├── Events.json              # Event data
│   ├── Resources.json           # Resource data
│   └── Localizable.xcstrings    # Localization strings
│
├── Config/                       # Build configuration files
│   ├── Debug.xcconfig           # Debug configuration
│   ├── Release.xcconfig         # Release configuration
│   ├── iOS.xcconfig             # iOS-specific settings
│   └── macOS.xcconfig           # macOS-specific settings
│
├── scripts/                      # Build and utility scripts
│   ├── validate-build.sh        # Build validation
│   ├── validate-platform-code.sh # Platform code validation
│   └── build-all-platforms.sh   # Universal build script
│
├── docs/                         # Documentation
│   ├── user/                    # User documentation
│   ├── BUILD.md                 # Build instructions
│   ├── CI_CD.md                 # CI/CD documentation
│   └── TESTING.md               # Testing documentation
│
└── .github/workflows/            # GitHub Actions workflows
    └── ci-build-test-lint.yml   # Main CI/CD workflow
```

## 🚀 Getting Started

### Prerequisites

- **Xcode 15.0+** (recommended)
- **macOS 14.0+** for development
- **Swift 5.9+**
- Command Line Tools installed

### Building the Project

1. **Clone the repository:**
   ```bash
   git clone https://github.com/linuxliam/disability.git
   cd disability
   ```

2. **Open in Xcode:**
   ```bash
   open DisabilityAdvocacy.xcodeproj
   ```

3. **Select a target:**
   - For iOS: Select "DisabilityAdvocacy-iOS" scheme and choose an iOS Simulator
   - For macOS: Select "DisabilityAdvocacy-macOS" scheme

4. **Build and Run:**
   - Press `⌘R` or click the Run button

### Building from Command Line

**Build iOS:**
```bash
xcodebuild -project DisabilityAdvocacy.xcodeproj \
  -scheme "DisabilityAdvocacy-iOS" \
  -sdk iphonesimulator \
  -configuration Debug \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build
```

**Build macOS:**
```bash
xcodebuild -project DisabilityAdvocacy.xcodeproj \
  -scheme "DisabilityAdvocacy-macOS" \
  -sdk macosx \
  -configuration Debug \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build
```

**Build All Platforms:**
```bash
./scripts/build-all-platforms.sh [Debug|Release]
```

For more detailed build instructions, see [docs/BUILD.md](docs/BUILD.md).

## 🧪 Testing

Run tests from Xcode:
- Press `⌘U` or Product → Test

Or from command line:
```bash
xcodebuild test \
  -project DisabilityAdvocacy.xcodeproj \
  -scheme "DisabilityAdvocacy-iOS" \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

See [docs/TESTING.md](docs/TESTING.md) for more testing information.

## 📖 Documentation

- **[User Documentation](docs/user/README.md)** - User guides and features
- **[Build Documentation](docs/BUILD.md)** - Detailed build instructions
- **[CI/CD Documentation](docs/CI_CD.md)** - Continuous Integration setup
- **[Testing Documentation](docs/TESTING.md)** - Testing guidelines
- **[macOS Setup](macOS/README.md)** - macOS-specific information

## 🛠️ Development

### Code Quality

The project uses:
- **SwiftLint** for code style (if installed)
- **Swift 6** strict concurrency checking
- Comprehensive code quality metrics in CI

### Code Style

- Follow Swift API Design Guidelines
- Use `@MainActor` for UI-related code
- Prefer `async/await` over completion handlers
- Use guard statements for early returns
- Avoid force unwraps in production code

### Platform-Specific Code

Use conditional compilation for platform-specific code:
```swift
#if os(iOS)
    // iOS-specific code
#elseif os(macOS)
    // macOS-specific code
#endif
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Ensure all CI checks pass
- Focus on accessibility improvements

## 📋 Requirements

### iOS
- **Minimum Deployment:** iOS 18.0
- **Architecture:** arm64
- **SDK:** iphonesimulator (for simulator builds)

### macOS
- **Minimum Deployment:** macOS 15.0
- **Architecture:** arm64, x86_64
- **SDK:** macosx

## 🔒 Security

- No hardcoded secrets or API keys
- Secure data handling
- Privacy-focused design
- See [Resources/PrivacyInfo.xcprivacy](Resources/PrivacyInfo.xcprivacy) for privacy details

## 📄 License

This project is created for educational and advocacy purposes.

## 🙏 Acknowledgments

Built with SwiftUI and designed with accessibility as a core principle.

## 📞 Support

For issues, questions, or contributions, please open an issue on GitHub.

---

**Version:** 1.0.0  
**Last Updated:** January 2026
