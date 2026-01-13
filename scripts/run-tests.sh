#!/bin/bash

# Universal Platform Test Execution Script
# Runs tests for both iOS and macOS platforms

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="DisabilityAdvocacy"
PROJECT_FILE="${PROJECT_NAME}.xcodeproj"
IOS_TEST_TARGET="DisabilityAdvocacyTests"
IOS_UI_TEST_TARGET="DisabilityAdvocacyUITests"
CONFIGURATION="${1:-Debug}"
REPORT_DIR="test-reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create report directory
mkdir -p "${REPORT_DIR}"

echo -e "${GREEN}=== Running Tests for ${PROJECT_NAME} ===${NC}"
echo "Configuration: ${CONFIGURATION}"
echo "Timestamp: ${TIMESTAMP}"
echo ""

# Function to run tests
run_tests() {
    local target=$1
    local sdk=$2
    local platform=$3
    local report_file="${REPORT_DIR}/${target}_${CONFIGURATION}_${TIMESTAMP}.txt"
    
    echo -e "${YELLOW}Running ${target} for ${platform}...${NC}"
    
    # Test command
    xcodebuild test \
        -project "${PROJECT_FILE}" \
        -scheme "${target}" \
        -sdk "${sdk}" \
        -configuration "${CONFIGURATION}" \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO \
        -derivedDataPath build \
        -destination 'generic/platform=iOS Simulator' \
        2>&1 | tee "${report_file}"
    
    local test_status=${PIPESTATUS[0]}
    
    if [ ${test_status} -eq 0 ]; then
        echo -e "${GREEN}✓ ${target} tests passed${NC}"
        return 0
    else
        echo -e "${RED}✗ ${target} tests failed${NC}"
        echo "See ${report_file} for details"
        return 1
    fi
}

# Track test results
IOS_TESTS_SUCCESS=false
IOS_UI_TESTS_SUCCESS=false

# Run iOS unit tests
echo -e "\n${GREEN}--- Running iOS Unit Tests ---${NC}"
if run_tests "${IOS_TEST_TARGET}" "iphonesimulator" "iOS Simulator"; then
    IOS_TESTS_SUCCESS=true
fi

# Run iOS UI tests (optional, can be skipped if not needed)
echo -e "\n${GREEN}--- Running iOS UI Tests ---${NC}"
if run_tests "${IOS_UI_TEST_TARGET}" "iphonesimulator" "iOS Simulator"; then
    IOS_UI_TESTS_SUCCESS=true
fi

# Summary
echo -e "\n${GREEN}=== Test Summary ===${NC}"
echo "iOS Unit Tests: $([ "${IOS_TESTS_SUCCESS}" = true ] && echo -e "${GREEN}PASSED${NC}" || echo -e "${RED}FAILED${NC}")"
echo "iOS UI Tests: $([ "${IOS_UI_TESTS_SUCCESS}" = true ] && echo -e "${GREEN}PASSED${NC}" || echo -e "${RED}FAILED${NC}")"
echo ""
echo "Test reports saved to: ${REPORT_DIR}/"

# Exit with error if any tests failed
if [ "${IOS_TESTS_SUCCESS}" = false ] || [ "${IOS_UI_TESTS_SUCCESS}" = false ]; then
    exit 1
fi

echo -e "${GREEN}All tests passed!${NC}"
