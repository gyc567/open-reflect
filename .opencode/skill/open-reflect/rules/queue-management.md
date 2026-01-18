# Rule: Queue Management

**Category:** Queue Management  
**Priority:** High  
**Confidence:** 1.00

## Definition

Rules for managing the learning capture queue, including addition, deduplication, and priority management.

## Queue Structure

```json
{
  "queue": [
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
  ],
  "metadata": {
    "version": "1.0",
    "created": "ISO-8601",
    "lastModified": "ISO-8601",
    "totalCaptures": 0
  }
}
```

## Addition Rules

### Rule: QUEUE_ADDITION

When adding to queue:
1. Generate unique ID (UUID v4)
2. Set timestamp to current ISO-8601
3. Auto-detect category from content
4. Auto-generate tags from keywords
5. Set priority based on confidence and type

### Rule: REQUIRED_FIELDS

All queue entries must include:
- `id`: Unique identifier
- `type`: Learning type
- `content`: Learning content
- `category`: Category name
- `tags`: Array of tags
- `confidence`: 0.60-0.95
- `priority`: Priority level
- `timestamp`: Capture time

## Deduplication Rules

### Rule: EXACT_MATCH_DETECTION

Before adding, check for exact matches:
- Same content (case-insensitive)
- Same category
→ Skip duplicate

```typescript
function isExactMatch(newEntry, existingEntry): boolean {
  return (
    newEntry.content.toLowerCase() === existingEntry.content.toLowerCase() &&
    newEntry.category === existingEntry.category
  )
}
```

### Rule: SIMILAR_MATCH_DETECTION

Check for similar entries (80%+ similarity):
- Use fuzzy matching (Levenshtein distance)
- If similar, merge with higher confidence
- Note both original entries

```typescript
function calculateSimilarity(str1, str2): number {
  // Levenshtein distance-based similarity
  const distance = levenshteinDistance(str1, str2)
  const maxLength = Math.max(str1.length, str2.length)
  return 1 - distance / maxLength
}
```

### Rule: CONTEXT_DIFFERENTIATION

If same pattern, different context:
- Keep both entries
- Add context to distinguish
- May suggest merge during review

## Priority Rules

### Rule: PRIORITY_ASSIGNMENT

Default priority by type:

| Type | Default Priority |
|------|------------------|
| Explicit | Critical |
| Correction | High |
| Success | Medium-High |
| Preference | Medium |
| Best Practice | Normal |
| Common Error | Medium-High |

### Rule: PRIORITY_BUMPING

Increase priority when:
- Same learning captured 3+ times → bump to High
- Category is Security → bump one level
- Category is Error Handling → bump one level
- User explicitly requests priority → respect request

### Rule: PRIORITY_DEGRADATION

Decrease priority when:
- Learning never used after 5 applications → bump down
- Confidence is consistently low (0.60) → Normal priority
- Context is very narrow/specific → Normal priority

## Queue Operations

### Rule: QUEUE_READ

Read queue from file:
1. Check if queue file exists
2. Parse JSON
3. Validate structure
4. Return queue object

### Rule: QUEUE_WRITE

Write queue to file:
1. Create backup of existing queue
2. Write new queue JSON
3. Validate write success
4. Update metadata

### Rule: QUEUE_CLEAR

Clear queue (on `/skip-reflect`):
1. Create backup of queue
2. Clear queue array
3. Update metadata
4. Notify user

---

## Related Rules

- [EXPLICIT_MARKER_DETECTION](explicit-marker-detection.md) - For Critical priority
- [CORRECTION_DETECTION](correction-detection.md) - For High priority
- [COMMON_ERROR_DETECTION](common-error-detection.md) - For Medium-High priority
