# CI/CD Workflows Documentation

## Overview

This document describes all GitHub Actions workflows in the Disability Advocacy project, including their purpose, triggers, and configuration.

## Workflows

### 1. CI Build, Test, and Lint (`ci-build-test-lint.yml`)

**Purpose:** Comprehensive CI pipeline for building, testing, and code quality checks.

**Triggers:**
- Push to `main` branch
- Pull requests to `main`
- Manual workflow dispatch

**Jobs:**
- **Lint:** Code quality checks (SwiftLint, formatting)
- **Validate Dependencies:** Xcode project validation
- **Check Swift Concurrency:** Pre-build concurrency checks
- **Build iOS:** Builds for Debug and Release configurations
- **Build macOS:** Builds for Debug and Release configurations
- **Test iOS:** Runs tests on multiple simulators
- **Test macOS:** Runs macOS test suite
- **Validate Build:** Build validation and code quality metrics
- **Security Scan:** Secret detection and dependency scanning
- **Build Status:** Generates comprehensive status report

**Key Features:**
- Matrix builds for multiple configurations
- Parallel execution for faster feedback
- Comprehensive error reporting
- Artifact archiving

---

### 2. Auto-Create PR on Bug Label (`auto-create-pr-on-bug-label.yml`)

**Purpose:** Automatically creates draft PRs when issues are labeled as `bug`.

**Triggers:**
- Issue labeled with `bug`

**Process:**
1. Checks if PR already exists for the issue
2. Creates branch `fix/<issue-number>/bug-fix`
3. Creates draft PR with issue link
4. Adds comment to issue with PR link

**Key Features:**
- Prevents duplicate PRs
- Automatic branch creation
- Issue-PR linking

---

### 3. Release (`release.yml`)

**Purpose:** Automated release creation with changelog generation and artifact building.

**Triggers:**
- Push of version tag (e.g., `v1.0.0`)
- Manual workflow dispatch with version input

**Process:**
1. Extracts version from tag or input
2. Generates changelog from commits since last tag
3. Creates GitHub release with changelog
4. Builds release artifacts (iOS and macOS)
5. Uploads artifacts for download

**Key Features:**
- Automatic changelog generation
- Release artifact building
- Version tag management

**Usage:**
```bash
# Create release via tag
git tag v1.0.0
git push origin v1.0.0

# Or use manual dispatch in GitHub Actions UI
```

---

### 4. Dependency Update Check (`dependency-update.yml`)

**Purpose:** Weekly checks for dependency updates and creates issues for review.

**Triggers:**
- Weekly schedule (Monday 9 AM UTC)
- Manual workflow dispatch

**Process:**
1. Checks for Swift Package dependencies
2. Checks Xcode project for package references
3. Creates issue if dependencies are found (for manual review)

**Key Features:**
- Automated weekly checks
- Issue creation for manual review
- Prevents duplicate issues

**Note:** This workflow creates issues for manual review. Actual dependency updates should be done manually after testing.

---

### 5. Code Coverage (`code-coverage.yml`)

**Purpose:** Generates code coverage reports and comments on PRs.

**Triggers:**
- Pull requests to `main`
- Push to `main`
- Manual workflow dispatch

**Process:**
1. Runs tests with code coverage enabled
2. Generates coverage report
3. Calculates coverage percentage
4. Comments on PR with coverage status
5. Uploads coverage report as artifact

**Key Features:**
- Automatic coverage calculation
- PR comments with coverage status
- Coverage goals (80%+ target)
- Coverage report artifacts

**Coverage Goals:**
- ✅ Excellent: 80%+
- ⚠️  Good: 60-79%
- ❌ Needs Improvement: < 60%

---

### 6. Stale Issue and PR Management (`stale.yml`)

**Purpose:** Automatically marks and closes stale issues and PRs.

**Triggers:**
- Daily schedule (2 AM UTC)
- Manual workflow dispatch

**Configuration:**
- **Issues:**
  - Stale after 60 days of inactivity
  - Closed after 7 more days if no activity
  - Exempt labels: `pinned`, `security`, `bug`, `enhancement`
  
- **PRs:**
  - Stale after 30 days of inactivity
  - Closed after 7 more days if no activity
  - Exempt labels: `work-in-progress`, `blocked`, `review-requested`

**Key Features:**
- Automatic stale detection
- Configurable timeframes
- Label-based exemptions
- Auto-removal when updated

---

### 7. PR Validation (`pr-validation.yml`)

**Purpose:** Validates pull requests before merge to ensure quality standards.

**Triggers:**
- Pull request opened
- Pull request synchronized (new commits)
- Pull request reopened
- Pull request marked as ready for review

**Checks:**
1. **PR Title:** Must follow conventional commits format
   - Format: `type(scope): description`
   - Examples: `feat: add feature`, `fix: resolve bug`
   
2. **Issue Linking:** Checks for linked issues
   - Looks for: `Fixes #X`, `Closes #X`, `Resolves #X`
   
3. **PR Description:** Must be present and meaningful
   - Minimum 50 characters
   
4. **Breaking Changes:** Detects and warns about breaking changes

**Key Features:**
- Automatic validation on PR events
- PR comments with validation results
- Conventional commits enforcement
- Issue linking verification

---

## Workflow Summary

| Workflow | Trigger | Frequency | Purpose |
|----------|---------|-----------|---------|
| `ci-build-test-lint.yml` | Push/PR | On every change | Build, test, lint |
| `auto-create-pr-on-bug-label.yml` | Issue labeled | On demand | Auto-create bug PRs |
| `release.yml` | Tag/Manual | On release | Create releases |
| `dependency-update.yml` | Schedule | Weekly | Check dependencies |
| `code-coverage.yml` | PR/Push | On every change | Coverage reporting |
| `stale.yml` | Schedule | Daily | Manage stale items |
| `pr-validation.yml` | PR events | On PR changes | Validate PRs |

## Best Practices

### For Developers

1. **PRs:**
   - Use conventional commit format for PR titles
   - Link to related issues
   - Provide detailed descriptions
   - Mark breaking changes appropriately

2. **Releases:**
   - Use semantic versioning (v1.0.0)
   - Tag releases with version tags
   - Review auto-generated changelogs

3. **Issues/PRs:**
   - Keep issues and PRs active
   - Use appropriate labels to prevent stale marking
   - Respond to stale warnings promptly

### For Maintainers

1. **Monitor Workflows:**
   - Check workflow runs regularly
   - Review failed workflows
   - Update workflow configurations as needed

2. **Dependencies:**
   - Review weekly dependency update issues
   - Test updates before merging
   - Keep dependencies up to date

3. **Coverage:**
   - Aim for 80%+ code coverage
   - Review coverage reports
   - Add tests for uncovered code

## Troubleshooting

### Workflow Not Running

1. Check workflow file exists in `.github/workflows/`
2. Verify workflow is enabled in repository settings
3. Check GitHub Actions is enabled
4. Review workflow syntax for errors

### Workflow Failing

1. Check workflow logs in Actions tab
2. Review error messages
3. Verify required permissions
4. Check for configuration issues

### Coverage Not Reporting

1. Ensure tests are running with coverage enabled
2. Check Xcode project settings
3. Verify test targets are configured correctly

## Related Documentation

- [CI/CD Overview](./CI_CD.md)
- [Testing Guide](./TESTING.md)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
