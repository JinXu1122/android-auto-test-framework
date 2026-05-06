#!/bin/bash
# Setup script - Automated test environment provisioning
# Usage: ./scripts/setup.sh

set -e

echo "=== Android Auto Test Framework Setup ==="
echo "Starting environment provisioning..."

# Check Python version
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    echo "✓ Python found: $PYTHON_VERSION"
else
    echo "✗ Python 3 not found. Please install Python 3.8+"
    exit 1
fi

# Install dependencies
echo "Installing Python dependencies..."
pip3 install -r requirements.txt --quiet
echo "✓ Dependencies installed"

# Verify Robot Framework
if command -v robot &> /dev/null; then
    ROBOT_VERSION=$(robot --version 2>&1 | head -1)
    echo "✓ Robot Framework: $ROBOT_VERSION"
else
    echo "✗ Robot Framework not found"
    exit 1
fi

# Create test results directory
mkdir -p test-results
echo "✓ Test results directory created"

echo ""
echo "=== Setup Complete ==="
echo "Run tests with: ./scripts/run_tests.sh"
