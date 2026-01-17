# Open-Reflect

**Advanced self-learning and reflection system with evolutionary knowledge tracking**

> "Learning through reflection, evolution through practice"

**Dual Platform Support**: Claude Code (full plugin) + OpenCode (basic skill)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/open-reflect/open-reflect)

---

## 🚀 What It Does

Open-Reflect captures learnings from your interactions with Claude Code and evolves them into a structured knowledge base. Unlike simple capture systems, Open-Reflect:

- ✅ **Captures broadly**: Not just corrections, but successes, preferences, and best practices
- 🔄 **Reflects deeply**: Maintains full evolution history with refinement tracking
- 📈 **Evolves continuously**: Tracks usage, validation, and learning trends
- 🎯 **Analyzes intelligently**: Provides insights on conflicts, patterns, and optimizations

---

## 🎯 Core Features

### 1. Multi-Dimensional Learning Capture

| Learning Type | Trigger | Priority | Example |
|--------------|---------|----------|----------|
| **Explicit** | `remember:` | 🔴 Critical | "remember: use venv for Python" |
| **Correction** | "no, use X", "don't use Y" | 🟡 High | "no, use gpt-5.1 not gpt-5" |
| **Success Pattern** | "Perfect!", "Great approach" | 🟢 Medium | "Perfect! Exactly what I wanted" |
| **Preference** | "you should use", "I prefer" | 🟢 Medium | "I prefer explicit types" |
| **Best Practice** | Discovered patterns | 🟢 Medium | "Always validate input" |

### 2. Evolution Tracking

Every learning tracks:
- **Evolution count**: How many times refined
- **Usage count**: How many times successfully applied
- **Last validated**: When last used successfully
- **Confidence score**: 0.60-0.95 based on pattern strength

### 3. Smart Analysis

- 🔍 **Duplicate detection**: Finds similar entries, suggests consolidation
- ⚠️ **Conflict detection**: Identifies contradictory learnings
- 📊 **Trend analysis**: Shows learning patterns and insights
- 💡 **Recommendations**: Suggests optimizations based on history

### 4. Priority-Based Processing

Critical learnings are highlighted and processed first:
- 🔴 **Critical**: User explicitly marked, 0.90+ confidence
- 🟡 **High**: Strong patterns, repeated corrections
- 🟢 **Medium**: General patterns, moderate confidence

### 5. Multi-Target Sync

- 📖 **REFLECT.md** (Primary): Enhanced format with full history
- 📘 **CLAUDE.md** (Standard): Simplified format for quick reference
- 🤖 **AGENTS.md** (Optional): Cross-tool compatibility

---

## 📋 Installation

### Prerequisites

- [Claude Code](https://claude.ai/code) CLI installed
- `jq` for JSON processing: `brew install jq` (macOS)

### Install from Marketplace

```bash
# Add the marketplace
claude plugin marketplace add open-reflect/open-reflect

# Install the plugin
claude plugin install open-reflect@open-reflect-marketplace

# IMPORTANT: Restart Claude Code to activate the plugin
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/open-reflect/open-reflect.git

# Copy to Claude plugins directory
cp -r open-reflect ~/.claude/plugins/open-reflect

# Make scripts executable
chmod +x ~/.claude/plugins/open-reflect/scripts/*.sh

# Restart Claude Code
```

After installation, **restart Claude Code** (exit and reopen). Hooks will auto-configure and commands will be ready.

### OpenCode CLI Installation

```bash
# Clone the repository
git clone https://github.com/open-reflect/open-reflect.git
cd open-reflect

# Copy skill to OpenCode skills directory
mkdir -p ~/.config/opencode/skill
cp -r .opencode/skill/open-reflect ~/.config/opencode/skill/

# OR copy to project directory
cp -r .opencode/skill/open-reflect /path/to/your-project/.opencode/skill/

# Restart OpenCode
```

**Note**: OpenCode support is basic (skill loading + instructions only). For full functionality (auto-capture, hooks, evolution tracking), use Claude Code.

See [docs/OPENCODE_COMPATIBILITY.md](docs/OPENCODE_COMPATIBILITY.md) for detailed comparison.

---

## 🎮 Usage

### Basic Workflow

```bash
# 1. Work with Claude Code normally
> no, use gpt-5.1 not gpt-5 for reasoning

# 2. Run reflection when work is complete
/reflect

# 3. Review and apply learnings
# (Interactive review process)

# 4. Knowledge is updated in REFLECT.md and CLAUDE.md
```

### Commands

| Command | Description |
|---------|-------------|
| `/reflect` | Process queued learnings with review |
| `/reflect --analyze` | Analyze REFLECT.md evolution and insights |
| `/reflect --view` | View queue with detailed metadata |
| `/reflect --critical-only` | Process only critical priority items |
| `/reflect --scan-history` | Scan past sessions for missed learnings |
| `/skip-reflect` | Discard all queued learnings |

---

## 🏗️ Architecture

```
┌─────────────────────┐     ┌──────────────────────┐     ┌──────────────────────┐
│   You interact    │ ──► │   Hooks capture    │ ──► │   Queue accumulates │
│   with Claude      │     │   multi-dim        │     │   enriched metadata │
└─────────────────────┘     └──────────────────────┘     └──────────────────────┘
          (automatic)                    (automatic)                   (automatic)

┌─────────────────────┐     ┌──────────────────────┐     ┌──────────────────────┐
│   You review      │ ──► │   Apply to         │ ──► │   Knowledge        │
│   and approve     │     │   REFLECT.md       │     │   evolves          │
└─────────────────────┘     └──────────────────────┘     └──────────────────────┘
          (manual)                      (sync)                    (continuous)
```

### Three-Stage System

**Stage 1: Capture (Automatic)**
Enhanced hooks detect multiple learning dimensions:
- Correction patterns
- Success patterns (positive feedback)
- User preferences
- Best practices discovered
- Common errors to avoid

**Stage 2: Reflect (Manual)**
User runs `/reflect` to:
- Review each learning with context
- Detect duplicates and conflicts
- Categorize and prioritize
- Apply to REFLECT.md with full history

**Stage 3: Evolve (Continuous)**
REFLECT.md serves as evolution record:
- Tracks refinement history
- Monitors usage patterns
- Identifies trends
- Provides actionable insights

---

## 📊 REFLECT.md Structure

REFLECT.md is the core knowledge evolution file:

```markdown
# Open-Reflect 知识演化日志

## 🎯 学习分类

### 🔄 修正类学习（Corrections）
### ✅ 成功模式（Success Patterns）
### 🎨 偏好设置（Preferences）
### 📋 最佳实践（Best Practices）
### ⚠️ 常见错误（Common Errors）

## 🔍 智能洞察

### 📈 学习趋势分析
### 🎯 建议优化
### 🔗 知识关联

## 📜 演化历史
Table tracking all changes over time

## 💭 反思笔记
### 待处理队列
### 已拒绝项
### 待验证项
```

---

## 🆚 Comparison: claude-reflect vs open-reflect

| Feature | claude-reflect | open-reflect |
|---------|---------------|--------------|
| **Learning types** | Corrections only | Corrections + Success + Preferences + Best Practices |
| **Data structure** | Simple queue | Structured REFLECT.md with full evolution history |
| **Evolution tracking** | None | Refinements, usage, validation tracking |
| **Priority system** | Confidence only | Priority + Confidence + Semantic tags |
| **Duplicate handling** | Basic | Semantic detection + Conflict resolution + Consolidation |
| **Analysis** | Basic queue view | Trend analysis + Insights + Recommendations |
| **Multi-target** | CLAUDE.md + AGENTS.md | REFLECT.md + CLAUDE.md + AGENTS.md |
| **Context awareness** | Project only | Project + Global + Evolution metrics |

---

## 💡 Tips

### For Best Results

1. **Use explicit markers** for important learnings:
   ```
   remember: always use venv for Python projects
   ```

2. **Provide positive feedback** when things work well:
   ```
   Perfect! That's exactly what I wanted.
   ```

3. **Run /reflect regularly** after completing work:
   - After git commits (auto-reminder)
   - After feature completion
   - When queue has critical items

4. **Review REFLECT.md** periodically to:
   - Validate learnings are still accurate
   - Remove outdated entries
   - Consolidate similar items

5. **Use /reflect --analyze** to see:
   - Learning trends over time
   - Success patterns captured
   - Areas needing attention

### Category Guidelines

| Category | When to Use | Example |
|----------|-------------|----------|
| **Global** | Model names, general patterns | "Use gpt-5.1 for reasoning" |
| **Project** | Project-specific conventions | "Use local database for caching" |

---

## 🧪 Testing

Run the test suite:

```bash
cd ~/.claude/plugins/open-reflect
./scripts/test.sh
```

---

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by [claude-reflect](https://github.com/bayramannakov/claude-reflect) by Bayram Annakov
- Built for the Claude Code community

---

## 📞 Support

- Issues: [GitHub Issues](https://github.com/open-reflect/open-reflect/issues)
- Discussions: [GitHub Discussions](https://github.com/open-reflect/open-reflect/discussions)

---

**"Knowledge is not static. It evolves through reflection and practice."** - Open-Reflect
