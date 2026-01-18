# Rule: Explicit Marker Detection

**Category:** Capture Pattern  
**Priority:** Critical  
**Confidence:** 0.95

## Definition

Detect when users explicitly mark something to remember using specific marker phrases.

## Trigger Patterns

```text
"remember: <learning>"
"note: <learning>"
"note that <learning>"
"important: <learning>"
"make sure to <learning>"
"don't forget to <learning>"
"always remember <learning>"
"keep in mind <learning>"
```

## Capture Format

```json
{
  "type": "explicit",
  "content": "<extracted learning>",
  "category": "auto-detected-from-content",
  "tags": ["explicit", "user-marked"],
  "confidence": 0.95,
  "priority": "critical"
}
```

## Examples

### Example 1: Basic Remember
```
User: remember: always use venv for Python projects
→ Content: "always use venv for Python projects"
→ Category: Environment
→ Tags: python, environment, venv
→ Confidence: 0.95
```

### Example 2: Note This
```
User: note: this API has rate limits of 100 req/min
→ Content: "API has rate limits of 100 req/min"
→ Category: API
→ Tags: api, rate-limit, configuration
→ Confidence: 0.95
```

### Example 3: Don't Forget
```
User: don't forget to validate input on the server side
→ Content: "validate input on the server side"
→ Category: Security
→ Tags: security, validation, server
→ Confidence: 0.95
```

### Example 4: Make Sure
```
User: make sure to close database connections in finally block
→ Content: "close database connections in finally block"
→ Category: Error Handling
→ Tags: database, resource-management, finally
→ Confidence: 0.95
```

## Implementation Notes

1. **Highest Confidence**: Explicit markers get 0.95 (highest non-perfect) confidence
2. **Critical Priority**: Always process first due to explicit user intent
3. **Preserve Exact Wording**: Capture the learning in user's exact words
4. **Extract Core Meaning**: Remove marker phrases, keep the actual learning
5. **Auto-categorize**: Infer category from content keywords

## Related Rules

- [PREFERENCE_DETECTION](preference-detection.md) - For "I prefer" patterns
- [BEST_PRACTICE_DISCOVERY](best-practice-discovery.md) - For discovered patterns
- [COMMON_ERROR_DETECTION](common-error-detection.md) - For "don't forget" anti-patterns
