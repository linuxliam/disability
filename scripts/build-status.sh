#!/bin/bash

# Build Status Reporter
# Generates build status report comparing builds across platforms

set -e

PROJECT_NAME="DisabilityAdvocacy"
PROJECT_FILE="${PROJECT_NAME}.xcodeproj"
REPORT_FILE="build-status-$(date +%Y%m%d_%H%M%S).txt"

echo "=== Build Status Report ===" > "${REPORT_FILE}"
echo "Generated: $(date)" >> "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"

# Function to get build time
get_build_time() {
    local target=$1
    local sdk=$2
    
    local start_time=$(date +%s)
    xcodebuild \
        -project "${PROJECT_FILE}" \
        -target "${target}" \
        -sdk "${sdk}" \
        -configuration Debug \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO \
        clean build > /dev/null 2>&1
    local end_time=$(date +%s)
    echo $((end_time - start_time))
}

echo "Building iOS target..." | tee -a "${REPORT_FILE}"
IOS_TIME=$(get_build_time "DisabilityAdvocacy-iOS" "iphonesimulator")
echo "iOS build time: ${IOS_TIME}s" | tee -a "${REPORT_FILE}"

echo "Building macOS target..." | tee -a "${REPORT_FILE}"
MACOS_TIME=$(get_build_time "DisabilityAdvocacy-macOS" "macosx")
echo "macOS build time: ${MACOS_TIME}s" | tee -a "${REPORT_FILE}"

echo "" >> "${REPORT_FILE}"
echo "=== Summary ===" >> "${REPORT_FILE}"
echo "iOS: ${IOS_TIME}s" >> "${REPORT_FILE}"
echo "macOS: ${MACOS_TIME}s" >> "${REPORT_FILE}"

cat "${REPORT_FILE}"
