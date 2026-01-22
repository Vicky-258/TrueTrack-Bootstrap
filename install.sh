#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# TrueTrack Bootstrap Installer (Unix)
# ==============================================================================

REPO_URL="https://github.com/Vicky-258/TrueTrack.git"
INSTALL_DIR="$HOME/.truetrack"

echo "TrueTrack Bootstrap Installer"
echo "-----------------------------"

# --------------------------------------------------------------------------
# OS Check
# --------------------------------------------------------------------------
case "$(uname -s)" in
  Linux|Darwin) ;;
  *)
    echo "Unsupported OS. TrueTrack supports Linux and macOS only."
    exit 1
    ;;
esac

# --------------------------------------------------------------------------
# Tool Checks
# --------------------------------------------------------------------------
if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required but not installed."
  echo "Please install git and re-run this command."
  exit 1
fi

# --------------------------------------------------------------------------
# Target Directory Check
# --------------------------------------------------------------------------
if [[ -d "$INSTALL_DIR" ]]; then
  echo "Error: $INSTALL_DIR already exists."
  echo "If this is a previous install, remove it first:"
  echo "  rm -rf $INSTALL_DIR"
  exit 1
fi

# --------------------------------------------------------------------------
# Clone Repository
# --------------------------------------------------------------------------
echo "Cloning TrueTrack into $INSTALL_DIR..."
git clone "$REPO_URL" "$INSTALL_DIR"

# --------------------------------------------------------------------------
# Delegate to Real Installer
# --------------------------------------------------------------------------
echo "Starting TrueTrack installer..."
exec "$INSTALL_DIR/install/install_unix.sh"
