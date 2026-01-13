#!/bin/bash

# Automatic Branch Protection Setup
# Tries multiple methods to authenticate and set up protection

set -e

REPO="linuxliam/disability"

echo "🔒 Automatic Branch Protection Setup"
echo "====================================="
echo ""

# Method 1: Check for token in environment
if [ -n "$GITHUB_TOKEN" ]; then
    echo "✅ Found GITHUB_TOKEN in environment"
    TOKEN="$GITHUB_TOKEN"
    METHOD="token"
# Method 2: Check for GitHub CLI
elif command -v gh &> /dev/null && gh auth status &> /dev/null; then
    echo "✅ GitHub CLI is authenticated"
    METHOD="gh"
# Method 3: Try to use gh auth token
elif command -v gh &> /dev/null; then
    echo "⚠️  GitHub CLI found but not authenticated"
    echo ""
    echo "Authenticating with GitHub CLI..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "You'll need to authenticate. Choose:"
    echo "  1. Browser (recommended) - will open GitHub"
    echo "  2. Token - paste a personal access token"
    echo ""
    read -p "Press Enter to start authentication (or Ctrl+C to cancel)..."
    
    if gh auth login; then
        METHOD="gh"
    else
        echo "❌ Authentication failed"
        exit 1
    fi
else
    echo "❌ No authentication method available"
    echo ""
    echo "Please either:"
    echo "  1. Set GITHUB_TOKEN environment variable, or"
    echo "  2. Install and authenticate GitHub CLI: brew install gh && gh auth login"
    exit 1
fi

echo ""
echo "🔍 Verifying access to repository: $REPO"
echo ""

# Verify access
if [ "$METHOD" = "token" ]; then
    if curl -s -H "Authorization: token $TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/repos/$REPO" | grep -q '"name"'; then
        echo "✅ Repository access confirmed!"
    else
        echo "❌ Cannot access repository. Check token permissions."
        exit 1
    fi
elif [ "$METHOD" = "gh" ]; then
    if gh repo view "$REPO" &> /dev/null; then
        echo "✅ Repository access confirmed!"
    else
        echo "❌ Cannot access repository. Check permissions."
        exit 1
    fi
fi

echo ""
echo "📋 Setting up branch protection..."
echo ""

# Protect main branch
echo "🔒 Protecting 'main' branch..."
if [ "$METHOD" = "token" ]; then
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
        echo "✅ main branch protected!"
    else
        echo "⚠️  main branch (HTTP $HTTP_CODE - may already be protected)"
    fi
else
    if gh api "repos/$REPO/branches/main/protection" -X PUT --input - <<EOF &> /dev/null
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
        echo "✅ main branch protected!"
    else
        echo "⚠️  main branch (may already be protected)"
    fi
fi

# Protect develop branch
echo "🔒 Protecting 'develop' branch..."
if [ "$METHOD" = "token" ]; then
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
        echo "✅ develop branch protected!"
    elif [ "$HTTP_CODE" = "404" ]; then
        echo "⚠️  develop branch not found (create it first)"
    else
        echo "⚠️  develop branch (HTTP $HTTP_CODE - may already be protected)"
    fi
else
    if gh api "repos/$REPO/branches/develop/protection" -X PUT --input - <<EOF &> /dev/null
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
        echo "✅ develop branch protected!"
    else
        echo "⚠️  develop branch (may not exist or already protected)"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✨ Setup complete!"
echo ""
echo "📊 Verify at: https://github.com/$REPO/settings/branches"
echo ""
