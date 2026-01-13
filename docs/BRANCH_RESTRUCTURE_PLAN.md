# Branch and PR Restructuring Plan

This document outlines the plan to restructure branches and PRs to align with milestones.

## Current State Analysis

### Current Branches
- `feature/resources-enhancements` → PR #41 (v0.2.0)
- `feature/events-enhancements` → PR #42 (v0.2.0)
- `feature/profile-favorites` → PR #43 (v0.2.0)
- `feature/user-documentation` → PR #39 (v1.0.0-beta)
- `feature/v0.2.0-core-features` (exists but no active PR)
- `feature/v0.3.0-platform-optimization` (exists but no active PR)
- `feature/v0.4.0-testing-quality` (exists but no active PR)
- `feature/v1.1.0-post-launch` (exists but no active PR)
- `release/v1.0.0-beta` (exists)
- `release/v1.0.0` (exists)

### Current PRs
- **PR #41**: Enhance Resources Features (v0.2.0) - Branch: `feature/resources-enhancements`
- **PR #42**: Enhance Events Features (v0.2.0) - Branch: `feature/events-enhancements`
- **PR #43**: Add Profile and Favorites (v0.2.0) - Branch: `feature/profile-favorites`
- **PR #39**: Create User Documentation (v1.0.0-beta) - Branch: `feature/user-documentation`
- **PR #11-16**: Draft/planning PRs for milestones

## Proposed Structure

### Milestone-Based Branch Naming

For each milestone, use a consistent naming pattern:

```
milestone/<version>-<name>
```

Examples:
- `milestone/v0.2.0-core-features`
- `milestone/v0.3.0-platform-optimization`
- `milestone/v0.4.0-testing-quality`
- `milestone/v1.0.0-beta-release`
- `milestone/v1.0.0-production`
- `milestone/v1.1.0-post-launch`
```

### Feature Branches Within Milestones

For individual features within a milestone:

```
feature/<milestone-version>/<feature-name>
```

Examples:
- `feature/v0.2.0/resources-enhancements`
- `feature/v0.2.0/events-enhancements`
- `feature/v0.2.0/profile-favorites`
- `feature/v1.0.0-beta/user-documentation`
```

## Restructuring Plan

### Phase 1: Consolidate v0.2.0 PRs

**Option A: Merge into single milestone branch (Recommended)**
1. Create/use `milestone/v0.2.0-core-features` branch
2. Merge PRs #41, #42, #43 into this branch
3. Create single PR from milestone branch to `develop`
4. Close individual PRs with reference to consolidated PR

**Option B: Keep separate but rename branches**
1. Rename branches to `feature/v0.2.0/resources-enhancements`
2. Rename branches to `feature/v0.2.0/events-enhancements`
3. Rename branches to `feature/v0.2.0/profile-favorites`
4. Update PR titles to include milestone prefix

### Phase 2: Rename Existing Branches

1. **v0.2.0 branches:**
   - `feature/resources-enhancements` → `feature/v0.2.0/resources-enhancements`
   - `feature/events-enhancements` → `feature/v0.2.0/events-enhancements`
   - `feature/profile-favorites` → `feature/v0.2.0/profile-favorites`

2. **v1.0.0-beta branches:**
   - `feature/user-documentation` → `feature/v1.0.0-beta/user-documentation`

3. **Milestone branches (already exist, verify):**
   - `feature/v0.2.0-core-features` → `milestone/v0.2.0-core-features`
   - `feature/v0.3.0-platform-optimization` → `milestone/v0.3.0-platform-optimization`
   - `feature/v0.4.0-testing-quality` → `milestone/v0.4.0-testing-quality`
   - `feature/v1.1.0-post-launch` → `milestone/v1.1.0-post-launch`

### Phase 3: Update PRs

1. Update PR titles to include milestone:
   - `[v0.2.0] Enhance Resources Features` ✅ (already correct)
   - `[v0.2.0] Enhance Events Features` ✅ (already correct)
   - `[v0.2.0] Add Profile and Favorites` ✅ (already correct)
   - `[v1.0.0-beta] Create User Documentation` ✅ (already correct)

2. Ensure all PRs are linked to correct milestones

3. Update PR descriptions to reference milestone

### Phase 4: Clean Up

1. Delete merged/closed branches
2. Archive or close draft PRs (#11-16) if not needed
3. Update documentation

## Recommended Approach

**Option A: Consolidate by Milestone (Best for tracking)**

1. For v0.2.0:
   - Keep PRs #41, #42, #43 separate (they're already well-organized)
   - Rename branches to `feature/v0.2.0/*` pattern
   - This allows parallel work while maintaining milestone organization

2. For future milestones:
   - Use `feature/<milestone>/<feature>` pattern from the start
   - Create milestone branches when ready to consolidate

## Implementation Steps

### Step 1: Rename Current Branches

```bash
# Rename v0.2.0 branches
git branch -m feature/resources-enhancements feature/v0.2.0/resources-enhancements
git branch -m feature/events-enhancements feature/v0.2.0/events-enhancements
git branch -m feature/profile-favorites feature/v0.2.0/profile-favorites

# Push renamed branches
git push origin feature/v0.2.0/resources-enhancements
git push origin feature/v0.2.0/events-enhancements
git push origin feature/v0.2.0/profile-favorites

# Delete old remote branches
git push origin --delete feature/resources-enhancements
git push origin --delete feature/events-enhancements
git push origin --delete feature/profile-favorites
```

### Step 2: Update PRs

Update PR base branches to point to renamed branches (GitHub will auto-update).

### Step 3: Update Documentation

Update BRANCHING_STRATEGY.md with new naming conventions.

## Benefits

1. **Clear Organization**: Branches clearly show which milestone they belong to
2. **Easy Filtering**: Can filter branches by milestone version
3. **Better Tracking**: Milestone progress is easier to see
4. **Consistent Naming**: All branches follow same pattern
5. **Scalable**: Pattern works for future milestones

## Migration Checklist

- [ ] Rename v0.2.0 feature branches
- [ ] Rename v1.0.0-beta feature branches
- [ ] Update PR base branches (if needed)
- [ ] Verify PRs are linked to correct milestones
- [ ] Update branch protection rules (if needed)
- [ ] Update documentation
- [ ] Clean up old branches
- [ ] Archive/close draft PRs
