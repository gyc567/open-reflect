---
name: open-reflect
description: |
  Advanced self-learning and reflection system with knowledge evolution tracking.
  Captures corrections, success patterns, preferences, and best practices,
  then organizes them in REFLECT.md with full evolution history.
  Use when discussing learnings, corrections, or when user mentions remembering.
  Triggers: "remember this", "use X not Y", "actually...", "Perfect!", corrections, feedback.
allowed-tools: Read, Write, Edit, Glob, Bash(jq:*), Bash(cat:*), AskUserQuestion, Grep
version: 1.0.0
license: MIT
author: OpenReflect Team
---

# Open-Reflect - Advanced Self-Learning & Reflection System

A three-stage system that helps Claude Code learn, reflect, and evolve from all interactions.

## How It Works

**Stage 1: Capture (Automatic)**
Enhanced hooks detect multiple learning dimensions and queue them to `~/.claude/openreflect-queue.json`:

| Learning Type | Trigger | Confidence | Example |
|---------------|---------|-------------|----------|
| **Explicit** | "remember:" | 0.95 (highest) | "remember: use venv for Python" |
| **Correction** | "no, use X", "don't use Y" | 0.90 | "no, use gpt-5.1 not gpt-5" |
| **Success Pattern** | "Perfect!", "Great approach" | 0.75 | "Perfect! That's what I wanted" |
| **Preference** | "you should use", "I prefer" | 0.70 | "I prefer shorter functions" |

Each captured learning includes:
- Multi-dimensional category (correction/success/preference/best-practice)
- Priority level (critical/high/medium/normal)
- Confidence score (0.60-0.95)
- Semantic tags
- Evolution tracking (refinement count, usage count, last validated)

**Stage 2: Reflect (Manual)**
User runs `/reflect` to review and apply queued learnings to REFLECT.md with:
- Multi-dimensional categorization
- Duplicate/conflict detection
- Evolution history tracking
- Smart deduplication and consolidation
- Priority-based processing

**Stage 3: Evolve (Continuous)**
REFLECT.md serves as knowledge evolution record:
- Tracks learning history and changes
- Monitors usage and validation
- Identifies patterns and trends
- Provides actionable insights for improvement

## Available Commands

| Command | Purpose |
|---------|---------|
| `/reflect` | Process queued learnings with review |
| `/reflect --analyze` | Analyze REFLECT.md evolution and provide insights |
| `/reflect --view` | View queue with detailed metadata |
| `/reflect --critical-only` | Process only critical priority items |
| `/reflect --scan-history` | Scan past sessions for missed learnings |
| `/skip-reflect` | Discard all queued learnings |

## When to Remind Users

Remind users about `/reflect` when:
- They complete a feature or meaningful work unit
- They make corrections that should be remembered
- They explicitly say "remember this" or similar
- Context is about to compact and queue has critical items
- Git commit is detected with pending learnings
- Success patterns are captured (positive feedback)

## Enhanced Learning Categories

| Category | Description | Example |
|-----------|-------------|----------|
| **Correction** | Mistakes and how to fix them | "no, use X not Y" |
| **Success Pattern** | What works well (positive feedback) | "Perfect! Exactly right" |
| **Preference** | User preferences and style choices | "I prefer explicit types" |
| **Best Practice** | Discovered best practices | "Always validate input" |
| **Common Error** | Mistakes to avoid | "Don't forget error handling" |

## REFLECT.md Structure

REFLECT.md is the core knowledge evolution file:

```markdown
# Open-Reflect 知识演化日志

## 🎯 学习分类
### 🔄 修正类学习（Corrections）
### ✅ 成功模式（Success Patterns）
### 🎨 偏好设置（Preferences）
### 📋 最佳实践（Best Practices）
### ⚠️ 常见错误（Common Errors）

## 🔍 智能洞察
### 📈 学习趋势分析
### 🎯 建议优化
### 🔗 知识关联

## 📜 演化历史
Table tracking all changes over time

## 💭 反思笔记
### 待处理队列
### 已拒绝项
### 待验证项
```

## CLAUDE.md Destinations

Syncs to:
- `~/.claude/CLAUDE.md` - Global learnings (model names, general patterns)
- `./CLAUDE.md` - Project-specific learnings (conventions, tools)
- `./AGENTS.md` - Cross-tool compatibility (if exists)

## Multi-Dimensional Analysis

### Priority Levels
- 🔴 **Critical**: User explicitly marked ("remember:"), 0.90+ confidence
- 🟡 **High**: Strong patterns, repeated corrections, 0.80+ confidence
- 🟢 **Medium**: General patterns, moderate confidence, 0.70+ confidence
- ⚪ **Normal**: Low confidence or unclear context

### Confidence Scoring
- **0.95**: Explicit "remember:" marker (highest priority)
- **0.90**: Strong corrections with clear intent
- **0.80-0.85**: Medium-strength patterns, clarifications
- **0.70**: General suggestions, preferences
- **0.60-0.65**: Weak patterns, requires validation

### Evolution Metrics
Each learning tracks:
- **evolution_count**: How many times refined/updated
- **usage_count**: How many times successfully applied
- **last_validated**: Last time this learning was validated as correct
- **decay_days**: Time before learning becomes stale

## Example Interaction

```
User: no, use gpt-5.1 not gpt-5 for reasoning tasks
Claude: Got it, I'll use gpt-5.1 for reasoning tasks.

[Hook captures to queue with: category=correction, priority=high, confidence=0.90]

User: /reflect
Claude: Found 1 learning queued.
        "Use gpt-5.1 for reasoning tasks"
        Category: Correction
        Priority: High
        Confidence: 90%
        Scope: global
        Apply to REFLECT.md? [y/n]
```

## Smart Features

### 1. Multi-Category Capture
Captures not just corrections but:
- ✅ What works (success patterns)
- 🎨 Preferences (style choices)
- 📋 Best practices (discoveries)
- ⚠️ Common errors (avoidance)

### 2. Evolution Tracking
- Refinements are tracked (evolution_count)
- Usage is monitored (usage_count)
- Validation is recorded (last_validated)
- Full history preserved in REFLECT.md

### 3. Smart Deduplication
- Detects semantically similar entries
- Identifies contradictory learnings
- Proposes consolidations
- Preserves history through changes

### 4. Priority-Based Processing
- Critical items highlighted
- High-confidence items prioritized
- Batch processing by priority
- Selective processing options

### 5. Multi-Target Sync
- REFLECT.md (enhanced format with history)
- CLAUDE.md (standard format)
- AGENTS.md (cross-tool)

## Enhancement Over claude-reflect

| Feature | claude-reflect | open-reflect |
|---------|---------------|--------------|
| Learning types | Corrections only | Corrections + Success + Preferences + Best Practices |
| Data structure | Simple queue | Structured REFLECT.md with evolution |
| Evolution tracking | None | Full history (refinements, usage, validation) |
| Priority levels | Confidence only | Priority + Confidence + Tags |
| Duplicate handling | Basic | Semantic + Conflict detection + Consolidation |
| Analysis | Basic queue view | Trend analysis + Insights + Recommendations |
| Multi-target | CLAUDE.md + AGENTS.md | REFLECT.md + CLAUDE.md + AGENTS.md |
| Context awareness | Project only | Project + Global + Evolution metrics |

## Philosophy

Open-Reflect embodies the principle: **"Learning through reflection, evolution through practice"**

Unlike simple capture systems, Open-Reflect:
1. **Captures broadly**: Not just mistakes, but successes, preferences, and patterns
2. **Reflects deeply**: Maintains full evolution history and context
3. **Evolves continuously**: Tracks usage, validation, and refinements
4. **Analyzes intelligently**: Provides insights on trends, conflicts, and optimizations

The system respects human autonomy while automating:
- 🤖 Automatic capture (machine efficiency)
- 👤 Manual review (human judgment)
- 📈 Continuous evolution (iterative improvement)
