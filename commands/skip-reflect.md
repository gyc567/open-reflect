---
description: Discard all or specific learnings from queue
allowed-tools: Bash, AskUserQuestion
---

## Context
- Queue count: !`jq 'length' ~/.claude/openreflect-queue.json 2>/dev/null || echo 0`

## Your Task

1. If queue is empty:
   - Output: "Queue is already empty. Nothing to skip."
   - Exit

2. If queue has items:
   - Show summary: "You are about to discard [count] learning(s)"
   - Show breakdown by priority:
     ```
     Queue breakdown:
       • Critical: [N] items
       • High: [N] items
       • Medium: [N] items
       • Normal: [N] items
     ```
   - Ask: "Are you sure you want to discard all? [y/n]"

3. If user confirms (y/yes):
   - Backup queue before clearing:
     ```bash
     mkdir -p ~/.claude/openreflect-backups
     cp ~/.claude/openreflect-queue.json ~/.claude/openreflect-backups/skip-backup-$(date +%Y%m%d-%H%M%S).json
     ```
   - Clear queue:
     ```bash
     echo "[]" > ~/.claude/openreflect-queue.json
     ```
   - Output: "Discarded [count] learnings. Queue cleared. Backup saved."

4. If user declines (n/no):
   - Output: "Aborted. Run /reflect to process learnings instead."

## Advanced Options

**Selective Skip** (future enhancement):
- Allow skipping specific items by ID
- Skip by category (e.g., skip all success patterns)
- Skip items older than N days

## Note

This is an escape hatch for when:
- Auto-detection captured false positives
- Learnings aren't worth saving
- Queue has accumulated too many low-quality items
- Starting fresh after major refactoring

Use sparingly - consider /reflect with selective application first.
