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
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/gyc567/open-reflect.git"
PLUGIN_SOURCE="open-reflect"
PLUGIN_DEST="$HOME/.claude/plugins"
SCRIPT_SOURCE="open-reflect/scripts"
TEMP_DIR=$(mktemp -d)

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Open-Reflect Claude Code Plugin Installer               ║${NC}"
echo -e "${BLUE}║  Self-learning system with evolutionary knowledge tracking║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Check prerequisites
echo -e "${YELLOW}📋 Step 1/5: Checking prerequisites...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is not installed. Please install Git first.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi
echo -e "${GREEN}✅ Git is installed${NC}"

# Step 2: Clone repository
echo -e "${YELLOW}📦 Step 2/5: Cloning repository...${NC}"
git clone --quiet "$REPO_URL" "$TEMP_DIR/open-reflect" 2>/dev/null || {
    echo -e "${RED}❌ Failed to clone repository${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
}
echo -e "${GREEN}✅ Repository cloned${NC}"

# Step 3: Create plugin directory
echo -e "${YELLOW}📁 Step 3/5: Creating plugin directory...${NC}"
mkdir -p "$PLUGIN_DEST"
echo -e "${GREEN}✅ Directory created: $PLUGIN_DEST${NC}"

# Step 4: Copy plugin files
echo -e "${YELLOW}📋 Step 4/5: Copying plugin files...${NC}"
if [ -d "$TEMP_DIR/$PLUGIN_SOURCE" ]; then
    cp -r "$TEMP_DIR/$PLUGIN_SOURCE" "$PLUGIN_DEST/"
    echo -e "${GREEN}✅ Plugin files copied${NC}"
else
    echo -e "${RED}❌ Plugin source directory not found${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Step 5: Make scripts executable
echo -e "${YELLOW}🔧 Step 5/5: Making scripts executable...${NC}"
if [ -d "$PLUGIN_DEST/$PLUGIN_SOURCE/scripts" ]; then
    chmod +x "$PLUGIN_DEST/$PLUGIN_SOURCE/scripts"/*.sh 2>/dev/null || true
    echo -e "${GREEN}✅ Scripts made executable${NC}"
else
    echo -e "${YELLOW}⚠️ No scripts directory found, skipping${NC}"
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
echo "Installed location: $PLUGIN_DEST/open-reflect"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart Claude Code to activate the plugin"
echo "2. Test the plugin: /reflect --view"
echo ""
echo "Plugin commands:"
echo "  /reflect         - Process pending learnings with review"
echo "  /reflect --view  - View pending learnings"
echo "  /skip-reflect    - Discard all pending learnings"
echo ""
echo -e "${BLUE}Documentation:${NC} https://github.com/gyc567/open-reflect/blob/master/README.en.md"
echo ""
