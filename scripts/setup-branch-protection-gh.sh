#!/bin/bash

# Branch Protection Setup using GitHub CLI
# This script uses 'gh' CLI for easier authentication

set -e

REPO="linuxliam/disability"

echo "🔒 Branch Protection Setup - GitHub CLI Method"
echo "=============================================="
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo ""
    echo "Install it with: brew install gh"
    echo "Or use the token method: ./scripts/setup-with-token.sh"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "🔐 GitHub CLI is not authenticated."
    echo ""
    echo "Starting authentication process..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "You'll be prompted to:"
    echo "  1. Choose authentication method (browser recommended)"
    echo "  2. Authorize the CLI in your browser"
    echo ""
    read -p "Press Enter to start authentication, or Ctrl+C to cancel..."
    echo ""
    
    gh auth login
    echo ""
fi

echo "✅ Authenticated with GitHub!"
echo ""

# Verify repository access
echo "🔍 Verifying repository access..."
if ! gh repo view "$REPO" &> /dev/null; then
    echo "❌ Cannot access repository: $REPO"
    echo "   Make sure you have the correct permissions."
    exit 1
fi
echo "✅ Repository access confirmed!"
echo ""

# Setup main branch protection
echo "📋 Protecting 'main' branch..."
if gh api "repos/$REPO/branches/main/protection" \
    -X PUT \
    --input - <<EOF
{
  "required_status_checks": {
    "strict": true,
    "contexts": []
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
then
    echo "✅ main branch protected successfully!"
else
    echo "⚠️  Could not protect main branch (may already be protected)"
fi
echo ""

# Setup develop branch protection
echo "📋 Protecting 'develop' branch..."
if gh api "repos/$REPO/branches/develop/protection" \
    -X PUT \
    --input - <<EOF
{
  "required_status_checks": {
    "strict": false,
    "contexts": []
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
then
    echo "✅ develop branch protected successfully!"
else
    echo "⚠️  Could not protect develop branch (may not exist or already protected)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✨ Setup complete!"
echo ""
echo "📊 Verify your branch protection at:"
echo "   https://github.com/$REPO/settings/branches"
echo ""
echo "🔒 Protection Summary:"
echo "   • main: Requires PR (1 approval), status checks, no force push"
echo "   • develop: Requires PR (1 approval), no force push"
echo ""
