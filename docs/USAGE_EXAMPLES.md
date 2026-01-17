# Open-Reflect Usage Examples

This document provides practical examples of how to use Open-Reflect effectively.

## Basic Workflow

### Example 1: Capturing and Applying a Correction

**Scenario**: You notice Claude is using the wrong model for reasoning tasks.

```
You: Build a reasoning system for this data

Claude: [Using gpt-5 to build the system...]

You: no, use gpt-5.1 not gpt-5 for reasoning tasks

[Hook automatically captures this correction]

Claude: Got it! I'll use gpt-5.1 for reasoning tasks.

[Continue working...]

You: /reflect

Claude: 
═══════════════════════════════════════════════════════════
📚 LEARNINGS SUMMARY — 1 item ready for review
═══════════════════════════════════════════════════════════

┌────┬───────────┬─────────────────┬──────────┬────────┬─────────┐
│ #  │ Priority  │ Category       │ Scope    │ Conf.   │ Action  │
├────┼───────────┼─────────────────┼──────────┼────────┼─────────┤
│ 1  │ 🔴 Critical│ Correction     │ global   │ 0.90    │ Add     │
└────┴───────────┴─────────────────┴──────────┴────────┴─────────┘

How would you like to process this learning?
[Apply all (Recommended)]
[Review each item]
[Apply critical only]
[Skip all]

You: [Apply all (Recommended)]

Claude: ✅ Applied to REFLECT.md
   ✅ Synced to ~/.claude/CLAUDE.md

Knowledge evolved successfully!
═══════════════════════════════════════════════════════════
```

**Result**: The learning is now in both REFLECT.md (with full history) and CLAUDE.md (simplified).

### Example 2: Capturing a Success Pattern

**Scenario**: Claude implements a caching strategy that works perfectly.

```
Claude: I'll implement a local database cache to minimize API calls...

[Implementation completes...]

You: Perfect! That's exactly what I wanted.

[Hook captures success pattern]

Claude: Thanks! I'll remember this pattern for future tasks.

[Later...]

You: /reflect

Claude: 
═══════════════════════════════════════════════════════════
📚 LEARNINGS SUMMARY — 1 item ready for review
═══════════════════════════════════════════════════════════

#1 [🟢 MEDIUM] Success Pattern
   "Use local database cache to minimize API calls"
   
   Context: /path/to/project
   Time: 2026-01-17T12:00:00Z
   Confidence: 0.75
   Evolution count: 0
   Usage count: 0
   
   → Run /reflect to process

Apply to: [Global CLAUDE.md / Project CLAUDE.md / REFLECT.md]
[Apply to CLAUDE.md]

Claude: ✅ Added to REFLECT.md under "成功模式"
   ✅ Synced to ./CLAUDE.md
```

### Example 3: Using Explicit Markers

**Scenario**: You want to ensure Claude remembers a preference.

```
You: Build a utility function for data validation

Claude: [Using type inference...]

You: remember: I prefer explicit types over type inference

[Hook captures with highest confidence 0.95)

Claude: Got it! I'll use explicit types for data validation functions.

[Immediate effect on next function]

Claude: I'll create a utility function with explicit type annotations...
```

## Advanced Usage

### Example 4: Analyzing Evolution Trends

**Scenario**: You want to understand your learning patterns.

```bash
/reflect --analyze
```

**Output**:
```
🔬 Open-Reflect Evolution Analysis
════════════════════════════════════════════════════

📊 Current Queue Status:
  Total items: 12

  By Category:
    • Corrections:   5
    • Success patterns: 3
    • Preferences:    2
    • Best practices: 2

  By Priority:
    • Critical: 1
    • High:     4
    • Medium:   7

  Average Confidence: 82%

💡 Recommendations:

  • High correction rate detected
    → Consider running /reflect to consolidate learnings
    → Review if initial instructions need clarification

  • Strong success patterns captured
    → Document these as best practices in CLAUDE.md
    → Consider creating reusable patterns

════════════════════════════════════════════════════
```

### Example 5: Viewing Queue Details

**Scenario**: You want to see what's pending before processing.

```bash
/reflect --view
```

**Output**:
```
═══════════════════════════════════════════════════════════
🧠 OPEN-REFLECT QUEUE ANALYSIS
═══════════════════════════════════════════════════════════

Total Learnings: 5

📊 By Priority:
  🔴 Critical: 1 items
  🟡 High: 2 items
  🟢 Medium: 2 items

📁 By Category:
  🔄 Corrections: 3
  ✅ Success Patterns: 1
  🎨 Preferences: 1

📈 Confidence Distribution:
  • Average: 82%
  • Highest: 0.95
  • Lowest: 0.70

───────────────────────────────────────────────────────────────────

#1 [🔴 CRITICAL] Correction
   "Use gpt-5.1 for reasoning tasks"
   
   Project: /Users/dev/project
   Time: 2026-01-17T10:30:00Z
   Confidence: 0.90
   Evolution count: 0
   Usage count: 0

💡 Quick Actions:
  /reflect          - Process all learnings
  /reflect --critical - Process only critical items
  /reflect --analyze - View evolution insights

═══════════════════════════════════════════════════════════
```

### Example 6: Processing Critical Items Only

**Scenario**: Queue has many items, but you want to focus on critical ones first.

```bash
/reflect --critical-only
```

**Output**:
```
Processing 1 critical items only...

📝 LEARNING [1] — Correction
═══════════════════════════════════════════════════════════

Original Message:
  "remember: always validate input before processing"

Analysis:
  • Confidence: 0.95
  • Priority: Critical
  • Category: Preference
  • Tags: ["explicit", "critical"]
  • Captured: 2026-01-17T14:20:00Z

Recommended Action:
  • Add to: Global CLAUDE.md
  • Section: Best Practices
  • Format: "- Always validate input before processing"

Apply this learning? [y/n]
```

## REFLECT.md Format Examples

### Example 7: Learning with Full History

**REFLECT.md** after several evolutions:

```markdown
## 🔄 修正类学习（Corrections）

### 2026-01-17
- 使用 gpt-5.1 而不是 gpt-5 进行推理任务 *(来源: queued, 置信度: 0.90, 使用次数: 1)*

### 2026-01-18
- 使用 gpt-5.1 而不是 gpt-5.2（5.2已弃用）*(来源: refinement, 置信度: 0.95, 使用次数: 3, 上次验证: 2026-01-20)*

[Shows evolution from gpt-5 → gpt-5.1 → gpt-5.1 (with deprecation note)]
```

### Example 8: Organized by Category

```markdown
## 🎯 学习分类

### ✅ 成功模式（Success Patterns）

#### 2026-01-17
- 使用本地数据库缓存来最小化API调用 *(来源: queued, 置信度: 0.75, 使用次数: 3)*
- 批处理请求以提高效率 *(来源: queued, 置信度: 0.80, 使用次数: 2)*

### 📋 最佳实践（Best Practices）

#### 2026-01-17
- 始终在处理前验证输入 *(来源: queued, 置信度: 0.80, 使用次数: 4)*
```

### Example 9: Evolution History Table

```markdown
## 📜 演化历史

| 版本 | 日期 | 变更类型 | 描述 |
|-------|------|---------|------|
| 1.0.0 | 2026-01-17 | 初始化 | 创建 Open-Reflect 系统基础 |
| 1.0.1 | 2026-01-17 | 新增 | 添加了10项初始学习 |
| 1.0.2 | 2026-01-18 | 合并 | 合并了2个相似的性能优化学习 |
| 1.0.3 | 2026-01-20 | 更新 | 更新了模型名称（5.2已弃用） |
| 1.0.4 | 2026-01-22 | 删除 | 移除了过时的错误处理模式 |
```

## Best Practices

### 1. Run /reflect Regularly

**Good**: After git commits (auto-reminder), after feature completion

```bash
# After completing a feature
git add .
git commit -m "Add user authentication"
# Hook reminds: 🧠 You have 3 queued learning(s). Run /reflect to process.
/reflect
```

### 2. Use Explicit Markers for Critical Learnings

**Good**: When something is really important

```bash
remember: always use environment variables for secrets, never hardcode
```

**Result**: Highest confidence (0.95) + critical priority + 180 day decay period.

### 3. Provide Positive Feedback for Patterns

**Good**: When something works exceptionally well

```bash
Perfect! That's exactly the approach I wanted for this.
```

**Result**: Captured as success pattern, helps identify what works.

### 4. Review REFLECT.md Periodically

**Schedule**: Weekly or bi-weekly

```bash
# Open REFLECT.md and review:
cat REFLECT.md

# Look for:
# - Outdated learnings (old model names, deprecated APIs)
# - Conflicting entries (do X vs don't do X)
# - Consolidation opportunities (similar items that can merge)
```

### 5. Use Priority-Based Processing

**When queue is large**:

```bash
# Process critical items first
/reflect --critical-only

# Then process the rest
/reflect
```

## Common Scenarios

### Scenario 10: Conflicting Learnings

**Problem**: Queue has "use X" and "don't use X" learnings.

**Detection**:
```
⚠️ CONFLICT DETECTED in REFLECT.md:
   Line 45: "- Use venv for Python projects"
   Line 78: "- Don't use venv, use pipenv instead"

Resolution Options:
  [r]esolve - Merge into consensus recommendation
  [k]eep both - Keep both entries with notes
  [s]kip new - Don't add this learning

[resolve]
→ Recommended: "- Use Python virtual environments (venv or pipenv) for project isolation"
```

### Scenario 11: Outdated Learnings

**Problem**: REFLECT.md has learnings about deprecated APIs.

**Manual Review**:
```markdown
## 🔄 修正类学习（Corrections）

### 2026-01-10 ⚠️ [过时]
- 使用 Twitter API v1.1 *(来源: queued, 置信度: 0.90, 使用次数: 5)*

### 2026-01-15
- 使用 Twitter API v2 *(来源: refinement, 置信度: 0.95, 使用次数: 2)*
```

**Action**: Add ⚠️ [过时] marker and update/refine entry.

### Scenario 12: High Correction Rate

**Analysis Output**:
```
💡 Recommendations:
  • High correction rate detected
    → Consider running /reflect to consolidate learnings
    → Review if initial instructions need clarification
```

**Root Cause Analysis**:
1. Review CLAUDE.md for clarity
2. Check for contradictory entries
3. Identify patterns in what gets corrected
4. Update initial instructions to reduce corrections

**Fix**: Update CLAUDE.md with clearer guidelines.

## Troubleshooting

### Issue: Hooks not triggering

**Check**:
```bash
# Verify hooks.json exists and is valid
cat ~/.claude/plugins/open-reflect/hooks/hooks.json
jq empty ~/.claude/plugins/open-reflect/hooks/hooks.json

# Verify scripts are executable
ls -l ~/.claude/plugins/open-reflect/scripts/*.sh

# Check Claude Code plugin is loaded
claude plugin list
```

### Issue: Queue not updating

**Check**:
```bash
# Verify queue file exists
ls -la ~/.claude/openreflect-queue.json

# Check permissions
chmod 644 ~/.claude/openreflect-queue.json

# Manually test capture
echo '{"prompt": "test message"}' | bash ~/.claude/plugins/open-reflect/scripts/capture-learning-enhanced.sh
cat ~/.claude/openreflect-queue.json
```

### Issue: REFLECT.md not updating

**Check**:
```bash
# Verify REFLECT.md exists in current directory
ls -la REFLECT.md

# Check permissions
chmod 644 REFLECT.md

# Test write access
echo "test" >> REFLECT.md
```

---

**"Knowledge is not static. It evolves through reflection and practice."** - Open-Reflect
