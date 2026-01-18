# Rule: Best Practice Discovery

**Category:** Capture Pattern  
**Priority:** Normal  
**Confidence:** 0.60

## Definition

Detect and capture effective patterns discovered during implementation or problem-solving that represent best practices.

## Trigger Patterns

**Implicit Discovery** (from successful implementations):
- Patterns that consistently solve problems
- Architectural decisions that work well
- Security patterns that prevent issues
- Performance optimizations that help

**Explicit Mentions**:
```
"always <best practice>"
"best practice is to <practice>"
"the right way is to <practice>"
"you should <practice>"
"recommended: <practice>"
```

## Capture Format

```json
{
  "type": "best-practice",
  "content": "<discovered best practice>",
  "context": "<implementation context>",
  "category": "auto-detected-from-content",
  "tags": ["best-practice", "discovered"],
  "confidence": 0.60,
  "priority": "normal"
}
```

## Examples

### Example 1: Security Best Practice
```
Context: Implementation revealed that input validation at API boundaries
         prevents most injection attacks.
→ Content: "Always validate input at API boundaries"
→ Category: Security
→ Tags: security, validation, api, input
→ Confidence: 0.60
```

### Example 2: Performance Best Practice
```
Context: Caching API responses with TTL reduced latency by 80%.
→ Content: "Cache API responses with TTL for performance"
→ Category: Performance
→ Tags: performance, caching, ttl, api
→ Confidence: 0.60
```

### Example 3: Error Handling Best Practice
```
Context: Wrapping all async operations in try-catch prevented silent failures.
→ Content: "Wrap all async operations in try-catch"
→ Category: Error Handling
→ Tags: error-handling, async, robustness
→ Confidence: 0.60
```

### Example 4: Documentation Best Practice
```
Context: Adding docstrings to all public functions reduced questions by 50%.
→ Content: "Add docstrings to all public functions"
→ Category: Documentation
→ Tags: documentation, maintainability, clarity
→ Confidence: 0.60
```

### Example 5: Explicit Best Practice
```
User: always use environment variables for configuration
→ Content: "Use environment variables for configuration"
→ Category: Configuration
→ Tags: configuration, environment, best-practice
→ Confidence: 0.60
```

## Implementation Notes

1. **Lower Confidence**: Best practices get 0.60 (discovered, not explicitly marked)
2. **Normal Priority**: Standard processing queue
3. **Note Context**: Capture where/how the practice was discovered
4. **Validate Effectiveness**: Note if the practice showed measurable improvement
5. **Categorize by Domain**: Infer category from technical area

## Best Practice Categories

| Category | Examples |
|----------|----------|
| **Security** | Input validation, auth, encryption |
| **Performance** | Caching, optimization, efficient algorithms |
| **Error Handling** | Try-catch, fallbacks, recovery |
| **Code Quality** | Testing, documentation, reviews |
| **Architecture** | Patterns, separation of concerns |
| **Configuration** | Environment variables, secrets |

## Related Rules

- [EXPLICIT_MARKER_DETECTION](explicit-marker-detection.md) - For explicit "always" markers
- [COMMON_ERROR_DETECTION](common-error-detection.md) - For errors that best practices prevent
- [SUCCESS_PATTERN_DETECTION](success-pattern-detection.md) - For successful implementations
