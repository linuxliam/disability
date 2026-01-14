#!/bin/bash

# Analyze Test Coverage
# Estimates coverage based on test file presence

set -e

echo "📊 Test Coverage Analysis"
echo "========================="
echo ""

# Count source files (excluding Views, Tests, and platform-specific UI)
SOURCE_FILES=$(find Shared -name "*.swift" -type f \
    -not -path "*/Views/*" \
    -not -path "*/Tests/*" \
    -not -path "*/UITests/*" \
    -not -path "*/.xcodeproj/*" \
    | wc -l | tr -d ' ')

# Count test files
TEST_FILES=$(find iOS/DisabilityAdvocacyTests -name "*Tests.swift" -type f | wc -l | tr -d ' ')

echo "📁 Source Files (excluding Views): $SOURCE_FILES"
echo "🧪 Test Files: $TEST_FILES"
echo ""

# Categorize files
echo "📋 Coverage by Category:"
echo ""

# Managers
MANAGER_FILES=$(find Shared/Managers -name "*.swift" -type f | wc -l | tr -d ' ')
MANAGER_TESTS=$(find iOS/DisabilityAdvocacyTests -name "*ManagerTests.swift" -type f | wc -l | tr -d ' ')
MANAGER_COVERAGE=$(echo "scale=1; ($MANAGER_TESTS * 100) / $MANAGER_FILES" | bc 2>/dev/null || echo "0")
echo "  Managers: $MANAGER_TESTS/$MANAGER_FILES (${MANAGER_COVERAGE}%)"

# ViewModels
VIEWMODEL_FILES=$(find Shared/ViewModels -name "*.swift" -type f | wc -l | tr -d ' ')
VIEWMODEL_TESTS=$(find iOS/DisabilityAdvocacyTests -name "*ViewModelTests.swift" -type f | wc -l | tr -d ' ')
VIEWMODEL_COVERAGE=$(echo "scale=1; ($VIEWMODEL_TESTS * 100) / $VIEWMODEL_FILES" | bc 2>/dev/null || echo "0")
echo "  ViewModels: $VIEWMODEL_TESTS/$VIEWMODEL_FILES (${VIEWMODEL_COVERAGE}%)"

# Models
MODEL_FILES=$(find Shared/Models -name "*.swift" -type f | wc -l | tr -d ' ')
MODEL_TESTS=$(find iOS/DisabilityAdvocacyTests -name "*ModelTests.swift" -type f | wc -l | tr -d ' ')
MODEL_COVERAGE=$(echo "scale=1; ($MODEL_TESTS * 100) / $MODEL_FILES" | bc 2>/dev/null || echo "0")
echo "  Models: $MODEL_TESTS/$MODEL_FILES (${MODEL_COVERAGE}%)"

# Utilities
UTILITY_FILES=$(find Shared/Utilities -name "*.swift" -type f | wc -l | tr -d ' ')
UTILITY_TESTS=$(find iOS/DisabilityAdvocacyTests -name "*ExtensionsTests.swift" -o -name "*HelperTests.swift" | wc -l | tr -d ' ')
UTILITY_COVERAGE=$(echo "scale=1; ($UTILITY_TESTS * 100) / $UTILITY_FILES" | bc 2>/dev/null || echo "0")
echo "  Utilities: $UTILITY_TESTS/$UTILITY_FILES (${UTILITY_COVERAGE}%)"

echo ""
echo "📊 Summary:"
echo "  Total Source Files: $SOURCE_FILES"
echo "  Total Test Files: $TEST_FILES"
echo ""

# List files without tests
echo "📝 Files Without Tests:"
echo ""

# Managers without tests
echo "Managers:"
for file in Shared/Managers/*.swift; do
    basename=$(basename "$file" .swift)
    if [ ! -f "iOS/DisabilityAdvocacyTests/${basename}Tests.swift" ]; then
        echo "  ❌ $basename"
    fi
done

# ViewModels without tests
echo ""
echo "ViewModels:"
for file in Shared/ViewModels/*.swift; do
    basename=$(basename "$file" .swift)
    if [ ! -f "iOS/DisabilityAdvocacyTests/UnitTests/ViewModels/${basename}Tests.swift" ]; then
        echo "  ❌ $basename"
    fi
done

echo ""
echo "💡 Note: This is an estimate based on test file presence."
echo "   For accurate coverage, run tests with code coverage enabled."
echo "   Use: ./scripts/generate-coverage-report.sh"
echo "   Or check GitHub Actions workflow: code-coverage.yml"
