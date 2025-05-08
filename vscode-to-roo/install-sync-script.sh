#!/bin/bash

set -e

echo "Installing RooCode MCP sync..."

# Define paths
SCRIPT_SOURCE="$(pwd)/sync_mcp_config.py"
SCRIPT_TARGET="$HOME/bin/sync_mcp_config.py"
SYSTEMD_DIR="$HOME/.config/systemd/user"

# Ensure ~/bin exists and copy the script
mkdir -p "$HOME/bin"
cp "$SCRIPT_SOURCE" "$SCRIPT_TARGET"
chmod +x "$SCRIPT_TARGET"
echo "Copied sync script to $SCRIPT_TARGET"

# Create systemd unit
mkdir -p "$SYSTEMD_DIR"

cat > "$SYSTEMD_DIR/sync-roocode.service" <<EOF
[Unit]
Description=Sync VSCode MCP Servers into RooCode

[Service]
Type=oneshot
ExecStart=%h/bin/sync_mcp_config.py
EOF

# Create systemd timer (once an hour)
cat > "$SYSTEMD_DIR/sync-roocode.timer" <<EOF
[Unit]
Description=Run VSCode → RooCode MCP sync hourly

[Timer]
OnBootSec=2min
OnUnitActiveSec=1h
Unit=sync-roocode.service

[Install]
WantedBy=default.target
EOF

# Reload systemd and enable the timer
systemctl --user daemon-reload
systemctl --user enable --now sync-roocode.timer

echo "RooCode MCP sync is now set to run hourly."
