# Setup Instructions

## Option 1: Create Xcode Project (Recommended)

1. **Open Xcode** and select "Create a new Xcode project"

2. **Choose Template:**
   - Select "macOS" tab
   - Choose "App"
   - Click "Next"

3. **Configure Project:**
   - Product Name: `Disability Advocacy` (or `AdvocacyApp`)
   - Team: Select your development team (or leave as "None")
   - Organization Identifier: `com.yourname` (or your preferred identifier)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: None (or Core Data if you want to add it later)
   - Click "Next"

4. **Save Location:**
   - Choose a location (you can save it elsewhere and move files)
   - Uncheck "Create Git repository" if you don't need it
   - Click "Create"

5. **Add Files to Project:**
   - Delete the default `ContentView.swift` and `AdvocacyApp.swift` (or `App.swift`) that Xcode created
   - In Xcode, right-click on the project in the navigator
   - Select "Add Files to [Project Name]..."
   - Navigate to this directory (`/Users/liammatthews/Desktop/APP`)
   - Select all the Swift files and folders:
     - All `.swift` files in the root
     - The `Models/` folder
     - The `Views/` folder
     - The `ViewModels/` folder
     - The `Managers/` folder
   - Make sure "Copy items if needed" is checked
   - Make sure your app target is selected
   - Click "Add"

6. **Configure Build Settings:**
   - Select your project in the navigator
   - Select your app target
   - Go to "General" tab
   - Set "Minimum Deployments" to macOS 13.0 or later
   - **Important**: Set the "Bundle Identifier" to `com.disabilityadvocacy.app` (or your preferred identifier like `com.yourname.disabilityadvocacy`)
   - Go to "Info" tab
   - The `Info.plist` should be automatically included
   - If you see bundle identifier errors, make sure the Bundle Identifier in the General tab matches what's in Info.plist

7. **Build and Run:**
   - Select a Mac as your destination (or "My Mac")
   - Press ⌘R to build and run

## Option 2: Using Swift Package Manager (Alternative)

If you prefer using Swift Package Manager:

```bash
cd /Users/liammatthews/Desktop/APP
swift build
swift run
```

Note: This approach is less common for macOS apps with UI. Xcode is the recommended approach.

## Troubleshooting

### Missing Files Error
If Xcode complains about missing files:
- Make sure all files are added to the target
- Check the File Inspector (right panel) for each file and ensure your app target is checked

### Build Errors
- Ensure macOS 13.0+ is set as the minimum deployment target
- Clean build folder: Product → Clean Build Folder (⇧⌘K)
- Restart Xcode if issues persist

### Runtime Issues
- Check that `Info.plist` is included in the target
- Verify all Swift files are compiled (check Build Phases → Compile Sources)

### Bundle Identifier Errors
- If you see "Cannot index window tabs due to missing main bundle identifier":
  - Go to your app target's "General" tab
  - Set the "Bundle Identifier" field (e.g., `com.disabilityadvocacy.app`)
  - Make sure it matches the CFBundleIdentifier in Info.plist
  - Clean build folder (⇧⌘K) and rebuild

## Project Structure

After setup, your Xcode project should have this structure:

```
Disability Advocacy/
├── AdvocacyApp.swift
├── ContentView.swift
├── SidebarView.swift
├── DetailView.swift
├── Models/
│   ├── AppState.swift
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

## Next Steps

Once the app is running:
1. Explore the different sections via the sidebar
2. Try the accessibility settings (⌘⇧,)
3. Browse resources and mark favorites
4. Check out upcoming events
5. Review community posts

The app includes sample data for demonstration. In a production version, you would connect to real APIs or databases.

