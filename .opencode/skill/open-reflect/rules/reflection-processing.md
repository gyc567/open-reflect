# Rule: Reflection Processing

**Category:** Reflection Processing  
**Priority:** High  
**Confidence:** 1.00

## Definition

Rules for processing queued learnings through manual review and applying them to REFLECT.md.

## Processing Workflow

```
1. Load queue from file
2. Present learnings to user
3. Get user approval (y/n/a for each)
4. Apply approved learnings to REFLECT.md
5. Update queue (remove applied, keep pending)
6. Update metadata
```

## Presentation Rules

### Rule: LEARNING_PRESENTATION

Present each learning with:
- Learning ID (e.g., C1, E1, P1)
- Type icon (🔴 correction, ⚪ explicit, 🟢 success, etc.)
- Content (truncated if >100 chars)
- Category and tags
- Confidence and priority
- Original and correction (for corrections)

### Rule: BATCH_PRESENTATION

Present all learnings at once:
```
Found 3 pending learnings:

[C1] 🔴 Correction: "use gpt-5.1 not gpt-5 for reasoning"
     Category: Model Selection
     Tags: ai, model-selection, reasoning
     Confidence: 0.90 (High)
     Apply to REFLECT.md? [y/n/a]

[E1] ⚪ Explicit: "always use venv for Python"
     Category: Environment
     Tags: python, environment, venv
     Confidence: 0.95 (Critical)
     Apply to REFLECT.md? [y/n/a]

[S1] 🟢 Success: "caching strategy with TTL"
     Category: Performance
     Tags: caching, performance, ttl
     Confidence: 0.75 (Medium-High)
     Apply to REFLECT.md? [y/n/a]
```

## Approval Rules

### Rule: INDIVIDUAL_APPROVAL

Each learning requires individual approval:
- `y` → Apply and remove from queue
- `n` → Skip, keep in queue
- `a` → Apply all remaining learnings

### Rule: BULK_APPROVAL

On `a` (apply all):
- Apply all pending learnings
- Clear entire queue
- Update metadata

### Rule: PARTIAL_APPROVAL

On `n` (skip):
- Learning stays in queue
- User can review later
- Log skip for analytics

## Conflict Detection

### Rule: DIRECT_CONFLICT_CHECK

Before applying, check for conflicts:
- Same category, opposite guidance
→ Flag for resolution

```typescript
function detectConflict(newLearning, existingLearnings): Conflict[] {
  return existingLearnings.filter(existing => {
    return (
      existing.category === newLearning.category &&
      isOpposite(newLearning.content, existing.content)
    )
  })
}

function isOpposite(content1, content2): boolean {
  // Check for negation patterns
  const patterns = [
    { pos: "always", neg: "never" },
    { pos: "use", neg: "don't use" },
    { pos: "do", neg: "don't do" }
  ]
  // Implementation to detect opposite statements
}
```

### Rule: PARTIAL_CONFLICT_CHECK

Check for partial conflicts:
- Same topic, different emphasis
→ Note both, apply both with reference

### Rule: NO_CONFLICT

If no conflict:
- Apply normally
- Update metadata

## Application Rules

### Rule: REFLECT_APPEND

Append to REFLECT.md:
1. Determine target section (Corrections, Preferences, etc.)
2. Generate new ID
3. Append entry with full metadata
4. Update section table
5. Update evolution history

### Rule: MERGE_SIMILAR

When similar learning exists:
- Extract common pattern
- Keep unique context
- Reference related entry
- Suggest merge in review

### Rule: METADATA_UPDATE

After applying:
1. Increment total captures
2. Update lastModified timestamp
3. Log application for analytics

## Queue Update

### Rule: QUEUE_UPDATE

After processing:
- Remove applied learnings
- Keep skipped learnings
- Update metadata
- Write to file

### Rule: QUEUE_CLEANUP

Periodically clean queue:
- Remove learnings older than 30 days
- Archive to separate file
- Notify user of cleanup

---

## Related Rules

- [QUEUE_MANAGEMENT](queue-management.md) - Queue operations
- [CONFLICT_DETECTION](conflict-detection.md) - Conflict resolution
- [EVOLUTION_TRACKING](evolution-tracking.md) - History recording
