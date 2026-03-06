#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

usage() {
  cat <<EOF
Usage: ./install.sh <skill-name> [--global|--workspace]
       ./install.sh --all [--global|--workspace]

Options:
  --global      Install to ~/.cursor/skills/ (default)
  --workspace   Install to .cursor/skills/ in the current directory
  --all         Install every skill in the catalog

Examples:
  ./install.sh code-review --global
  ./install.sh commit-agent-changes --workspace
  ./install.sh --all --global
EOF
  exit 1
}

install_skill() {
  local name="$1"
  local dest="$2"

  local src="$SKILLS_DIR/$name"
  if [ ! -d "$src" ]; then
    echo "Error: skill '$name' not found in $SKILLS_DIR" >&2
    exit 1
  fi

  local target="$dest/$name"
  mkdir -p "$dest"
  cp -r "$src" "$target"
  echo "Installed '$name' -> $target"
}

[ $# -eq 0 ] && usage

skill_name=""
scope="global"
install_all=false

for arg in "$@"; do
  case "$arg" in
    --global)    scope="global" ;;
    --workspace) scope="workspace" ;;
    --all)       install_all=true ;;
    --help|-h)   usage ;;
    -*)          echo "Unknown option: $arg" >&2; usage ;;
    *)           skill_name="$arg" ;;
  esac
done

if [ "$install_all" = false ] && [ -z "$skill_name" ]; then
  echo "Error: provide a skill name or --all" >&2
  usage
fi

if [ "$scope" = "global" ]; then
  dest="$HOME/.cursor/skills"
else
  dest="$(pwd)/.cursor/skills"
fi

if [ "$install_all" = true ]; then
  for dir in "$SKILLS_DIR"/*/; do
    name="$(basename "$dir")"
    install_skill "$name" "$dest"
  done
  echo "All skills installed to $dest"
else
  install_skill "$skill_name" "$dest"
fi
