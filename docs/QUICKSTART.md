# Open-Reflect Quick Start Guide

Get started with Open-Reflect in 5 minutes.

## 📦 Installation

### 1. Install Prerequisites

```bash
# Install jq (JSON processor)
brew install jq  # macOS
# or
sudo apt-get install jq  # Ubuntu/Debian
```

### 2. Install Plugin

```bash
# Add marketplace
claude plugin marketplace add open-reflect/open-reflect

# Install plugin
claude plugin install open-reflect@open-reflect-marketplace

# IMPORTANT: Restart Claude Code
```

### 3. Verify Installation

```bash
# Check plugin is loaded
claude plugin list | grep open-reflect

# Should show: open-reflect (version 1.0.0)
```

## 🚀 First Use

### Step 1: Initialize in Your Project

```bash
cd your-project-directory
/reflect --setup  # or run scripts/setup.sh manually
```

This creates:
- `REFLECT.md` - Knowledge evolution log
- Queue file in `~/.claude/`
- Backup directory

### Step 2: Work Normally

Just use Claude Code as usual. Open-Reflect captures learnings automatically.

**Example interactions that get captured**:

```
# Explicit marker (highest priority)
remember: always use virtual environments for Python

# Correction (high priority)
no, use gpt-5.1 not gpt-5 for reasoning

# Success pattern (medium priority)
Perfect! That's exactly what I wanted.

# Preference (medium priority)
I prefer explicit types over inference
```

### Step 3: Review and Apply

After completing work:

```bash
/reflect
```

You'll see:
- Summary of queued learnings
- Priority breakdown (critical/high/medium)
- Interactive review for each learning
- Options to apply to REFLECT.md, CLAUDE.md, or both

### Step 4: Check Evolution

```bash
/reflect --analyze
```

Shows:
- Learning trends over time
- Success patterns captured
- Areas needing attention
- Recommendations

## 📚 REFLECT.md Format

Your `REFLECT.md` will look like this:

```markdown
# Open-Reflect 知识演化日志

## 🎯 学习分类

### 🔄 修正类学习（Corrections）
#### 2026-01-17
- Use gpt-5.1 for reasoning tasks *(来源: queued, 置信度: 0.90, 使用次数: 1)*

### ✅ 成功模式（Success Patterns）
#### 2026-01-17
- Use local database cache to minimize API calls *(来源: queued, 置信度: 0.75, 使用次数: 3)*

### 🎨 偏好设置（Preferences）
### 📋 最佳实践（Best Practices）
### ⚠️ 常见错误（Common Errors）

## 🔍 智能洞察
### 📈 学习趋势分析
### 🎯 建议优化
### 🔗 知识关联

## 📜 演化历史
[Table tracking all changes]

## 💭 反思笔记
### 待处理队列
### 已拒绝项
### 待验证项
```

## 🎮 Common Workflows

### Workflow 1: Typical Development Session

```bash
# 1. Work with Claude
> Implement user authentication with JWT

Claude: [Implementation...]

> No, use OAuth2 instead of JWT

[Hook captures correction]

Claude: Got it! Using OAuth2 for authentication.

[Continue working...]

> git commit -m "Add OAuth2 authentication"

[Hook reminds: 🧠 You have 1 queued learning. Run /reflect.]

# 2. Process learnings
/reflect

# 3. Review and apply
[Interactive review process]

# 4. Knowledge is in REFLECT.md and CLAUDE.md
```

### Workflow 2: Pattern Discovery

```bash
# 1. Discover a good pattern
> Use batching for API calls

Claude: [Implementation...]

> Perfect! That's exactly what I wanted.

[Hook captures success pattern]

# 2. Later in another session
> Need to call this API multiple times

Claude: [Remembers pattern]
I'll use batching based on your success pattern.

# 3. Validate learning
/reflect --analyze

# Shows: "Success patterns: 3 - Strong pattern in API optimization"
```

### Workflow 3: Managing Queue

```bash
# View what's pending
/reflect --view

# Shows queue with details:
# Total: 5 items
# Critical: 1, High: 2, Medium: 2

# Process only critical items
/reflect --critical-only

# Discard low-quality items
/skip-reflect
```

## 💡 Pro Tips

### Tip 1: Use Explicit Markers

For important learnings that shouldn't be forgotten:

```
remember: always handle errors gracefully with try-catch
remember: use environment variables for secrets, never hardcode
```

**Benefit**: Highest confidence (0.95) + critical priority + 180 day decay.

### Tip 2: Provide Positive Feedback

When something works exceptionally well:

```
Perfect! This is exactly what I need.
Great approach! Keep doing this.
```

**Benefit**: Captures success patterns that can be reused.

### Tip 3: Run /reflect Regularly

After:
- Git commits (auto-reminder)
- Feature completion
- Bug fixes
- Major refactors

**Benefit**: Keeps knowledge base current and queue manageable.

### Tip 4: Review REFLECT.md Weekly

Check for:
- Outdated learnings (old model names, deprecated APIs)
- Conflicting entries (do X vs don't do X)
- Consolidation opportunities (similar items)

**Benefit**: Maintains knowledge quality and relevance.

### Tip 5: Use Priority Processing

When queue is large:

```bash
# Process critical first
/reflect --critical-only

# Then process rest
/reflect
```

**Benefit**: Ensures important learnings are applied quickly.

## 🔍 Troubleshooting

### Issue: Hooks Not Triggering

**Check**:
```bash
# Verify plugin is loaded
claude plugin list

# Check hooks file exists
cat ~/.claude/plugins/open-reflect/hooks/hooks.json

# Restart Claude Code
# Exit and reopen
```

### Issue: Queue Not Updating

**Check**:
```bash
# View queue
cat ~/.claude/openreflect-queue.json

# Check file permissions
ls -la ~/.claude/openreflect-queue.json

# Test capture manually
echo '{"prompt": "remember: test"}' | bash ~/.claude/plugins/open-reflect/scripts/capture-learning-enhanced.sh
```

### Issue: REFLECT.md Not Created

**Check**:
```bash
# Run setup in project directory
cd your-project
bash ~/.claude/plugins/open-reflect/scripts/setup.sh

# Verify file exists
ls -la REFLECT.md
```

## 📖 Next Steps

1. **Read Full Documentation**
   - [README.md](README.md) - Complete project overview
   - [ARCHITECTURE.md](ARCHITECTURE.md) - System internals
   - [USAGE_EXAMPLES.md](USAGE_EXAMPLES.md) - Detailed examples

2. **Test in Real Project**
   - Install in a real project
   - Work through typical development tasks
   - Run `/reflect` after git commits

3. **Customize for Your Workflow**
   - Adjust pattern detection in `capture-learning-enhanced.sh`
   - Modify REFLECT.md sections as needed
   - Add custom analysis scripts

4. **Contribute Back**
   - Share improvements with the community
   - Report bugs and issues
   - Suggest new features

---

**"Knowledge is not static. It evolves through reflection and practice."**

Happy Reflecting! 🎯
