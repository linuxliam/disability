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
RESPONSE=$(curl -s -w "\n%{http_code}" -X PUT \
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
  }')

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ main branch protected successfully!"
elif [ "$HTTP_CODE" = "403" ]; then
    if echo "$BODY" | grep -q "Upgrade to GitHub Pro"; then
        echo "⚠️  Branch protection requires GitHub Pro for private repositories"
        echo "   Options:"
        echo "   1. Make repository public, or"
        echo "   2. Upgrade to GitHub Pro"
        echo "   3. Set up protection manually at: https://github.com/$REPO/settings/branches"
    else
        echo "⚠️  Permission denied. Check token permissions."
    fi
elif [ "$HTTP_CODE" = "404" ]; then
    echo "⚠️  Repository or branch not found"
else
    echo "⚠️  main branch (HTTP $HTTP_CODE - may already be protected)"
fi

echo ""

# Setup develop branch
echo "📋 Protecting 'develop' branch..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X PUT \
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
  }')

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ develop branch protected successfully!"
elif [ "$HTTP_CODE" = "403" ]; then
    if echo "$BODY" | grep -q "Upgrade to GitHub Pro"; then
        echo "⚠️  Branch protection requires GitHub Pro for private repositories"
    else
        echo "⚠️  Permission denied. Check token permissions."
    fi
elif [ "$HTTP_CODE" = "404" ]; then
    echo "⚠️  Branch 'develop' not found (create it first)"
else
    echo "⚠️  develop branch (HTTP $HTTP_CODE - may already be protected)"
fi

echo ""
echo "✨ Setup complete!"
echo "Verify at: https://github.com/$REPO/settings/branches"
