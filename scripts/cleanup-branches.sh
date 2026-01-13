#!/bin/bash

# Script to clean up merged and unused branches
# 
# This script will:
# 1. Delete branches that have been merged into develop or main
# 2. Delete branches with no open PRs
# 3. Keep branches with active open PRs
# 4. Keep main and develop branches

set -e

REPO="linuxliam/disability"
TOKEN="${GITHUB_TOKEN:-}"

if [ -z "$TOKEN" ]; then
    echo "❌ Error: GITHUB_TOKEN not set"
    echo "   Set it with: export GITHUB_TOKEN=your_token"
    exit 1
fi

echo "🧹 Branch Cleanup Script"
echo "========================"
echo ""

# Fetch latest
echo "Fetching latest branches..."
git fetch --prune origin

# Get all feature/milestone/release branches
ALL_BRANCHES=$(git branch -r | grep -E "feature|milestone|release" | sed 's|origin/||' | sort)

echo "Analyzing branches..."
echo ""

KEEP_BRANCHES=()
DELETE_BRANCHES=()

for branch in $ALL_BRANCHES; do
    # Skip main and develop
    if [ "$branch" = "main" ] || [ "$branch" = "develop" ]; then
        continue
    fi
    
    # Check if branch has open PR
    HAS_OPEN_PR=$(curl -s -H "Authorization: token $TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/$REPO/pulls?head=linuxliam:$branch&state=open" | \
        python3 -c "import sys, json; prs = json.load(sys.stdin); print('yes' if prs else 'no')" 2>/dev/null)
    
    # Check if merged into develop
    if git merge-base --is-ancestor origin/"$branch" origin/develop 2>/dev/null; then
        DELETE_BRANCHES+=("$branch")
        echo "🗑️  DELETE: $branch (merged into develop)"
    # Check if merged into main
    elif git merge-base --is-ancestor origin/"$branch" origin/main 2>/dev/null; then
        DELETE_BRANCHES+=("$branch")
        echo "🗑️  DELETE: $branch (merged into main)"
    # Check if has open PR
    elif [ "$HAS_OPEN_PR" = "yes" ]; then
        KEEP_BRANCHES+=("$branch")
        echo "✅ KEEP: $branch (has open PR)"
    else
        DELETE_BRANCHES+=("$branch")
        echo "🗑️  DELETE: $branch (no open PR)"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Summary:"
echo "  Branches to keep: ${#KEEP_BRANCHES[@]}"
echo "  Branches to delete: ${#DELETE_BRANCHES[@]}"
echo ""

if [ ${#DELETE_BRANCHES[@]} -eq 0 ]; then
    echo "✅ No branches to delete!"
    exit 0
fi

echo "Branches to delete:"
for branch in "${DELETE_BRANCHES[@]}"; do
    echo "  • $branch"
done

echo ""
read -p "Delete these branches? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Cancelled"
    exit 0
fi

echo ""
echo "Deleting branches..."
for branch in "${DELETE_BRANCHES[@]}"; do
    echo "  Deleting $branch..."
    git push origin --delete "$branch" 2>/dev/null || echo "    ⚠️  Could not delete $branch (may not exist)"
done

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "Remaining branches:"
for branch in "${KEEP_BRANCHES[@]}"; do
    echo "  • $branch"
done
