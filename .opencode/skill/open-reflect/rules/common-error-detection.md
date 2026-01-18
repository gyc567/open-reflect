# Rule: Common Error Detection

**Category:** Capture Pattern  
**Priority:** Medium-High  
**Confidence:** 0.65

## Definition

Detect and capture common errors, anti-patterns, or mistakes that users warn about or that are identified during work.

## Trigger Patterns

```text
"don't forget <error handling>"
"common mistake: <anti-pattern>"
"avoid <anti-pattern>"
"<error pattern> is a common bug"
"people often forget <error handling>"
"a common error is <pattern>"
"<anti-pattern> is an anti-pattern"
"never <anti-pattern>"
```

## Capture Format

```json
{
  "type": "common-error",
  "error": "<error or anti-pattern>",
  "solution": "<recommended solution>",
  "category": "auto-detected-from-content",
  "tags": ["common-error", "anti-pattern"],
  "confidence": 0.65,
  "priority": "medium-high"
}
```

## Examples

### Example 1: Async Error Handling
```
User: don't forget to wrap async calls in try-catch
→ Error: "async calls without try-catch"
→ Solution: "wrap async calls in try-catch"
→ Category: Error Handling
→ Tags: async, error-handling, try-catch
→ Confidence: 0.65
```

### Example 2: Memory Leak
```
User: common mistake: not cleaning up event listeners
→ Error: "not cleaning up event listeners"
→ Solution: "remove event listeners in cleanup function"
→ Category: Memory Management
→ Tags: memory-leak, event-listeners, cleanup
→ Confidence: 0.65
```

### Example 3: Injection Vulnerability
```
User: never interpolate user input into SQL queries
→ Error: "SQL injection via interpolated input"
→ Solution: "use parameterized queries"
→ Category: Security
→ Tags: security, sql-injection, parameterized-queries
→ Confidence: 0.65
```

### Example 4: Race Condition
```
User: a common bug is not handling race conditions in async code
→ Error: "race conditions in async code"
→ Solution: "use proper async synchronization (Promises, async/await order)"
→ Category: Concurrency
→ Tags: async, race-condition, concurrency
→ Confidence: 0.65
```

### Example 5: Anti-Pattern
```
User: never use var in JavaScript, it's an anti-pattern
→ Error: "using var in JavaScript"
→ Solution: "use let or const instead"
→ Category: Code Quality
→ Tags: javascript, var, anti-pattern, modern-js
→ Confidence: 0.65
```

## Implementation Notes

1. **Capture Both Error and Solution**: Document what to avoid AND what to do instead
2. **Moderate Confidence**: Common errors get 0.65 (reliable but general)
3. **Medium-High Priority**: Important for preventing bugs
4. **Categorize by Impact**: Security errors may deserve higher priority
5. **Note Severity**: Some errors are critical, others are minor

## Common Error Categories

| Category | Examples |
|----------|----------|
| **Security** | SQL injection, XSS, auth bypasses |
| **Memory** | Leaks, not cleaning up, references |
| **Concurrency** | Race conditions, deadlocks |
| **Error Handling** | Silent failures, uncaught exceptions |
| **Performance** | N+1 queries, unnecessary computations |
| **Code Quality** | Anti-patterns, bad practices |

## Related Rules

- [BEST_PRACTICE_DISCOVERY](best-practice-discovery.md) - Best practices that prevent errors
- [CORRECTION_DETECTION](correction-detection.md) - Corrections that fix errors
- [SUCCESS_PATTERN_DETECTION](success-pattern-detection.md) - Successful error handling patterns
