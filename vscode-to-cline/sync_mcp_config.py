#!/usr/bin/env python3

import json
from pathlib import Path

# Paths
vscode_path = Path.home() / ".config/Code/User/settings.json"
cline_path = Path.home() / ".config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json"

# Load VS Code settings.json
try:
    with open(vscode_path) as f:
        vscode_settings = json.load(f)
except FileNotFoundError:
    print(f"Error: VS Code settings file not found at {vscode_path}")
    exit(1)
except json.JSONDecodeError:
    print(f"Error: Could not decode JSON from {vscode_path}")
    exit(1)


# Get the "mcp.servers" block
mcp_servers = vscode_settings.get("mcp", {}).get("servers", {})

# Prepare Cline config structure
# Read existing Cline settings to merge, if the file exists
cline_settings = {}
if cline_path.exists():
    try:
        with open(cline_path, 'r') as f:
            cline_settings = json.load(f)
    except json.JSONDecodeError:
        print(f"Warning: Could not decode JSON from existing {cline_path}. Overwriting.")
        cline_settings = {} # Start fresh if existing file is corrupt

# Update the mcpServers block in Cline settings
cline_settings["mcpServers"] = mcp_servers

# Ensure directory exists
cline_path.parent.mkdir(parents=True, exist_ok=True)

# Write updated file
try:
    with open(cline_path, "w") as f:
        json.dump(cline_settings, f, indent=2)
    print("Synced MCP servers from VS Code to Cline.")
except IOError as e:
    print(f"Error writing to {cline_path}: {e}")