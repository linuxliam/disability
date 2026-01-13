#!/bin/bash

# Setup Branch Protection using GitHub Token
# Usage: GITHUB_TOKEN=your_token ./scripts/setup-with-token.sh

set -e

REPO="linuxliam/disability"

if [ -z "$GITHUB_TOKEN" ] && [ -z "$GH_TOKEN" ]; then
    echo "❌ Error: GitHub token required"
    echo ""
    echo "Usage:"
    echo "  GITHUB_TOKEN=your_token ./scripts/setup-with-token.sh"
    echo ""
    echo "Or set it as an environment variable:"
    echo "  export GITHUB_TOKEN=your_token"
    echo "  ./scripts/setup-with-token.sh"
    echo ""
    echo "Get a token at: https://github.com/settings/tokens"
    echo "Required scopes: repo, admin:repo_hook"
    exit 1
fi

TOKEN="${GITHUB_TOKEN:-$GH_TOKEN}"
export GH_TOKEN="$TOKEN"

echo "🔒 Setting up branch protection for $REPO"
echo ""

# Setup main branch
echo "📋 Protecting 'main' branch..."
curl -X PUT \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO/branches/main/protection" \
  -d '{
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
  }' 2>/dev/null && echo "✅ main branch protected" || echo "⚠️  main branch (may already be protected)"

echo ""

# Setup develop branch
echo "📋 Protecting 'develop' branch..."
curl -X PUT \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO/branches/develop/protection" \
  -d '{
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
  }' 2>/dev/null && echo "✅ develop branch protected" || echo "⚠️  develop branch (may already be protected)"

echo ""
echo "✨ Setup complete!"
echo "Verify at: https://github.com/$REPO/settings/branches"
