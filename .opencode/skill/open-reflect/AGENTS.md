# Open-Reflect Agents Guide

**Version 1.1.0**  
OpenReflect Team  
January 2026

> **Note:**  
> This document is mainly for agents and LLMs to follow when implementing
> learning capture, reflection processing, and knowledge evolution workflows.

---

## Overview

Open-Reflect is a three-stage knowledge evolution system for AI assistants. This guide provides specific rules for agents to:

1. **Detect** learning opportunities in conversations
2. **Capture** learnings with proper classification
3. **Process** reflections with human review
4. **Track** knowledge evolution over time

## Core Principles

### 1. Capture Broadly, Not Just Errors

Unlike simple error logging, Open-Reflect captures multiple learning dimensions:

| Learning Type | What It Captures | Example Triggers |
|--------------|------------------|------------------|
| **Explicit** | User explicitly marks to remember | "remember:", "note this" |
| **Correction** | User corrects AI behavior | "no, use X", "don't use Y", "actually..." |
| **Success** | What worked well (positive feedback) | "Perfect!", "Exactly right", "Great!" |
| **Preference** | User's style/approach preferences | "I prefer", "should use", "you should" |
| **Best Practice** | Discovered effective patterns | "Always validate input first" |
| **Common Error** | Errors and how to avoid them | Error patterns, anti-patterns |

### 2. Confidence Scoring

Each capture includes a confidence score (0.60-0.95):

| Confidence | When to Use | Example |
|------------|-------------|---------|
| **0.95** | Explicit markers like "remember:" | "remember: use venv for Python" |
| **0.90** | Clear corrections with alternatives | "no, use gpt-5.1 not gpt-5" |
| **0.75** | Positive success patterns | "Perfect! That's exactly what I wanted" |
| **0.70** | User preferences and style | "I prefer explicit types" |
| **0.65** | Common errors identified | "Don't forget error handling" |
| **0.60** | General best practices discovered | "Always validate input first" |

### 3. Priority Assignment

Learnings are prioritized to help with processing order:

| Priority | Criteria | Action |
|----------|----------|--------|
| **Critical** | Explicit markers, 0.90+ confidence | Process first, flag for immediate review |
| **High** | Strong corrections, repeated feedback | Process soon, add to knowledge base |
| **Medium** | General patterns, moderate confidence | Standard processing |
| **Normal** | Context-dependent, lower confidence | Queue for later review |

---

## Detection Rules

### Rule: EXPLICIT_MARKER_DETECTION

**Trigger**: User explicitly marks something to remember
**Confidence**: 0.95 (highest)
**Priority**: Critical

**Patterns:**
```
"remember: <learning>"
"note: <learning>"
"note that <learning>"
"important: <learning>"
"make sure to <learning>"
"don't forget to <learning>"
```

**Example:**
```
User: remember: always use venv for Python projects
→ Extract: "always use venv for Python projects"
→ Category: Best Practice
→ Tags: python, environment, development
→ Confidence: 0.95
→ Priority: Critical
```

### Rule: CORRECTION_DETECTION

**Trigger**: User corrects AI behavior or output
**Confidence**: 0.90
**Priority**: High

**Patterns:**
```
"no, use X not Y"
"no, don't use Y"
"actually, <correction>"
"<statement> not <correction>"
"you should have <correction>"
"instead of <wrong>, use <right>"
```

**Example:**
```
User: no, use gpt-5.1 not gpt-5 for reasoning tasks
→ Extract correction: "use gpt-5.1 not gpt-5 for reasoning"
→ Original behavior: "using gpt-5 for reasoning"
→ Category: Model Selection
→ Tags: ai, reasoning, model-selection
→ Confidence: 0.90
→ Priority: High
```

### Rule: SUCCESS_PATTERN_DETECTION

**Trigger**: User provides positive feedback on AI output
**Confidence**: 0.75
**Priority**: Medium-High

**Patterns:**
```
"Perfect!"
"Exactly right!"
"That's exactly what I wanted"
"Great approach"
"Exactly how I would have done it"
"This is perfect"
"Nailed it"
```

**Example:**
```
User: Perfect! That's the exact caching strategy I wanted.
→ Extract: "caching strategy with TTL and LRU eviction"
→ Success context: API response caching
→ Category: Performance
→ Tags: caching, performance, api
→ Confidence: 0.75
→ Priority: Medium-High
```

### Rule: PREFERENCE_DETECTION

**Trigger**: User expresses style or approach preferences
**Confidence**: 0.70
**Priority**: Medium

**Patterns:**
```
"I prefer <preference>"
"you should use <preference>"
"always <preference>"
"in my code, I <preference>"
"for me, <preference>"
```

**Example:**
```
User: I prefer explicit types over implicit any
→ Extract: "explicit types over implicit any"
→ Category: Code Style
→ Tags: typescript, types, style
→ Confidence: 0.70
→ Priority: Medium
```

### Rule: BEST_PRACTICE_DISCOVERY

**Trigger**: Discovering effective patterns during work
**Confidence**: 0.60
**Priority**: Normal

**Patterns** (inferred from successful implementations):
- Patterns that consistently solve problems
- Architectural decisions that work well
- Security patterns that prevent issues
- Performance optimizations that help

**Example:**
```
During implementation, discovered that input validation
at API boundaries prevents 90% of injection attacks.
→ Extract: "Always validate input at API boundaries"
→ Category: Security
→ Tags: security, validation, api
→ Confidence: 0.60
→ Priority: Normal
```

### Rule: COMMON_ERROR_DETECTION

**Trigger**: Errors or anti-patterns identified
**Confidence**: 0.65
**Priority**: Medium-High

**Patterns:**
```
"don't forget <error handling>"
"common mistake: <anti-pattern>"
"avoid <anti-pattern>"
"<error pattern> is a common bug"
```

**Example:**
```
User: don't forget to wrap async calls in try-catch
→ Extract: "wrap async calls in try-catch"
→ Category: Error Handling
→ Tags: async, error-handling, javascript
→ Confidence: 0.65
→ Priority: Medium-High
```

---

## Classification Rules

### Rule: CATEGORY_CLASSIFICATION

Classify learnings into appropriate categories:

| Category | Description | Examples |
|----------|-------------|----------|
| **Model Selection** | AI/ML model choices | "use gpt-5.1 not gpt-5" |
| **Code Style** | Code formatting and style | "prefer explicit types" |
| **Error Handling** | Exception and error patterns | "wrap async in try-catch" |
| **Security** | Security best practices | "validate input at boundaries" |
| **Performance** | Optimization patterns | "use caching with TTL" |
| **Architecture** | System design choices | "use event-driven architecture" |
| **Testing** | Testing practices | "use integration tests" |
| **Documentation** | Documentation patterns | "add docstrings" |
| **Git/Version Control** | Version control practices | "use conventional commits" |
| **Environment** | Dev environment setup | "use venv for Python" |

### Rule: TAG_GENERATION

Generate semantic tags for better organization:

**Tag Format:** lowercase, hyphens, max 5 tags per learning

**Examples:**
- "python", "environment", "development"
- "ai", "model-selection", "reasoning"
- "typescript", "types", "code-style"
- "security", "validation", "api"
- "performance", "caching", "optimization"

---

## Queue Management

### Rule: QUEUE_ADDITION

When adding to queue, include all metadata:

```json
{
  "id": "uuid-v4",
  "type": "correction|preference|success|explicit|best-practice|common-error",
  "content": "The learning content",
  "original": "Original behavior (for corrections)",
  "correction": "Correct behavior",
  "category": "Category name",
  "tags": ["tag1", "tag2"],
  "confidence": 0.90,
  "priority": "critical|high|medium|normal",
  "context": "Conversation context",
  "timestamp": "ISO-8601"
}
```

### Rule: QUEUE_DEDUPLICATION

Before adding to queue, check for duplicates:

1. **Exact match**: Same content, same category → skip
2. **Similar match**: 80%+ content similarity → merge with higher confidence
3. **Different context**: Same pattern, different use case → keep separate

### Rule: PRIORITY_BUMPING

Increase priority when:
- Same learning captured 3+ times → bump to High
- Critical tag present → at least High
- User explicitly requests priority → respect request

---

## Reflection Processing

### Rule: HUMAN_REVIEW_REQUIRED

Always require human review before applying to REFLECT.md:

1. **Present** learning with full context
2. **Suggest** category and tags
3. **Confirm** confidence and priority
4. **Apply** only after human approval

### Rule: CONFLICT_DETECTION

Before applying, check for conflicts:

- **Direct conflict**: Same topic, opposite guidance → flag for resolution
- **Partial conflict**: Same topic, different emphasis → note both
- **No conflict**: Different aspects → apply normally

### Rule: MERGE_SIMILAR

When learnings are similar but not identical:
- Extract common pattern
- Keep unique context
- Reference related learnings
- Suggest merge in review

---

## Evolution Tracking

### Rule: HISTORY_RECORDING

For each applied learning, record:

| Field | Description |
|-------|-------------|
| **Optimizations** | Number of times refined |
| **Usage Count** | Number of times applied |
| **Last Used** | Most recent application date |
| **Validation** | Was it effective? |
| **Notes** | Human feedback |

### Rule: USAGE_TRACKING

Track when learnings are used:
- Increment usage count
- Update "last used" timestamp
- Note context of usage
- Flag for review if never used

### Rule: TREND_ANALYSIS

Periodically analyze REFLECT.md for:
- Frequently used learnings → promote to CLAUDE.md
- Never used learnings → investigate relevance
- Conflicting learnings → flag for resolution
- Emerging patterns → suggest new categories

---

## Integration Rules

### Rule: CONTEXT_INJECTION

When relevant learnings exist in REFLECT.md:
1. Check for applicable learnings
2. Suggest them in response
3. Increment usage count
4. Note in response that learning was applied

### Rule: CLAUDE_SYNC

Sync learnings to CLAUDE.md when:
- Used 3+ times
- Critical or High priority
- User explicitly requests
- Pattern is widely applicable

### Rule: AGENTS_SYNC

Sync learnings to AGENTS.md for:
- Cross-tool compatibility
- Standardized patterns
- Best practices
- Common errors to avoid

---

## Error Handling

### Rule: CAPTURE_FAILURE

If capture fails:
1. Log error to console
2. Notify user of capture failure
3. Preserve original context
4. Do NOT block conversation

### Rule: QUEUE_WRITE_FAILURE

If queue write fails:
1. Retry once
2. If still failing, use fallback storage
3. Notify user of potential data loss
4. Log for debugging

### Rule: REFLECT_PROCESS_FAILURE

If reflection processing fails:
1. Preserve queue state
2. Show error to user
3. Suggest manual review
4. Do NOT modify REFLECT.md without confirmation

---

## Best Practices

### 1. Capture Early, Review Often

- Don't wait for perfect capture
- Queue early, refine during review
- Better partial capture than none

### 2. Preserve Context

- Include conversation context
- Note user intent
- Record exact wording
- Reference specific files/lines if applicable

### 3. Use Specific Tags

- Avoid generic tags like "important"
- Use specific, searchable tags
- Max 5 tags per learning
- Use established tag vocabulary

### 4. Respect User Intent

- Don't capture hypotheticals
- Capture explicit user guidance
- Don't second-guess corrections
- Trust user expertise

### 5. Regular Reflection

- Encourage regular `/reflect` usage
- Process queue before context compression
- Review learnings before major changes
- Update priorities based on usage

---

## Examples

### Example 1: Correction Capture

```
User: no, use gpt-5.1 not gpt-5 for reasoning tasks
Claude: Got it! I'll use gpt-5.1 for reasoning tasks.
[Auto-captured to queue with confidence 0.90, priority High]

User: /reflect
Claude: Found 1 learning:

[C1] Correction: "use gpt-5.1 not gpt-5 for reasoning"
     Category: Model Selection
     Tags: ai, model-selection, reasoning
     Confidence: 0.90 (High)
     Apply to REFLECT.md? [y/n/a]

User: y
Claude: Applied to REFLECT.md.
```

### Example 2: Success Pattern Capture

```
User: Perfect! That's the exact caching strategy I wanted.
Claude: Thanks! I'll remember this caching pattern worked well.
[Auto-captured to queue with confidence 0.75, priority Medium-High]

User: /reflect --view
Claude: Found 1 pending learning:

[S1] Success Pattern: "caching strategy with TTL"
     Context: API response caching
     Category: Performance
     Tags: caching, performance, api
     Confidence: 0.75 (Medium-High)
```

### Example 3: Preference Capture

```
User: I prefer explicit type annotations over implicit any
Claude: Understood! I'll use explicit types in TypeScript.
[Auto-captured to queue with confidence 0.70, priority Medium]

User: /reflect
Claude: Found 1 learning:

[P1] Preference: "explicit type annotations over implicit any"
     Category: Code Style
     Tags: typescript, types, code-style
     Confidence: 0.70 (Medium)
```

### Example 4: Best Practice Discovery

```
During implementation, discovered that adding input validation
at API boundaries prevents most injection attacks.
→ Manual capture:
   Content: "Always validate input at API boundaries"
   Category: Security
   Tags: security, validation, api
   Confidence: 0.60
   Priority: Normal
```

---

## Command Reference

| Command | Purpose |
|---------|---------|
| `/reflect` | Process all pending learnings with review |
| `/reflect --view` | View queue details without processing |
| `/reflect --analyze` | Analyze REFLECT.md evolution trends |
| `/reflect --critical-only` | Process only critical priority items |
| `/reflect --scan-history` | Scan past sessions for missed learnings (Python script) |

---

### Command Details: --scan-history

The `/reflect --scan-history` command uses the `scripts/scan-history.py` script to:

1. **Scan Claude Code history** (`~/.claude/history.jsonl`)
2. **Detect learning patterns**: corrections, successes, preferences, explicit markers
3. **Compare against existing queue** to avoid duplicates
4. **Report potential missed learnings** with recommendations

**Pattern Categories Detected:**
| Category | Patterns |
|----------|----------|
| **Correction** | "no, use", "don't use", "actually,", "instead of", "incorrect" |
| **Success** | "perfect!", "exactly what i wanted", "great!", "nailed it" |
| **Preference** | "i prefer", "you should use", "i always", "in my code" |
| **Explicit** | "remember:", "note this", "important:", "don't forget" |

**Usage:**
```bash
# Scan all history
/reflect --scan-history

# Scan for specific project (optional project filter)
cd /path/to/project && /reflect --scan-history
```

**Output includes:**
- Pattern summary (counts per category)
- Potential missed learnings with examples
- Recommendations based on detected patterns
- Session statistics

---

## Troubleshooting

### Learning Not Captured

**Issue**: User correction not auto-captured
**Solution**: 
- Check hook configuration
- Verify pattern matching
- Manual capture if needed

### Duplicate Learnings

**Issue**: Same learning captured multiple times
**Solution**:
- During reflection, merge similar learnings
- Increase confidence threshold
- Add specific context to differentiate

### Queue Not Processing

**Issue**: `/reflect` returns empty or error
**Solution**:
- Check queue file permissions
- Verify JSON format
- Check disk space

### REFLECT.md Not Updating

**Issue**: Approved learnings not applied
**Solution**:
- Check file permissions
- Verify backup created
- Manual edit if needed

---

## References

- [SKILL.md](SKILL.md) - Full skill documentation
- [README.zh.md](../../README.zh.md) - Project documentation in Chinese
- [README.en.md](../../README.en.md) - Project documentation in English
- [docs/OPENCODE_COMPATIBILITY.zh.md](../../docs/OPENCODE_COMPATIBILITY.zh.md) - OpenCode CLI guide
