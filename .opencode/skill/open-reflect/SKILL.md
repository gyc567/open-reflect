---
name: open-reflect
description: Advanced self-learning system with knowledge evolution tracking. Captures corrections, success patterns, preferences, and best practices. Use when discussing learnings, corrections, or when user mentions remembering. Triggers: remember this, no use X, Perfect!, I prefer.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: continuous-learning
---

# Open-Reflect - Self-Learning & Reflection System

A three-stage knowledge evolution system for AI assistants.

## What I Do

**Stage 1: Capture (Automatic)**
Detect and queue learnings from your interactions:
- **Corrections**: "no, use X", "don't use Y", "actually..."
- **Success Patterns**: "Perfect!", "Exactly right", "Great approach"
- **Preferences**: "remember:", "I prefer", "you should use"
- **Best Practices**: Discovered patterns and conventions

**Stage 2: Reflect (Manual)**
Review and apply queued learnings:
- `/reflect` - Process all pending learnings
- `/reflect --view` - View queue details
- `/reflect --analyze` - Analyze evolution trends
- `/skip-reflect` - Discard queue

**Stage 3: Evolve (Continuous)**
Knowledge evolves through:
- Evolution history tracking
- Usage validation
- Trend analysis
- Conflict resolution

## Learning Types

| Type | Triggers | Example |
|------|----------|---------|
| **Explicit** | `remember:` | "remember: use venv for Python" |
| **Correction** | "no, use X", "don't Y" | "no, use gpt-5.1 not gpt-5" |
| **Success** | "Perfect!", "Great!" | "Perfect! That's exactly what I wanted" |
| **Preference** | "I prefer", "should use" | "I prefer explicit types" |
| **Best Practice** | Discovered patterns | "Always validate input first" |

## Priority System

- 🔴 **Critical**: Explicit markers (`remember:`), 0.90+ confidence
- 🟡 **High**: Strong corrections, repeated feedback
- 🟢 **Medium**: General patterns, moderate confidence

## Usage Examples

### Capture a Correction
```
You: no, use gpt-5.1 not gpt-5 for reasoning
Claude: Got it! I'll use gpt-5.1 for reasoning.

[Hook auto-captures to queue]

You: /reflect
Claude: Found 1 learning. Review and apply?
```

### Capture Success Pattern
```
You: Perfect! That's the exact caching strategy I wanted.
Claude: Thanks! I'll remember this pattern.
```

### View Pending Learnings
```
/reflect --view

Shows queue with:
- Total count by priority
- Category breakdown
- Individual learning details
```

### Analyze Evolution
```
/reflect --analyze

Shows:
- Learning trends over time
- Success patterns captured
- Recommendations for improvement
```

## REFLECT.md Format

Knowledge is stored in REFLECT.md with:
- Multi-category organization
- Evolution history table
- Smart insights and recommendations
- Full metadata (confidence, usage, validation)

## Multi-Target Sync

Learnings sync to:
- **REFLECT.md** (Primary) - Enhanced format with history
- **CLAUDE.md** (Optional) - Simplified format
- **AGENTS.md** (Optional) - Cross-tool compatibility

## When to Use Me

Use this skill when:
- User corrects your behavior ("no, use X not Y")
- User provides positive feedback ("Perfect!", "Great!")
- User explicitly marks something to remember
- Discussing learnings, corrections, or improvements
- User asks to capture or track knowledge

## Tips

1. **Explicit markers work best**: `remember: <learning>`
2. **Positive feedback captures success patterns**
3. **Run /reflect after completing features**
4. **Review REFLECT.md periodically for quality**

## Compatibility

This skill works with:
- Claude Code CLI (full plugin)
- OpenCode CLI (basic skill loader)
- Any AI assistant with skill tool support
