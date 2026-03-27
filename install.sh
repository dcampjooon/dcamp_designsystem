#!/bin/bash
# dcamp Design System - Claude Code Skill Installer

set -e

REPO="dcamp2/dcamp_designsystem"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
SKILL_DIR="$HOME/.claude/skills/ui-standards"

echo "=== dcamp Design System Installer ==="
echo ""

# Create directories
mkdir -p "${SKILL_DIR}/references"

# Download files
echo "Downloading SKILL.md..."
curl -fsSL "${BASE_URL}/skills/ui-standards/SKILL.md" -o "${SKILL_DIR}/SKILL.md"

echo "Downloading design-system.md..."
curl -fsSL "${BASE_URL}/skills/ui-standards/references/design-system.md" -o "${SKILL_DIR}/references/design-system.md"

echo "Downloading component-patterns.md..."
curl -fsSL "${BASE_URL}/skills/ui-standards/references/component-patterns.md" -o "${SKILL_DIR}/references/component-patterns.md"

echo "Downloading chart-standards.md..."
curl -fsSL "${BASE_URL}/skills/ui-standards/references/chart-standards.md" -o "${SKILL_DIR}/references/chart-standards.md"

echo ""
echo "Installed to: ${SKILL_DIR}"
echo ""
echo "Files:"
ls -la "${SKILL_DIR}/SKILL.md"
ls -la "${SKILL_DIR}/references/"
echo ""
echo "Done! Restart Claude Code to activate the ui-standards skill."
