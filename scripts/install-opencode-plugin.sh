#!/bin/bash
#
# Open-Reflect OpenCode Plugin Installation Script
# Installs the OpenCode plugin with one command
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
PLUGIN_SOURCE=".opencode/plugin"
PLUGIN_DEST="$HOME/.config/opencode/plugin"
TEMP_DIR=$(mktemp -d)

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Open-Reflect OpenCode Plugin Installer                   ║${NC}"
echo -e "${BLUE}║  Self-learning system with evolutionary knowledge tracking║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Clone repository
echo -e "${YELLOW}📦 Step 1/4: Cloning repository...${NC}"
git clone --quiet "$REPO_URL" "$TEMP_DIR/open-reflect" 2>/dev/null || {
    echo -e "${RED}❌ Failed to clone repository${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
}
echo -e "${GREEN}✅ Repository cloned${NC}"

# Step 2: Create plugin directory
echo -e "${YELLOW}📁 Step 2/4: Creating plugin directory...${NC}"
mkdir -p "$PLUGIN_DEST"
echo -e "${GREEN}✅ Directory created: $PLUGIN_DEST${NC}"

# Step 3: Copy plugin files
echo -e "${YELLOW}📋 Step 3/4: Copying plugin files...${NC}"
if [ -d "$TEMP_DIR/open-reflect/$PLUGIN_SOURCE" ]; then
    cp -r "$TEMP_DIR/open-reflect/$PLUGIN_SOURCE"/* "$PLUGIN_DEST/"
    echo -e "${GREEN}✅ Plugin files copied${NC}"
else
    echo -e "${RED}❌ Plugin source directory not found${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Step 4: Cleanup and verify
echo -e "${YELLOW}🧹 Step 4/4: Cleaning up...${NC}"
rm -rf "$TEMP_DIR"
echo -e "${GREEN}✅ Cleanup complete${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✅ Installation Complete!                                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Installed files:"
ls -la "$PLUGIN_DEST"/
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart OpenCode to load the plugin"
echo "2. Verify installation: opencode && /repo --view"
echo ""
echo -e "${BLUE}Documentation:${NC} https://github.com/gyc567/open-reflect/blob/master/docs/OPENCODE_PLUGIN.md"
echo ""
