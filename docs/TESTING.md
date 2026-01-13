# Testing Documentation

## Overview
This document describes the testing infrastructure for the Disability Advocacy app, including unit tests, UI tests, and platform-specific testing considerations.

## Test Targets

### DisabilityAdvocacyTests
Unit tests for iOS platform covering:
- View Models
- Managers
- Models
- Utilities
- Extensions

### DisabilityAdvocacyUITests
UI tests for iOS platform covering:
- User interactions
- Navigation flows
- UI components

## Running Tests

### Run All Tests
```bash
./scripts/run-tests.sh
```

### Run Tests from Xcode
1. Select the test scheme
2. Press `Cmd+U` or Product → Test
3. View results in Test Navigator

### Run Specific Test Class
```bash
xcodebuild test \
  -project DisabilityAdvocacy.xcodeproj \
  -scheme "DisabilityAdvocacy-iOS" \
  -sdk iphonesimulator \
  -only-testing:DisabilityAdvocacyTests/AppStateTests
```

### Run Tests via Command Line
```bash
xcodebuild test \
  -project DisabilityAdvocacy.xcodeproj \
  -scheme "DisabilityAdvocacy-iOS" \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Test Structure

### Test Organization
```
iOS/DisabilityAdvocacyTests/
├── UnitTests/
│   ├── ViewModels/
│   ├── Utilities/
│   └── ...
├── Helpers/
│   ├── PlatformTestHelpers.swift
│   └── TestConfiguration.swift
└── TestData/
    └── TestDataFactories.swift
```

### Platform-Aware Testing

Use `PlatformTestHelpers` for cross-platform test utilities:

```swift
import XCTest
@testable import DisabilityAdvocacy_iOS

final class MyTests: XCTestCase {
    func testPlatformSpecific() {
        PlatformTestHelpers.skipIfNotPlatform("iOS", testCase: self)
        // iOS-specific test code
    }
    
    func testCrossPlatform() {
        // Works on both platforms
        let resource = TestDataFactory.makeResource()
        XCTAssertNotNil(resource)
    }
}
```

### Test Data Factories

Use `TestDataFactory` for creating test objects:

```swift
let resource = TestDataFactory.makeResource(
    title: "Test Resource",
    category: .legal
)

let event = TestDataFactory.makeEvent(
    title: "Test Event",
    category: .workshop
)
```

## Writing Tests

### Unit Test Template
```swift
import XCTest
@testable import DisabilityAdvocacy_iOS

@MainActor
final class MyViewModelTests: XCTestCase {
    var viewModel: MyViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MyViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testExample() async {
        // Given
        let input = "test"
        
        // When
        await viewModel.process(input)
        
        // Then
        XCTAssertEqual(viewModel.result, "expected")
    }
}
```

### Async Test Support
Tests support async/await:

```swift
func testAsyncOperation() async {
    let result = await someAsyncFunction()
    XCTAssertNotNil(result)
}
```

## Platform-Specific Testing

### iOS-Specific Tests
```swift
func testIOSFeature() {
    runOnIOS {
        // iOS-specific test code
    }
}
```

### macOS-Specific Tests
```swift
func testMacOSFeature() {
    runOnMacOS {
        // macOS-specific test code
    }
}
```

### Cross-Platform Tests
```swift
func testCrossPlatformFeature() {
    runOnAllPlatforms {
        // Works on both platforms
    }
}
```

## Test Coverage

### Viewing Coverage
1. Enable Code Coverage in scheme
2. Run tests
3. View coverage in Report Navigator

### Coverage Goals
- Aim for >80% code coverage
- Focus on critical business logic
- Test error paths and edge cases

## Troubleshooting

### Test Compilation Errors

#### Module Import Issues
**Problem:** `Unable to find module dependency`

**Solution:** Ensure correct module name:
```swift
@testable import DisabilityAdvocacy_iOS  // For iOS tests
```

#### Async/Await Issues
**Problem:** `'async' call in a function that does not support concurrency`

**Solution:** Mark test function as `async`:
```swift
func testAsync() async {
    await someAsyncFunction()
}
```

### Test Execution Issues

#### Simulator Not Available
**Problem:** `Unable to find a device matching`

**Solution:** List and boot simulator:
```bash
xcrun simctl list devices
xcrun simctl boot "iPhone 15"
```

#### Test Timeout
**Problem:** Tests timeout before completion

**Solution:** Increase timeout in test:
```swift
func testLongRunning() {
    let expectation = XCTestExpectation()
    // ... setup
    wait(for: [expectation], timeout: 10.0)
}
```

## Best Practices

1. **Isolation:** Each test should be independent
2. **Naming:** Use descriptive test names
3. **Arrange-Act-Assert:** Follow AAA pattern
4. **Mocking:** Mock external dependencies
5. **Fast:** Keep tests fast (< 1 second each)
6. **Deterministic:** Tests should produce same results every time

## Continuous Integration

Tests run automatically on every commit via GitHub Actions. See [CI_CD.md](CI_CD.md) for details.
