# Rule: Evolution Tracking

**Category:** Evolution Tracking  
**Priority:** Normal  
**Confidence:** 1.00

## Definition

Rules for tracking knowledge evolution over time, including usage, optimization, and validation.

## Evolution Data Structure

```markdown
## Evolution History
| Date | Learning ID | Action | Details |
|------|-------------|--------|---------|
| 2024-01-15 | E1 | Created | Initial capture |
| 2024-01-16 | E1 | Optimized | Refined description |
| 2024-01-17 | E1 | Used | Applied in Python project |
```

## Usage Tracking

### Rule: USAGE_INCREMENT

When a learning is used in response:
1. Find learning in REFLECT.md
2. Increment usage count
3. Update "last used" timestamp
4. Log context of usage

### Rule: USAGE_LOG

Log each usage:
```json
{
  "learningId": "E1",
  "timestamp": "ISO-8601",
  "context": "Applied in Python venv setup",
  "file": "/path/to/file.py"
}
```

### Rule: USAGE_ANALYSIS

Periodically analyze usage:
- Frequently used (5+) → promote to CLAUDE.md
- Never used (30 days) → investigate relevance
- Used incorrectly → flag for review

## Optimization Tracking

### Rule: OPTIMIZATION_LOG

When a learning is refined:
1. Add entry to evolution history
2. Increment optimization count
3. Update content
4. Note reason for optimization

### Rule: OPTIMIZATION_TYPES

| Type | Description | Example |
|------|-------------|---------|
| **Refine** | Better wording | "use venv" → "activate venv before installing" |
| **Expand** | Add context | "use venv" → "use venv and .gitignore Python packages" |
| **Narrow** | More specific | "use venv" → "use venv for project-specific dependencies" |
| **Correct** | Fix error | Wrong info corrected |

## Validation Tracking

### Rule: VALIDATION_LOG

When learning effectiveness is confirmed:
1. Log validation event
2. Note effectiveness (high/medium/low)
3. Add notes from user feedback

### Rule: VALIDATION_TYPES

| Type | Description |
|------|-------------|
| **Success** | Learning worked as expected |
| **Partial** | Learning partially applicable |
| **Failed** | Learning didn't apply in this context |
| **Refuted** | Learning was incorrect |

## Trend Analysis

### Rule: TREND_CALCULATION

Calculate trends monthly:
- New learnings added
- Most used learnings
- Most optimized learnings
- Learnings with most conflicts
- Category distribution

### Rule: INSIGHT_GENERATION

Generate insights from trends:
- "User frequently corrects model selection → Consider adding model guidelines"
- "Best practices category growing → Create dedicated section"
- "Security learnings rarely used → Review and update"

## Historical Queries

### Rule: HISTORY_QUERY

Query evolution history:
- By learning ID → full history
- By date range → entries in range
- By category → entries in category
- By action type → all optimizations/usages

### Rule: HISTORY_EXPORT

Export history:
- JSON format for tools
- Markdown for documentation
- CSV for analysis

---

## Related Rules

- [REFLECTION_PROCESSING](reflection-processing.md) - Applying learnings
- [QUEUE_MANAGEMENT](queue-management.md) - Queue operations
- [CONFLICT_DETECTION](conflict-detection.md) - Conflict resolution
