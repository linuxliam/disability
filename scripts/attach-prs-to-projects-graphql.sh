#!/bin/bash

# Script to attach PRs to projects using GraphQL API
# Note: Requires token with 'project' scope

set -e

# Get token from environment variable or GitHub CLI
if [ -z "$GITHUB_TOKEN" ]; then
    if command -v gh &> /dev/null; then
        GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "")
    fi
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Error: GITHUB_TOKEN environment variable not set"
    echo "   Set it with: export GITHUB_TOKEN=your_token"
    echo "   Or use: gh auth login"
    exit 1
fi

TOKEN="$GITHUB_TOKEN"
REPO_OWNER="linuxliam"
REPO_NAME="disability"

echo "Attaching PRs to milestone projects using GraphQL API..."
echo ""

# Get projects
echo "Fetching projects..."
PROJECTS_QUERY='query { repository(owner: "'$REPO_OWNER'", name: "'$REPO_NAME'") { projectsV2(first: 10) { nodes { id number title } } } }'

PROJECTS_RESPONSE=$(curl -s -X POST \
  -H "Authorization: bearer $TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.github.com/graphql" \
  -d "{\"query\": \"$PROJECTS_QUERY\"}")

# Check for errors
if echo "$PROJECTS_RESPONSE" | grep -q '"errors"'; then
    echo "❌ Error fetching projects:"
    echo "$PROJECTS_RESPONSE" | python3 -c "import sys, json; data = json.load(sys.stdin); print(json.dumps(data.get('errors', []), indent=2))" 2>/dev/null
    exit 1
fi

# Get PRs with milestones
echo "Fetching PRs..."
PRS_QUERY='query { repository(owner: "'$REPO_OWNER'", name: "'$REPO_NAME'") { pullRequests(first: 20, states: OPEN) { nodes { id number title milestone { title } } } } }'

PRS_RESPONSE=$(curl -s -X POST \
  -H "Authorization: bearer $TOKEN" \
  -H "Content-Type: application/json" \
  "https://api.github.com/graphql" \
  -d "{\"query\": \"$PRS_QUERY\"}")

# Parse projects into associative array (using Python)
PROJECT_MAP=$(echo "$PROJECTS_RESPONSE" | python3 << 'PYTHON'
import sys, json
data = json.load(sys.stdin)
projects = data.get('data', {}).get('repository', {}).get('projectsV2', {}).get('nodes', [])
for p in projects:
    print(f"{p['id']}|{p['number']}|{p['title']}")
PYTHON
)

# Parse PRs and attach to projects
echo "$PRS_RESPONSE" | python3 << 'PYTHON'
import sys, json
import subprocess

data = json.load(sys.stdin)
prs = data.get('data', {}).get('repository', {}).get('pullRequests', {}).get('nodes', [])

# Read project map from stdin (passed via environment or file)
# For now, we'll hardcode the mapping based on milestone names
milestone_to_project = {
    "v0.2.0 - Core Features": "v0.2.0 - Core Features",
    "v0.3.0 - Platform Optimization": "v0.3.0 - Platform Optimization",
    "v0.4.0 - Testing & Quality": "v0.4.0 - Testing & Quality",
    "v1.0.0-beta - Beta Release": "v1.0.0-beta - Beta Release",
    "v1.0.0 - Production Release": "v1.0.0 - Production Release",
    "v1.1.0+ - Post-Launch": "v1.1.0+ - Post-Launch"
}

import os
token = os.environ.get('GITHUB_TOKEN', '')
if not token:
    print("❌ Error: GITHUB_TOKEN environment variable not set")
    sys.exit(1)

# Get projects first
projects_query = '''
query {
  repository(owner: "linuxliam", name: "disability") {
    projectsV2(first: 10) {
      nodes {
        id
        number
        title
      }
    }
  }
}
'''

import urllib.request
import urllib.parse

def run_graphql(query):
    url = "https://api.github.com/graphql"
    data = json.dumps({"query": query}).encode('utf-8')
    req = urllib.request.Request(url, data=data)
    req.add_header('Authorization', f'bearer {token}')
    req.add_header('Content-Type', 'application/json')
    
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read())
    except Exception as e:
        return {"errors": [{"message": str(e)}]}

projects_data = run_graphql(projects_query)
projects = projects_data.get('data', {}).get('repository', {}).get('projectsV2', {}).get('nodes', [])

project_map = {p['title']: p['id'] for p in projects}

for pr in prs:
    milestone = pr.get('milestone', {}).get('title') if pr.get('milestone') else None
    if not milestone:
        print(f"⚠️  PR #{pr['number']}: No milestone - skipping")
        continue
    
    project_title = milestone_to_project.get(milestone)
    if not project_title:
        print(f"⚠️  PR #{pr['number']}: Unknown milestone '{milestone}' - skipping")
        continue
    
    project_id = project_map.get(project_title)
    if not project_id:
        print(f"⚠️  PR #{pr['number']}: Project '{project_title}' not found - skipping")
        continue
    
    # Add PR to project
    mutation = f'''
    mutation {{
      addProjectV2ItemById(input: {{
        projectId: "{project_id}"
        contentId: "{pr['id']}"
      }}) {{
        item {{
          id
        }}
      }}
    }}
    '''
    
    result = run_graphql(mutation)
    if result.get('errors'):
        print(f"❌ PR #{pr['number']}: Failed to add to project - {result['errors']}")
    else:
        print(f"✅ PR #{pr['number']}: Added to project '{project_title}'")
PYTHON

echo ""
echo "✅ Done!"
