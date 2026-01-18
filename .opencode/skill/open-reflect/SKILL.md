---
name: open-reflect
description: |
  Advanced self-learning and reflection system with knowledge evolution tracking.
  Captures corrections, success patterns, preferences, and best practices.
  Use when discussing learnings, corrections, or when user mentions remembering.
  Triggers: "remember:", "no use X", "Perfect!", "I prefer", corrections, feedback.
allowed-tools: Read, Write, Edit, Glob, Bash(jq:*), Bash(cat:*), AskUserQuestion, Grep, WebSearch, WebFetch
restricted-tools: Bash(rm:*), Bash(mv:*), Bash(chmod:*), Bash(chown:*)
version: 1.1.0
license: MIT
author: OpenReflect Team
compatibility: claude-code,opencode
metadata:
  audience: developers
  workflow: continuous-learning
---

# Open-Reflect - Self-Learning & Reflection System

**Version 1.1.0**  
OpenReflect Team  
January 2026

> **Note:**  
> This document is mainly for agents and LLMs to follow when implementing
> learning capture, reflection processing, and knowledge evolution workflows.

---

## Overview

A three-stage knowledge evolution system for AI assistants that captures learnings from all interactions, enables manual reflection and review, and tracks knowledge evolution over time.

## Core Philosophy

**"Learning through reflection, evolution through practice"**

Open-Reflect captures not just errors, but also successes, preferences, and patterns:
1. **Capture Broadly**: Corrections + Success + Preferences + Best Practices
2. **Reflect Deeply**: Complete evolution history and context
3. **Evolve Continuously**: Track usage, validation, and optimization
4. **Analyze Smartly**: Trends, conflicts, and optimization insights

---

## Learning Types

| Type | Triggers | Confidence | Example |
|------|----------|------------|---------|
| **Explicit** | `remember:` | 0.95 (highest) | "remember: use venv for Python" |
| **Correction** | "no, use X", "don't Y", "actually..." | 0.90 | "no, use gpt-5.1 not gpt-5" |
| **Success** | "Perfect!", "Exactly right", "Great!" | 0.75 | "Perfect! That's exactly what I wanted" |
| **Preference** | "I prefer", "should use", "you should" | 0.70 | "I prefer explicit types" |
| **Best Practice** | Discovered patterns | 0.60 | "Always validate input first" |
| **Common Error** | Error patterns, anti-patterns | 0.65 | "Don't forget error handling" |

## Priority System

- 🔴 **Critical**: Explicit markers (`remember:`), 0.90+ confidence
- 🟡 **High**: Strong corrections, repeated feedback
- 🟢 **Medium**: General patterns, moderate confidence
- ⚪ **Normal**: Standard captures, context-dependent

---

## Workflow Stages

### Stage 1: Capture (Automatic)

Enhanced hooks detect multiple learning dimensions and queue them:

**Automatic Capture Patterns:**
```
User: no, use gpt-5.1 not gpt-5 for reasoning
→ Auto-detected correction, queued with confidence 0.90

User: Perfect! That's the exact caching strategy I wanted.
→ Auto-detected success pattern, queued with confidence 0.75

User: remember: always validate input first
→ Auto-detected explicit learning, queued with confidence 0.95
```

**Manual Capture (OpenCode):**
When user explicitly marks something to remember, use the skill tool:
```
skill({ name: "open-reflect" })
# Then reference the learning in context
```

### Stage 2: Reflect (Manual)

Process queued learnings with human review:

**Commands:**
- `/reflect` - Process all pending learnings with review
- `/reflect --view` - View queue details without processing
- `/reflect --analyze` - Analyze REFLECT.md evolution and provide insights
- `/reflect --critical-only` - Process only critical priority items
- `/reflect --scan-history` - Scan Claude Code history for missed learnings (uses `scan-history.py`)
- `/skip-reflect` - Discard all queued learnings

**Command Details:**
| Command | Script | Purpose |
|---------|--------|---------|
| `--view` | `check-reflect-queue.sh` | Display pending learnings |
| `--analyze` | `analyze-evolution.sh` | Analyze REFLECT.md trends |
| `--scan-history` | `scan-history.py` | Scan history for missed patterns |

**Manual Processing Example:**
```
User: /reflect
Claude: Found 3 pending learnings:

1. [Critical] "remember: use venv for Python"
   - Category: Best Practice
   - Tags: python, environment, development
   - Apply to REFLECT.md? [y/n/a]

2. [High] "no, use gpt-5.1 not gpt-5"
   - Category: Correction
   - Tags: ai, model-selection
   - Apply to REFLECT.md? [y/n/a]
```

### Stage 3: Evolve (Continuous)

REFLECT.md serves as the knowledge evolution record:
- Full history tracking (optimizations, usages, validations)
- Usage and validation monitoring
- Pattern and trend identification
- Actionable improvement insights

---

## When to Use This Skill

Use this skill when:
1. **User corrects behavior**: "no, use X not Y", "don't use Z"
2. **User provides positive feedback**: "Perfect!", "Great!", "Exactly right"
3. **User explicitly marks memory**: "remember:", "I want you to remember"
4. **Discussing learnings or improvements**: "What did we learn from..."
5. **User asks to capture knowledge**: "Capture this pattern"
6. **Detecting success patterns**: Effective solutions, good approaches

## When to Remind User

Remind user to run `/reflect` when:
- Completing a feature or meaningful work unit
- Making corrections that should be remembered
- Context is about to compress and queue has critical items
- Detecting git commits with pending learnings
- Capturing success patterns (positive feedback)

---

## REFLECT.md Structure

```markdown
# Learning Evolution Log

## Explicit Learnings
| ID | Learning | Category | Priority | Created | Last Used | Optimizations |
|----|----------|----------|----------|---------|-----------|---------------|
| E1 | "remember: use venv for Python" | Best Practice | Critical | 2024-01-15 | 2024-01-17 | 3 |

## Corrections
| ID | Original | Correction | Category | Priority | Created | Last Used | Optimizations |
|----|----------|------------|----------|----------|---------|-----------|---------------|
| C1 | "use gpt-5 for reasoning" | "use gpt-5.1 not gpt-5" | Model Selection | High | 2024-01-16 | 2024-01-18 | 2 |

## Success Patterns
| ID | Pattern | Context | Priority | Created | Last Used |
|----|---------|---------|----------|---------|-----------|-----------|
| S1 | "caching strategy" | API responses | Medium | 2024-01-17 | 2024-01-17 | 1 |

## User Preferences
| ID | Preference | Category | Priority | Created | Last Used |
|----|------------|----------|----------|---------|-----------|-----------|
| P1 | "prefer explicit types" | Code Style | Medium | 2024-01-15 | 2024-01-16 | 2 |

## Best Practices
| ID | Practice | Category | Priority | Created | Last Used |
|----|----------|----------|----------|---------|-----------|-----------|
| B1 | "Always validate input first" | Security | High | 2024-01-14 | 2024-01-18 | 4 |

## Common Errors
| ID | Error | Solution | Category | Priority | Created |
|----|-------|----------|----------|----------|---------|-----------|
| E1 | "forgot error handling" | "Always wrap async calls in try-catch" | Error Handling | High | 2024-01-15 |

## Evolution History
| Date | Learning ID | Action | Details |
|------|-------------|--------|---------|
| 2024-01-15 | E1 | Created | Initial capture |
| 2024-01-16 | E1 | Optimized | Refined description |
| 2024-01-17 | E1 | Used | Applied in Python project |
```

---

## Multi-Target Sync

Learnings can sync to multiple targets:

| Target | Format | Purpose |
|--------|--------|---------|
| **REFLECT.md** | Enhanced + History | Primary knowledge evolution |
| **CLAUDE.md** | Simplified | Context injection for Claude |
| **AGENTS.md** | Cross-tool | AI agent compatibility |

---

## Tips for Agents

1. **Explicit markers work best**: `remember: <learning>`
2. **Positive feedback captures success patterns**
3. **Run /reflect after completing features**
4. **Review REFLECT.md periodically for quality**
5. **Track evolution history for pattern analysis**
6. **Use semantic tags for better organization**

---

## Compatibility

This skill works with:
- Claude Code CLI (full plugin with hooks)
- OpenCode CLI (basic skill loader)
- Any AI assistant with skill tool support

---

## References

- [README.zh.md](../README.zh.md) - Full documentation in Chinese
- [README.en.md](../README.en.md) - Full documentation in English
- [README.jp.md](../README.jp.md) - Full documentation in Japanese
- [docs/OPENCODE_COMPATIBILITY.zh.md](../docs/OPENCODE_COMPATIBILITY.zh.md) - OpenCode CLI guide
