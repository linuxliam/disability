#!/bin/bash

# Script to create GitHub Projects for each milestone
# 
# Prerequisites:
# 1. GitHub CLI (gh) must be installed: brew install gh
# 2. You must be authenticated: gh auth login
# 3. Or use a token with 'project' scope: export GITHUB_TOKEN=your_token_with_project_scope

set -e

REPO="linuxliam/disability"
MILESTONES=(
    "v0.2.0 - Core Features"
    "v0.3.0 - Platform Optimization"
    "v0.4.0 - Testing & Quality"
    "v1.0.0-beta - Beta Release"
    "v1.0.0 - Production Release"
    "v1.1.0+ - Post-Launch"
)

echo "Creating GitHub Projects for milestones..."
echo ""

# Check if gh CLI is available
if command -v gh &> /dev/null; then
    echo "Using GitHub CLI (gh)"
    
    for milestone in "${MILESTONES[@]}"; do
        echo "Creating project: $milestone"
        
        # Create project using gh CLI
        gh project create "$milestone" \
            --owner "$REPO" \
            --body "Project board for $milestone milestone. Track issues and PRs for this milestone." \
            --format json | jq -r '.url' || echo "  ⚠️  Project may already exist or failed to create"
        
        echo ""
    done
    
    echo "✅ Projects created!"
    echo ""
    echo "Next steps:"
    echo "1. Go to https://github.com/$REPO/projects"
    echo "2. For each project, add issues from the corresponding milestone"
    echo "3. Set up columns (e.g., To Do, In Progress, Done)"
    
else
    echo "GitHub CLI (gh) not found."
    echo ""
    echo "Option 1: Install GitHub CLI"
    echo "  brew install gh"
    echo "  gh auth login"
    echo "  Then run this script again"
    echo ""
    echo "Option 2: Create projects manually"
    echo "  1. Go to https://github.com/$REPO/projects"
    echo "  2. Click 'New project'"
    echo "  3. Create a project for each milestone:"
    for milestone in "${MILESTONES[@]}"; do
        echo "     - $milestone"
    done
    echo ""
    echo "Option 3: Use GraphQL API with token that has 'project' scope"
    echo "  Update your token at: https://github.com/settings/tokens"
    echo "  Add 'project' scope"
    echo "  Then use the GraphQL mutation:"
    echo ""
    echo "  mutation {"
    echo "    createProjectV2(input: {"
    echo "      ownerId: \"R_kgDOQ4ucIw\""
    echo "      title: \"MILESTONE_NAME\""
    echo "    }) {"
    echo "      projectV2 {"
    echo "        id"
    echo "        number"
    echo "        title"
    echo "        url"
    echo "      }"
    echo "    }"
    echo "  }"
fi
