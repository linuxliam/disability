# Auto-Create PR for Bug Issues - Workflow Status

## Overview
The `auto-create-pr-on-bug-label.yml` workflow automatically creates a draft PR when an issue is labeled with `bug`.

## Workflow Configuration

**File:** `.github/workflows/auto-create-pr-on-bug-label.yml`

**Trigger:**
```yaml
on:
  issues:
    types: [labeled]
```

**Condition:**
- Only runs when `github.event.label.name == 'bug'` AND `github.event.action == 'labeled'`
- Skips if PR already exists for the issue
- Skips if branch already exists

## How It Works

1. **Trigger:** When an issue is labeled with `bug`
2. **Check:** Verifies no PR already exists for the issue
3. **Check:** Verifies branch `fix/<issue-number>/bug-fix` doesn't exist
4. **Create Branch:** Creates branch from `main` with placeholder file
5. **Create PR:** Creates draft PR linking to the issue
6. **Comment:** Adds comment to issue with PR link

## Current Status

### Workflow Status
- ✅ **Active** - Workflow is enabled and active
- ✅ **Configured** - Correctly triggers on issue label events
- ⚠️ **Note:** Workflow runs may show as "failure" for push events (these are skipped by the `if` condition)

### Test Issue
- **Issue #61:** "this is a test issue" - Labeled with `bug` on 2026-01-13T22:03:16Z
- **Status:** No PR created (workflow may not have been active when label was added)

## Troubleshooting

### If PRs aren't being created:

1. **Check workflow is active:**
   ```bash
   gh workflow view auto-create-pr-on-bug-label.yml
   ```

2. **Check issue events:**
   ```bash
   gh api repos/linuxliam/disability/issues/<issue-number>/events
   ```

3. **Check workflow runs:**
   ```bash
   gh run list --workflow=auto-create-pr-on-bug-label.yml
   ```

4. **Verify label:**
   - Ensure issue has `bug` label
   - Label must be added (not just present)

5. **Check for existing PR:**
   ```bash
   gh pr list --json number,title,body --jq '.[] | select(.body | contains("#<issue-number>"))'
   ```

6. **Check for existing branch:**
   ```bash
   git ls-remote --heads origin fix/<issue-number>/bug-fix
   ```

### Common Issues

1. **Workflow not triggering:**
   - Ensure workflow file exists in `.github/workflows/`
   - Check workflow is enabled in GitHub Actions settings
   - Verify the label was added (not just present)

2. **Workflow skipping:**
   - Check the `if` condition matches
   - Verify `github.event.label.name == 'bug'`
   - Verify `github.event.action == 'labeled'`

3. **PR already exists:**
   - Workflow checks for PRs that reference the issue
   - If a PR exists, workflow skips creation

4. **Branch already exists:**
   - If branch `fix/<issue-number>/bug-fix` exists, workflow skips branch creation
   - PR creation step may still run if no PR exists

## Testing

To test the workflow:

1. Create a test issue:
   ```bash
   gh issue create --title "Test bug issue" --body "Testing auto-create PR workflow"
   ```

2. Add `bug` label:
   ```bash
   gh issue edit <issue-number> --add-label bug
   ```

3. Check workflow run:
   ```bash
   gh run list --workflow=auto-create-pr-on-bug-label.yml --limit 1
   ```

4. Verify PR was created:
   ```bash
   gh pr list --head fix/<issue-number>/bug-fix
   ```

## Workflow Steps

1. **Checkout code** - Checks out repository
2. **Configure Git** - Sets up git user for commits
3. **Check if PR exists** - Searches for existing PRs referencing the issue
4. **Check if branch exists** - Verifies branch doesn't already exist
5. **Create branch and commit** - Creates branch with placeholder file
6. **Create Pull Request** - Creates draft PR with issue link
7. **Summary** - Outputs summary of actions taken

## Related Documentation

- [Auto-Create Bug PR Documentation](./AUTO_BUG_PR.md)
- [GitHub Actions Workflows](../.github/workflows/)
