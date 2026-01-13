# CI/CD Documentation

## Overview
This document describes the Continuous Integration and Continuous Deployment setup for the Disability Advocacy app.

## GitHub Actions

### Workflow: Build and Test

**File:** `.github/workflows/build-and-test.yml`

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Manual workflow dispatch

**Jobs:**

#### 1. Build iOS
- Builds iOS target for simulator
- Archives build artifacts
- Runs on `macos-14` runner

#### 2. Build macOS
- Builds macOS target
- Archives build artifacts
- Runs on `macos-14` runner

#### 3. Test iOS
- Runs iOS unit tests
- Archives test results
- Requires successful iOS build

#### 4. Validate Build
- Runs build validation scripts
- Validates platform code
- Requires successful builds

#### 5. Build Status
- Generates build status summary
- Posts to GitHub Actions summary
- Runs after all other jobs

## Local CI Simulation

### Run Build Validation
```bash
./scripts/validate-build.sh
```

### Run Platform Code Validation
```bash
./scripts/validate-platform-code.sh
```

### Run All Validations
```bash
./scripts/build-all-platforms.sh && \
./scripts/run-tests.sh && \
./scripts/validate-build.sh
```

## Build Pipeline

```
┌─────────────┐
│   Push/PR   │
└──────┬──────┘
       │
       ├─→ Build iOS ──→ Test iOS
       │
       └─→ Build macOS
       │
       └─→ Validate ──→ Status Report
```

## Artifacts

### Build Artifacts
- iOS app bundle (`.app`)
- macOS app bundle (`.app`)
- Retained for 7 days

### Test Results
- Test reports
- Coverage data
- Retained for 7 days

## Monitoring

### Build Status
- Check GitHub Actions tab
- View workflow runs
- Inspect failed builds

### Notifications
- Email on failure (if configured)
- GitHub status checks on PRs
- Build status badge (optional)

## Adding New Platforms

### Steps
1. Add new build job in workflow
2. Update validation scripts
3. Add platform-specific config
4. Update documentation

### Example: Adding watchOS
```yaml
build-watchos:
  name: Build watchOS
  runs-on: macos-14
  steps:
    - uses: actions/checkout@v4
    - name: Build watchOS target
      run: |
        xcodebuild \
          -project DisabilityAdvocacy.xcodeproj \
          -target "DisabilityAdvocacy-watchOS" \
          -sdk watchsimulator \
          -configuration Debug \
          build
```

## Troubleshooting

### Workflow Failures

#### Build Timeout
**Problem:** Build takes too long

**Solution:**
- Increase timeout in workflow
- Optimize build settings
- Use build caching

#### Missing Dependencies
**Problem:** Build fails due to missing dependencies

**Solution:**
- Check dependency installation step
- Verify Xcode version
- Check SDK availability

#### Test Failures
**Problem:** Tests fail in CI but pass locally

**Solution:**
- Check simulator availability
- Verify test environment
- Review test logs

## Advanced Configuration

### Xcode Cloud (Optional)

If using Xcode Cloud, create `.xcode-version`:
```
15.0
```

### Fastlane (Optional)

For advanced automation:
1. Install Fastlane: `gem install fastlane`
2. Initialize: `fastlane init`
3. Configure `Fastfile`
4. Add to CI workflow

## Security

### Secrets Management
- Use GitHub Secrets for sensitive data
- Never commit API keys or certificates
- Use environment variables in workflows

### Code Signing
- Store certificates in GitHub Secrets
- Use secure code signing in CI
- Validate signatures before distribution

## Performance

### Build Optimization
- Use build caching
- Parallel job execution
- Incremental builds where possible

### Test Optimization
- Run tests in parallel
- Use test sharding
- Skip unnecessary tests

## Best Practices

1. **Fast Feedback:** Keep builds under 10 minutes
2. **Reliability:** Ensure builds are deterministic
3. **Documentation:** Keep CI/CD docs up to date
4. **Monitoring:** Track build times and failures
5. **Security:** Never expose secrets in logs

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Xcode Cloud Documentation](https://developer.apple.com/xcode-cloud/)
- [Fastlane Documentation](https://docs.fastlane.tools/)
