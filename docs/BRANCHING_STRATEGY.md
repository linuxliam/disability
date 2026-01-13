# Branching Strategy

This document outlines the branching strategy for the Disability Advocacy project.

## Branch Types

### Main Branches

- **`main`** - Production-ready code. Always stable and deployable.
  - Protected branch (should require PR reviews)
  - Only merged from `release/` or `hotfix/` branches
  - Tags are created for each release

- **`develop`** - Integration branch for ongoing development.
  - Main development branch
  - All feature branches merge here
  - Should always be in a deployable state
  - Automatically tested via CI/CD

### Supporting Branches

#### Feature Branches
- **Naming:** `feature/<milestone-version>/<feature-name>`
- **Purpose:** New features or enhancements organized by milestone
- **Source:** Branched from `develop`
- **Merge:** Back into `develop`
- **Examples:**
  - `feature/v0.2.0/resources-enhancements`
  - `feature/v0.2.0/events-enhancements`
  - `feature/v0.3.0/ios-accessibility-improvements`
  - `feature/v0.3.0/macos-keyboard-shortcuts`
  - `feature/v1.0.0-beta/user-documentation`

#### Bugfix Branches
- **Naming:** `bugfix/<bug-description>`
- **Purpose:** Fix bugs found in `develop`
- **Source:** Branched from `develop`
- **Merge:** Back into `develop`
- **Examples:**
  - `bugfix/ios-launch-crash`
  - `bugfix/macos-window-resize`
  - `bugfix/memory-leak-resources`

#### Release Branches
- **Naming:** `release/<version>`
- **Purpose:** Prepare a new production release
- **Source:** Branched from `develop`
- **Merge:** Into both `main` and `develop`
- **Examples:**
  - `release/1.0.0`
  - `release/1.1.0`

#### Hotfix Branches
- **Naming:** `hotfix/<issue-description>`
- **Purpose:** Critical fixes for production
- **Source:** Branched from `main`
- **Merge:** Into both `main` and `develop`
- **Examples:**
  - `hotfix/security-patch`
  - `hotfix/critical-crash-fix`

## Workflow

### Starting a New Feature

```bash
git checkout develop
git pull origin develop
git checkout -b feature/my-new-feature
# ... make changes ...
git commit -m "Add feature: my new feature"
git push -u origin feature/my-new-feature
```

### Completing a Feature

```bash
# Create PR on GitHub from feature branch to develop
# After PR is approved and merged:
git checkout develop
git pull origin develop
git branch -d feature/my-new-feature  # Delete local branch
```

### Starting a Release

```bash
git checkout develop
git pull origin develop
git checkout -b release/1.0.0
# ... finalize version numbers, update changelog ...
git commit -m "Prepare release 1.0.0"
git push -u origin release/1.0.0
```

### Completing a Release

```bash
# Merge release branch to main
git checkout main
git merge release/1.0.0
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin main --tags

# Merge release branch back to develop
git checkout develop
git merge release/1.0.0
git push origin develop

# Delete release branch
git branch -d release/1.0.0
git push origin --delete release/1.0.0
```

### Starting a Hotfix

```bash
git checkout main
git pull origin main
git checkout -b hotfix/critical-fix
# ... make fix ...
git commit -m "Fix: critical issue"
git push -u origin hotfix/critical-fix
```

### Completing a Hotfix

```bash
# Merge hotfix to main
git checkout main
git merge hotfix/critical-fix
git tag -a v1.0.1 -m "Hotfix: critical issue"
git push origin main --tags

# Merge hotfix to develop
git checkout develop
git merge hotfix/critical-fix
git push origin develop

# Delete hotfix branch
git branch -d hotfix/critical-fix
git push origin --delete hotfix/critical-fix
```

## Branch Protection Rules

### Recommended GitHub Branch Protection:

**`main` branch:**
- Require pull request reviews (at least 1 approval)
- Require status checks to pass
- Require branches to be up to date
- Do not allow force pushes
- Do not allow deletions

**`develop` branch:**
- Require pull request reviews (at least 1 approval)
- Require status checks to pass
- Allow force pushes (for rebasing, use with caution)

## CI/CD Integration

- All branches trigger CI/CD workflows
- `main` and `develop` branches run full test suites
- Feature branches run tests on push and PR
- Release branches run full builds and tests
- Hotfix branches run critical path tests

## Naming Conventions

- Use lowercase with hyphens: `feature/user-authentication`
- Be descriptive: `bugfix/ios-keyboard-dismissal` not `bugfix/fix1`
- Keep names concise but clear
- Use present tense for features: `feature/add-dark-mode`
- Use past tense for fixes: `bugfix/fixed-memory-leak`

## Best Practices

1. **Keep branches short-lived** - Merge or delete within 1-2 weeks
2. **Regularly sync with base branch** - Rebase or merge from `develop` frequently
3. **One feature per branch** - Don't mix unrelated changes
4. **Write clear commit messages** - Follow conventional commits format
5. **Delete merged branches** - Clean up after merging
6. **Use descriptive PR titles** - Help reviewers understand changes
7. **Link issues in PRs** - Reference related issues/tickets

## Current Active Branches

- `main` - Production branch
- `develop` - Development branch

## Branch Lifecycle

```
feature/branch → develop → release/1.0.0 → main
                                    ↓
                                 develop (merged back)
```
