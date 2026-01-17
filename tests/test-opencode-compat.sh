#!/bin/bash
# Open-Reflect: OpenCode Compatibility Tests

set -e

echo "🧪 OpenCode Compatibility Tests"
echo "════════════════════════════════════════════════════"
echo ""

PASS=0
FAIL=0

# Test 1: Check OpenCode skill directory exists
echo "Test 1: OpenCode skill directory exists"
if [ -d ".opencode/skill/open-reflect" ]; then
  echo "✅ PASS: .opencode/skill/open-reflect exists"
  PASS=$((PASS + 1))
else
  echo "❌ FAIL: .opencode/skill/open-reflect not found"
  FAIL=$((FAIL + 1))
fi
echo ""

# Test 2: Check OpenCode SKILL.md exists
echo "Test 2: OpenCode SKILL.md exists"
if [ -f ".opencode/skill/open-reflect/SKILL.md" ]; then
  echo "✅ PASS: OpenCode SKILL.md exists"
  PASS=$((PASS + 1))
else
  echo "❌ FAIL: OpenCode SKILL.md not found"
  FAIL=$((FAIL + 1))
fi
echo ""

# Test 3: Check OpenCode SKILL.md frontmatter
echo "Test 3: OpenCode SKILL.md has valid frontmatter"
if [ -f ".opencode/skill/open-reflect/SKILL.md" ]; then
  if grep -q "^---" ".opencode/skill/open-reflect/SKILL.md"; then
    echo "✅ PASS: Frontmatter start found"
    PASS=$((PASS + 1))
  else
    echo "❌ FAIL: Frontmatter start not found"
    FAIL=$((FAIL + 1))
  fi
else
  echo "❌ FAIL: File not found"
  FAIL=$((FAIL + 1))
fi
echo ""

# Test 4: Check OpenCode frontmatter has name
echo "Test 4: OpenCode SKILL.md has name in frontmatter"
if [ -f ".opencode/skill/open-reflect/SKILL.md" ]; then
  if grep -q "^name: open-reflect" ".opencode/skill/open-reflect/SKILL.md"; then
    echo "✅ PASS: name field found"
    PASS=$((PASS + 1))
  else
    echo "❌ FAIL: name field not found"
    FAIL=$((FAIL + 1))
  fi
else
  echo "❌ FAIL: File not found"
  FAIL=$((FAIL + 1))
fi
echo ""

# Test 5: Check OpenCode frontmatter has description
echo "Test 5: OpenCode SKILL.md has description"
if [ -f ".opencode/skill/open-reflect/SKILL.md" ]; then
  if grep -q "^description:" ".opencode/skill/open-reflect/SKILL.md"; then
    echo "✅ PASS: description field found"
    PASS=$((PASS + 1))
  else
    echo "❌ FAIL: description field not found"
    FAIL=$((FAIL + 1))
  fi
else
  echo "❌ FAIL: File not found"
  FAIL=$((FAIL + 1))
fi
echo ""

# Test 6: Check OpenCode has compatibility field
echo "Test 6: OpenCode SKILL.md has compatibility field"
if [ -f ".opencode/skill/open-reflect/SKILL.md" ]; then
  if grep -q "^compatibility: opencode" ".opencode/skill/open-reflect/SKILL.md"; then
    echo "✅ PASS: compatibility field found"
    PASS=$((PASS + 1))
  else
    echo "❌ FAIL: compatibility field not found"
    FAIL=$((FAIL + 1))
  fi
else
  echo "❌ FAIL: File not found"
  FAIL=$((FAIL + 1))
fi
echo ""

# Test 7: Check Claude Code SKILL.md exists
echo "Test 7: Claude Code SKILL.md exists"
if [ -f "SKILL.md" ]; then
  echo "✅ PASS: Claude Code SKILL.md exists"
  PASS=$((PASS + 1))
else
  echo "❌ FAIL: Claude Code SKILL.md not found"
  FAIL=$((FAIL + 1))
fi
echo ""

# Test 8: Check Claude Code has OpenCode compatibility
echo "Test 8: Claude Code SKILL.md mentions OpenCode"
if [ -f "SKILL.md" ]; then
  if grep -q -i "opencode" "SKILL.md"; then
    echo "✅ PASS: OpenCode mentioned in Claude Code SKILL.md"
    PASS=$((PASS + 1))
  else
    echo "❌ FAIL: OpenCode not mentioned"
    FAIL=$((FAIL + 1))
  fi
else
  echo "❌ FAIL: File not found"
  FAIL=$((FAIL + 1))
fi
echo ""

# Test 9: Check OpenCode config example exists
echo "Test 9: OpenCode config example exists"
if [ -f ".opencode/open-reflect-config.json" ]; then
  echo "✅ PASS: OpenCode config example exists"
  PASS=$((PASS + 1))
else
  echo "❌ FAIL: OpenCode config example not found"
  FAIL=$((FAIL + 1))
fi
echo ""

# Test 10: Check OpenCode compatibility documentation
echo "Test 10: OpenCode compatibility documentation exists"
if [ -f "docs/OPENCODE_COMPATIBILITY.md" ]; then
  echo "✅ PASS: OpenCode compatibility docs exist"
  PASS=$((PASS + 1))
else
  echo "❌ FAIL: OpenCode compatibility docs not found"
  FAIL=$((FAIL + 1))
fi
echo ""

# Summary
echo "════════════════════════════════════════════════════"
echo "📊 Test Results: $PASS passed, $FAIL failed"
echo ""

if [ $FAIL -eq 0 ]; then
  echo "✅ All OpenCode compatibility tests passed!"
  exit 0
else
  echo "❌ Some tests failed. Please review the issues above."
  exit 1
fi
