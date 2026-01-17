#!/bin/bash
# Open-Reflect: Smart Commit Analysis with Learning Reminder
# Used by PostToolUse hook for Bash tool

QUEUE_FILE="$HOME/.claude/openreflect-queue.json"
REFLECT_FILE="$PWD/REFLECT.md"

# Read JSON from stdin
INPUT="$(cat -)"
[ -z "$INPUT" ] && exit 0

# Extract command
COMMAND="$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)"
[ -z "$COMMAND" ] && exit 0

# Check if it was a git commit (not amend)
if [[ "$COMMAND" == *"git commit"* && "$COMMAND" != *"--amend"* ]]; then
  MSG="📦 Git commit detected!"
  
  # Analyze queue
  if [ -f "$QUEUE_FILE" ]; then
    COUNT=$(jq 'length' "$QUEUE_FILE" 2>/dev/null || echo 0)
    
    if [ "$COUNT" -gt 0 ]; then
      # Get breakdown
      CRITICAL=$(jq '[.[] | select(.priority == "critical")] | length' "$QUEUE_FILE")
      POSITIVE=$(jq '[.[] | select(.category == "success_pattern")] | length' "$QUEUE_FILE")
      
      MSG="$MSG You have $COUNT queued learning(s)."
      
      if [ "$CRITICAL" -gt 0 ]; then
        MSG="$MSG ⚠️  $CRITICAL critical item(s) need attention!"
      fi
      
      if [ "$POSITIVE" -gt 0 ]; then
        MSG="$MSG ✅ $POSITIVE success pattern(s) captured."
      fi
    fi
  fi
  
  # Check REFLECT.md exists
  if [ -f "$REFLECT_FILE" ]; then
    MSG="$MSG 📖 REFLECT.md ready for evolution."
  fi
  
  MSG="$MSG 💡 Run /reflect to evolve knowledge base."
  
  # Output JSON response
  jq -n --arg msg "$MSG" '{
    "hookSpecificOutput": {
      "hookEventName": "PostToolUse",
      "additionalContext": $msg
    }
  }'
fi

exit 0
