#!/bin/bash

# Pre-commit Hook Template
# Install by copying to .git/hooks/pre-commit and making executable
# cp scripts/pre-commit-hook.sh .git/hooks/pre-commit
# chmod +x .git/hooks/pre-commit

set -e

echo "Running pre-commit validation..."

# Run build validation (quick check)
if [ -f "scripts/validate-build.sh" ]; then
    ./scripts/validate-build.sh || {
        echo "Build validation failed. Commit aborted."
        exit 1
    }
fi

# Run platform code validation
if [ -f "scripts/validate-platform-code.sh" ]; then
    ./scripts/validate-platform-code.sh || {
        echo "Platform code validation failed. Commit aborted."
        exit 1
    }
fi

echo "Pre-commit validation passed!"
exit 0
