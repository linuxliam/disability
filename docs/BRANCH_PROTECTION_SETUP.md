# Branch Protection Setup Guide

This guide will help you set up branch protection rules for the Disability Advocacy project.

## Quick Setup

### Option 1: Using GitHub CLI (Recommended)

1. **Authenticate with GitHub CLI:**
   ```bash
   gh auth login
   ```
   Follow the prompts to authenticate (browser or token).

2. **Run the setup script:**
   ```bash
   ./scripts/setup-branch-protection-simple.sh
   ```

### Option 2: Manual Setup via GitHub Web Interface

1. Go to: https://github.com/linuxliam/disability/settings/branches

2. **For `main` branch:**
   - Click "Add rule" or edit existing rule for `main`
   - Configure:
     - ✅ Require a pull request before merging
       - Require approvals: 1
       - Dismiss stale pull request approvals when new commits are pushed
     - ✅ Require status checks to pass before merging
       - Require branches to be up to date before merging
     - ✅ Require conversation resolution before merging
     - ✅ Do not allow bypassing the above settings
     - ✅ Restrict who can push to matching branches (optional)
     - ❌ Allow force pushes
     - ❌ Allow deletions

3. **For `develop` branch:**
   - Click "Add rule" for `develop`
   - Configure:
     - ✅ Require a pull request before merging
       - Require approvals: 1
       - Dismiss stale pull request approvals when new commits are pushed
     - ❌ Require status checks (optional, can enable later)
     - ✅ Do not allow bypassing the above settings
     - ❌ Allow force pushes
     - ❌ Allow deletions

## Protection Rules Summary

### `main` Branch (Strict)
- ✅ Requires pull request with 1 approval
- ✅ Requires status checks to pass
- ✅ Requires branches to be up to date
- ❌ No force pushes
- ❌ No deletions
- ✅ Admins must follow rules

### `develop` Branch (Moderate)
- ✅ Requires pull request with 1 approval
- ❌ Status checks optional (can enable later)
- ❌ No force pushes
- ❌ No deletions
- ⚠️ Admins can bypass (for emergency fixes)

## Verification

After setup, verify the rules are active:

1. Try to push directly to `main`:
   ```bash
   git checkout main
   git commit --allow-empty -m "Test direct push"
   git push origin main
   ```
   This should be **blocked** if protection is working.

2. Check the branch protection status:
   ```bash
   gh api repos/linuxliam/disability/branches/main/protection
   ```

## Troubleshooting

### "Permission denied" errors
- Ensure you have admin access to the repository
- Check your GitHub CLI authentication: `gh auth status`

### Script fails silently
- Check repository permissions
- Verify branch names match exactly: `main` and `develop`
- Try the manual setup method instead

### Need to modify rules later
- Use GitHub web interface: https://github.com/linuxliam/disability/settings/branches
- Or use GitHub CLI: `gh api repos/linuxliam/disability/branches/main/protection --method PUT ...`

## Advanced Configuration

### Custom Status Checks
To require specific CI/CD checks:
```bash
gh api repos/linuxliam/disability/branches/main/protection \
  --method PUT \
  -f required_status_checks='{"strict":true,"contexts":["build-ios","build-macos","test-ios"]}'
```

### Code Owner Reviews
To require code owner reviews:
```bash
gh api repos/linuxliam/disability/branches/main/protection \
  --method PUT \
  -f required_pull_request_reviews='{"required_approving_review_count":1,"require_code_owner_reviews":true}'
```

## Best Practices

1. **Start Strict, Relax Later**: Begin with strict rules, then adjust as needed
2. **Monitor PR Flow**: Ensure protection rules don't block legitimate workflows
3. **Emergency Access**: Consider keeping admin bypass for `develop` branch
4. **Document Exceptions**: If rules need to be bypassed, document why
5. **Regular Review**: Periodically review and update protection rules

## Related Documentation

- [Branching Strategy](./BRANCHING_STRATEGY.md)
- [CI/CD Guide](./CI_CD.md)
