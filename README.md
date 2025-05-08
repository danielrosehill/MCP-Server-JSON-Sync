# VS Code -> RooCode MCP Config Sync

This script syncs the `mcp.servers` section from your VS Code `settings.json` to RooCode's `mcpServers` config.

## Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/yourname/roocode-sync.git
   cd roocode-sync
````

2. Run the installer:

   ```bash
   bash install_roocode_sync.sh
   ```

This sets up a user-level systemd timer that runs the sync script once per hour.

## Files

* `sync_mcp_config.py` — extracts the relevant MCP config from VS Code and writes it to RooCode.
* `install_roocode_sync.sh` — installs the script and sets up the systemd timer.

 