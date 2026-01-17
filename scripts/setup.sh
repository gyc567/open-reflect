#!/bin/bash
# Open-Reflect: Setup Script

set -e

echo "🚀 Open-Reflect Setup"
echo "════════════════════════════════════════════════════"
echo ""

# Check dependencies
echo "Checking dependencies..."
if ! command -v jq &> /dev/null; then
  echo "❌ jq is not installed"
  echo "   Install with: brew install jq (macOS)"
  echo "               or: sudo apt-get install jq (Ubuntu)"
  exit 1
fi
echo "✅ jq is installed"
echo ""

# Create necessary directories
echo "Creating directories..."
mkdir -p ~/.claude/openreflect-backups
echo "✅ Backup directory created"
echo ""

# Initialize queue file
QUEUE_FILE="$HOME/.claude/openreflect-queue.json"
if [ ! -f "$QUEUE_FILE" ]; then
  echo "[]" > "$QUEUE_FILE"
  echo "✅ Queue file initialized"
else
  echo "✅ Queue file exists"
fi
echo ""

# Create example REFLECT.md in current directory
if [ ! -f "REFLECT.md" ]; then
  cp REFLECT.md.example REFLECT.md 2>/dev/null || echo "Skipping REFLECT.md creation (no template)"
  echo "✅ REFLECT.md ready in current directory"
fi

echo ""
echo "════════════════════════════════════════════════════"
echo "✅ Open-Reflect setup complete!"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code to activate hooks"
echo "  2. Run /reflect to process learnings"
echo "  3. Check REFLECT.md for evolved knowledge"
echo "════════════════════════════════════════════════════"
