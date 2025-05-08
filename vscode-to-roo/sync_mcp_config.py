#!/usr/bin/env python3

import json
from pathlib import Path

# Paths
vscode_path = Path.home() / ".config/Code/User/settings.json"
roocode_path = Path.home() / ".config/Code/User/globalStorage/rooveterinaryinc.roo-cline/settings/mcp_settings.json"

# Load VS Code settings.json
with open(vscode_path) as f:
    vscode_settings = json.load(f)

# Get the "mcp.servers" block
mcp_servers = vscode_settings.get("mcp", {}).get("servers", {})

# Prepare RooCode config structure
roocode_settings = {
    "mcpServers": mcp_servers
}

# Ensure directory exists
roocode_path.parent.mkdir(parents=True, exist_ok=True)

# Write updated file
with open(roocode_path, "w") as f:
    json.dump(roocode_settings, f, indent=2)

print("Synced MCP servers to RooCode.")
