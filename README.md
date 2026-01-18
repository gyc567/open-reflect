# Open-Reflect

**This is the default README. For other languages, see:**

- [English](README.en.md)
- [中文](README.zh.md)
- [日本語](README.jp.md)

---

## Quick Links

| Language | File | Status |
|----------|------|--------|
| English | README.en.md | ✅ Complete |
| Chinese | README.zh.md | ✅ Complete |
| Japanese | README.jp.md | ✅ Complete |

---

**Open-Reflect** - Advanced self-learning and reflection system with evolutionary knowledge tracking.

> "Learning through reflection, evolution through practice"

**Dual Platform Support**: Claude Code + OpenCode

See [README.en.md](README.en.md) for full documentation.

---

## 🚀 Quick Install (One-Click)

### Claude Code Plugin (Full Features)

```bash
# One-line installation
curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/scripts/install-claude-plugin.sh | bash
```

### OpenCode Skill (Lightweight)

```bash
# One-line installation
curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/.opencode/scripts/install-opencode-skill.sh | bash
```

---

## 📋 Installation

### Claude Code

```bash
# One-click (recommended)
curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/scripts/install-claude-plugin.sh | bash

# Or manual
git clone https://github.com/gyc567/open-reflect.git
cp -r open-reflect ~/.claude/plugins/open-reflect
chmod +x ~/.claude/plugins/open-reflect/scripts/*.sh
```

### OpenCode

```bash
# One-click (recommended)
curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/.opencode/scripts/install-opencode-skill.sh | bash

# Or manual
git clone https://github.com/gyc567/open-reflect.git
cp -r .opencode/skill/open-reflect ~/.config/opencode/skill/
```

---

## ✅ Verify

```bash
# Claude Code
/reflect --view

# OpenCode
skill({ name: "open-reflect" })
```

Expected: `📭 No pending learnings. System is up to date.`

---

**License**: Apache License 2.0 - See [LICENSE](LICENSE)
