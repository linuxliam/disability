# Simplified GitHub Structure

## Overview

The repository has been simplified to focus on active development only.

## Current Structure

### Active Branches (2)
- `feature/v0.2.0/resources-enhancements` - Resources features (PR #44)
- `feature/v0.2.0/events-enhancements` - Events features (PR #45)

### Main Branches
- `main` - Production-ready code
- `develop` - Active development branch

## Branch Naming Convention

```
feature/<milestone-version>/<feature-name>
```

Examples:
- `feature/v0.2.0/resources-enhancements`
- `feature/v0.2.0/events-enhancements`

## Simplification Changes

### Removed
- ✅ Closed 6 draft PRs for future milestones
- ✅ Deleted 6 planning branches
- ✅ Removed unused feature branches

### Kept
- ✅ Only active development branches
- ✅ Branches with open, active PRs
- ✅ Main and develop branches

## Workflow

1. **Create feature branch from develop:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/v0.2.0/my-feature
   ```

2. **Create PR to develop:**
   - PR should be linked to appropriate milestone
   - Include issue references in PR description

3. **After merge:**
   ```bash
   git checkout develop
   git pull origin develop
   git branch -d feature/v0.2.0/my-feature
   git push origin --delete feature/v0.2.0/my-feature
   ```

## Future Milestones

When ready to work on a new milestone:
1. Create feature branch: `feature/v0.3.0/feature-name`
2. Create PR linked to milestone
3. Work on feature
4. Merge when complete

No need to create draft PRs or branches until actively working on them.

