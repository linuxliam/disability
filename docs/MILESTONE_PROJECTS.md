# Milestone Projects Setup

This document explains how to create GitHub Projects for each milestone to track progress.

## Overview

Each milestone should have its own GitHub Project board to:
- Track issues and PRs for that milestone
- Visualize progress
- Organize work by status (To Do, In Progress, Done)

## Milestones

The following milestones need projects:

1. **v0.2.0 - Core Features** (8 issues)
2. **v0.3.0 - Platform Optimization** (5 issues)
3. **v0.4.0 - Testing & Quality** (3 issues)
4. **v1.0.0-beta - Beta Release** (2 issues)
5. **v1.0.0 - Production Release** (2 issues)
6. **v1.1.0+ - Post-Launch** (2 issues)

## Method 1: Using GitHub CLI (Recommended)

### Prerequisites

```bash
# Install GitHub CLI
brew install gh

# Authenticate
gh auth login
```

### Create Projects

```bash
# Run the script
./scripts/create-milestone-projects.sh
```

Or manually:

```bash
gh project create "v0.2.0 - Core Features" \
  --owner linuxliam/disability \
  --body "Project board for v0.2.0 - Core Features milestone"

gh project create "v0.3.0 - Platform Optimization" \
  --owner linuxliam/disability \
  --body "Project board for v0.3.0 - Platform Optimization milestone"

# ... repeat for each milestone
```

## Method 2: Manual Creation via GitHub UI

1. Go to https://github.com/linuxliam/disability/projects
2. Click **"New project"**
3. Select **"Board"** template
4. Name it after the milestone (e.g., "v0.2.0 - Core Features")
5. Add description: "Project board for [milestone name] milestone"
6. Click **"Create project"**
7. Repeat for each milestone

## Method 3: Using GraphQL API

If you have a token with `project` scope:

```bash
# Get repository node ID (already known: R_kgDOQ4ucIw)

# Create project
curl -X POST \
  -H "Authorization: bearer YOUR_TOKEN_WITH_PROJECT_SCOPE" \
  -H "Content-Type: application/json" \
  https://api.github.com/graphql \
  -d '{
    "query": "mutation { createProjectV2(input: {ownerId: \"R_kgDOQ4ucIw\", title: \"v0.2.0 - Core Features\"}) { projectV2 { id number title url } } }"
  }'
```

## Setting Up Projects

After creating projects:

### 1. Add Columns

For each project, set up columns:
- **To Do** - Issues not started
- **In Progress** - Issues being worked on
- **Done** - Completed issues

### 2. Add Issues

For each project:
1. Click **"Add cards"**
2. Search for issues by milestone
3. Add all issues from that milestone
4. Drag issues to appropriate columns

### 3. Link PRs

When PRs are created:
1. Add PR to the project
2. Move to "In Progress" when work starts
3. Move to "Done" when merged

### 4. Set Up Automation (Optional)

You can automate column movement:
- When issue is closed → Move to "Done"
- When PR is opened → Move to "In Progress"
- When PR is merged → Move to "Done"

## Current Status

To check which projects exist:

```bash
gh project list --owner linuxliam/disability
```

Or visit: https://github.com/linuxliam/disability/projects

## Notes

- Projects are repository-level (not organization-level)
- Each project can track issues and PRs
- Projects can be filtered by milestone
- Use labels for additional categorization
