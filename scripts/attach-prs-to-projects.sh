#!/bin/bash

# Script to attach PRs to their corresponding milestone projects
# 
# Prerequisites:
# 1. GitHub CLI (gh) must be installed: brew install gh
# 2. You must be authenticated: gh auth login
# 3. Projects must exist for each milestone

set -e

REPO="linuxliam/disability"

echo "Attaching PRs to milestone projects..."
echo ""

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found."
    echo "   Install: brew install gh"
    echo "   Login: gh auth login"
    exit 1
fi

# Get all open PRs with their milestones
echo "Fetching PRs and milestones..."
PRS=$(gh pr list --repo "$REPO" --state open --json number,title,milestone --jq '.[] | "\(.number)|\(.title)|\(.milestone.title // "None")"')

# Get all projects
echo "Fetching projects..."
PROJECTS=$(gh project list --owner "$REPO" --format json | jq -r '.[] | "\(.number)|\(.title)"')

# Map milestones to project names
declare -A MILESTONE_TO_PROJECT=(
    ["v0.2.0 - Core Features"]="v0.2.0 - Core Features"
    ["v0.3.0 - Platform Optimization"]="v0.3.0 - Platform Optimization"
    ["v0.4.0 - Testing & Quality"]="v0.4.0 - Testing & Quality"
    ["v1.0.0-beta - Beta Release"]="v1.0.0-beta - Beta Release"
    ["v1.0.0 - Production Release"]="v1.0.0 - Production Release"
    ["v1.1.0+ - Post-Launch"]="v1.1.0+ - Post-Launch"
)

# Process each PR
while IFS='|' read -r pr_number pr_title milestone; do
    if [ "$milestone" = "None" ]; then
        echo "⚠️  PR #$pr_number: No milestone - skipping"
        continue
    fi
    
    # Find project number for this milestone
    project_number=""
    while IFS='|' read -r proj_num proj_title; do
        if [ "$proj_title" = "${MILESTONE_TO_PROJECT[$milestone]}" ]; then
            project_number=$proj_num
            break
        fi
    done <<< "$PROJECTS"
    
    if [ -z "$project_number" ]; then
        echo "⚠️  PR #$pr_number: Project for milestone '$milestone' not found"
        continue
    fi
    
    echo "📌 Adding PR #$pr_number to project #$project_number ($milestone)..."
    
    # Add PR to project using gh CLI
    if gh project item-add "$project_number" --owner "$REPO" --url "https://github.com/$REPO/pull/$pr_number" 2>/dev/null; then
        echo "   ✅ Added PR #$pr_number to project"
    else
        echo "   ⚠️  PR may already be in project or failed to add"
    fi
    
done <<< "$PRS"

echo ""
echo "✅ Done!"
echo ""
echo "To verify, check projects at: https://github.com/$REPO/projects"
