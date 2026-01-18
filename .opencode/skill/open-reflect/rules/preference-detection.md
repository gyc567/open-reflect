# Rule: Preference Detection

**Category:** Capture Pattern  
**Priority:** Medium  
**Confidence:** 0.70

## Definition

Detect when users express personal style, approach, or technical preferences that should be remembered for future interactions.

## Trigger Patterns

```text
"I prefer <preference>"
"you should use <preference>"
"always <preference>"
"in my code, I <preference>"
"for me, <preference>"
"when I write code, I <preference>"
"my preference is <preference>"
"<preference> is my preferred way"
```

## Capture Format

```json
{
  "type": "preference",
  "content": "<user preference>",
  "category": "auto-detected-from-content",
  "tags": ["preference", "user-style"],
  "confidence": 0.70,
  "priority": "medium"
}
```

## Examples

### Example 1: Type Preference
```
User: I prefer explicit type annotations over implicit any
→ Content: "explicit type annotations over implicit any"
→ Category: Code Style
→ Tags: typescript, types, explicit
→ Confidence: 0.70
```

### Example 2: Naming Preference
```
User: you should use kebab-case for file names, not camelCase
→ Content: "kebab-case for file names, not camelCase"
→ Category: Code Style
→ Tags: naming, conventions, files
→ Confidence: 0.70
```

### Example 3: Import Style
```
User: always use named imports in TypeScript, not default imports
→ Content: "named imports in TypeScript, not default imports"
→ Category: Code Style
→ Tags: typescript, imports, named
→ Confidence: 0.70
```

### Example 4: Framework Preference
```
User: for me, I always use Zod for validation, not Joi
→ Content: "Zod for validation, not Joi"
→ Category: Tool Selection
→ Tags: validation, zod, joi, typescript
→ Confidence: 0.70
```

### Example 5: Code Organization
```
User: in my code, I group related functions together, not by type
→ Content: "group related functions together, not by type"
→ Category: Code Organization
→ Tags: organization, functions, grouping
→ Confidence: 0.70
```

## Implementation Notes

1. **Preserve Exact Preference**: Capture the user's exact wording of preference
2. **Note Scope**: Is this a general preference or project-specific?
3. **Moderate Confidence**: Preferences get 0.70 (subjective but explicit)
4. **Medium Priority**: Important for user satisfaction but not urgent
5. **Track Context**: Note if preference is project-specific

## Preference Types

| Type | Examples |
|------|----------|
| **Code Style** | Naming, formatting, organization |
| **Tool Selection** | Libraries, frameworks, tools |
| **Architecture** | Patterns, approaches, structures |
| **Communication** | How to report, ask, explain |
| **Testing** | Test styles, coverage requirements |
| **Documentation** | Comment styles, doc formats |

## Related Rules

- [CORRECTION_DETECTION](correction-detection.md) - For corrections that override preferences
- [SUCCESS_PATTERN_DETECTION](success-pattern-detection.md) - For positive feedback on preferences
- [EXPLICIT_MARKER_DETECTION](explicit-marker-detection.md) - For explicit "remember my preference"
