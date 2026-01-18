#!/bin/bash

#===============================================================================
# Open-Reflect OpenCode Skill Installer
#
# Usage:
#   ./install.sh [--uninstall] [--force]
#
# Options:
#   --uninstall   Remove the skill instead of installing
#   --force       Overwrite existing installation without prompting
#
#===============================================================================

set -euo pipefail

# Configuration
SKILL_NAME="open-reflect"
SKILL_SOURCE_DIR=".opencode/skill/${SKILL_NAME}"
SKILL_TARGET_DIR="${HOME}/.config/opencode/skill/${SKILL_NAME}"
CONFIG_FILE="${HOME}/.config/opencode/opencode.json"
OPENCODE_SKILL_DIR="${HOME}/.config/opencode/skill"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check if running from correct directory
    if [[ ! -d "${SKILL_SOURCE_DIR}" ]]; then
        log_error "Skill source directory not found: ${SKILL_SOURCE_DIR}"
        log_error "Please run this script from the open-reflect repository root"
        exit 1
    fi

    # Check for required files
    if [[ ! -f "${SKILL_SOURCE_DIR}/SKILL.md" ]]; then
        log_error "Required file missing: ${SKILL_SOURCE_DIR}/SKILL.md"
        exit 1
    fi

    log_success "Prerequisites check passed"
}

detect_opencode_config() {
    log_info "Detecting OpenCode configuration..."

    # Check if opencode config directory exists
    if [[ -d "${OPENCODE_SKILL_DIR}" ]]; then
        log_success "OpenCode skill directory found: ${OPENCODE_SKILL_DIR}"
        return 0
    else
        log_warning "OpenCode skill directory not found: ${OPENCODE_SKILL_DIR}"
        log_info "Will attempt to create it"
        return 1
    fi
}

create_opencode_config() {
    log_info "Creating OpenCode skill directory..."

    mkdir -p "${OPENCODE_SKILL_DIR}"

    if [[ $? -eq 0 ]]; then
        log_success "Created: ${OPENCODE_SKILL_DIR}"
    else
        log_error "Failed to create directory: ${OPENCODE_SKILL_DIR}"
        exit 1
    fi
}

backup_existing() {
    if [[ -d "${SKILL_TARGET_DIR}" ]]; then
        log_warning "Backing up existing installation..."
        local backup_dir="${SKILL_TARGET_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "${SKILL_TARGET_DIR}" "${backup_dir}"
        log_success "Backed up to: ${backup_dir}"
    fi
}

#-------------------------------------------------------------------------------
# Installation Functions
#-------------------------------------------------------------------------------

install_skill() {
    log_info "Installing Open-Reflect skill for OpenCode..."

    # Create target directory
    mkdir -p "$(dirname "${SKILL_TARGET_DIR}")"

    # Copy skill files
    cp -r "${SKILL_SOURCE_DIR}" "${SKILL_TARGET_DIR}"

    if [[ $? -eq 0 ]]; then
        log_success "Skill installed to: ${SKILL_TARGET_DIR}"

        # List installed files
        log_info "Installed files:"
        find "${SKILL_TARGET_DIR}" -type f -name "*.md" -o -name "*.json" | while read -r file; do
            echo "  - ${file#$SKILL_TARGET_DIR/}"
        done
    else
        log_error "Failed to install skill"
        exit 1
    fi
}

update_opencode_config() {
    log_info "Checking OpenCode configuration..."

    if [[ -f "${CONFIG_FILE}" ]]; then
        log_success "Config file found: ${CONFIG_FILE}"

        # Check if skill is already in config
        if grep -q "\"${SKILL_NAME}\"" "${CONFIG_FILE}" 2>/dev/null; then
            log_info "Skill already referenced in config"
        else
            log_warning "Skill not found in config - manual permission configuration may be needed"
            log_info "Add to opencode.json:"
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
        local rule_count=$(find "${SKILL_TARGET_DIR}/rules" -name "*.md" | wc -l | tr -d ' ')
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

print_usage_instructions() {
    echo ""
    echo "==============================================================================="
    echo "  Open-Reflect Skill Installed Successfully!"
    echo "==============================================================================="
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
    echo "==============================================================================="
}

#-------------------------------------------------------------------------------
# Uninstallation Functions
#-------------------------------------------------------------------------------

uninstall_skill() {
    log_info "Uninstalling Open-Reflect skill..."

    if [[ -d "${SKILL_TARGET_DIR}" ]]; then
        log_info "Removing: ${SKILL_TARGET_DIR}"
        rm -rf "${SKILL_TARGET_DIR}"

        if [[ $? -eq 0 ]]; then
            log_success "Skill uninstalled successfully"
        else
            log_error "Failed to uninstall skill"
            exit 1
        fi
    else
        log_warning "Skill not installed at: ${SKILL_TARGET_DIR}"
        log_info "Nothing to uninstall"
    fi

    echo ""
    echo "==============================================================================="
    echo "  Open-Reflect Skill Uninstalled"
    echo "==============================================================================="
    echo ""
    echo "Note: This only removes the OpenCode skill."
    echo "For complete removal, also remove:"
    echo "  - Claude Code plugin: ~/.claude/plugins/open-reflect/"
    echo "  - Learning data: ~/.claude/openreflect-queue.json"
    echo "  - REFLECT.md files in your projects"
    echo ""
    echo "==============================================================================="
}

#-------------------------------------------------------------------------------
# Main Script
#-------------------------------------------------------------------------------

main() {
    local do_uninstall=false
    local do_force=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --uninstall)
                do_uninstall=true
                shift
                ;;
            --force)
                do_force=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                echo "Usage: $0 [--uninstall] [--force]"
                exit 1
                ;;
        esac
    done

    echo ""
    echo "==============================================================================="
    echo "  Open-Reflect OpenCode Skill Installer v1.1.0"
    echo "==============================================================================="
    echo ""

    if [[ "${do_uninstall}" == true ]]; then
        # Uninstall mode
        check_prerequisites
        uninstall_skill
    else
        # Install mode
        check_prerequisites

        if [[ "${do_force}" == false ]]; then
            backup_existing
        fi

        detect_opencode_config || create_opencode_config
        install_skill
        update_opencode_config
        verify_installation
        print_usage_instructions
    fi
}

# Run main function
main "$@"
