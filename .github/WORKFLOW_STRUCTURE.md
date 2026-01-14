# CI Workflow Structure

## Overview

The CI pipeline has been split into individual workflow files for better maintainability and organization. Each workflow focuses on a specific concern and can be managed independently.

## Workflow Files

### Main Orchestrator
- **`ci-build-test-lint.yml`** - Main orchestrator that documents the CI pipeline structure

### Validation & Quality
- **`ci-code-quality.yml`** - Code quality checks using SwiftLint
- **`ci-validate-project.yml`** - Project structure validation
- **`ci-validate-dependencies.yml`** - Swift Package Manager dependency validation and caching
- **`ci-security-scan.yml`** - Security scanning for secrets and vulnerabilities

### Builds
- **`ci-build-ios.yml`** - iOS builds for Debug and Release configurations
- **`ci-build-macos.yml`** - macOS builds for Debug and Release configurations

### Tests
- **`ci-test-ios.yml`** - iOS unit tests on multiple simulators
- **`ci-test-macos.yml`** - macOS unit tests

### Post-Build
- **`ci-post-build-validation.yml`** - Post-build validation, code metrics, and quality checks
- **`ci-status-summary.yml`** - Build status summary and reporting

## Benefits of This Structure

### 1. **Easier Maintenance**
- Each workflow is focused on a single concern
- Changes to one workflow don't affect others
- Smaller files are easier to understand and modify

### 2. **Better Organization**
- Related jobs are grouped together
- Clear separation of concerns
- Easy to find and update specific workflows

### 3. **Parallel Execution**
- All workflows run in parallel on the same events
- Faster CI execution times
- Independent failure handling

### 4. **Selective Execution**
- Can run individual workflows manually via `workflow_dispatch`
- Skip specific checks when needed
- Better control over CI execution

### 5. **Improved Debugging**
- Easier to identify which workflow failed
- Focused logs for each concern
- Better error reporting

## Workflow Triggers

All workflows trigger on:
- **Push to `main`** (excluding documentation-only changes)
- **Pull requests to `main`** (excluding documentation-only changes)
- **Manual workflow dispatch** (with optional inputs)

## Path Filtering

All workflows use path-based filtering to skip execution for:
- Documentation changes (`**.md`, `docs/**`)
- Configuration-only changes (`.github/ISSUE_TEMPLATE/**`, `.github/CODEOWNERS`, etc.)

## Workflow Dependencies

While workflows run in parallel, there are logical dependencies:

1. **Validation** → **Builds**
   - Project and dependency validation should pass before builds
   - However, workflows run independently for speed

2. **Builds** → **Tests**
   - Tests require successful builds
   - Test workflows can be configured to wait for build completion

3. **Builds** → **Post-Build Validation**
   - Post-build validation runs after builds complete
   - Uses `workflow_run` trigger to wait for build workflows

## Manual Execution

Each workflow can be run manually with specific inputs:

### Code Quality
```yaml
skip_lint: true/false
```

### Builds
```yaml
configuration: Debug/Release
```

### Tests
```yaml
skip_tests: true/false
```

## Reusable Workflows

The following reusable workflows are available in `.github/workflows/reusable/`:
- `build-platform.yml` - Reusable build job
- `test-platform.yml` - Reusable test job with coverage
- `validate-project.yml` - Reusable validation job

These can be called from other workflows using `workflow_call`.

## Migration Notes

The original monolithic `ci-build-test-lint.yml` has been refactored into:
- A simple orchestrator that documents the pipeline
- Individual workflow files for each concern

All functionality is preserved, but now organized for better maintainability.

## Future Improvements

Potential enhancements:
1. Use `workflow_call` to create a true dependency chain
2. Add workflow status badges
3. Create workflow templates for new platforms
4. Add workflow performance monitoring
5. Implement workflow result aggregation
