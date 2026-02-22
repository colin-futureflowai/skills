#!/bin/bash
# Install all skills to Claude Code settings directory

SKILLS_DIR="$(cd "$(dirname "$0")/../skills" && pwd)"
TARGET_DIR="$HOME/.claude/skills"

mkdir -p "$TARGET_DIR"

for skill in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill")
  echo "Installing $skill_name..."
  cp -r "$skill" "$TARGET_DIR/$skill_name"
done

echo "Done. Installed skills to $TARGET_DIR"
