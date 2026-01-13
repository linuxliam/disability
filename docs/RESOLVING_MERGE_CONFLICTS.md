# Resolving Merge Conflicts

## Quick Guide

### 1. Check for Conflicts

```bash
# Check current status
git status

# Check for conflict markers
git diff --check

# List unmerged files
git ls-files -u
```

### 2. Identify Conflicted Files

Conflicted files will show:
```
<<<<<<< HEAD
Your changes
=======
Incoming changes
>>>>>>> branch-name
```

### 3. Resolve Conflicts

**Option A: Manual Resolution**
1. Open the conflicted file
2. Find conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
3. Choose which changes to keep (or combine both)
4. Remove the conflict markers
5. Save the file

**Option B: Use Merge Tool**
```bash
# Open merge tool
git mergetool

# Or use specific tool
git mergetool --tool=vimdiff
```

**Option C: Accept One Side**
```bash
# Accept your changes (ours)
git checkout --ours <file>

# Accept incoming changes (theirs)
git checkout --theirs <file>
```

### 4. Stage Resolved Files

```bash
# Stage resolved file
git add <file>

# Or stage all resolved files
git add .
```

### 5. Complete the Merge

```bash
# Commit the merge
git commit

# Or if using merge message
git commit -m "Merge branch 'feature/name' into develop"
```

## Common Scenarios

### Scenario 1: Pulling with Conflicts

```bash
git pull origin develop
# Conflicts detected

# Resolve conflicts in files
# Edit files, remove markers

git add .
git commit
```

### Scenario 2: Merging Feature Branch

```bash
git checkout develop
git merge feature/my-feature
# Conflicts detected

# Resolve conflicts
git add .
git commit
```

### Scenario 3: Rebasing with Conflicts

```bash
git rebase develop
# Conflicts detected

# Resolve conflicts
git add .
git rebase --continue

# Or abort
git rebase --abort
```

## Conflict Markers Explained

```
<<<<<<< HEAD
Your current changes
=======
Changes from the branch being merged
>>>>>>> branch-name
```

**To resolve:**
- Keep your changes: Delete everything except your changes
- Keep their changes: Delete everything except their changes
- Keep both: Combine both sets of changes
- Remove all markers: `<<<<<<<`, `=======`, `>>>>>>>`

## Best Practices

### 1. Pull Frequently

```bash
# Pull before starting work
git pull origin develop

# Pull before pushing
git pull origin develop
```

### 2. Keep Branches Short-Lived

- Reduces chance of conflicts
- Easier to resolve when they occur
- Less divergence from main branch

### 3. Communicate with Team

- Coordinate on shared files
- Discuss major changes
- Review PRs before merging

### 4. Use Feature Branches

- Isolate changes
- Test before merging
- Easier conflict resolution

## Tools

### Visual Merge Tools

```bash
# Configure merge tool
git config --global merge.tool vimdiff
git config --global merge.tool kdiff3
git config --global merge.tool meld

# Use merge tool
git mergetool
```

### Common Tools:
- **vimdiff** - Vim-based diff tool
- **kdiff3** - Cross-platform GUI
- **meld** - Visual diff and merge
- **VS Code** - Built-in merge editor
- **Xcode** - Built-in for macOS

## Aborting a Merge

If you want to cancel a merge:

```bash
# Abort merge
git merge --abort

# Or reset to before merge
git reset --hard HEAD
```

⚠️ **Warning:** `git reset --hard` will discard all uncommitted changes!

## Preventing Conflicts

### 1. Regular Integration

```bash
# Merge develop into feature branch regularly
git checkout feature/my-feature
git merge develop
```

### 2. Rebase Instead of Merge

```bash
# Rebase feature branch on develop
git checkout feature/my-feature
git rebase develop
```

### 3. Small, Focused Commits

- Easier to review
- Easier to resolve conflicts
- Clearer history

### 4. Coordinate on Shared Files

- Communicate changes
- Review together
- Use code reviews

## Example: Resolving a Conflict

```bash
# 1. Start merge
git merge feature/new-feature

# 2. Conflict detected
Auto-merging Shared/Views/HomeView.swift
CONFLICT (content): Merge conflict in Shared/Views/HomeView.swift

# 3. Check status
git status
# Shows: both modified: Shared/Views/HomeView.swift

# 4. Open file and resolve
# File contains:
<<<<<<< HEAD
    var body: some View {
        Text("Hello")
    }
=======
    var body: some View {
        Text("Hi")
    }
>>>>>>> feature/new-feature

# 5. Resolve (keep both or choose one)
    var body: some View {
        Text("Hello World")
    }

# 6. Stage resolved file
git add Shared/Views/HomeView.swift

# 7. Complete merge
git commit
```

## Getting Help

If you're stuck:
1. Check `git status` for current state
2. Review conflicted files
3. Use `git mergetool` for visual help
4. Ask team members for assistance
5. Consider `git merge --abort` to start over

## Summary

**Quick Steps:**
1. ✅ Check: `git status`
2. ✅ Find: Look for conflict markers
3. ✅ Resolve: Edit files, remove markers
4. ✅ Stage: `git add <file>`
5. ✅ Commit: `git commit`

**Remember:**
- Conflicts are normal
- Take time to resolve properly
- Test after resolving
- Communicate with team
