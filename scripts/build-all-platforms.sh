#!/bin/bash

# Universal Platform Build Script
# Builds both iOS and macOS targets with validation and reporting

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="DisabilityAdvocacy"
PROJECT_FILE="${PROJECT_NAME}.xcodeproj"
IOS_TARGET="${PROJECT_NAME}-iOS"
MACOS_TARGET="${PROJECT_NAME}-macOS"
CONFIGURATION="${1:-Debug}"
BUILD_DIR="build"
REPORT_DIR="build-reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create report directory
mkdir -p "${REPORT_DIR}"

echo -e "${GREEN}=== Building ${PROJECT_NAME} for All Platforms ===${NC}"
echo "Configuration: ${CONFIGURATION}"
echo "Timestamp: ${TIMESTAMP}"
echo ""

# Function to build a target
build_target() {
    local target=$1
    local sdk=$2
    local platform=$3
    local report_file="${REPORT_DIR}/${target}_${CONFIGURATION}_${TIMESTAMP}.txt"
    
    echo -e "${YELLOW}Building ${target} for ${platform}...${NC}"
    
    # Build command
    xcodebuild \
        -project "${PROJECT_FILE}" \
        -target "${target}" \
        -sdk "${sdk}" \
        -configuration "${CONFIGURATION}" \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO \
        -derivedDataPath "${BUILD_DIR}" \
        clean build \
        2>&1 | tee "${report_file}"
    
    local build_status=${PIPESTATUS[0]}
    
    if [ ${build_status} -eq 0 ]; then
        echo -e "${GREEN}✓ ${target} built successfully${NC}"
        return 0
    else
        echo -e "${RED}✗ ${target} build failed${NC}"
        echo "See ${report_file} for details"
        return 1
    fi
}

# Track build results
IOS_BUILD_SUCCESS=false
MACOS_BUILD_SUCCESS=false

# Build iOS target
echo -e "\n${GREEN}--- Building iOS Target ---${NC}"
if build_target "${IOS_TARGET}" "iphonesimulator" "iOS Simulator"; then
    IOS_BUILD_SUCCESS=true
fi

# Build macOS target
echo -e "\n${GREEN}--- Building macOS Target ---${NC}"
if build_target "${MACOS_TARGET}" "macosx" "macOS"; then
    MACOS_BUILD_SUCCESS=true
fi

# Summary
echo -e "\n${GREEN}=== Build Summary ===${NC}"
echo "iOS Build: $([ "${IOS_BUILD_SUCCESS}" = true ] && echo -e "${GREEN}SUCCESS${NC}" || echo -e "${RED}FAILED${NC}")"
echo "macOS Build: $([ "${MACOS_BUILD_SUCCESS}" = true ] && echo -e "${GREEN}SUCCESS${NC}" || echo -e "${RED}FAILED${NC}")"
echo ""
echo "Build reports saved to: ${REPORT_DIR}/"

# Exit with error if any build failed
if [ "${IOS_BUILD_SUCCESS}" = false ] || [ "${MACOS_BUILD_SUCCESS}" = false ]; then
    exit 1
fi

echo -e "${GREEN}All builds completed successfully!${NC}"
