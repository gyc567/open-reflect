# OpenCode Plugin

Open-Reflect OpenCode Plugin - Self-learning system plugin with automatic pattern detection and knowledge evolution tracking.

## Features

### 1. Pattern Detection
The plugin automatically detects the following types of messages:
- **Correction patterns**: `no, use X`, `don't use Y`, `that's wrong`, `I meant`, etc.
- **Explicit markers**: `remember:`, `note:`, `important:`
- **Positive feedback**: `Perfect!`, `Exactly right`, `Great approach`

### 2. Queue Management
The plugin uses `.opencode/openreflect-queue.json` file to manage pending learning entries:
```json
[
  {
    "id": "uuid",
    "type": "correction" | "positive" | "explicit",
    "message": "Original message content",
    "patterns": ["correction", "remember"],
    "confidence": 0.85,
    "timestamp": "2024-01-01T00:00:00.000Z"
  }
]
```

### 3. Custom Commands
- `/repo` - Manually trigger reflection processing
- `/skip-reflect` - Skip reflection for current session
- `/view-queue` - View pending reflection queue

### 4. Event Hooks
The plugin listens to the following events:
- `session.compacted` - Process queue when session ends
- `tool.execute.before` - Check before tool execution
- `tool.execute.after` - Process after tool execution
- `message.updated` - Detect new patterns when messages update

## Installation

### Option 1: One-Click Installation (Recommended)

```bash
# Run the installation script to automatically install the plugin
curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/scripts/install-opencode-plugin.sh | bash
```

This script will:
- Clone the repository (temporary)
- Copy plugin files to `~/.config/opencode/plugin/`
- Clean up temporary files
- Display installation status

### Option 2: Manual Installation

```bash
# Clone the repository
git clone https://github.com/gyc567/open-reflect.git

# Create OpenCode plugin directory
mkdir -p ~/.config/opencode/plugin

# Copy OpenCode plugin files
cp -r open-reflect/.opencode/plugin/* ~/.config/opencode/plugin/

# Clean up
rm -rf open-reflect
```

## Verify Installation

After installation is working:

```, verify the pluginbash
# Check if plugin files exist
ls -la ~/.config/opencode/plugin/open-reflect-plugin.ts

# Restart OpenCode and run a test command
opencode
/repo --view
```

If the plugin is installed correctly, you should see:
```
📭 No pending learnings. System is up to date.
```

## File Structure

```
.opencode/
├── plugin.config.json          # Plugin metadata configuration
├── package.json                # Dependencies configuration
├── plugin/
│   └── open-reflect-plugin.ts  # Main plugin file (~400 lines)
└── tools/                      # Custom tools directory
```

## Usage Examples

### Basic Usage
The plugin automatically detects learning patterns in conversation:

```
User: Use gpt-4 for this task.
Assistant: no, use gpt-5.1 instead. gpt-4 is deprecated for this use case.

→ Plugin detects correction pattern, adds to queue
→ Updates REFLECT.md at session end
```

### Manual Commands
```bash
# Trigger reflection processing
/repo

# Skip current session
/skip-reflect

# View queue
/view-queue
/repo --view
```

## REFLECT.md Format

The plugin updates `REFLECT.md` in the project root:

```markdown
# Open-Reflect Knowledge Evolution Log

## 🎯 Learning Categories

### Corrections
- **2024-01-01**: "Use gpt-5.1 not gpt-4" - AI model selection
  - Confidence: 0.90
  - Source: Assistant correction

### Positive Feedback
- **2024-01-01**: "Perfect! Exactly what I wanted" - User satisfaction
  - Confidence: 0.85
  - Source: User praise

### Important Notes
- **2024-01-01**: "remember: always use venv for Python" - Python environment management
  - Confidence: 1.00
  - Source: Explicit marker

---

Last updated: 2024-01-01T00:00:00.000Z
```

## Knowledge Evolution Tracking

The Open-Reflect plugin supports knowledge evolution tracking through versioned learning records:

1. **Version number**: Increment when updating REFLECT.md
2. **Change log**: Record source and confidence for each learning
3. **Statistics**: Track learning pattern frequency

## Comparison with Claude Code Plugin

| Feature | Claude Code | OpenCode |
|---------|-------------|----------|
| Installation | `claude plugin install` | Copy to `~/.config/opencode/plugin/` |
| Configuration | `CLAUDE.md` | `plugin.config.json` |
| Command format | `/reflect` | `/repo` |
| Queue file | `.claude/openreflect-queue.json` | `.opencode/openreflect-queue.json` |
| Event listening | `CLAUDE.md` rules | OpenCode event system |

## Development

### Run Tests
```bash
npx tsx tests/opencode-plugin/opencode-plugin.test.ts
```

### Debug Plugin
```bash
# Enable verbose logging
DEBUG=open-reflect:* npx tsx .opencode/plugin/open-reflect-plugin.ts
```

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](../../CONTRIBUTING.md).

## License

MIT License - see [LICENSE](../../LICENSE)
