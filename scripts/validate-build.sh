#!/bin/bash

# Build Validation Script
# Validates that all targets compile and checks for common issues

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROJECT_NAME="DisabilityAdvocacy"
PROJECT_FILE="${PROJECT_NAME}.xcodeproj"
ERRORS=0
WARNINGS=0

echo -e "${GREEN}=== Build Validation ===${NC}"
echo ""

# Function to check build
check_build() {
    local target=$1
    local sdk=$2
    local platform=$3
    
    echo -e "${YELLOW}Checking ${target} for ${platform}...${NC}"
    
    local output=$(xcodebuild \
        -project "${PROJECT_FILE}" \
        -target "${target}" \
        -sdk "${sdk}" \
        -configuration Debug \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO \
        clean build 2>&1)
    
    local build_status=$?
    local error_count=$(echo "$output" | grep -c "error:" || true)
    local warning_count=$(echo "$output" | grep -c "warning:" || true)
    
    if [ ${build_status} -eq 0 ]; then
        echo -e "${GREEN}✓ ${target} builds successfully${NC}"
        if [ ${warning_count} -gt 0 ]; then
            echo -e "${YELLOW}  ${warning_count} warning(s)${NC}"
            WARNINGS=$((WARNINGS + warning_count))
        fi
    else
        echo -e "${RED}✗ ${target} build failed${NC}"
        echo -e "${RED}  ${error_count} error(s)${NC}"
        ERRORS=$((ERRORS + error_count))
        return 1
    fi
}

# Check all targets
check_build "DisabilityAdvocacy-iOS" "iphonesimulator" "iOS Simulator"
check_build "DisabilityAdvocacy-macOS" "macosx" "macOS"

# Check Info.plist files exist
echo ""
echo -e "${YELLOW}Checking Info.plist files...${NC}"
if [ -f "iOS/Info.plist" ]; then
    echo -e "${GREEN}✓ iOS/Info.plist exists${NC}"
else
    echo -e "${RED}✗ iOS/Info.plist missing${NC}"
    ERRORS=$((ERRORS + 1))
fi

if [ -f "macOS/Info.plist" ]; then
    echo -e "${GREEN}✓ macOS/Info.plist exists${NC}"
else
    echo -e "${RED}✗ macOS/Info.plist missing${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Summary
echo ""
echo -e "${GREEN}=== Validation Summary ===${NC}"
echo "Errors: ${ERRORS}"
echo "Warnings: ${WARNINGS}"

if [ ${ERRORS} -eq 0 ]; then
    echo -e "${GREEN}✓ Build validation passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Build validation failed!${NC}"
    exit 1
fi
