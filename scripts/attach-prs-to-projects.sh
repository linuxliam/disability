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

# Get all projects using REST API
echo "Fetching projects..."
TOKEN="${GITHUB_TOKEN:-$(gh auth token 2>/dev/null || echo '')}"
if [ -z "$TOKEN" ]; then
    echo "❌ Error: GITHUB_TOKEN not set and gh auth token not available"
    exit 1
fi

PROJECTS_JSON=$(curl -s -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO/projects")

PROJECTS=$(echo "$PROJECTS_JSON" | python3 -c "
import sys, json
try:
    projects = json.load(sys.stdin)
    for p in projects:
        print(f\"{p['number']}|{p['name']}\")
except:
    print('')
" 2>/dev/null)

if [ -z "$PROJECTS" ]; then
    echo "⚠️  No projects found. Projects may need to be created first."
    echo "   See docs/MILESTONE_PROJECTS.md for instructions"
fi

# Function to get project number by title
get_project_number() {
    local milestone_title="$1"
    echo "$PROJECTS" | while IFS='|' read -r proj_num proj_title; do
        if [ "$proj_title" = "$milestone_title" ]; then
            echo "$proj_num"
            return
        fi
    done
}

# Process each PR
while IFS='|' read -r pr_number pr_title milestone; do
    if [ "$milestone" = "None" ]; then
        echo "⚠️  PR #$pr_number: No milestone - skipping"
        continue
    fi
    
    # Find project number for this milestone (project name should match milestone)
    project_number=$(get_project_number "$milestone")
    
    if [ -z "$project_number" ]; then
        echo "⚠️  PR #$pr_number: Project for milestone '$milestone' not found"
        echo "   Available projects:"
        echo "$PROJECTS" | while IFS='|' read -r proj_num proj_title; do
            echo "     - $proj_title (Project #$proj_num)"
        done
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
