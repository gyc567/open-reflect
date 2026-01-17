# OpenCode CLI 兼容性指南

## 概述

Open-Reflect 现在同时支持 **Claude Code CLI** 和 **OpenCode CLI** 两种平台。

## 平台对比

| 功能 | Claude Code | OpenCode |
|------|------------|----------|
| **Skill 结构** | 多文件（commands/, hooks/, scripts/） | 单文件（.opencode/skill/<name>/SKILL.md） |
| **配置方式** | .claude-plugin/plugin.json | 自动扫描发现 |
| **命令定义** | 独立 .md 文件 + allowed-tools | 通过 skill 工具加载 |
| **自动化** | 复杂 hooks 系统 | 简单 skill 工具调用 |
| **复杂度** | 高 (~3000行) | 低 (~150行) |

## 安装方式

### Claude Code（完整功能）

```bash
# 方法 1: Marketplace 安装
claude plugin marketplace add open-reflect/open-reflect
claude plugin install open-reflect@open-reflect-marketplace

# 方法 2: 手动安装
git clone https://github.com/gyc567/open-reflect.git
cp -r open-reflect ~/.claude/plugins/open-reflect
```

**功能**: 完整功能（自动捕获、hooks、演化追踪）

### OpenCode（基础功能）

```bash
# 方式 1: 克隆仓库
git clone https://github.com/gyc567/open-reflect.git
cd open-reflect

# 方式 2: 复制 skill 文件到项目
cp -r .opencode/skill/open-reflect ~/.config/opencode/skill/
# 或复制到项目目录
cp -r .opencode/skill/open-reflect /path/to/your-project/.opencode/skill/

# 方式 3: 链接到项目
ln -s $(pwd)/.opencode/skill/open-reflect /path/to/project/.opencode/skill/open-reflect
```

**功能**: 基础功能（skill 加载、指令提供）

## 使用方式

### Claude Code

```bash
# 自动捕获（通过 hooks）
> no, use gpt-5.1 not gpt-5

# 手动处理
/reflect
/reflect --view
/reflect --analyze
/skip-reflect
```

### OpenCode

```bash
# 加载 skill
skill({ name: "open-reflect" })

# 使用 skill 内的指令
# OpenCode 会显示可用的操作指南

# 手动操作（在提示中）
> remember: use venv for Python
> /reflect
> no, use X not Y
```

## 文件结构

### Claude Code（完整）

```
open-reflect/
├── .claude-plugin/
│   └── plugin.json          # 插件配置
├── commands/
│   ├── reflect.md           # 主命令
│   ├── skip-reflect.md      # 丢弃队列
│   └── view-queue.md        # 查看队列
├── hooks/
│   └── hooks.json           # Hook 配置
├── scripts/
│   ├── capture-learning-enhanced.sh
│   ├── check-reflect-queue.sh
│   ├── post-commit-reminder.sh
│   ├── analyze-evlection.sh
│   ├── setup.sh
│   └── test.sh
└── SKILL.md                 # Skill 定义
```

### OpenCode（精简）

```
open-reflect/
└── .opencode/
    └── skill/
        └── open-reflect/
            └── SKILL.md     # 单一 skill 文件
```

## 共享文件

两个平台共享以下文件：

| 文件 | 用途 |
|------|------|
| `REFLECT.md` | 知识演化日志 |
| `REFLECT.md.example` | 示例模板 |
| `README.md` | 项目文档 |
| `LICENSE` | MIT 许可证 |
| `.gitignore` | Git 忽略配置 |

## 功能对比

| 功能 | Claude Code | OpenCode |
|------|------------|----------|
| **自动捕获** | ✅ 自动 hooks | ⚪ 手动提醒 |
| **队列管理** | ✅ 完整 | ⚪ 无队列 |
| **演化追踪** | ✅ 完整历史 | ⚪ 静态记录 |
| **智能分析** | ✅ 趋势洞察 | ⚪ 无分析 |
| **优先级处理** | ✅ 多维度 | ⚪ 无优先级 |
| **多目标同步** | ✅ 3个目标 | ⚪ 手动 |
| **冲突检测** | ✅ 自动检测 | ⚪ 手动 |
| **双语支持** | ✅ 中英双语 | ⚪ 英文 |

## 推荐使用场景

### Claude Code 适合
- 长期开发项目
- 需要自动学习追踪
- 需要复杂的知识演化
- 团队协作知识共享

### OpenCode 适合
- 快速参考 skill 指令
- 一次性任务指导
- 轻量级知识管理
- 多平台 AI 助手共享

## OpenCode 权限配置

在 `opencode.json` 中配置：

```json
{
  "permission": {
    "skill": {
      "open-reflect": "allow",
      "internal-*": "allow",
      "experimental-*": "ask"
    }
  }
}
```

## 故障排除

### Skill 不显示

**Claude Code**:
```bash
# 检查插件是否加载
claude plugin list | grep open-reflect

# 重启 Claude Code
```

**OpenCode**:
```bash
# 检查 skill 文件位置
ls -la .opencode/skill/open-reflect/SKILL.md

# 检查文件权限
chmod 644 .opencode/skill/open-reflect/SKILL.md

# 重启 OpenCode
```

### 权限问题

**OpenCode**:
```bash
# 检查权限配置
cat opencode.json | jq '.permission.skill'

# 刷新配置
# 重启 OpenCode
```

## 迁移指南

### 从 Claude Code 迁移到 OpenCode

1. **复制 skill 文件**:
   ```bash
   cp -r .opencode/skill/open-reflect /path/to/project/.opencode/skill/
   ```

2. **复制共享文件**:
   ```bash
   cp REFLECT.md.example /path/to/project/
   ```

3. **配置权限**（如需要）:
   ```bash
   cat >> opencode.json << 'EOF'
   {
     "permission": {
       "skill": {
         "open-reflect": "allow"
       }
     }
   }
   EOF
   ```

### 从 OpenCode 升级到 Claude Code

1. **完整安装**:
   ```bash
   claude plugin marketplace add open-reflect/open-reflect
   ```

2. **复制项目文件**:
   ```bash
   cp .claude-plugin/plugin.json ~/.claude/plugins/open-reflect/
   cp -r commands ~/.claude/plugins/open-reflect/
   cp -r hooks ~/.claude/plugins/open-reflect/
   cp -r scripts ~/.claude/plugins/open-reflect/
   ```

3. **重启 Claude Code**

## 贡献

欢迎贡献来改进双平台兼容性！

- **Claude Code 功能**: 在 `commands/`, `hooks/`, `scripts/` 中添加
- **OpenCode 功能**: 更新 `.opencode/skill/open-reflect/SKILL.md`
- **共享文档**: 更新 `README.md` 和 `docs/`

## 许可证

MIT License - 见 [LICENSE](../LICENSE)
