import json
from pathlib import Path

# Define paths
vscode_settings_path = Path.home() / ".config" / "Code" / "User" / "settings.json"
windsurf_config_path = Path.home() / ".codeium" / "windsurf" / "mcp_config.json"

# Load VS Code MCP servers
try:
    with open(vscode_settings_path, "r") as f:
        vscode_settings = json.load(f)
        vscode_mcp_servers = vscode_settings.get("mcp", {}).get("servers", {})
        print(f"🟢 Found {len(vscode_mcp_servers)} MCP servers in VS Code.")
except (FileNotFoundError, json.JSONDecodeError) as e:
    print(f"🔴 Failed to read VS Code settings: {e}")
    vscode_mcp_servers = {}

# Load Windsurf config
if windsurf_config_path.exists():
    try:
        with open(windsurf_config_path, "r") as f:
            windsurf_data = json.load(f)
            windsurf_mcp_servers = windsurf_data.get("mcpServers", {})
    except json.JSONDecodeError as e:
        print(f"🔴 Error reading Windsurf config: {e}")
        windsurf_data = {}
        windsurf_mcp_servers = {}
else:
    windsurf_data = {}
    windsurf_mcp_servers = {}

# Prepare Windsurf config
windsurf_data.setdefault("mcpServers", {})

# Merge
added = []
for name, config in vscode_mcp_servers.items():
    if name not in windsurf_data["mcpServers"]:
        windsurf_data["mcpServers"][name] = config
        added.append(name)

# Save
windsurf_config_path.parent.mkdir(parents=True, exist_ok=True)
with open(windsurf_config_path, "w") as f:
    json.dump(windsurf_data, f, indent=2)

print("✅ Synced MCP servers from VS Code to Windsurf:")
for name in added:
    print(f"  - {name}")
