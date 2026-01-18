# Rule: Conflict Detection

**Category:** Conflict Detection  
**Priority:** High  
**Confidence:** 1.00

## Definition

Rules for detecting and resolving conflicts between learnings in REFLECT.md.

## Conflict Types

| Type | Description | Severity |
|------|-------------|----------|
| **Direct** | Same topic, opposite guidance | Critical |
| **Partial** | Same topic, different emphasis | Medium |
| **Obsolete** | Newer learning contradicts older | High |
| **Redundant** | Duplicate or nearly identical | Low |

## Detection Rules

### Rule: DIRECT_CONFLICT_DETECTION

Detect opposite statements:
- "always use X" vs "never use X"
- "use X not Y" vs "use Y not X"
- "X is correct" vs "X is wrong"

```typescript
function detectDirectConflict(learnings: Learning[]): Conflict[] {
  const conflicts: Conflict[] = []

  for (const l1 of learnings) {
    for (const l2 of learnings) {
      if (l1.id === l2.id) continue
      if (l1.category !== l2.category) continue

      if (isOpposite(l1.content, l2.content)) {
        conflicts.push({
          type: 'direct',
          severity: 'critical',
          learning1: l1,
          learning2: l2
        })
      }
    }
  }

  return conflicts
}

function isOpposite(content1: string, content2: string): boolean {
  const opposites = [
    { pos: /\balways\b/i, neg: /\bnever\b/i },
    { pos: /\buse\b/i, neg: /\bdon'?t use\b/i },
    { pos: /\bdo\b/i, neg: /\bdon'?t do\b/i },
    { pos: /\byes\b/i, neg: /\bno\b/i }
  ]

  for (const { pos, neg } of opposites) {
    const hasPos1 = pos.test(content1)
    const hasNeg2 = neg.test(content2)
    const hasPos2 = pos.test(content2)
    const hasNeg1 = neg.test(content1)

    if ((hasPos1 && hasNeg2) || (hasPos2 && hasNeg1)) {
      return true
    }
  }

  return false
}
```

### Rule: PARTIAL_CONFLICT_DETECTION

Detect different emphases:
- Same topic, different aspects
- Different but related recommendations

### Rule: OBSOLETE_DETECTION

Detect when newer learning contradicts older:
- Compare timestamps
- Check for contradiction
- Flag older as potentially obsolete

### Rule: REDUNDANCY_DETECTION

Detect duplicates:
- Exact matches (skip during capture)
- 90%+ similarity
- Same category, similar content

## Resolution Rules

### Rule: HUMAN_RESOLUTION

For critical conflicts:
1. Flag both learnings
2. Present to user
3. User decides which to keep
4. Archive or update accordingly

### Rule: AUTO_RESOLUTION

For low-severity conflicts:
- Merge into single entry
- Note both perspectives
- Update evolution history

### Rule: DOCUMENT_CONFLICT

When conflict can't be resolved:
1. Note both in REFLECT.md
2. Add conflict note
3. Reference in evolution history
4. Periodically revisit

## Prevention Rules

### Rule: PRE_CHECK

Before adding new learning:
1. Query existing learnings in same category
2. Check for conflicts
3. Warn if conflict detected
4. Proceed only with user approval

### Rule: SUGGEST_RELATED

When adding learning:
1. Find related learnings
2. Suggest linking
3. Note relationship in evolution
4. Build knowledge graph

---

## Related Rules

- [EVOLUTION_TRACKING](evolution-tracking.md) - History recording
- [REFLECTION_PROCESSING](reflection-processing.md) - Processing learnings
- [QUEUE_MANAGEMENT](queue-management.md) - Queue operations
