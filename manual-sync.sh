#!/bin/bash

# manual-sync.sh - Interactive script to manually sync MCP configurations from VS Code
# to one or multiple target IDEs (Cline, RooCode, Windsurf)

# Set text formatting
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print header
print_header() {
    clear
    echo -e "${BOLD}MCP Server Configuration Sync Tool${RESET}"
    echo "This script will sync MCP server configurations from VS Code to your selected IDE(s)."
    echo "----------------------------------------------------------------------"
    echo
}

# Function to sync to a specific target
sync_to_target() {
    local target=$1
    local script_path=""
    local target_name=""
    
    case $target in
        "cline")
            script_path="${SCRIPT_DIR}/vscode-to-cline/sync_mcp_config.py"
            target_name="Cline"
            ;;
        "roo")
            script_path="${SCRIPT_DIR}/vscode-to-roo/sync_mcp_config.py"
            target_name="RooCode"
            ;;
        "windsurf")
            script_path="${SCRIPT_DIR}/vscode-to-windsurf/sync_mcp_config.py"
            target_name="Windsurf"
            ;;
    esac
    
    if [ -f "$script_path" ]; then
        echo -e "Syncing to ${BOLD}$target_name${RESET}..."
        if python3 "$script_path"; then
            echo -e "${GREEN}✓ Successfully synced to $target_name${RESET}"
            return 0
        else
            echo -e "${RED}✗ Failed to sync to $target_name${RESET}"
            return 1
        fi
    else
        echo -e "${RED}✗ Sync script for $target_name not found at: $script_path${RESET}"
        return 1
    fi
}

# Main function
main() {
    print_header
    
    # Array to store selected targets
    declare -a selected_targets
    
    # Display menu
    echo -e "${BOLD}Select target IDE(s) to sync to:${RESET}"
    echo "1) Cline (Claude AI assistant in VS Code)"
    echo "2) RooCode (Anthropic's Roo AI assistant)"
    echo "3) Windsurf (Anthropic's Windsurf IDE)"
    echo "4) All of the above"
    echo "0) Exit"
    echo
    
    # Get user selection
    read -p "Enter your choice(s) separated by space (e.g., 1 3): " choices
    
    # Process choices
    for choice in $choices; do
        case $choice in
            1)
                selected_targets+=("cline")
                ;;
            2)
                selected_targets+=("roo")
                ;;
            3)
                selected_targets+=("windsurf")
                ;;
            4)
                selected_targets=("cline" "roo" "windsurf")
                break
                ;;
            0)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo -e "${YELLOW}Warning: Invalid choice '$choice' ignored${RESET}"
                ;;
        esac
    done
    
    # Check if any targets were selected
    if [ ${#selected_targets[@]} -eq 0 ]; then
        echo -e "${RED}No valid targets selected. Exiting.${RESET}"
        exit 1
    fi
    
    echo
    echo -e "${BOLD}Starting sync process...${RESET}"
    echo
    
    # Counter for successful syncs
    success_count=0
    
    # Sync to each selected target
    for target in "${selected_targets[@]}"; do
        if sync_to_target "$target"; then
            ((success_count++))
        fi
        echo
    done
    
    # Summary
    echo -e "${BOLD}Sync Summary:${RESET}"
    echo -e "Successfully synced to ${GREEN}$success_count${RESET} out of ${#selected_targets[@]} targets."
    
    if [ $success_count -eq ${#selected_targets[@]} ]; then
        echo -e "${GREEN}All syncs completed successfully!${RESET}"
    elif [ $success_count -gt 0 ]; then
        echo -e "${YELLOW}Some syncs failed. Check the output above for details.${RESET}"
    else
        echo -e "${RED}All syncs failed. Check the output above for details.${RESET}"
    fi
}

# Run the main function
main