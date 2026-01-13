# Quick Branch Protection Setup

## Fastest Method (One Command)

If you have a GitHub Personal Access Token:

```bash
GITHUB_TOKEN=your_token_here ./scripts/setup-with-token.sh
```

## Get Your Token

1. Visit: https://github.com/settings/tokens/new
2. Name: "Branch Protection Setup"
3. Expiration: Choose your preference
4. Scopes: Check `repo` and `admin:repo_hook`
5. Click "Generate token"
6. Copy the token immediately

## Alternative: GitHub CLI

```bash
# Authenticate once
gh auth login

# Then run
./scripts/setup-branch-protection-gh.sh
```

## What Gets Protected

- **main**: Requires PR with 1 approval, status checks, no force push
- **develop**: Requires PR with 1 approval, no force push

## Verify

After running, check: https://github.com/linuxliam/disability/settings/branches
