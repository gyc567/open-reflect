# Open-Reflect Architecture Documentation

## System Overview

Open-Reflect is an advanced self-learning and reflection system that captures learnings from Claude Code interactions and evolves them into a structured knowledge base.

```
┌─────────────────────────────────────────────────────────────────┐
│                     User Interaction Flow                    │
└─────────────────────────────────────────────────────────────────┘

User Input ──► Hook Capture ──► Queue Enrichment ──► Queue Storage
                    ↓                    ↓                    ↓
                 Multi-Dimensional      Enhanced Metadata      JSON File
                 Pattern Detection      (Priority, Tags)       with
                                      Evolution Metrics        History

                    ↓
                 Manual Review
                    ↓
         ┌──────────┴──────────┐
         │                     │
    Apply to REFLECT.md   Sync to CLAUDE.md
         │                     │
         └──────────┬──────────┘
                    ↓
            Knowledge Evolution
                    ↓
         Continuous Improvement
```

## Core Components

### 1. Capture System (Automatic)

**Location**: `scripts/capture-learning-enhanced.sh`

**Triggers**: UserPromptSubmit hook (every user message)

**Learning Dimensions**:
- **Explicit**: "remember:" markers (confidence: 0.95)
- **Correction**: "no, use X", "don't use Y" (confidence: 0.90)
- **Success**: "Perfect!", "Great approach" (confidence: 0.75)
- **Preference**: "you should use", "I prefer" (confidence: 0.70)

**Metadata Captured**:
- Category (correction/success_pattern/preference/best_practice/common_error)
- Subcategory (explicit_correction/perfect_match/etc.)
- Priority (critical/high/medium/normal)
- Confidence score (0.60-0.95)
- Semantic tags
- Project path
- Timestamp
- Decay period (60-180 days)
- Evolution metrics (usage_count, evolution_count, last_validated)

### 2. Queue System

**Location**: `~/.claude/openreflect-queue.json`

**Structure**:
```json
[
  {
    "type": "correction",
    "category": "correction",
    "subcategory": "explicit_correction",
    "message": "no, use gpt-5.1 not gpt-5",
    "timestamp": "2026-01-17T10:30:00Z",
    "project": "/path/to/project",
    "patterns": "no,use",
    "confidence": 0.90,
    "priority": "high",
    "tags": ["correction", "pending-review"],
    "decay_days": 90,
    "status": "pending",
    "evolution_count": 0,
    "usage_count": 0,
    "last_validated": null
  }
]
```

**Features**:
- JSON array for easy querying with jq
- Rich metadata for each learning
- Status tracking (pending/applied/rejected)
- Evolution metrics for continuous improvement

### 3. Analysis System

**Location**: `scripts/analyze-evolution.sh`

**Functions**:
- Queue statistics (total, by category, by priority)
- Confidence distribution
- Trend analysis
- Recommendations based on patterns

**Output**: Console report with visual breakdown

### 4. Command System

**Location**: `commands/*.md`

**Commands**:
- `/reflect` - Main processing command
- `/reflect --analyze` - Evolution insights
- `/reflect --view` - Queue inspection
- `/reflect --critical-only` - Critical-only processing
- `/skip-reflect` - Discard queue

**Features**:
- Interactive review with AskUserQuestion
- Duplicate/conflict detection
- Smart deduplication
- Priority-based processing
- Multi-target sync (REFLECT.md, CLAUDE.md, AGENTS.md)

### 5. REFLECT.md (Primary Knowledge Store)

**Structure**:
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
[Table of all changes over time]

## 💭 反思笔记
### 待处理队列
### 已拒绝项
### 待验证项
```

**Features**:
- Full evolution history tracking
- Multi-category organization
- Metadata preservation (confidence, usage, validation)
- Insight and trend analysis
- Chinese/English bilingual headers

### 6. Hooks System

**Location**: `hooks/hooks.json`

**Hooks**:
1. **PreCompact**: Queue check with backup
2. **PostToolUse**: Commit reminder for Bash
3. **UserPromptSubmit**: Learning capture

**Configuration**:
```json
{
  "hooks": {
    "PreCompact": [...],
    "PostToolUse": [...],
    "UserPromptSubmit": [...]
  }
}
```

## Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    Stage 1: Capture                    │
└─────────────────────────────────────────────────────────────┘

User Message
    ↓
UserPromptSubmit Hook
    ↓
capture-learning-enhanced.sh
    ↓
Pattern Detection (Multi-Dimensional)
    ↓
Metadata Enrichment
    ↓
Queue Storage (~/.claude/openreflect-queue.json)

┌─────────────────────────────────────────────────────────────┐
│                   Stage 2: Reflect                     │
└─────────────────────────────────────────────────────────────┘

User runs /reflect
    ↓
Load Queue
    ↓
Categorization & Prioritization
    ↓
Duplicate/Conflict Detection
    ↓
Interactive Review (AskUserQuestion)
    ↓
Apply to REFLECT.md (with full history)
    ↓
Sync to CLAUDE.md (optional)

┌─────────────────────────────────────────────────────────────┐
│                   Stage 3: Evolve                      │
└─────────────────────────────────────────────────────────────┘

Monitor Usage
    ↓
Update Evolution Metrics
    ↓
Trend Analysis
    ↓
Insights & Recommendations
    ↓
Continuous Improvement
```

## Key Design Principles

### 1. Multi-Dimensional Capture

Not just corrections, but:
- ✅ Success patterns (what works)
- 🎨 Preferences (style choices)
- 📋 Best practices (discoveries)
- ⚠️ Common errors (avoidance)

**Why**: Comprehensive learning from all interactions, not just mistakes.

### 2. Evolution Tracking

Each learning tracks:
- **evolution_count**: Refinements over time
- **usage_count**: Successful applications
- **last_validated**: Last verification

**Why**: Understand how knowledge evolves and what's most useful.

### 3. Priority-Based Processing

Priority levels:
- 🔴 Critical: Explicit markers, high confidence
- 🟡 High: Strong patterns, repeated corrections
- 🟢 Medium: General patterns, moderate confidence

**Why**: Ensure important learnings get attention first.

### 4. Smart Deduplication

- Semantic similarity detection
- Conflict identification
- Consolidation proposals
- History preservation

**Why**: Avoid redundancy while maintaining full context.

### 5. Multi-Target Sync

Targets:
- **REFLECT.md**: Primary, enhanced format
- **CLAUDE.md**: Standard, simplified
- **AGENTS.md**: Cross-tool compatibility

**Why**: Support different workflows and tool ecosystems.

## Comparison with claude-reflect

| Dimension | claude-reflect | open-reflect |
|-----------|---------------|--------------|
| **Learning Types** | Corrections | Corrections + Success + Preferences + Best Practices + Errors |
| **Data Structure** | Simple queue | Queue + REFLECT.md with history |
| **Evolution** | None | Full tracking (refinements, usage, validation) |
| **Priority** | Confidence only | Priority + Confidence + Tags |
| **Deduplication** | Basic | Semantic + Conflict + Consolidation |
| **Analysis** | Queue view | Trends + Insights + Recommendations |
| **Multi-Target** | CLAUDE.md + AGENTS.md | REFLECT.md + CLAUDE.md + AGENTS.md |
| **Language** | English | Chinese + English bilingual |

## Future Enhancements

### Planned Features

1. **Knowledge Graph**: Visualize relationships between learnings
2. **Automatic Validation**: Test learnings against new code
3. **Cross-Project Sync**: Share learnings between projects
4. **ML-Based Classification**: Improve pattern detection with ML
5. **Web Dashboard**: UI for viewing and managing knowledge

### Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.
