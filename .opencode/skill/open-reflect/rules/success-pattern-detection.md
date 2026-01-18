# Rule: Success Pattern Detection

**Category:** Capture Pattern  
**Priority:** Medium-High  
**Confidence:** 0.75

## Definition

Detect when users provide positive feedback on AI output, indicating what worked well and should be remembered.

## Trigger Patterns

```text
"Perfect!"
"Exactly right!"
"That's exactly what I wanted"
"Great approach"
"Exactly how I would have done it"
"This is perfect"
"Nailed it"
"Excellent!"
"That's it!"
"This is exactly what I needed"
"Spot on!"
```

## Capture Format

```json
{
  "type": "success",
  "content": "<what worked well>",
  "context": "<conversation context>",
  "category": "auto-detected-from-context",
  "tags": ["success", "positive-feedback"],
  "confidence": 0.75,
  "priority": "medium-high"
}
```

## Examples

### Example 1: Perfect Caching Strategy
```
User: Perfect! That's the exact caching strategy I wanted.
→ Context: API response caching implementation
→ Content: "caching strategy with TTL and LRU eviction"
→ Category: Performance
→ Tags: caching, performance, ttl, lru
→ Confidence: 0.75
```

### Example 2: Exactly Right Approach
```
User: Exactly right! That's the correct way to handle async errors.
→ Context: Error handling in async/await
→ Content: "try-catch with async/await error handling"
→ Category: Error Handling
→ Tags: async, error-handling, best-practice
→ Confidence: 0.75
```

### Example 3: Great Approach
```
User: Great approach! Using composition API is much cleaner.
→ Context: Vue.js component refactoring
→ Content: "Vue composition API for better organization"
→ Category: Code Style
→ Tags: vue, composition-api, clean-code
→ Confidence: 0.75
```

### Example 4: Spot On
```
User: Spot on! The authentication flow is exactly as required.
→ Context: OAuth2 implementation
→ Content: "OAuth2 flow with refresh token rotation"
→ Category: Security
→ Tags: authentication, oauth, security
→ Confidence: 0.75
```

## Implementation Notes

1. **Extract the What**: Identify what specific approach or solution worked
2. **Note the Context**: Capture the conversation context for future reference
3. **Moderate Confidence**: Success patterns get 0.75 (reliable but subjective)
4. **Medium-High Priority**: Important for pattern recognition but not critical
5. **Categorize by Domain**: Infer category from the technical domain

## Success Pattern Categories

| Category | Examples |
|----------|----------|
| **Performance** | Caching, optimization, efficient algorithms |
| **Security** | Authentication, authorization, encryption |
| **Architecture** | Design patterns, component structure |
| **Code Style** | Clean code, readability, maintainability |
| **Error Handling** | Robust error management, recovery |
| **Testing** | Test coverage, testing strategies |
| **Documentation** | Clear docs, comments |

## Related Rules

- [CORRECTION_DETECTION](correction-detection.md) - For negative feedback/corrections
- [PREFERENCE_DETECTION](preference-detection.md) - For style preferences
- [BEST_PRACTICE_DISCOVERY](best-practice-discovery.md) - For discovered patterns
