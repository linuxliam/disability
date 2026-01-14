#!/bin/bash

# Generate Code Coverage Report
# This script runs tests and generates a coverage report

set -e

PROJECT="DisabilityAdvocacy.xcodeproj"
SCHEME="DisabilityAdvocacy-iOS"
SDK="iphonesimulator"
CONFIGURATION="Debug"
DESTINATION="platform=iOS Simulator,name=iPhone 16 Pro"

echo "🧪 Running tests with coverage..."
echo ""

# Run tests with coverage
xcodebuild test \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -sdk "$SDK" \
    -configuration "$CONFIGURATION" \
    -destination "$DESTINATION" \
    -enableCodeCoverage YES \
    -only-testing:DisabilityAdvocacyTests \
    -derivedDataPath build \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    2>&1 | tee test-output.txt

echo ""
echo "📊 Generating coverage report..."
echo ""

# Find coverage data
COVERAGE_DATA=$(find build -name "*.profdata" -type f | head -1)

if [ -z "$COVERAGE_DATA" ]; then
    echo "❌ Coverage data not found"
    echo "   Looking in: build/"
    find build -name "*.profdata" 2>/dev/null || echo "   No .profdata files found"
    exit 1
fi

echo "✅ Found coverage data: $COVERAGE_DATA"
echo ""

# Find the binary
BINARY=$(find build -name "DisabilityAdvocacy-iOS" -type f -path "*/DisabilityAdvocacy-iOS.app/DisabilityAdvocacy-iOS" | head -1)

if [ -z "$BINARY" ]; then
    echo "⚠️  Binary not found, using xcrun xccov view method"
    xcrun xccov view --report "$COVERAGE_DATA" > coverage-report.txt 2>&1 || true
    
    if [ -f coverage-report.txt ]; then
        echo ""
        echo "📋 Coverage Report:"
        echo "==================="
        cat coverage-report.txt | head -50
        echo ""
        
        # Extract overall coverage
        COVERAGE=$(grep -oE '[0-9]+\.[0-9]+%' coverage-report.txt | head -1 | sed 's/%//' || echo "0")
        echo "📊 Overall Coverage: ${COVERAGE}%"
    else
        echo "❌ Failed to generate coverage report"
        exit 1
    fi
else
    echo "✅ Found binary: $BINARY"
    echo ""
    
    # Generate coverage report using llvm-cov
    xcrun llvm-cov report "$BINARY" \
        -instr-profile="$COVERAGE_DATA" \
        -ignore-filename-regex=".*Tests.*|.*UITests.*" \
        -ignore-filename-regex=".*\.swiftpm.*" \
        2>&1 | tee coverage-report.txt
    
    # Extract overall coverage from last line
    COVERAGE=$(tail -1 coverage-report.txt | awk '{print $NF}' | sed 's/%//' || echo "0")
    echo ""
    echo "📊 Overall Coverage: ${COVERAGE}%"
fi

# Determine status
if (( $(echo "$COVERAGE >= 80" | bc -l 2>/dev/null || echo "0") )); then
    echo "✅ Excellent! Coverage is 80% or above"
    STATUS="✅"
elif (( $(echo "$COVERAGE >= 60" | bc -l 2>/dev/null || echo "0") )); then
    echo "⚠️  Good coverage, but below 80% target"
    STATUS="⚠️"
else
    echo "❌ Coverage needs improvement (below 60%)"
    STATUS="❌"
fi

echo ""
echo "📁 Coverage report saved to: coverage-report.txt"
echo "📁 Test output saved to: test-output.txt"
