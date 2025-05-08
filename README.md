# MCP Server JSON Sync

This repository contains scripts to synchronize Model Context Protocol (MCP) server configurations from VS Code to various AI assistants. It allows you to maintain a single source of truth for your MCP server configurations in VS Code and automatically sync them to multiple AI assistants.

## Overview

The scripts extract the `mcp.servers` section from your VS Code `settings.json` file and write it to the corresponding configuration files for different AI assistants. Each sync is set up as a systemd timer that runs once per hour, ensuring your configurations stay in sync.

Currently supported targets:

- **Cline** - Claude AI assistant in VS Code
- **RooCode** - Anthropic's Roo AI assistant
- **Windsurf** - Anthropic's Windsurf IDE

## Repository Structure

```
MCP-Server-JSON-Sync/
├── vscode-to-cline/
│   ├── sync_mcp_config.py
│   └── install-sync-script.sh
├── vscode-to-roo/
│   ├── sync_mcp_config.py
│   └── install-sync-script.sh
└── vscode-to-windsurf/
    ├── sync_mcp_config.py
    └── install-sync-script.sh
```

## Installation and Usage

### VS Code to Cline Sync

1. Navigate to the `vscode-to-cline` directory:
   ```bash
   cd vscode-to-cline
   ```

2. Run the installer:
   ```bash
   ./install-sync-script.sh
   ```

### VS Code to RooCode Sync

1. Navigate to the `vscode-to-roo` directory:
   ```bash
   cd vscode-to-roo
   ```

2. Run the installer:
   ```bash
   ./install-sync-script.sh
   ```

### VS Code to Windsurf Sync

1. Navigate to the `vscode-to-windsurf` directory:
   ```bash
   cd vscode-to-windsurf
   ```

2. Run the installer:
   ```bash
   ./install-sync-script.sh
   ```

Each installer:
- Copies the sync script to your `~/bin` directory
- Creates systemd service and timer units in your user directory
- Sets up the timer to run the sync script once per hour
- Enables and starts the timer

## Manual Sync

In addition to the automated hourly sync, you can use the interactive manual sync script to immediately sync your MCP configurations to one or multiple target IDEs:

```bash
./manual-sync.sh
```

This will present a menu where you can select which target IDE(s) to sync to:
- Cline
- RooCode
- Windsurf
- All of the above

The script will execute the selected sync operations and provide feedback on the results.

## How It Works

Each `sync_mcp_config.py` script:
1. Reads the MCP server configurations from VS Code's `settings.json`
2. Reads the existing configuration file for the target application (if it exists)
3. Updates the MCP server section in the target configuration
4. Writes the updated configuration back to the target file

This ensures that any MCP servers you configure in VS Code are automatically available in your other AI assistants.