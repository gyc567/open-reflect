---
description: View enhanced learnings queue with multi-dimensional metadata
allowed-tools: Bash
---

## Context
- Queue file: `~/.claude/openreflect-queue.json`
- REFLECT.md: `./REFLECT.md`

## Your Task

Display current learnings queue with enhanced analysis:

```
═══════════════════════════════════════════════════════════
🧠 OPEN-REFLECT QUEUE ANALYSIS
═══════════════════════════════════════════════════════════

Total Learnings: [N]

📊 By Priority:
  🔴 Critical: [N] items
  🟡 High: [N] items
  🟢 Medium: [N] items
  ⚪ Normal: [N] items

📁 By Category:
  🔄 Corrections: [N]
  ✅ Success Patterns: [N]
  🎨 Preferences: [N]
  📋 Best Practices: [N]
  ⚠️ Common Errors: [N]

📈 Confidence Distribution:
  • Average: [X]%
  • Highest: 0.XX
  • Lowest: 0.XX

───────────────────────────────────────────────────────────────────

#1 [🔴 CRITICAL] [Category]
   "[First 80 chars...]"
   
   Project: [path]
   Time: [timestamp]
   Confidence: 0.XX
   Evolution count: 0
   Usage count: 0
   
   → Run /reflect to process

#2 [🟡 HIGH] [Category]
   "[First 80 chars...]"
   ...

───────────────────────────────────────────────────────────────────

💡 Quick Actions:
  /reflect          - Process all learnings
  /reflect --critical - Process only critical items
  /reflect --analyze - View evolution insights

═══════════════════════════════════════════════════════════
```

If queue is empty:
```
═══════════════════════════════════════════════════════════
🧠 OPEN-REFLECT QUEUE: Empty
═══════════════════════════════════════════════════════════

No learnings queued. System is up to date.

To add learnings:
  • Use "remember: <learning>" for explicit capture
  • Corrections are auto-detected during conversations
  • Success patterns are captured automatically

💡 Run /reflect --analyze to view evolution insights
═══════════════════════════════════════════════════════════
```

## Implementation

Read and parse queue:
```bash
cat ~/.claude/openreflect-queue.json 2>/dev/null || echo "[]"
```

Extract and display metadata for each item:
- `type`: explicit/auto/positive/correction
- `category`: correction/success_pattern/preference/best_practice/common_error
- `priority`: critical/high/medium/normal
- `confidence`: 0.0-1.0
- `tags`: array of contextual tags
- `evolution_count`: times refined
- `usage_count`: times applied
- `last_validated`: last successful use
- `timestamp`: when captured
- `project`: where captured
- `patterns`: what triggered detection
