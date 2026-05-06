#!/bin/bash
# Run all tests - Automated test execution
# Usage: ./scripts/run_tests.sh [test_suite]

set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_DIR="test-results/${TIMESTAMP}"

echo "=== Android Auto Test Framework - Test Execution ==="
echo "Timestamp: $TIMESTAMP"

# Create results directory
mkdir -p "$RESULTS_DIR"

# Run tests
if [ -z "$1" ]; then
    echo "Running all test suites..."
    robot --outputdir "$RESULTS_DIR" --output output.xml --log log.html --report report.html tests/
else
    echo "Running test suite: $1"
    robot --outputdir "$RESULTS_DIR" --output output.xml --log log.html --report report.html "tests/$1"
fi

# Generate summary
echo ""
echo "=== Test Results Summary ==="
if [ -f "${RESULTS_DIR}/output.xml" ]; then
    PASSED=$(grep -c '<status status="PASS"' "${RESULTS_DIR}/output.xml" 2>/dev/null || echo "0")
    FAILED=$(grep -c '<status status="FAIL"' "${RESULTS_DIR}/output.xml" 2>/dev/null || echo "0")
    echo "Passed: $PASSED"
    echo "Failed: $FAILED"
    echo "Results saved to: ${RESULTS_DIR}/"
fi

echo ""
echo "=== Test Execution Complete ==="
