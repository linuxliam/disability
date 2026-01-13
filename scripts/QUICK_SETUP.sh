#!/bin/bash

# Quick Setup Script for Branch Protection
# Run this script to set up branch protection rules

set -e

echo "🔒 Branch Protection Quick Setup"
echo "================================"
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo "Install it with: brew install gh"
    exit 1
fi

# Check authentication
if ! gh auth status &>/dev/null; then
    echo "🔐 GitHub CLI authentication required"
    echo ""
    echo "Choose authentication method:"
    echo "1. Web browser (recommended)"
    echo "2. Token"
    echo ""
    read -p "Enter choice (1 or 2): " auth_choice
    
    case $auth_choice in
        1)
            echo "Opening browser for authentication..."
            gh auth login --web
            ;;
        2)
            echo "Enter your GitHub Personal Access Token:"
            echo "(Create one at: https://github.com/settings/tokens)"
            read -s token
            echo "$token" | gh auth login --with-token
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
    
    if ! gh auth status &>/dev/null; then
        echo "❌ Authentication failed"
        exit 1
    fi
fi

echo ""
echo "✅ Authenticated with GitHub"
echo ""

# Run the protection setup
echo "📋 Setting up branch protection rules..."
echo ""

./scripts/setup-branch-protection-simple.sh

echo ""
echo "✨ Setup complete!"
echo ""
echo "Verify at: https://github.com/linuxliam/disability/settings/branches"
