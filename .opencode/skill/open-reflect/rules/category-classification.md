# Rule: Category Classification

**Category:** Classification  
**Priority:** Medium  
**Confidence:** 0.85

## Definition

Rules for automatically classifying learnings into appropriate categories.

## Category Definitions

| Category | Description | Keywords |
|----------|-------------|----------|
| **Model Selection** | AI/ML model choices | model, gpt, ai, llm, reasoning |
| **Code Style** | Code formatting and style | style, format, naming, convention |
| **Error Handling** | Exception patterns | error, exception, catch, try |
| **Security** | Security best practices | security, auth, encryption, validate |
| **Performance** | Optimization patterns | performance, cache, optimize, speed |
| **Architecture** | System design | architecture, pattern, design, structure |
| **Testing** | Testing practices | test, coverage, mock, stub |
| **Documentation** | Documentation patterns | docstring, comment, document |
| **Git/Version Control** | Version control | git, commit, branch, merge |
| **Environment** | Dev environment | env, venv, docker, configuration |
| **API** | API design/usage | api, endpoint, request, response |
| **Database** | Database patterns | database, query, sql, schema |
| **JavaScript** | JS-specific | javascript, js, node, npm |
| **TypeScript** | TS-specific | typescript, ts, type, interface |
| **Python** | Python-specific | python, py, pip, virtualenv |
| **Tool Selection** | Tool preferences | tool, library, framework, package |

## Classification Rules

### Rule: KEYWORD_MATCH

Match content against category keywords:

```typescript
function classifyByKeywords(content: string): string {
  const categories: Record<string, RegExp[]> = {
    'Model Selection': [
      /\bmodel\b/i, /\bgpt\b/i, /\bllm\b/i, /\bai\b/i, /\breasoning\b/i
    ],
    'Code Style': [
      /\bstyle\b/i, /\bformat\b/i, /\bnaming\b/i, /\bconvention\b/i
    ],
    'Error Handling': [
      /\berror\b/i, /\bexception\b/i, /\bcatch\b/i, /\btry\b/i
    ],
    'Security': [
      /\bsecurity\b/i, /\bauth\b/i, /\bencrypt\b/i, /\bvalidate\b/i
    ],
    // ... more categories
  }

  let bestMatch = 'General'
  let maxMatches = 0

  for (const [category, patterns] of Object.entries(categories)) {
    const matches = patterns.filter(p => p.test(content)).length
    if (matches > maxMatches) {
      maxMatches = matches
      bestMatch = category
    }
  }

  return bestMatch
}
```

### Rule: CONTEXT_AUGMENTATION

Use conversation context to improve classification:
- Look at surrounding messages
- Identify technical domain
- Adjust category if needed

### Rule: USER_CORRECTION

Allow user to override classification:
- During reflection review
- Via explicit category specification
- Update rules based on corrections

## Tag Generation

### Rule: TAG_EXTRACTION

Extract tags from content:
1. Identify key terms
2. Remove stop words
3. Convert to kebab-case
4. Limit to 5 tags

```typescript
function extractTags(content: string): string[] {
  const stopWords = ['a', 'an', 'the', 'is', 'are', 'was', 'were', 'to', 'for']
  const words = content.toLowerCase().split(/\s+/)
  const tags = words
    .filter(w => !stopWords.includes(w))
    .map(w => w.replace(/[^a-z0-9]/g, ''))
    .filter(w => w.length > 2)

  return [...new Set(tags)].slice(0, 5)
}
```

---

## Related Rules

- [EXPLICIT_MARKER_DETECTION](explicit-marker-detection.md) - Initial capture
- [CORRECTION_DETECTION](correction-detection.md) - Correction capture
- [BEST_PRACTICE_DISCOVERY](best-practice-discovery.md) - Discovery capture
