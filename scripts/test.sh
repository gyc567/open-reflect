#!/bin/bash
# Open-Reflect: Run All Tests

echo "🧪 Open-Reflect Test Suite"
echo "════════════════════════════════════════════════════"
echo ""

# Get plugin directory
PLUGIN_DIR="${0%/*}"
if [ "$PLUGIN_DIR" = "scripts" ]; then
  PLUGIN_DIR="."
fi

echo "Plugin directory: $PLUGIN_DIR"
echo ""

# Run capture tests
echo "Running capture tests..."
bash "$PLUGIN_DIR/tests/test-capture.sh"
echo ""

# Run integration tests
echo "Running integration tests..."
bash "$PLUGIN_DIR/tests/test-integration.sh"
echo ""

# Run OpenCode compatibility tests
echo "Running OpenCode compatibility tests..."
bash "$PLUGIN_DIR/tests/test-opencode-compat.sh"
echo ""

echo "════════════════════════════════════════════════════"
echo "✅ All tests completed!"
echo "════════════════════════════════════════════════════"
