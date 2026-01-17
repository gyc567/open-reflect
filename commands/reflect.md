---
description: Advanced reflection system with knowledge evolution and multi-dimensional analysis
allowed-tools: Read, Write, Edit, Glob, Bash, Grep, AskUserQuestion
---

## Arguments
- `--analyze`: Analyze REFLECT.md and provide evolution insights
- `--view`: Show pending learnings queue with detailed metadata
- `--apply-all`: Apply all learnings without review (use with caution)
- `--critical-only`: Process only critical priority items
- `--scan-history`: Scan past sessions for missed learnings
- `--days N`: Limit history scan to N days (default: 30)
- `--export <file>`: Export learnings to external file
- `--import <file>`: Import learnings from external file

## Context
- Project REFLECT.md: @REFLECT.md
- Global CLAUDE.md: @~/.claude/CLAUDE.md
- Project CLAUDE.md: @CLAUDE.md
- Learnings queue: !`cat ~/.claude/openreflect-queue.json 2>/dev/null || echo "[]"`
- Current project: !`pwd`

## Enhanced Learning Categories

| Category | Purpose | Example |
|----------|---------|---------|
| **Correction** | Capture mistakes and fixes | "no, use gpt-5.1 not gpt-5" |
| **Success Pattern** | What works well | "Perfect! That's exactly what I wanted" |
| **Preference** | User preferences | "remember: I prefer shorter functions" |
| **Best Practice** | Discovered best practices | "Always validate input before processing" |
| **Common Error** | Mistakes to avoid | "Don't forget to handle null values" |

## Your Task

### Handle --analyze Argument

**If user passed `--analyze`:**
Run the evolution analysis script:
```bash
~/.claude/plugins/open-reflect/scripts/analyze-evolution.sh
```
Exit after showing analysis (don't process queue).

### Handle --view Argument

**If user passed `--view`:**
Display the current learnings queue with enhanced metadata:
```
═══════════════════════════════════════════════════════════
🧠 OPEN-REFLECT QUEUE ANALYSIS
═══════════════════════════════════════════════════════════

Total Learnings: [N]

By Priority:
  🔴 Critical: [N]
  🟡 High: [N]
  🟢 Medium: [N]

By Category:
  🔄 Corrections: [N]
  ✅ Success Patterns: [N]
  🎨 Preferences: [N]
  📋 Best Practices: [N]
  ⚠️ Common Errors: [N]

───────────────────────────────────────────────────────────────────

#1 [CRITICAL] Correction
   "First 80 chars..."
   
   Context: [project path]
   Time: [timestamp]
   Confidence: 0.95
   Tags: ["explicit", "critical"]
   Evolution count: 0
   
   → Action: Review and apply

#2 [HIGH] Success Pattern
   ...

───────────────────────────────────────────────────────────────────
```

Exit after showing view (don't process queue).

### Step 1: Load and Validate Queue

Read the queue from `~/.claude/openreflect-queue.json`:
```bash
cat ~/.claude/openreflect-queue.json 2>/dev/null || echo "[]"
```

If queue is empty and not doing history scan:
- Show: "No learnings queued. System is up to date."
- Exit

### Step 2: Filter by Priority (if --critical-only)

If user passed `--critical-only`:
- Filter queue to only items with `priority: "critical"`
- Show: "Processing [N] critical items only"
- Proceed with filtered list

### Step 3: Multi-Dimensional Categorization

For each learning in the queue, categorize by:

**1. Learning Type:**
- **Explicit**: Marked with "remember:" → Highest priority
- **Correction**: "no, use", "don't use", etc.
- **Positive**: "Perfect!", "Great approach", etc.
- **Preference**: "you should use", "I prefer", etc.

**2. Scope Determination:**
- **Global**: Model names, general patterns, tool preferences
- **Project**: Specific files, local configs, project conventions

**3. Enhancement Analysis:**
- Check if similar entries exist in REFLECT.md
- Track evolution_count (how many times refined)
- Track usage_count (how many times applied)
- Track last_validated (when last used successfully)

### Step 4: Duplicate and Conflict Detection

Search REFLECT.md for similar/contradictory entries:
```bash
grep -n -i "keyword" REFLECT.md
```

For each learning:
- **Duplicate found**: Show existing entry and offer: [m]erge | [r]eplace | [s]kip
- **Conflict found**: Show conflicting entries and offer: [r]esolve | [k]eep both | [s]kip new
- **Similar pattern found**: Show related entries and offer: [c]onsolidate | [k]eep separate

### Step 5: Present Summary Table

```
═══════════════════════════════════════════════════════════
📚 LEARNINGS SUMMARY — [N] items ready for review
═══════════════════════════════════════════════════════════

┌────┬───────────┬─────────────────┬──────────┬────────┬─────────┐
│ #  │ Priority  │ Category       │ Scope    │ Conf.   │ Action  │
├────┼───────────┼─────────────────┼──────────┼────────┼─────────┤
│ 1  │ 🔴 Critical│ Correction     │ global   │ 0.95    │ Merge   │
│ 2  │ 🟡 High    │ Success Pattern │ project  │ 0.85    │ Add     │
│ 3  │ 🟢 Medium  │ Preference     │ project  │ 0.70    │ Add     │
└────┴───────────┴─────────────────┴──────────┴────────┴─────────┘

Statistics:
  • Corrections:   [N]
  • Success patterns: [N]
  • Preferences:    [N]
  • Average confidence: [X]%
  • Pending since: [oldest timestamp]

═══════════════════════════════════════════════════════════
```

### Step 6: Get User Decision

Use AskUserQuestion for action selection:
```json
{
  "questions": [{
    "question": "How would you like to process these [N] learnings?",
    "header": "Action Required",
    "multiSelect": false,
    "options": [
      {"label": "Apply all (Recommended)", "description": "Apply all learnings with recommended actions"},
      {"label": "Review each item", "description": "Review details for each learning before applying"},
      {"label": "Apply critical only", "description": "Process only critical priority items"},
      {"label": "Skip all", "description": "Don't apply anything, keep queue for later"}
    ]
  }]
}
```

**Handle response:**
- **"Apply all"** → Go to Step 7
- **"Review each item"** → Go to Step 6.1
- **"Apply critical only"** → Filter queue to critical items, return to Step 5
- **"Skip all"** → Exit without changes

### Step 6.1: Detailed Review Mode (if user chose)

For each learning, show detailed card:
```
═══════════════════════════════════════════════════════════
📝 LEARNING [#N] — [Category]
═══════════════════════════════════════════════════════════

Original Message:
  "[full user message]"

Analysis:
  • Confidence: 0.XX
  • Priority: [critical/high/medium]
  • Category: [correction/success_pattern/preference/etc]
  • Tags: [array]
  • Captured: [timestamp]

Duplicate Check:
  ✓ No duplicates found
  OR
  ⚠️ Similar entry in REFLECT.md:
     [line]: "[existing content]"

Recommended Action:
  • Add to: [Global CLAUDE.md / Project CLAUDE.md / REFLECT.md]
  • Section: [Section name]
  • Format: "- [learning text]"

═══════════════════════════════════════════════════════════
```

Use AskUserQuestion per item:
```json
{
  "questions": [{
    "question": "What should we do with this learning?",
    "header": "Review Item #N",
    "multiSelect": false,
    "options": [
      {"label": "Apply to CLAUDE.md", "description": "Add to [global/project] CLAUDE.md"},
      {"label": "Add to REFLECT.md", "description": "Add to project REFLECT.md for review"},
      {"label": "Edit before applying", "description": "Modify the learning text"},
      {"label": "Skip this item", "description": "Remove from queue without applying"}
    ]
  }]
}
```

### Step 7: Apply Changes

**7a. Update REFLECT.md (Primary Target - Enhanced Format):**

Read current REFLECT.md and update with new learnings in structured format:

```markdown
## 🔄 修正类学习（Corrections）

### 2026-01-17
- [Learning 1] *(来源: queued, 置信度: 0.95, 使用次数: 0)*
- [Learning 2] *(来源: queued, 置信度: 0.85, 使用次数: 0)*

### [Earlier dates...]
...
```

Update evolution history table at bottom:
```markdown
## 📜 演化历史

| 版本 | 日期 | 变更类型 | 描述 |
|-------|------|---------|------|
| 1.0.1 | 2026-01-17 | 新增 | Added [N] learnings from queue |
...
```

**7b. Update CLAUDE.md (Optional - User Choice):**

If user chose to sync to CLAUDE.md, apply with appropriate sections:

```markdown
## LLM Model Recommendations
- [Model preference learning]

## Tool Usage
- [Tool usage pattern]

## Project Conventions
- [Project-specific learning]

## Best Practices
- [Best practice discovery]
```

**7c. Update Evolution Metrics:**

For each applied learning, increment its `evolution_count` and update `last_validated` timestamp.

### Step 8: Clear Applied Items

Remove applied items from queue:
```bash
jq 'map(select(.status != "applied"))' ~/.claude/openreflect-queue.json > ~/.claude/openreflect-queue.json.tmp
mv ~/.claude/openreflect-queue.json.tmp ~/.claude/openreflect-queue.json
```

Or clear entire queue if all applied:
```bash
echo "[]" > ~/.claude/openreflect-queue.json
```

### Step 9: Confirm and Summary

```
═══════════════════════════════════════════════════════════
✅ KNOWLEDGE EVOLUTION COMPLETE
═══════════════════════════════════════════════════════════

Applied:
  ✓ REFLECT.md    [N] learnings
  ✓ CLAUDE.md     [N] learnings (if sync enabled)
  
Enhanced:
  📊 Evolution metrics updated
  🏷️ Tags and metadata preserved
  📜 History logged

Skipped:
  [N] items (with reasons)

═══════════════════════════════════════════════════════════

💡 Next Steps:
  • Review REFLECT.md to ensure quality
  • Run /reflect --analyze to see evolution insights
  • Share learnings across projects if applicable
```

## Advanced Features

### Evolution Tracking

Each learning tracks:
- **evolution_count**: How many times refined
- **usage_count**: How many times successfully applied
- **last_validated**: Last time this learning was validated

### Smart Deduplication

- Detects semantically similar entries
- Identifies contradictions
- Proposes consolidations
- Preserves history

### Multi-Target Sync

Supports:
- **REFLECT.md** (Primary - Enhanced format with history)
- **CLAUDE.md** (Standard - Simplified format)
- **AGENTS.md** (Cross-tool compatibility)

### Priority-Based Processing

Critical learnings are highlighted and processed first:
- 🔴 Critical: User explicitly marked ("remember:")
- 🟡 High: Strong patterns, repeated corrections
- 🟢 Medium: General patterns, moderate confidence

## Formatting Rules

**REFLECT.md Enhanced Format:**
- Include metadata in parentheses: *(来源: queued, 置信度: 0.95, 使用次数: 0)*
- Group by date and category
- Track evolution in dedicated section
- Preserve full history

**CLAUDE.md Standard Format:**
- Simple bullet points
- Clear section headers
- Actionable language
- Max 2 lines per entry
