# Disability Advocacy App

A comprehensive macOS application designed to support disability advocacy, providing resources, community connections, events, and advocacy tools.

## Features

### 🏠 Home Dashboard
- Overview of resources, events, and community activity
- Quick access to featured content
- Statistics and recent updates

### 📚 Resource Library
- Comprehensive database of disability-related resources
- Categories: Legal Rights, Education, Employment, Healthcare, Technology, Community Support, Government Services, and Advocacy Organizations
- Search and filter functionality
- Favorite resources for quick access
- Tags for easy discovery

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

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** architecture pattern:

- **Models**: Data structures (`Resource`, `Event`, `CommunityPost`, etc.)
- **Views**: SwiftUI views for each section
- **ViewModels**: Business logic and state management
- **Managers**: Data persistence and management (`ResourcesManager`, `EventsManager`)

## Project Structure

```
APP/
├── AdvocacyApp.swift          # Main app entry point
├── ContentView.swift          # Root content view with navigation
├── SidebarView.swift          # Sidebar navigation
├── DetailView.swift           # Detail view router
├── Models/
│   ├── AppState.swift         # Global app state
│   ├── AccessibilitySettings.swift
│   ├── Resource.swift
│   ├── Event.swift
│   └── CommunityPost.swift
├── Views/
│   ├── HomeView.swift
│   ├── ResourcesView.swift
│   ├── CommunityView.swift
│   ├── EventsView.swift
│   ├── AdvocacyToolsView.swift
│   ├── NewsView.swift
│   └── AccessibilitySettingsView.swift
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── ResourcesViewModel.swift
│   ├── CommunityViewModel.swift
│   ├── EventsViewModel.swift
│   └── NewsViewModel.swift
├── Managers/
│   ├── ResourcesManager.swift
│   └── EventsManager.swift
├── Info.plist
└── README.md
```

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 14.0 or later
- Swift 5.7 or later

## Building and Running

1. Open the project in Xcode:
   ```bash
   open APP.xcodeproj
   ```
   (Note: You'll need to create an Xcode project first - see instructions below)

2. Select a target device or simulator (Mac)

3. Build and run (⌘R)

## Creating the Xcode Project

Since this is a SwiftUI app, you'll need to create an Xcode project:

1. Open Xcode
2. Create a new project (File → New → Project)
3. Select "macOS" → "App"
4. Choose SwiftUI for the interface
5. Name it "Disability Advocacy" or "AdvocacyApp"
6. Copy all the Swift files into the project
7. Ensure the deployment target is macOS 13.0 or later

## Design Principles

### Accessibility First
- All UI elements are accessible to VoiceOver
- Keyboard navigation throughout
- High contrast and large text support
- Screen reader optimized layouts

### User Experience
- Clean, modern interface following macOS design guidelines
- Dark Mode support
- Responsive layouts
- Intuitive navigation

### Data Persistence
- User preferences saved with `UserDefaults`
- Favorite resources persist across sessions
- Accessibility settings are remembered

## Future Enhancements

- Real-time community features
- Integration with external APIs for events and news
- Cloud sync for saved resources
- Export functionality for advocacy letters
- Calendar integration
- Push notifications for events
- Advanced search with filters
- User profiles and authentication

## License

This project is created for educational and advocacy purposes.

## Contributing

This app is designed to be a starting point for a disability advocacy platform. Contributions that improve accessibility, add features, or enhance the user experience are welcome.

---

**Note**: This app includes sample data for demonstration purposes. In a production environment, you would connect to real data sources, APIs, or databases.


