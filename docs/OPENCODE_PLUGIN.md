# OpenCode Plugin

Open-Reflect OpenCode 插件 - 自学习系统插件，支持自动捕获学习模式并跟踪知识演化。

## 功能特性

### 1. 模式检测
插件会自动检测以下类型的消息：
- **纠错模式**: `no, use X`, `don't use Y`, `that's wrong`, `I meant`, etc.
- **显式标记**: `remember:`, `note:`, `important:`
- **正向反馈**: `Perfect!`, `Exactly right`, `Great approach`

### 2. 队列管理
插件使用 `.opencode/openreflect-queue.json` 文件管理待处理的学习条目：
```json
[
  {
    "id": "uuid",
    "type": "correction" | "positive" | "explicit",
    "message": "原始消息内容",
    "patterns": ["correction", "remember"],
    "confidence": 0.85,
    "timestamp": "2024-01-01T00:00:00.000Z"
  }
]
```

### 3. 自定义命令
- `/repo` - 手动触发反思处理
- `/skip-reflect` - 跳过当前会话的反思
- `/view-queue` - 查看待处理的反思队列

### 4. 事件钩子
插件监听以下事件：
- `session.compacted` - 会话结束时处理队列
- `tool.execute.before` - 工具执行前检查
- `tool.execute.after` - 工具执行后处理
- `message.updated` - 消息更新时检测新模式

## 安装

### 方式一：一键安装（推荐）

```bash
# 运行安装脚本自动安装插件
curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/scripts/install-opencode-plugin.sh | bash
```

此脚本将：
- 克隆仓库（临时）
- 复制插件文件到 `~/.config/opencode/plugin/`
- 清理临时文件
- 显示安装状态

### 方式二：手动安装

```bash
# 克隆仓库
git clone https://github.com/gyc567/open-reflect.git

# 创建 OpenCode 插件目录
mkdir -p ~/.config/opencode/plugin

# 复制 OpenCode 插件文件
cp -r open-reflect/.opencode/plugin/* ~/.config/opencode/plugin/

# 清理
rm -rf open-reflect
```

### 验证安装

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

## 配置

### 插件配置 (`.opencode/plugin.config.json`)
```json
{
  "name": "open-reflect",
  "version": "1.0.0",
  "description": "Self-learning system with knowledge evolution tracking",
  "author": {
    "name": "OpenReflect Team",
    "url": "https://github.com/gyc567/open-reflect"
  },
  "repository": "https://github.com/gyc567/open-reflect",
  "license": "MIT"
}
```

### 依赖配置 (`.opencode/package.json`)
```json
{
  "name": "open-reflect",
  "version": "1.0.0",
  "type": "module",
  "dependencies": {}
}
```

## 文件结构

```
.opencode/
├── plugin.config.json          # 插件元数据配置
├── package.json                # 依赖配置
├── plugin/
│   └── open-reflect-plugin.ts  # 主插件文件 (~500 lines)
└── tools/                      # 自定义工具目录
```

## 使用示例

### 基本用法
插件会自动检测对话中的学习模式：

```
User: Use gpt-4 for this task.
Assistant: no, use gpt-5.1 instead. gpt-4 is deprecated for this use case.

→ 插件检测到纠错模式，添加到队列
→ 会话结束时更新 REFLECT.md
```

### 手动触发
```bash
# 触发反思处理
/repo

# 跳过当前会话
/skip-reflect

# 查看队列
/view-queue
```

## REFLECT.md 格式

插件会更新项目根目录的 `REFLECT.md` 文件：

```markdown
# Open-Reflect 学习记录

## 学习分类

### 纠错模式 (Corrections)
- **2024-01-01**: "Use gpt-5.1 not gpt-4" - AI模型选择
  - 置信度: 0.90
  - 来源: 助手纠错

### 正向反馈 (Positive)
- **2024-01-01**: "Perfect! Exactly what I wanted" - 用户满意度
  - 置信度: 0.85
  - 来源: 用户表扬

### 重要记录 (Important)
- **2024-01-01**: "remember: always use venv for Python" - Python 环境管理
  - 置信度: 1.00
  - 来源: 显式标记

---

最后更新: 2024-01-01T00:00:00.000Z
```

## 知识演化跟踪

Open-Reflect 插件支持知识演化跟踪，通过版本化的学习记录实现：

1. **版本号**: 每次更新 REFLECT.md 递增版本
2. **变更日志**: 记录每次学习的来源和置信度
3. **统计信息**: 跟踪学习模式的出现频率

## 与 Claude Code 插件的区别

| 特性 | Claude Code | OpenCode |
|------|-------------|----------|
| 安装方式 | `claude plugin install` | 复制到 `~/.config/opencode/plugin/` |
| 配置文件 | `CLAUDE.md` | `plugin.config.json` |
| 命令格式 | `/reflect` | `/repo` |
| 队列文件 | `.claude/openreflect-queue.json` | `.opencode/openreflect-queue.json` |
| 事件监听 | `CLAUDE.md` 规则 | OpenCode 事件系统 |

## 开发

### 运行测试
```bash
npx tsx tests/opencode-plugin/opencode-plugin.test.ts
```

### 调试插件
```bash
# 启用详细日志
DEBUG=open-reflect:* npx tsx .opencode/plugin/open-reflect-plugin.ts
```

## 贡献

欢迎贡献代码！请查看 [CONTRIBUTING.md](../../CONTRIBUTING.md)。

## 许可证

MIT License - 见 [LICENSE](../../LICENSE)
