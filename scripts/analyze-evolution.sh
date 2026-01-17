#!/bin/bash
# Open-Reflect: Knowledge Evolution Analysis Script
# Analyzes REFLECT.md and provides insights on learning trends

REFLECT_FILE="$PWD/REFLECT.md"
QUEUE_FILE="$HOME/.claude/openreflect-queue.json"

if [ ! -f "$REFLECT_FILE" ]; then
  echo "❌ REFLECT.md not found in current project"
  exit 1
fi

echo "🔬 Open-Reflect Evolution Analysis"
echo "════════════════════════════════════════════════════"
echo ""

# Analyze queue
if [ -f "$QUEUE_FILE" ]; then
  COUNT=$(jq 'length' "$QUEUE_FILE" 2>/dev/null || echo 0)
  
  if [ "$COUNT" -gt 0 ]; then
    echo "📊 Current Queue Status:"
    echo "  Total items: $COUNT"
    
    # Category breakdown
    echo ""
    echo "  By Category:"
    CORRECTIONS=$(jq '[.[] | select(.category == "correction")] | length' "$QUEUE_FILE")
    SUCCESS=$(jq '[.[] | select(.category == "success_pattern")] | length' "$QUEUE_FILE")
    PREFERENCES=$(jq '[.[] | select(.category == "preference")] | length' "$QUEUE_FILE")
    
    echo "    • Corrections:   $CORRECTIONS"
    echo "    • Success patterns: $SUCCESS"
    echo "    • Preferences:    $PREFERENCES"
    
    # Priority breakdown
    echo ""
    echo "  By Priority:"
    CRITICAL=$(jq '[.[] | select(.priority == "critical")] | length' "$QUEUE_FILE")
    HIGH=$(jq '[.[] | select(.priority == "high")] | length' "$QUEUE_FILE")
    MEDIUM=$(jq '[.[] | select(.priority == "medium")] | length' "$QUEUE_FILE")
    
    echo "    • Critical: $CRITICAL"
    echo "    • High:     $HIGH"
    echo "    • Medium:   $MEDIUM"
    
    # Average confidence
    AVG_CONF=$(jq 'map(.confidence) | add / length' "$QUEUE_FILE" 2>/dev/null || echo "0")
    echo ""
    echo "  Average Confidence: $(echo "$AVG_CONF * 100" | bc)%"
  else
    echo "📦 Queue is empty"
  fi
fi

echo ""
echo "💡 Recommendations:"
echo ""

# Analyze patterns and provide recommendations
if [ -f "$QUEUE_FILE" ] && [ "$COUNT" -gt 0 ]; then
  if [ "$CORRECTIONS" -gt 5 ]; then
    echo "  • High correction rate detected"
    echo "    → Consider running /reflect to consolidate learnings"
    echo "    → Review if initial instructions need clarification"
  fi
  
  if [ "$SUCCESS" -gt 3 ]; then
    echo "  • Strong success patterns captured"
    echo "    → Document these as best practices in CLAUDE.md"
    echo "    → Consider creating reusable patterns"
  fi
  
  if [ "$CRITICAL" -gt 0 ]; then
    echo "  • Critical items pending review"
    echo "    → Prioritize processing these with /reflect"
  fi
else
  echo "  • No pending learnings - system is current"
fi

echo ""
echo "════════════════════════════════════════════════════"

exit 0
