#!/bin/bash
# Open-Reflect: Enhanced Queue Check with Backup and Analysis
# Used by PreCompact hook

QUEUE_FILE="$HOME/.claude/openreflect-queue.json"
BACKUP_DIR="$HOME/.claude/openreflect-backups"
REFLECT_FILE="$PWD/REFLECT.md"

if [ -f "$QUEUE_FILE" ]; then
  COUNT=$(jq 'length' "$QUEUE_FILE" 2>/dev/null || echo 0)
  
  if [ "$COUNT" -gt 0 ]; then
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    # Save timestamped backup
    BACKUP_FILE="$BACKUP_DIR/pre-compact-$(date +%Y%m%d-%H%M%S).json"
    cp "$QUEUE_FILE" "$BACKUP_FILE"
    
    # Enhanced notification with priority breakdown
    CRITICAL=$(jq '[.[] | select(.priority == "critical")] | length' "$QUEUE_FILE")
    HIGH=$(jq '[.[] | select(.priority == "high")] | length' "$QUEUE_FILE")
    MEDIUM=$(jq '[.[] | select(.priority == "medium")] | length' "$QUEUE_FILE")
    
    echo ""
    echo "🧠 Open-Reflect Queue Analysis:"
    echo "════════════════════════════════════════════════════"
    echo "  Total learnings: $COUNT"
    echo "  └─ Critical: $CRITICAL | High: $HIGH | Medium: $MEDIUM"
    echo ""
    echo "💾 Backup saved to: $BACKUP_FILE"
    echo ""
    echo "📝 Process learnings in new session:"
    echo "   /reflect       - Review and apply learnings"
    echo "   /reflect view  - View queue details"
    echo ""
  fi
fi

exit 0
