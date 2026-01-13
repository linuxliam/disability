#!/bin/bash

# Setup Branch Protection Rules for Disability Advocacy Project
# This script configures branch protection rules for main and develop branches

set -e

REPO="linuxliam/disability"

echo "🔒 Setting up branch protection rules for $REPO"
echo ""

# Check if authenticated
if ! gh auth status &>/dev/null; then
    echo "❌ Not authenticated with GitHub CLI"
    echo "Please run: gh auth login"
    exit 1
fi

echo "✅ Authenticated with GitHub CLI"
echo ""

# Function to set branch protection
setup_branch_protection() {
    local branch=$1
    local require_reviews=$2
    local require_status_checks=$3
    
    echo "📋 Configuring protection for '$branch' branch..."
    
    # Build the protection command
    local cmd="gh api repos/$REPO/branches/$branch/protection \
        --method PUT \
        --field required_status_checks='{\"strict\":true,\"contexts\":[]}' \
        --field enforce_admins=true \
        --field required_pull_request_reviews='{\"required_approving_review_count\":$require_reviews,\"dismiss_stale_reviews\":true,\"require_code_owner_reviews\":false}' \
        --field restrictions=null"
    
    if [ "$require_status_checks" = "true" ]; then
        cmd="$cmd --field required_status_checks='{\"strict\":true,\"contexts\":[\"build-ios\",\"build-macos\",\"test-ios\"]}'"
    fi
    
    # Execute the command
    if eval "$cmd" 2>/dev/null; then
        echo "✅ Branch protection configured for '$branch'"
    else
        echo "⚠️  Failed to configure protection for '$branch' (may already be configured or insufficient permissions)"
    fi
    echo ""
}

# Configure main branch (strict protection)
echo "🔐 Setting up MAIN branch protection (strict)..."
setup_branch_protection "main" 1 true

# Configure develop branch (moderate protection)
echo "🔐 Setting up DEVELOP branch protection (moderate)..."
setup_branch_protection "develop" 1 false

echo "✨ Branch protection setup complete!"
echo ""
echo "📝 Summary:"
echo "  - main: Requires PR reviews (1 approval), status checks, no force push"
echo "  - develop: Requires PR reviews (1 approval), no force push"
echo ""
echo "💡 To verify, visit: https://github.com/$REPO/settings/branches"
