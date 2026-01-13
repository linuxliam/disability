# Auto-Create PR for Bug Issues

## Overview

When an issue is labeled as `bug`, a GitHub Actions workflow automatically:
1. Creates a branch: `fix/<issue-number>/bug-fix`
2. Creates a draft PR linked to the issue
3. Adds a comment to the issue with the PR link

## How It Works

### Trigger
- **Event:** Issue labeled
- **Condition:** Label is `bug`
- **Action:** `labeled` (not `unlabeled`)

### Process

1. **Check for existing PR**
   - Searches for open PRs that reference the issue
   - Skips if PR already exists

2. **Check for existing branch**
   - Checks if branch `fix/<issue-number>/bug-fix` exists
   - Skips if branch already exists

3. **Create branch**
   - Creates branch from `develop`
   - Adds placeholder file: `.github/auto-fix/issue-<number>.md`
   - Commits with conventional commit format

4. **Create PR**
   - Creates draft PR from branch to `develop`
   - PR title: `fix: <issue-title> (Issue #<number>)`
   - PR body includes issue details and next steps
   - Links to issue using `Fixes #<number>`

5. **Comment on issue**
   - Adds comment with PR link
   - Notifies that PR is in draft mode

## Branch Naming

**Format:** `fix/<issue-number>/bug-fix`

**Examples:**
- Issue #52 → `fix/52/bug-fix`
- Issue #123 → `fix/123/bug-fix`

## PR Details

### Title
```
fix: <issue-title> (Issue #<number>)
```

### Body Template
```markdown
## Description
This PR was automatically created for bug issue #<number>.

## Issue Details
- Title: <issue-title>
- Number: #<number>
- Labels: bug, ...

## Status
🚧 Work in Progress - This PR was automatically created.

## Next Steps
1. [ ] Investigate the bug
2. [ ] Implement the fix
3. [ ] Add tests (if applicable)
4. [ ] Update documentation (if needed)
5. [ ] Ensure all CI/CD checks pass
6. [ ] Request review when ready

## Related
Fixes #<number>
```

## Usage

### To Trigger

1. **Label an issue as "bug":**
   ```bash
   gh issue edit <number> --add-label bug
   ```

2. **Or via GitHub UI:**
   - Go to the issue
   - Click "Labels"
   - Select "bug"
   - Workflow runs automatically

### After PR Creation

1. **Implement the fix:**
   ```bash
   git checkout fix/<number>/bug-fix
   # Make changes
   git commit -m "fix(scope): implement bug fix (Closes #<number>)"
   git push
   ```

2. **Mark PR as ready:**
   - Go to PR on GitHub
   - Click "Ready for review"
   - Request review

3. **Complete the PR:**
   - Ensure all CI/CD checks pass
   - Get approval
   - Merge when ready

## Configuration

### Workflow File
`.github/workflows/auto-create-bug-pr.yml`

### Customization

**Change branch name format:**
```yaml
BRANCH_NAME="fix/$ISSUE_NUM/bug-fix"
```

**Change base branch:**
```yaml
base: 'develop'  # Change to 'main' or other branch
```

**Change PR template:**
Edit the `body` section in the "Create Pull Request" step.

## Limitations

1. **Only creates draft PRs**
   - PRs start in draft mode
   - Must be marked ready for review manually

2. **Requires "bug" label**
   - Only triggers on `bug` label
   - Other labels don't trigger

3. **One PR per issue**
   - Won't create duplicate PRs
   - Checks for existing PRs first

4. **Base branch must exist**
   - Defaults to `develop`
   - Will fail if branch doesn't exist

## Troubleshooting

### PR Not Created

**Check:**
1. Is the issue labeled as `bug`?
2. Does a PR already exist for this issue?
3. Does the branch already exist?
4. Check workflow run logs in Actions tab

### Branch Already Exists

**Solution:**
```bash
# Delete the branch if needed
git push origin --delete fix/<number>/bug-fix

# Or use the branch that exists
git checkout fix/<number>/bug-fix
```

### PR Created but Wrong Branch

**Solution:**
1. Close the auto-created PR
2. Create branch manually
3. Create PR manually

### Workflow Not Running

**Check:**
1. Workflow file exists: `.github/workflows/auto-create-bug-pr.yml`
2. Workflow is enabled in repository settings
3. GitHub Actions is enabled
4. Check Actions tab for errors

## Examples

### Example 1: Simple Bug

**Issue #52:** "CreatePostView does not actually create posts"
- Labeled as `bug`
- Workflow creates: `fix/52/bug-fix`
- PR: "fix: CreatePostView does not actually create posts (Issue #52)"

### Example 2: Complex Bug

**Issue #100:** "App crashes on iOS 17 when opening settings"
- Labeled as `bug`
- Workflow creates: `fix/100/bug-fix`
- PR: "fix: App crashes on iOS 17 when opening settings (Issue #100)"

## Best Practices

1. **Label issues correctly**
   - Use `bug` for actual bugs
   - Don't use for features or enhancements

2. **Review auto-created PRs**
   - Check the placeholder content
   - Update PR description if needed
   - Add more details about the fix

3. **Follow conventional commits**
   - When committing fixes, use: `fix(scope): description (Closes #X)`
   - Follow the commit message format

4. **Clean up after merge**
   - Delete the branch after merge
   - Close related issues
   - Update documentation if needed

## Related Documentation

- [Trackable Development Practices](./TRACKABLE_DEVELOPMENT.md)
- [Issue-PR Linking Guide](./ISSUE_PR_LINKING.md)
- [Enforcement Setup](./ENFORCEMENT_SETUP.md)
