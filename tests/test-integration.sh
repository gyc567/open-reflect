#!/bin/bash
# Open-Reflect: Integration Tests

set -e

echo "🧪 Open-Reflect Integration Tests"
echo "════════════════════════════════════════════════════"
echo ""

# Test environment setup
TEST_DIR="/tmp/openreflect-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo ""

# Initialize test queue
export HOME="$TEST_DIR"
mkdir -p "$HOME/.claude"
echo "[]" > "$HOME/.claude/openreflect-queue.json"

# Test 1: Queue check script
echo "Test 1: Queue check with backup"
bash ~/.claude/plugins/open-reflect/scripts/check-reflect-queue.sh
if [ -d "$HOME/.claude/openreflect-backups" ]; then
  echo "✅ PASS: Backup directory created"
else
  echo "❌ FAIL: Backup directory not created"
fi
echo ""

# Test 2: Evolution analysis
echo "Test 2: Evolution analysis script"
cat > REFLECT.md << 'EOFMARKER'
# Open-Reflect 知识演化日志

## 🎯 学习分类
EOFMARKER

if [ -f "REFLECT.md" ]; then
  bash ~/.claude/plugins/open-reflect/scripts/analyze-evolution.sh
  echo "✅ PASS: Evolution analysis executed"
else
  echo "❌ FAIL: REFLECT.md not found"
fi
echo ""

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo "════════════════════════════════════════════════════"
echo "Integration tests completed!"
