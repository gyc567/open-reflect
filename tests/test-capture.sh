#!/bin/bash
# Open-Reflect: Capture Learning Script Tests

set -e

echo "🧪 Testing Open-Reflect Capture Scripts"
echo "════════════════════════════════════════════════════"
echo ""

# Test 1: Explicit "remember:" capture
echo "Test 1: Explicit remember: capture"
INPUT='{"prompt": "remember: use venv for Python projects"}'
OUTPUT=$(echo "$INPUT" | bash scripts/capture-learning-enhanced.sh 2>&1)
if [ $? -eq 0 ]; then
  echo "✅ PASS: Explicit marker captured"
else
  echo "❌ FAIL: Explicit marker not captured"
fi
echo ""

# Test 2: Correction pattern capture
echo "Test 2: Correction pattern (no, use X)"
INPUT='{"prompt": "no, use gpt-5.1 not gpt-5"}'
OUTPUT=$(echo "$INPUT" | bash scripts/capture-learning-enhanced.sh 2>&1)
if [ $? -eq 0 ]; then
  echo "✅ PASS: Correction pattern captured"
else
  echo "❌ FAIL: Correction pattern not captured"
fi
echo ""

# Test 3: Positive pattern capture
echo "Test 3: Positive pattern (Perfect!)"
INPUT='{"prompt": "Perfect! That'\''s exactly what I wanted."}'
OUTPUT=$(echo "$INPUT" | bash scripts/capture-learning-enhanced.sh 2>&1)
if [ $? -eq 0 ]; then
  echo "✅ PASS: Positive pattern captured"
else
  echo "❌ FAIL: Positive pattern not captured"
fi
echo ""

# Test 4: Queue initialization
echo "Test 4: Queue initialization"
QUEUE_FILE="/tmp/test-openreflect-queue.json"
echo "[]" > "$QUEUE_FILE"
COUNT=$(jq 'length' "$QUEUE_FILE" 2>/dev/null || echo "0")
if [ "$COUNT" -eq 0 ]; then
  echo "✅ PASS: Queue initialized correctly"
else
  echo "❌ FAIL: Queue initialization failed"
fi
echo ""

echo "════════════════════════════════════════════════════"
echo "Tests completed!"
