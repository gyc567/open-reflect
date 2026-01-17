---
name: open-reflect
description: |
  具有知识演化追踪的高级自学习与反思系统。
  捕获修正、成功模式、偏好和最佳实践，然后将它们组织到 REFLECT.md 中，包含完整的演化历史。
  同时支持 Claude Code（完整插件）和 OpenCode（基础技能）。
  在讨论学习、修正或用户提到记忆时使用。
  触发词: "记住这个", "用X不用Y", "实际上...", "完美！", 修正, 反馈。
allowed-tools: Read, Write, Edit, Glob, Bash(jq:*), Bash(cat:*), AskUserQuestion, Grep
version: 1.1.0
license: MIT
author: OpenReflect Team
compatibility: claude-code,opencode
---

# Open-Reflect - 高级自学习与反思系统

**双平台支持**: Claude Code（完整插件） + OpenCode（基础技能）

帮助 AI 助手从所有交互中学习、反思和进化的三阶段系统。

## 平台支持

### Claude Code（完整插件）
- 位置: `~/.claude/plugins/open-reflect/`
- 功能: 自动捕获、hooks、队列管理、演化追踪
- 命令: `/reflect`, `/reflect --view`, `/reflect --analyze`, `/skip-reflect`

### OpenCode（基础技能）
- 位置: `.opencode/skill/open-reflect/SKILL.md` 或 `~/.config/opencode/skill/open-reflect/`
- 功能: 技能加载、指令参考、手动操作
- 使用: `skill({ name: "open-reflect" })`

详见 [docs/OPENCODE_COMPATIBILITY.zh.md](docs/OPENCODE_COMPATIBILITY.zh.md)。

## 工作原理

**阶段 1: 捕获（Claude Code 上自动，OpenCode 上手动）**
增强的 hooks 检测多个学习维度并将其加入队列到 `~/.claude/openreflect-queue.json`:

| 学习类型 | 触发器 | 置信度 | 示例 |
|----------|--------|--------|------|
| **显式标记** | "remember:" | 0.95（最高） | "remember: 为 Python 使用虚拟环境" |
| **修正** | "no, use X", "don't use Y" | 0.90 | "no, 使用 gpt-5.1 而不是 gpt-5" |
| **成功模式** | "Perfect!", "Great approach" | 0.75 | "Perfect! 这正是我想要的" |
| **偏好** | "you should use", "I prefer" | 0.70 | "我偏好更短的函数" |

每个捕获的学习包括：
- 多维度分类（修正/成功/偏好/最佳实践）
- 优先级级别（关键/高/中/正常）
- 置信度评分（0.60-0.95）
- 语义标签
- 演化追踪（优化次数、使用次数、最后验证）

**阶段 2: 反思（手动）**
用户运行 `/reflect` 来审核并将队列中的学习应用到 REFLECT.md，包含：
- 多维度分类
- 重复/冲突检测
- 演化历史追踪
- 智能去重和合并
- 基于优先级的处理

**阶段 3: 演化（持续）**
REFLECT.md 作为知识演化记录：
- 追踪学习历史和变更
- 监控使用和验证情况
- 识别模式和趋势
- 提供可改进的洞察

## 可用命令

| 命令 | 用途 |
|------|------|
| `/reflect` | 处理队列中的学习（带审核） |
| `/reflect --analyze` | 分析 REFLECT.md 演化并提供洞察 |
| `/reflect --view` | 查看队列详情 |
| `/reflect --critical-only` | 仅处理关键优先级项 |
| `/reflect --scan-history` | 扫描过去会话遗漏的学习 |
| `/skip-reflect` | 丢弃所有队列学习 |

## 何时提醒用户

在以下情况提醒用户使用 `/reflect`：
- 他们完成了功能或有意义的工作单元
- 他们做出了应该记住的修正
- 他们明确说"记住这个"或类似的话
- 上下文即将压缩且队列有关键项目
- 检测到 Git 提交且有待处理的学习
- 捕获到成功模式（正面反馈）

## 增强的学习分类

| 分类 | 描述 | 示例 |
|------|------|------|
| **修正** | 错误及如何修复 | "no, 用 X 不用 Y" |
| **成功模式** | 什么效果好（正面反馈） | "Perfect! 正好" |
| **偏好** | 用户偏好和风格选择 | "我偏好显式类型" |
| **最佳实践** | 发现的最佳实践 | "始终验证输入" |
| **常见错误** | 要避免的错误 | "别忘记错误处理" |

## REFLECT.md 结构

REFLECT.md 是核心知识演化文件，详见 [README.zh.md](README.zh.md)。

## 与 claude-reflect 的增强对比

| 功能 | claude-reflect | open-reflect |
|------|---------------|--------------|
| **平台支持** | 仅 Claude Code | Claude Code + OpenCode |
| **学习类型** | 仅修正 | 修正 + 成功 + 偏好 + 最佳实践 |
| **数据结构** | 简单队列 | 带演化的结构化 REFLECT.md |
| **演化追踪** | 无 | 完整历史（优化、使用、验证） |
| **优先级级别** | 仅置信度 | 优先级 + 置信度 + 标签 |
| **重复处理** | 基础 | 语义 + 冲突检测 + 合并 |
| **分析** | 基础队列视图 | 趋势分析 + 洞察 + 建议 |
| **多目标** | CLAUDE.md + AGENTS.md | REFLECT.md + CLAUDE.md + AGENTS.md |

## 哲学

Open-Reflect 体现了原则：**"通过反思学习，通过实践演化"**

与简单的捕获系统不同，Open-Reflect：
1. **广泛捕获**: 不仅捕获错误，还包括成功、偏好和模式
2. **深入反思**: 保持完整的演化历史和上下文
3. **持续演化**: 追踪使用、验证和优化
4. **智能分析**: 提供趋势、冲突和优化的洞察

系统在自动化的同时尊重人类自主性：
- 🤖 自动捕获（机器效率）
- 👤 手动审核（人类判断）
- 📈 持续演化（迭代改进）
