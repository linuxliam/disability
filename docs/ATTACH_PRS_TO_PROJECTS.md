# Attach PRs to Projects

This guide explains how to attach pull requests to their corresponding milestone projects.

## Overview

Each PR should be added to the project board for its milestone to track progress visually.

## Current PRs and Their Milestones

Based on the open PRs:

- **PR #41**: [v0.2.0] Enhance Resources Features → **v0.2.0 - Core Features**
- **PR #42**: [v0.2.0] Enhance Events Features → **v0.2.0 - Core Features**
- **PR #43**: [v0.2.0] Add Profile and Favorites Features → **v0.2.0 - Core Features**
- **PR #39**: [v1.0.0-beta] Create User Documentation → **v1.0.0-beta - Beta Release**

## Method 1: Using GitHub CLI (Recommended)

### Prerequisites

```bash
# Install GitHub CLI
brew install gh

# Authenticate
gh auth login
```

### Automated Script

```bash
# Run the script
./scripts/attach-prs-to-projects.sh
```

### Manual Steps

1. **List projects:**
   ```bash
   gh project list --owner linuxliam/disability
   ```

2. **Add PR to project:**
   ```bash
   # Get project number first (e.g., 1, 2, 3...)
   gh project item-add <PROJECT_NUMBER> \
     --owner linuxliam/disability \
     --url https://github.com/linuxliam/disability/pull/41
   ```

3. **Repeat for each PR:**
   ```bash
   gh project item-add 1 --owner linuxliam/disability --url https://github.com/linuxliam/disability/pull/41
   gh project item-add 1 --owner linuxliam/disability --url https://github.com/linuxliam/disability/pull/42
   gh project item-add 1 --owner linuxliam/disability --url https://github.com/linuxliam/disability/pull/43
   gh project item-add 4 --owner linuxliam/disability --url https://github.com/linuxliam/disability/pull/39
   ```

## Method 2: Manual via GitHub UI

1. **Go to the project board:**
   - Navigate to: https://github.com/linuxliam/disability/projects
   - Select the project for the milestone (e.g., "v0.2.0 - Core Features")

2. **Add PR to project:**
   - Click **"Add cards"** button
   - Search for the PR number (e.g., "41")
   - Click to add it to the project
   - Drag to appropriate column (e.g., "In Progress" or "To Do")

3. **Repeat for each PR:**
   - PR #41, #42, #43 → v0.2.0 - Core Features project
   - PR #39 → v1.0.0-beta - Beta Release project

## Method 3: Using GraphQL API

If you have a token with `project` scope:

```bash
# Get project ID
PROJECT_ID=$(curl -s -X POST \
  -H "Authorization: bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.github.com/graphql" \
  -d '{"query":"query { repository(owner: \"linuxliam\", name: \"disability\") { projectsV2(first: 10) { nodes { id number title } } } }"}' \
  | jq -r '.data.repository.projectsV2.nodes[] | select(.title == "v0.2.0 - Core Features") | .id')

# Get PR node ID
PR_ID=$(curl -s -H "Authorization: bearer YOUR_TOKEN" \
  "https://api.github.com/graphql" \
  -d '{"query":"query { repository(owner: \"linuxliam\", name: \"disability\") { pullRequest(number: 41) { id } } }"}' \
  | jq -r '.data.repository.pullRequest.id')

# Add PR to project
curl -s -X POST \
  -H "Authorization: bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.github.com/graphql" \
  -d "{\"query\":\"mutation { addProjectV2ItemById(input: {projectId: \\\"$PROJECT_ID\\\", contentId: \\\"$PR_ID\\\"}) { item { id } } }\"}"
```

## Quick Reference: PR to Project Mapping

| PR # | Title | Milestone | Project |
|------|-------|-----------|---------|
| #41 | Enhance Resources Features | v0.2.0 - Core Features | v0.2.0 - Core Features |
| #42 | Enhance Events Features | v0.2.0 - Core Features | v0.2.0 - Core Features |
| #43 | Add Profile and Favorites | v0.2.0 - Core Features | v0.2.0 - Core Features |
| #39 | Create User Documentation | v1.0.0-beta - Beta Release | v1.0.0-beta - Beta Release |

## Automation: GitHub Actions

You can automate this with a GitHub Action workflow:

```yaml
name: Add PRs to Projects

on:
  pull_request:
    types: [opened, labeled]

jobs:
  add-to-project:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/add-to-project@v0.5.0
        with:
          project-url: https://github.com/linuxliam/disability/projects/<PROJECT_NUMBER>
          github-token: ${{ secrets.GITHUB_TOKEN }}
          labeled: true
          label-operator: OR
```

## Notes

- Projects must exist before PRs can be added
- PRs can be in multiple projects if needed
- Projects can be filtered by milestone
- Use columns to track PR status (To Do, In Progress, Done)
