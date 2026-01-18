# Rule: Correction Detection

**Category:** Capture Pattern  
**Priority:** High  
**Confidence:** 0.90

## Definition

Detect when users correct AI behavior, output, or suggested approaches with alternative recommendations.

## Trigger Patterns

```text
"no, use X not Y"
"no, don't use Y"
"actually, <correction>"
"<statement> not <correction>"
"you should have <correction>"
"instead of <wrong>, use <right>"
"not <wrong>, but <right>"
"<wrong> is wrong, use <right>"
```

## Capture Format

```json
{
  "type": "correction",
  "content": "<correction>",
  "original": "<incorrect behavior>",
  "correction": "<correct behavior>",
  "category": "auto-detected-from-content",
  "tags": ["correction", "user-feedback"],
  "confidence": 0.90,
  "priority": "high"
}
```

## Examples

### Example 1: Direct Correction
```
User: no, use gpt-5.1 not gpt-5 for reasoning tasks
→ Original: "use gpt-5 for reasoning"
→ Correction: "use gpt-5.1 for reasoning"
→ Category: Model Selection
→ Tags: ai, model-selection, reasoning
→ Confidence: 0.90
```

### Example 2: Negative Correction
```
User: no, don't use var in JavaScript, use let or const
→ Original: "use var in JavaScript"
→ Correction: "use let or const in JavaScript"
→ Category: Code Style
→ Tags: javascript, modern-js, variables
→ Confidence: 0.90
```

### Example 3: Actually Correction
```
User: actually, the API endpoint is /users not /user
→ Original: "/user endpoint"
→ Correction: "/users endpoint"
→ Category: API
→ Tags: api, endpoint, rest
→ Confidence: 0.90
```

### Example 4: Instead Of Correction
```
User: instead of Array.forEach, use for...of for async operations
→ Original: "Array.forEach for async operations"
→ Correction: "for...of for async operations"
→ Category: JavaScript Patterns
→ Tags: javascript, async, loops
→ Confidence: 0.90
```

### Example 5: Not But Correction
```
User: it's not the response time, but the timeout configuration
→ Original: "response time issue"
→ Correction: "timeout configuration issue"
→ Category: Debugging
→ Tags: debugging, configuration, timeout
→ Confidence: 0.90
```

## Implementation Notes

1. **Extract Both Parts**: Capture both the wrong approach and the correction
2. **Preserve Context**: Note the conversation context where correction occurred
3. **High Confidence**: Corrections get 0.90 confidence (very reliable)
4. **High Priority**: Process corrections soon (they address actual errors)
5. **Category Inference**: Auto-detect category from technical terms

## Correction Types

| Type | Pattern | Example |
|------|---------|---------|
| **Direct** | "use X not Y" | "use gpt-5.1 not gpt-5" |
| **Negative** | "don't use X" | "don't use var" |
| **Restatement** | "actually, X" | "actually, the endpoint is /users" |
| **Instead** | "instead of X, use Y" | "instead of forEach, use for...of" |
| **Refutation** | "X is wrong, Y is correct" | "X is wrong, use Y" |

## Related Rules

- [EXPLICIT_MARKER_DETECTION](explicit-marker-detection.md) - For explicit "remember:" markers
- [SUCCESS_PATTERN_DETECTION](success-pattern-detection.md) - For positive feedback
- [PREFERENCE_DETECTION](preference-detection.md) - For style preferences
