#!/bin/bash

# Platform Code Validation Script
# Checks for missing platform implementations and validates conditional compilation

set -e

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

echo -e "${GREEN}=== Platform Code Validation ===${NC}"
echo ""

# Check for #if os(iOS) without corresponding #else
echo -e "${YELLOW}Checking for missing #else blocks...${NC}"
while IFS= read -r file; do
    if grep -q "#if os(iOS)" "$file"; then
        if ! grep -q "#else" "$file"; then
            echo -e "${YELLOW}Warning: ${file} has #if os(iOS) without #else${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi
done < <(find Shared -name "*.swift" -type f)

# Check for platform-specific imports without guards
echo ""
echo -e "${YELLOW}Checking for unguarded platform-specific imports...${NC}"
while IFS= read -r file; do
    if grep -q "^import UIKit" "$file" && ! grep -q "#if os(iOS)" "$file"; then
        echo -e "${RED}Error: ${file} imports UIKit without iOS guard${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    if grep -q "^import AppKit" "$file" && ! grep -q "#if os(macOS)" "$file"; then
        echo -e "${RED}Error: ${file} imports AppKit without macOS guard${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find Shared -name "*.swift" -type f)

# Check for .insetGrouped usage (iOS only)
echo ""
echo -e "${YELLOW}Checking for .insetGrouped usage...${NC}"
while IFS= read -r file; do
    if grep -q "\.insetGrouped" "$file"; then
        if ! grep -q "#if os(iOS)" "$file"; then
            echo -e "${YELLOW}Warning: ${file} uses .insetGrouped without iOS guard${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi
done < <(find Shared -name "*.swift" -type f)

# Summary
echo ""
echo -e "${GREEN}=== Validation Summary ===${NC}"
echo "Errors: ${ERRORS}"
echo "Warnings: ${WARNINGS}"

if [ ${ERRORS} -eq 0 ]; then
    echo -e "${GREEN}✓ Platform code validation passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Platform code validation failed!${NC}"
    exit 1
fi
