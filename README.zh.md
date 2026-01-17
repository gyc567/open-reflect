# Open-Reflect

**具有知识演化追踪的高级自学习与反思系统**

> "通过反思学习，通过实践演化"

**双平台支持**: Claude Code（完整插件） + OpenCode（基础技能）

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)
[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/gyc567/open-reflect)

---

## 🚀 功能介绍

Open-Reflect 从你与 Claude Code 的交互中捕获学习内容，并将它们演化为结构化知识库。与简单的捕获系统不同，Open-Reflect：

- ✅ **广泛捕获**: 不仅捕获修正，还包括成功模式、偏好和最佳实践
- 🔄 **深入反思**: 保持完整的演化历史和优化追踪
- 📈 **持续演化**: 追踪使用情况、验证结果和学习趋势
- 🎯 **智能分析**: 提供冲突、模式和优化的洞察

---

## 🎯 核心功能

### 1. 多维度学习捕获

| 学习类型 | 触发器 | 优先级 | 示例 |
|----------|--------|--------|------|
| **显式标记** | `remember:` | 🔴 关键 | "remember: 使用 Python 虚拟环境" |
| **修正** | "no, use X", "don't use Y" | 🟡 高 | "no, 使用 gpt-5.1 而不是 gpt-5" |
| **成功模式** | "Perfect!", "Great approach" | 🟢 中 | "Perfect! 这正是我想要的" |
| **偏好** | "you should use", "I prefer" | 🟢 中 | "我偏好显式类型" |
| **最佳实践** | 发现的模式 | 🟢 中 | "始终先验证输入" |

### 2. 演化追踪

每项学习都会追踪：
- **演化次数**: 优化的次数
- **使用次数**: 成功应用的次数
- **最后验证**: 最后一次验证正确的时间
- **置信度评分**: 基于模式强度的 0.60-0.95

### 3. 智能分析

- 🔍 **重复检测**: 查找相似条目，建议合并
- ⚠️ **冲突检测**: 识别矛盾的学习内容
- 📊 **趋势分析**: 显示学习模式和洞察
- 💡 **建议**: 基于历史提供优化建议

### 4. 基于优先级的处理

关键学习会优先处理：
- 🔴 **关键**: 用户显式标记，0.90+ 置信度
- 🟡 **高**: 强模式、重复修正
- 🟢 **中**: 一般模式、中等置信度

### 5. 多目标同步

- 📖 **REFLECT.md**（主要）: 增强格式，带完整历史
- 📘 **CLAUDE.md**（标准）: 简化格式，快速参考
- 🤖 **AGENTS.md**（可选）: 跨工具兼容性

---

## 📋 安装

### 前置条件

- 已安装 [Claude Code](https://claude.ai/code) CLI
- `jq` 用于 JSON 处理: `brew install jq`（macOS）

### 方式一：一键安装（推荐）

```bash
# 运行安装脚本自动安装插件
curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/scripts/install-claude-plugin.sh | bash
```

此脚本将：
- 检查前置条件（Git）
- 克隆仓库（临时）
- 复制插件文件到 `~/.claude/plugins/open-reflect`
- 使脚本可执行
- 清理临时文件
- 显示安装状态

### 方式二：手动安装

```bash
# 克隆仓库
git clone https://github.com/gyc567/open-reflect.git

# 复制到 Claude 插件目录
cp -r open-reflect ~/.claude/plugins/open-reflect

# 使脚本可执行
chmod +x ~/.claude/plugins/open-reflect/scripts/*.sh

# 重启 Claude Code 以激活插件
```

> **注意**: Claude Code Marketplace 安装即将推出。目前请使用上述一键安装或手动安装方式。

### 验证安装

安装后，验证插件是否正常工作：

```bash
# 重启 Claude Code 并运行测试命令
/reflect --view
```

如果插件安装正确，您应该看到：
```
📭 No pending learnings. System is up to date.
```

### OpenCode 插件

Open-Reflect 还提供具有相同核心功能的 OpenCode 插件。提供两种安装方式：

#### 方式一：一键安装（推荐）

```bash
# 运行安装脚本自动安装插件
curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/scripts/install-opencode-plugin.sh | bash
```

此脚本将：
- 克隆仓库（临时）
- 复制插件文件到 `~/.config/opencode/plugin/`
- 清理临时文件
- 显示安装状态

#### 方式二：手动安装

```bash
# 创建 OpenCode 插件目录
mkdir -p ~/.config/opencode/plugin

# 克隆仓库
git clone https://github.com/gyc567/open-reflect.git

# 复制 OpenCode 插件文件
cp -r open-reflect/.opencode/plugin/* ~/.config/opencode/plugin/

# 清理
rm -rf open-reflect

# 重启 OpenCode 以加载插件
```

#### 验证安装

安装后，验证插件是否正常工作：

```bash
# 检查插件文件是否存在
ls -la ~/.config/opencode/plugin/open-reflect-plugin.ts

# 重启 OpenCode 并运行测试命令
opencode
/repo --view
```

如果插件安装正确，您应该看到：
```
📭 No pending learnings. System is up to date.
```

#### OpenCode 命令

插件提供以下命令：

| 命令 | 描述 |
|------|------|
| `/repo` | 处理待处理的学习并更新 REFLECT.md |
| `/repo --view` | 查看待处理的学习而不处理 |
| `/skip-reflect` | 清除所有待处理的学习 |
| `/view-queue` | 查看待处理的学习而不处理 |

详细文档请参见 [docs/OPENCODE_PLUGIN.zh.md](docs/OPENCODE_PLUGIN.zh.md)。

---

## 🎮 使用方法

### 基本工作流程

```bash
# 1. 正常与 Claude Code 交互
> no, 使用 gpt-5.1 而不是 gpt-5 进行推理

# 2. 工作完成后运行反思
/reflect

# 3. 审核并应用学习
（交互式审核过程）

# 4. 知识更新到 REFLECT.md 和 CLAUDE.md
```

### 命令

| 命令 | 描述 |
|------|------|
| `/reflect` | 处理队列中的学习内容 |
| `/reflect --analyze` | 分析 REFLECT.md 演化并提供洞察 |
| `/reflect --view` | 查看队列详情 |
| `/reflect --critical-only` | 仅处理关键优先级项 |
| `/reflect --scan-history` | 扫描过去会话遗漏的学习 |
| `/skip-reflect` | 丢弃所有队列学习 |

---

## 🏗️ 架构

```
┌─────────────────────┐     ┌──────────────────────┐     ┌──────────────────────┐
│   你与 Claude      │ ──► │   Hooks 捕获        │ ──► │   队列累积          │
│   交互             │     │   多维度学习         │     │   丰富元数据         │
└─────────────────────┘     └──────────────────────┘     └──────────────────────┘
          （自动）                    （自动）                   （自动）

┌─────────────────────┐     ┌──────────────────────┐     ┌──────────────────────┐
│   你审核并批准      │ ──► │   应用到            │ ──► │   知识演化          │
│                     │     │   REFLECT.md        │     │                     │
└─────────────────────┘     └──────────────────────┘     └──────────────────────┘
          （手动）                    （同步）                   （持续）
```

### 三阶段系统

**阶段 1: 捕获（自动）**
增强的 hooks 检测多个学习维度：
- 修正模式
- 成功模式（正面反馈）
- 用户偏好
- 发现的最佳实践
- 要避免的常见错误

**阶段 2: 反思（手动）**
用户运行 `/reflect` 来：
- 审核每个学习内容及其上下文
- 检测重复和冲突
- 分类和优先级排序
- 应用到带完整历史的 REFLECT.md

**阶段 3: 演化（持续）**
REFLECT.md 作为演化记录：
- 追踪优化历史
- 监控使用模式
- 识别趋势
- 提供可操作的洞察

---

## 📊 REFLECT.md 结构

REFLECT.md 是核心知识演化文件：

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
追踪所有变更的表格

## 💭 反思笔记
### 待处理队列
### 已拒绝项
### 待验证项
```

---

## 🆚 对比: claude-reflect vs open-reflect

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
| **上下文感知** | 仅项目 | 项目 + 全局 + 演化指标 |

---

## 💡 提示

### 获得最佳效果

1. **对重要学习使用显式标记**:
   ```
   remember: 始终为 Python 项目使用虚拟环境
   ```

2. **当事情做得好时提供正面反馈**:
   ```
   Perfect! 这正是我想要的方法。
   ```

3. **定期运行 /reflect**:
   - Git 提交后（自动提醒）
   - 功能完成后
   - 当队列有关键项目时

4. **定期审核 REFLECT.md**:
   - 验证学习是否仍然准确
   - 删除过时的条目
   - 合并相似的项目

5. **使用 /reflect --analyze** 查看:
   - 学习趋势
   - 捕获的成功模式
   - 需要关注的领域

### 分类指南

| 分类 | 何时使用 | 示例 |
|------|----------|------|
| **全局** | 模型名称、一般模式 | "使用 gpt-5.1 进行推理" |
| **项目** | 项目特定约定 | "使用本地数据库进行缓存" |

---

## 🧪 测试

运行测试套件：

```bash
cd ~/.claude/plugins/open-reflect
./scripts/test.sh
```

---

## 🤝 贡献

欢迎贡献！请：

1. Fork 仓库
2. 创建功能分支
3. 用测试进行更改
4. 提交 pull request

---

## 📜 许可证

开源许可证
本项目采用 Apache License 2.0 许可。
见 [LICENSE](LICENSE) 文件。

---

## 🙏 致谢

- 灵感来自 Bayram Annakov 的 [claude-reflect](https://github.com/bayramannakov/claude-reflect)
- 为 Claude Code 社区构建

---

## 📞 支持

- 问题: [GitHub Issues](https://github.com/gyc567/open-reflect/issues)
- 讨论: [GitHub Discussions](https://github.com/gyc567/open-reflect/discussions)

---

**"知识不是静态的。它通过反思和实践而演化。"** - Open-Reflect
