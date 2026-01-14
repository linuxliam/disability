#!/bin/bash

# Validate Xcode Project Structure
# Checks that all Swift files are properly included in the project

set -e

PROJECT_FILE="DisabilityAdvocacy.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "❌ Project file not found: $PROJECT_FILE"
    exit 1
fi

echo "🔍 Analyzing Xcode project structure..."
echo ""

# Extract Swift files from project.pbxproj
# Pattern: [24-char-id] /* filename.swift */
SWIFT_FILES_IN_PROJECT=$(grep -oE '[A-F0-9]{24} /\* [^/]+\.swift \*/' "$PROJECT_FILE" | \
    sed 's/.*\/\* \(.*\)\.swift \*\/.*/\1.swift/' | \
    sort -u)

# Find all Swift files in the codebase
SWIFT_FILES_IN_FS=$(find . -name "*.swift" \
    -not -path "./.git/*" \
    -not -path "./build/*" \
    -not -path "./.build/*" \
    -not -path "./DerivedData/*" \
    -not -path "./*.xcodeproj/*" \
    -type f | \
    sed 's|^\./||' | \
    sort)

# Count files
PROJECT_COUNT=$(echo "$SWIFT_FILES_IN_PROJECT" | grep -c . || echo "0")
FS_COUNT=$(echo "$SWIFT_FILES_IN_FS" | grep -c . || echo "0")

echo "📊 Statistics:"
echo "  Files in project.pbxproj: $PROJECT_COUNT"
echo "  Files in filesystem: $FS_COUNT"
echo ""

# Find files in filesystem but not in project
MISSING_FILES=$(comm -23 <(echo "$SWIFT_FILES_IN_FS") <(echo "$SWIFT_FILES_IN_PROJECT"))

# Find files in project but not in filesystem
ORPHANED_REFERENCES=$(comm -13 <(echo "$SWIFT_FILES_IN_FS") <(echo "$SWIFT_FILES_IN_PROJECT"))

ISSUES=0

if [ -n "$MISSING_FILES" ]; then
    echo "⚠️  Files NOT in project.pbxproj:"
    echo "$MISSING_FILES" | while read -r file; do
        echo "  - $file"
    done
    echo ""
    ISSUES=1
fi

if [ -n "$ORPHANED_REFERENCES" ]; then
    echo "⚠️  Orphaned references in project.pbxproj:"
    echo "$ORPHANED_REFERENCES" | while read -r file; do
        echo "  - $file"
    done
    echo ""
    ISSUES=1
fi

# Check for duplicate references
DUPLICATES=$(grep -oE '[A-F0-9]{24} /\* [^/]+\.swift \*/' "$PROJECT_FILE" | \
    sed 's/.*\/\* \(.*\)\.swift \*\/.*/\1.swift/' | \
    sort | uniq -d)

if [ -n "$DUPLICATES" ]; then
    echo "⚠️  Duplicate file references:"
    echo "$DUPLICATES" | while read -r file; do
        echo "  - $file"
    done
    echo ""
    ISSUES=1
fi

# Validate project can be parsed
if xcodebuild -list -project DisabilityAdvocacy.xcodeproj > /dev/null 2>&1; then
    echo "✅ Project file is valid"
else
    echo "❌ Project file cannot be parsed"
    ISSUES=1
fi

if [ $ISSUES -eq 0 ]; then
    echo ""
    echo "✅ Project structure is valid!"
    exit 0
else
    echo ""
    echo "❌ Project structure issues found"
    exit 1
fi
