#!/bin/bash

# Simple Branch Protection Setup Script
# Alternative method using gh CLI branch protection commands

set -e

REPO="linuxliam/disability"

echo "🔒 Setting up branch protection rules (Simple Method)"
echo ""

# Check authentication
if ! gh auth status &>/dev/null; then
    echo "❌ Please authenticate first: gh auth login"
    exit 1
fi

echo "📋 Setting protection for 'main' branch..."
gh api repos/$REPO/branches/main/protection \
    --method PUT \
    -f required_status_checks='{"strict":true,"contexts":[]}' \
    -f enforce_admins=true \
    -f required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
    -f restrictions=null \
    -f allow_force_pushes=false \
    -f allow_deletions=false 2>/dev/null && echo "✅ main branch protected" || echo "⚠️  main branch protection may already exist"

echo ""
echo "📋 Setting protection for 'develop' branch..."
gh api repos/$REPO/branches/develop/protection \
    --method PUT \
    -f required_status_checks='{"strict":false,"contexts":[]}' \
    -f enforce_admins=false \
    -f required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
    -f restrictions=null \
    -f allow_force_pushes=false \
    -f allow_deletions=false 2>/dev/null && echo "✅ develop branch protected" || echo "⚠️  develop branch protection may already exist"

echo ""
echo "✨ Done! Visit https://github.com/$REPO/settings/branches to verify"
