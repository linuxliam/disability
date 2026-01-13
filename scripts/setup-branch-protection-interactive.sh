#!/bin/bash

# Interactive Branch Protection Setup
# This script will prompt you for your GitHub token and set up branch protection

set -e

REPO="linuxliam/disability"

echo "🔒 Branch Protection Setup - Token Method"
echo "=========================================="
echo ""
echo "This will set up branch protection for:"
echo "  • main branch (strict protection)"
echo "  • develop branch (moderate protection)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Step 1: Get your GitHub Personal Access Token"
echo ""
echo "If you don't have a token yet:"
echo "  1. Visit: https://github.com/settings/tokens"
echo "  2. Click 'Generate new token (classic)'"
echo "  3. Name it (e.g., 'Branch Protection Setup')"
echo "  4. Select scopes: repo, admin:repo_hook"
echo "  5. Click 'Generate token'"
echo "  6. Copy the token (you won't see it again!)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Prompt for token
read -sp "Enter your GitHub Personal Access Token: " TOKEN
echo ""
echo ""

if [ -z "$TOKEN" ]; then
    echo "❌ Token cannot be empty. Exiting."
    exit 1
fi

echo "🔐 Token received. Setting up branch protection..."
echo ""

# Test token
echo "🔍 Verifying token..."
if curl -s -H "Authorization: token $TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/user" | grep -q '"login"'; then
    echo "✅ Token is valid!"
    echo ""
else
    echo "❌ Token verification failed. Please check your token and try again."
    exit 1
fi

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
if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ main branch protected successfully!"
elif [ "$HTTP_CODE" = "404" ]; then
    echo "⚠️  Repository or branch not found. Check repository name and permissions."
    exit 1
elif [ "$HTTP_CODE" = "403" ]; then
    echo "⚠️  Permission denied. Ensure your token has 'admin:repo_hook' scope."
    exit 1
else
    echo "⚠️  main branch (HTTP $HTTP_CODE - may already be protected or need different settings)"
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
if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ develop branch protected successfully!"
elif [ "$HTTP_CODE" = "404" ]; then
    echo "⚠️  Branch 'develop' not found. Make sure it exists on GitHub."
elif [ "$HTTP_CODE" = "403" ]; then
    echo "⚠️  Permission denied. Ensure your token has 'admin:repo_hook' scope."
else
    echo "⚠️  develop branch (HTTP $HTTP_CODE - may already be protected)"
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
