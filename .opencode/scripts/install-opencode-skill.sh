#!/bin/bash

#===============================================================================
# Open-Reflect OpenCode Skill Installer
#
# Usage (from anywhere - RECOMMENDED):
#   curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/.opencode/scripts/install-opencode-skill.sh | bash
#
# Or from the repository:
#   git clone https://github.com/gyc567/open-reflect.git
#   cd open-reflect
#   .opencode/scripts/install-opencode-skill.sh --force
#
# Options:
#   --uninstall   Remove the skill instead of installing
#   --force       Overwrite existing installation without prompting
#
#===============================================================================

set -euo pipefail

# Configuration
REPO_URL="https://github.com/gyc567/open-reflect.git"
SKILL_NAME="open-reflect"
SKILL_TARGET_DIR="${HOME}/.config/opencode/skill/${SKILL_NAME}"
CONFIG_FILE="${HOME}/.config/opencode/opencode.json"
OPENCODE_SKILL_DIR="${HOME}/.config/opencode/skill"
TEMP_DIR=$(mktemp -d)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Open-Reflect OpenCode Skill Installer                    ║${NC}"
echo -e "${BLUE}║  Self-learning system with knowledge evolution tracking   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Parse arguments
DO_UNINSTALL=false
DO_FORCE=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --uninstall) DO_UNINSTALL=true; shift ;;
        --force) DO_FORCE=true; shift ;;
        *) shift ;;
    esac
done

#-------------------------------------------------------------------------------
# Utility Functions
#-------------------------------------------------------------------------------

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

cleanup() {
    if [[ -d "${TEMP_DIR}" ]]; then
        rm -rf "${TEMP_DIR}"
    fi
}
trap cleanup EXIT

#-------------------------------------------------------------------------------
# Uninstall Mode
#-------------------------------------------------------------------------------

uninstall_skill() {
    log_info "Uninstalling Open-Reflect skill..."

    if [[ -d "${SKILL_TARGET_DIR}" ]]; then
        rm -rf "${SKILL_TARGET_DIR}"
        log_success "Skill removed from: ${SKILL_TARGET_DIR}"
    else
        log_warning "Skill not found at: ${SKILL_TARGET_DIR}"
    fi

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  Open-Reflect Skill Uninstalled                          ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Note: This only removes the OpenCode skill."
    echo "For complete removal, also remove:"
    echo "  - Claude Code plugin: ~/.claude/plugins/open-reflect/"
    echo "  - Learning data: ~/.claude/openreflect-queue.json"
    echo ""
}

#-------------------------------------------------------------------------------
# Install Mode
#-------------------------------------------------------------------------------

check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check for git (needed to clone repo if not running from repo)
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed. Please install Git first."
        exit 1
    fi
    log_success "Git is installed"

    log_success "Prerequisites check passed"
}

clone_or_use_repo() {
    log_info "Preparing skill files..."

    # Try to find the repo root
    # First, check if SKILL.md exists in the current directory's .opencode/skill/open-reflect
    CURRENT_DIR="$(pwd)"
    
    if [[ -f "${CURRENT_DIR}/.opencode/skill/open-reflect/SKILL.md" ]]; then
        log_info "Using local files from: ${CURRENT_DIR}"
        cp -r "${CURRENT_DIR}/.opencode/skill/open-reflect" "${TEMP_DIR}/"
        log_success "Skill files prepared from local repository"
    elif [[ -f "$(dirname "${BASH_SOURCE[0]}")/../skill/open-reflect/SKILL.md" ]]; then
        # Script is in .opencode/scripts/
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        REPO_ROOT="$(dirname "$SCRIPT_DIR")"
        log_info "Using local files from: ${REPO_ROOT}"
        cp -r "${REPO_ROOT}/skill/open-reflect" "${TEMP_DIR}/"
        log_success "Skill files prepared from local repository"
    else
        # Clone repository
        log_info "Cloning repository..."
        git clone --quiet "${REPO_URL}" "${TEMP_DIR}/open-reflect" 2>/dev/null || {
            log_error "Failed to clone repository"
            exit 1
        }
        log_success "Repository cloned"

        # Verify files exist
        if [[ ! -f "${TEMP_DIR}/open-reflect/.opencode/skill/open-reflect/SKILL.md" ]]; then
            log_error "Skill files not found in repository"
            exit 1
        fi
    fi
}

create_opencode_dir() {
    log_info "Creating OpenCode skill directory..."

    mkdir -p "${OPENCODE_SKILL_DIR}"

    if [[ $? -eq 0 ]]; then
        log_success "Created: ${OPENCODE_SKILL_DIR}"
    else
        log_error "Failed to create directory"
        exit 1
    fi
}

backup_existing() {
    if [[ -d "${SKILL_TARGET_DIR}" ]]; then
        if [[ "${DO_FORCE}" == true ]]; then
            log_warning "Backing up existing installation..."
            local backup_dir="${SKILL_TARGET_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "${SKILL_TARGET_DIR}" "${backup_dir}"
            log_success "Backed up to: ${backup_dir}"
        else
            log_warning "Skill already installed at: ${SKILL_TARGET_DIR}"
            log_info "Use --force to overwrite"
            exit 0
        fi
    fi
}

install_skill() {
    log_info "Installing Open-Reflect skill..."

    mkdir -p "$(dirname "${SKILL_TARGET_DIR}")"

    # Determine source path based on whether we cloned or used local files
    if [[ -d "${TEMP_DIR}/open-reflect/.opencode/skill/open-reflect" ]]; then
        # Cloned from remote
        SOURCE_DIR="${TEMP_DIR}/open-reflect/.opencode/skill/open-reflect"
    else
        # Used local files
        SOURCE_DIR="${TEMP_DIR}/open-reflect"
    fi

    # Copy skill files
    cp -r "${SOURCE_DIR}" "${SKILL_TARGET_DIR}"

    if [[ $? -eq 0 ]]; then
        log_success "Skill installed to: ${SKILL_TARGET_DIR}"

        # List installed files
        log_info "Installed files:"
        find "${SKILL_TARGET_DIR}" -type f \( -name "*.md" -o -name "*.json" \) | while read -r file; do
            echo "  - ${file#$SKILL_TARGET_DIR/}"
        done
    else
        log_error "Failed to install skill"
        exit 1
    fi
}

update_config() {
    log_info "Checking OpenCode configuration..."

    if [[ -f "${CONFIG_FILE}" ]]; then
        log_success "Config file found: ${CONFIG_FILE}"

        # Check if skill is already in config
        if grep -q "\"${SKILL_NAME}\"" "${CONFIG_FILE}" 2>/dev/null; then
            log_info "Skill already referenced in config"
        else
            log_warning "Skill not found in config - manual permission configuration may be needed"
            echo ""
            echo -e "${YELLOW}To enable the skill, add to ${CONFIG_FILE}:${NC}"
            cat <<EOF

{
  "permission": {
    "skill": {
      "${SKILL_NAME}": "allow"
    }
  }
}
EOF
        fi
    else
        log_info "No existing config file - skill will be auto-discovered"
    fi
}

verify_installation() {
    log_info "Verifying installation..."

    local required_files=(
        "SKILL.md"
        "AGENTS.md"
    )

    local missing_files=()

    for file in "${required_files[@]}"; do
        if [[ -f "${SKILL_TARGET_DIR}/${file}" ]]; then
            log_success "  ✓ ${file}"
        else
            log_warning "  ✗ ${file} (missing)"
            missing_files+=("${file}")
        fi
    done

    # Check rules directory
    if [[ -d "${SKILL_TARGET_DIR}/rules" ]]; then
        local rule_count=$(find "${SKILL_TARGET_DIR}/rules" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        log_success "  ✓ rules/ (${rule_count} rules)"
    else
        log_warning "  ✗ rules/ directory (missing)"
    fi

    if [[ ${#missing_files[@]} -gt 0 ]]; then
        log_error "Installation verification failed - missing files"
        exit 1
    fi

    log_success "Installation verified successfully"
}

#-------------------------------------------------------------------------------
# Main Execution
#-------------------------------------------------------------------------------

main() {
    if [[ "${DO_UNINSTALL}" == true ]]; then
        uninstall_skill
        exit 0
    fi

    # Install mode
    check_prerequisites
    clone_or_use_repo
    create_opencode_dir
    backup_existing
    install_skill
    update_config
    verify_installation

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  Open-Reflect Skill Installed Successfully!               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Usage in OpenCode:"
    echo ""
    echo "  1. Load the skill:"
    echo "     skill({ name: \"open-reflect\" })"
    echo ""
    echo "  2. Available commands:"
    echo "     - /reflect          Process pending learnings"
    echo "     - /reflect --view   View queue details"
    echo "     - /reflect --analyze  Analyze evolution trends"
    echo "     - /skip-reflect     Discard queue"
    echo ""
    echo "  3. Trigger capture:"
    echo "     - \"remember: <learning>\""
    echo "     - \"no, use X not Y\""
    echo "     - \"Perfect! That's exactly what I wanted\""
    echo "     - \"I prefer <preference>\""
    echo ""
    echo "For more information, see:"
    echo "  - SKILL.md      : Full skill documentation"
    echo "  - AGENTS.md     : Agent rules and patterns"
    echo "  - rules/*.md    : Detailed rule documentation"
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  IMPORTANT: Restart OpenCode to load the new skill          ${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

main
