# String Analysis Report

## Overview
This document catalogs all user-facing strings in the Disability Advocacy app for localization and consistency review.

## Status
- ❌ No localization files found (`.strings` or `.lproj` directories)
- ⚠️ All strings are hardcoded in Swift files
- ✅ Some strings are centralized in constants

## String Categories

### 1. Menu Items (`AdvocacyApp.swift`)

#### File Menu
- "Import Resources..."
- "Import Events..."
- "Export Resources..."
- "Export Events..."

#### Edit Menu
- "Cut"
- "Copy"
- "Paste"
- "Select All"

#### View Menu
- "Show Sidebar"
- "Actual Size"
- "Zoom In"
- "Zoom Out"

#### Window Menu
- "Minimize"
- "Zoom"
- "Bring All to Front"

#### Help Menu
- "Advocacy Help"
- "Keyboard Shortcuts"

#### Custom Menu
- "Search"
- "Refresh"
- "Accessibility Settings"

### 2. UI Labels & Buttons

#### Home View (`HomeView.swift`)
- "Loading home data..."
- "Overview"
- "Featured Resources"
- "Upcoming Events"
- "Resources"
- "Events"
- "Posts"
- "Open Profile"

#### Resources View (`ResourcesView.swift`)
- "Loading resources..."
- "Search resources..."
- "Category"
- "All"
- "No resources found"
- "Resources will appear here once they're added to the library."
- "Try adjusting your search or filter criteria."
- "About"
- "Tags"
- "Visit Website"

#### Events View (`EventsView.swift`)
- "Loading events..."
- "Category"
- "All"
- "No events found"
- "Event Details"
- "About This Event"
- "Accessibility Information"
- "Add to Calendar"
- "Adding to Calendar..."
- "Register"
- "Register for Event"

#### Search View (`SearchView.swift`)
- "Search resources, events, and more..."
- "Search for resources, events, and community posts"
- "Try searching for:"
- "Legal Rights"
- "Events"
- "Community"
- "No results found"
- "Try different keywords or check your spelling"
- "Resources"
- "Events"
- "Community Posts"

#### Share Button (`ShareButton.swift`)
- "Share"

### 3. Contextual Menus (`ContextualMenuExtensions.swift`)
- "Remove from Favorites"
- "Add to Favorites"
- "Open in Browser"
- "Copy Link"
- "Share"
- "Add to Calendar"
- "Open Registration"
- "Copy Text"

### 4. Default Resources (`ResourcesManager.swift`)
- "ADA National Network"
- "Comprehensive information about the Americans with Disabilities Act, including your rights, how to file complaints, and resources for businesses."
- "Legal Rights"
- "Complaints"
- "Job Accommodation Network (JAN)"
- "Free, expert, and confidential guidance on workplace accommodations and disability employment issues."
- "Employment"
- "Accommodations"
- "Workplace"
- "Assistive Technology Industry Association"
- "Resources and information about assistive technology products and services that help people with disabilities."
- "Technology"
- "Assistive Devices"
- "AT"
- "Disability Rights Education & Defense Fund"
- "Leading national civil rights law and policy center directed by individuals with disabilities and parents."
- "Advocacy"
- "Education"
- "Centers for Independent Living"
- "Community-based, cross-disability, nonresidential private nonprofit agencies that provide services and advocacy."
- "Community Support"
- "Support"
- "Independent Living"
- "Social Security Disability Benefits"
- "Information about Social Security Disability Insurance (SSDI) and Supplemental Security Income (SSI) programs."
- "Benefits"
- "Government"
- "SSDI"
- "SSI"
- "National Center on Disability and Journalism"
- "Resources for journalists covering disability issues, including style guides and best practices."
- "Media"
- "Journalism"
- "Healthcare Access for People with Disabilities"
- "Information about healthcare rights, accessible medical facilities, and finding disability-competent providers."
- "Healthcare"
- "Medical"
- "Access"

### 5. File Operations (`FileManager.swift`)
- "Import Resources"
- "Select a JSON file containing resources"
- "Import Events"
- "Select a JSON file containing events"
- "Export Resources"
- "Save resources to a JSON file"
- "Export Events"
- "Save events to a JSON file"
- "Export User Data"
- "Save user profile to a JSON file"

### 6. Notifications (`NotificationManager.swift`, `AppState.swift`)
- "Upcoming Event: {title}"
- "Export Successful"
- "Resources exported successfully"
- "Events exported successfully"

### 7. Calendar (`CalendarManager.swift`)
- "Event added to calendar successfully!"
- "Failed to add event to calendar: {error}"
- "Failed to request calendar access: {error}"
- "Calendar Access Required"
- "Calendar access is required to add events. Please enable it in Settings to continue."
- "Open Settings"
- "Cancel"

### 8. Error Messages
- "Error decoding resources from bundle: {error}"
- "Failed to decode resources: {error}"
- "Failed to decode events: {error}"
- "Failed to export resources: {error}"
- "Failed to export events: {error}"
- "Failed to export user data: {error}"

## Recommendations

### 1. Create Localization Infrastructure
- Create `en.lproj` directory structure
- Create `Localizable.strings` file
- Extract all user-facing strings to localization keys

### 2. String Constants File
Create `Strings.swift` with:
```swift
enum LocalizedString {
    // Menu items
    static let importResources = NSLocalizedString("menu.import.resources", comment: "")
    static let exportResources = NSLocalizedString("menu.export.resources", comment: "")
    // ... etc
}
```

### 3. Consistency Issues Found
- Some strings use title case ("Import Resources...")
- Some use sentence case ("Loading resources...")
- Inconsistent ellipsis usage ("..." vs none)
- Mixed punctuation in error messages

### 4. Missing Strings
- Empty state messages need review
- Error messages need user-friendly alternatives
- Accessibility labels for VoiceOver

### 5. Hardcoded URLs
- Resource URLs in `ResourcesManager.swift` should be configurable
- Help URL in menu is placeholder ("https://example.com/help")

## Action Items

1. ✅ Document all strings (this file)
2. ⏳ Create localization infrastructure
3. ⏳ Extract strings to `.strings` file
4. ⏳ Create `Strings.swift` constants file
5. ⏳ Standardize string formatting
6. ⏳ Add accessibility labels
7. ⏳ Review and improve error messages

## String Count Summary
- Menu Items: ~20
- UI Labels: ~50
- Button Text: ~15
- Error Messages: ~10
- Default Resources: ~30+ (titles, descriptions, tags)
- **Total: ~125+ user-facing strings**

