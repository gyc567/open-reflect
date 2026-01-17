#!/bin/bash
#
# Open-Reflect Claude Code Plugin Installation Script
# Installs the Claude Code plugin with one command
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/gyc567/open-reflect.git"
PLUGIN_SOURCE="open-reflect"
PLUGIN_DEST="$HOME/.claude/plugins"
SETTINGS_FILE="$HOME/.claude/settings.json"
TEMP_DIR=$(mktemp -d)

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Open-Reflect Claude Code Plugin Installer               ║${NC}"
echo -e "${BLUE}║  Self-learning system with evolutionary knowledge tracking║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Check prerequisites
echo -e "${YELLOW}📋 Step 1/6: Checking prerequisites...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is not installed. Please install Git first.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi
echo -e "${GREEN}✅ Git is installed${NC}"

# Step 2: Clone repository
echo -e "${YELLOW}📦 Step 2/6: Cloning repository...${NC}"
git clone --quiet "$REPO_URL" "$TEMP_DIR/open-reflect" 2>/dev/null || {
    echo -e "${RED}❌ Failed to clone repository${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
}
echo -e "${GREEN}✅ Repository cloned${NC}"

# Step 3: Create plugin directory
echo -e "${YELLOW}📁 Step 3/6: Setting up plugin directory...${NC}"
# Remove old installation if exists
if [ -d "$PLUGIN_DEST/$PLUGIN_SOURCE" ]; then
    echo -e "${YELLOW}   Removing old installation...${NC}"
    rm -rf "$PLUGIN_DEST/$PLUGIN_SOURCE"
fi
mkdir -p "$PLUGIN_DEST"
echo -e "${GREEN}✅ Directory ready${NC}"

# Step 4: Copy plugin files with verification
echo -e "${YELLOW}📋 Step 4/6: Copying plugin files...${NC}"
if [ -d "$TEMP_DIR/$PLUGIN_SOURCE" ]; then
    # Copy entire directory
    cp -r "$TEMP_DIR/$PLUGIN_SOURCE/." "$PLUGIN_DEST/$PLUGIN_SOURCE/"
    
    # Verify critical files exist
    echo -e "${YELLOW}   Verifying plugin files...${NC}"
    
    if [ ! -f "$PLUGIN_DEST/$PLUGIN_SOURCE/.claude-plugin/plugin.json" ]; then
        echo -e "${RED}❌ Missing plugin.json${NC}"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
    
    if [ ! -f "$PLUGIN_DEST/$PLUGIN_SOURCE/commands/reflect.md" ]; then
        echo -e "${RED}❌ Missing commands/reflect.md${NC}"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
    
    if [ ! -f "$PLUGIN_DEST/$PLUGIN_SOURCE/commands/skip-reflect.md" ]; then
        echo -e "${RED}❌ Missing commands/skip-reflect.md${NC}"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
    
    if [ ! -f "$PLUGIN_DEST/$PLUGIN_SOURCE/hooks/hooks.json" ]; then
        echo -e "${RED}❌ Missing hooks/hooks.json${NC}"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
    
    echo -e "${GREEN}✅ All critical files verified${NC}"
else
    echo -e "${RED}❌ Plugin source directory not found${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Step 5: Make scripts executable and enable plugin
echo -e "${YELLOW}🔧 Step 5/6: Enabling plugin...${NC}"
if [ -d "$PLUGIN_DEST/$PLUGIN_SOURCE/scripts" ]; then
    chmod +x "$PLUGIN_DEST/$PLUGIN_SOURCE/scripts"/*.sh 2>/dev/null || true
fi

# Enable plugin in settings.json
echo -e "${YELLOW}   Updating Claude Code settings...${NC}"
if [ -f "$SETTINGS_FILE" ]; then
    # Use Python to update settings.json
    python3 << 'PYEOF'
import json
import sys

settings_file = sys.argv[1]
plugin_name = "open-reflect"

try:
    with open(settings_file, 'r') as f:
        settings = json.load(f)
    
    # Add enabledPlugins section if not exists
    if 'enabledPlugins' not in settings:
        settings['enabledPlugins'] = {}
    
    # Enable the plugin
    settings['enabledPlugins'][plugin_name] = True
    
    # Save settings
    with open(settings_file, 'w') as f:
        json.dump(settings, f, indent=2)
    
    print("✅ Plugin enabled in settings.json")
except Exception as e:
    print(f"⚠️ Could not update settings.json: {e}")
    print("   You may need to manually add open-reflect to enabledPlugins")
PYEOF
    "$SETTINGS_FILE"
else
    echo -e "${YELLOW}⚠️ settings.json not found. Creating new one...${NC}"
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    python3 << 'PYEOF'
import json
import sys

settings_file = sys.argv[1]
plugin_name = "open-reflect"

settings = {
    "enabledPlugins": {
        plugin_name: True
    }
}

with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2)

print("✅ Created settings.json with plugin enabled")
PYEOF
    "$SETTINGS_FILE"
fi

echo -e "${GREEN}✅ Plugin enabled${NC}"

# Step 6: Clear plugin cache
echo -e "${YELLOW}🧹 Step 6/6: Clearing plugin cache...${NC}"
if [ -d "$HOME/.claude/plugins/cache" ]; then
    rm -rf "$HOME/.claude/plugins/cache"
    echo -e "${GREEN}✅ Plugin cache cleared${NC}"
else
    echo -e "${YELLOW}ℹ️ No cache to clear${NC}"
fi

# Cleanup
echo -e "${YELLOW}🧹 Cleaning up...${NC}"
rm -rf "$TEMP_DIR"
echo -e "${GREEN}✅ Cleanup complete${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ Installation Complete!                                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Installed location: $PLUGIN_DEST/$PLUGIN_SOURCE"
echo ""
echo "Plugin files:"
ls -la "$PLUGIN_DEST/$PLUGIN_SOURCE/.claude-plugin/" 2>/dev/null || true
ls -la "$PLUGIN_DEST/$PLUGIN_SOURCE/commands/" 2>/dev/null || true
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  IMPORTANT: Restart Claude Code to activate the plugin       ${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}To activate the plugin:${NC}"
echo ""
echo "  1. ${RED}Completely exit${NC} Claude Code (Cmd+Q or Ctrl+Q)"
echo ""
echo "  2. ${GREEN}Re-open Claude Code${NC}"
echo ""
echo "  3. ${GREEN}Test the plugin:${NC}"
echo "     /reflect --view"
echo ""
echo -e "${BLUE}Documentation:${NC} https://github.com/gyc567/open-reflect/blob/master/README.en.md"
echo ""
echo "Plugin commands:"
echo "  /reflect         - Process pending learnings with review"
echo "  /reflect --view  - View pending learnings"
echo "  /skip-reflect    - Discard all pending learnings"
echo "  /view-queue      - View pending learnings"
echo ""
