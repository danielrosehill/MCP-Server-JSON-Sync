#!/bin/bash

set -e

echo "Installing Cline MCP sync..."

# Define paths
SCRIPT_SOURCE="$(pwd)/sync_mcp_config.py"
SCRIPT_TARGET="$HOME/bin/sync_cline_mcp_config.py"
SYSTEMD_DIR="$HOME/.config/systemd/user"

# Ensure ~/bin exists and copy the script
mkdir -p "$HOME/bin"
cp "$SCRIPT_SOURCE" "$SCRIPT_TARGET"
chmod +x "$SCRIPT_TARGET"
echo "Copied sync script to $SCRIPT_TARGET"

# Create systemd unit
mkdir -p "$SYSTEMD_DIR"

cat > "$SYSTEMD_DIR/sync-cline.service" <<EOF
[Unit]
Description=Sync VSCode MCP Servers into Cline

[Service]
Type=oneshot
ExecStart=%h/bin/sync_cline_mcp_config.py
EOF

# Create systemd timer (once an hour)
cat > "$SYSTEMD_DIR/sync-cline.timer" <<EOF
[Unit]
Description=Run VSCode → Cline MCP sync hourly

[Timer]
OnBootSec=2min
OnUnitActiveSec=1h
Unit=sync-cline.service

[Install]
WantedBy=default.target
EOF

# Reload systemd and enable the timer
systemctl --user daemon-reload
systemctl --user enable --now sync-cline.timer

echo "Cline MCP sync is now set to run hourly."