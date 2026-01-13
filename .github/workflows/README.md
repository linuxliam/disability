# GitHub Actions Workflows

## Build and Test Workflow

**File:** `.github/workflows/build-and-test.yml`

### Overview
Automated CI/CD pipeline that builds and tests the Disability Advocacy app for both iOS and macOS platforms.

### Triggers
- **Push** to `main` or `develop` branches
- **Pull Requests** to `main` or `develop` branches
- **Manual dispatch** with optional configuration selection (Debug/Release)

### Jobs

#### 1. Build iOS
- Builds iOS target for simulator
- Caches Swift packages for faster builds
- Archives build artifacts
- Timeout: 30 minutes

#### 2. Build macOS
- Builds macOS target
- Caches Swift packages for faster builds
- Archives build artifacts
- Timeout: 30 minutes

#### 3. Test iOS
- Runs iOS unit tests
- Boots iOS Simulator
- Generates test results
- Archives test artifacts
- Timeout: 20 minutes

#### 4. Validate Build
- Runs build validation scripts
- Validates platform code
- Checks for common issues
- Timeout: 10 minutes

#### 5. Build Status Summary
- Generates comprehensive status report
- Posts to GitHub Actions summary
- Shows build, test, and validation results

### Features

- **Caching:** Swift packages and build artifacts are cached
- **Parallel Execution:** iOS and macOS builds run in parallel
- **Artifact Archiving:** Build outputs and test results are saved
- **Error Reporting:** Detailed error output on failures
- **Status Summary:** Visual status report in GitHub Actions

### Usage

#### Automatic
Workflow runs automatically on push/PR to main/develop branches.

#### Manual
1. Go to Actions tab in GitHub
2. Select "Build and Test" workflow
3. Click "Run workflow"
4. Optionally select Debug or Release configuration
5. Click "Run workflow" button

### Artifacts

- **iOS Build:** `ios-build-Debug.app` or `ios-build-Release.app`
- **macOS Build:** `macos-build-Debug.app` or `macos-build-Release.app`
- **Test Results:** `ios-test-results.xcresult` and test output logs

Artifacts are retained for 7 days.

### Environment Variables

- `XCODE_VERSION`: Xcode version to use (default: 15.0)
- `SWIFT_VERSION`: Swift version (default: 5.0)
- `CONFIGURATION`: Build configuration (Debug or Release)

### Troubleshooting

#### Build Failures
- Check build logs in Actions tab
- Verify Xcode version compatibility
- Check for missing dependencies

#### Test Failures
- Review test output logs
- Verify simulator availability
- Check test target configuration

#### Timeout Issues
- Increase timeout in workflow file
- Optimize build settings
- Use build caching effectively

### Customization

To modify the workflow:
1. Edit `.github/workflows/build-and-test.yml`
2. Commit and push changes
3. Workflow will use updated configuration

### Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Xcode Build Documentation](https://developer.apple.com/documentation/xcode)
# Workflow triggered on Tue Jan 13 09:28:11 PST 2026
