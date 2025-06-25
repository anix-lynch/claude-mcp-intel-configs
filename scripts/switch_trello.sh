#!/bin/bash
# 🎀 Bchan's Intel MCP Switch Script with Trello Support
# Optimized for Intel MacBook Pro - keeps fans quiet!

# Colors for pretty output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

CLAUDE_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
BACKUP_DIR="$HOME/.claude-server-commander/backups"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../configs"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Function to backup current config
backup_config() {
    if [ -f "$CLAUDE_CONFIG" ]; then
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        cp "$CLAUDE_CONFIG" "$BACKUP_DIR/claude_config_backup_$TIMESTAMP.json"
        echo -e "${GREEN}✅ Backed up current config${NC}"
    fi
}

# Function to switch config
switch_config() {
    local config_name=$1
    local config_file="$CONFIG_DIR/$config_name.json"
    
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ Config file not found: $config_file${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}🔄 Switching to $config_name...${NC}"
    
    # Backup current config
    backup_config
    
    # Copy new config
    cp "$config_file" "$CLAUDE_CONFIG"
    
    echo -e "${GREEN}✅ Switched to $config_name${NC}"
    echo -e "${YELLOW}🔄 Please restart Claude Desktop for changes to take effect${NC}"
}

# Function to show current config
show_current() {
    if [ -f "$CLAUDE_CONFIG" ]; then
        echo -e "${BLUE}📋 Current MCP Servers:${NC}"
        # Extract server names from config
        python3 -c "
import json
try:
    with open('$CLAUDE_CONFIG', 'r') as f:
        config = json.load(f)
    servers = config.get('mcpServers', {}).keys()
    for server in servers:
        print(f'  • {server}')
except:
    print('  Could not parse config')
"
    else
        echo -e "${YELLOW}⚠️  No Claude config found${NC}"
    fi
}

# Function to check for Trello credentials
check_trello_creds() {
    echo -e "${BLUE}🔍 Checking Trello MCP setup...${NC}"
    
    if [ -f "$CLAUDE_CONFIG" ]; then
        if grep -q "your_trello_api_key_here" "$CLAUDE_CONFIG"; then
            echo -e "${YELLOW}⚠️  Trello API credentials not configured${NC}"
            echo -e "${BLUE}📋 Get your credentials:${NC}"
            echo "   1. API Key: https://trello.com/app-key"
            echo "   2. Token: Click 'Token' link on API key page"
            echo "   3. Board ID: Extract from board URL (/b/BOARD_ID/...)"
        else
            echo -e "${GREEN}✅ Trello credentials configured${NC}"
        fi
    fi
}

# Main menu
case "$1" in
    "quiet-trello")
        switch_config "intel_quiet_with_trello"
        check_trello_creds
        ;;
    "balanced-trello")
        switch_config "intel_balanced_with_trello"
        check_trello_creds
        ;;
    "current")
        show_current
        ;;
    "check-trello")
        check_trello_creds
        ;;
    *)
        echo -e "${BLUE}🎀 Bchan's Intel MCP Switcher with Trello${NC}"
        echo ""
        echo "Usage: $0 [option]"
        echo ""
        echo "Options:"
        echo "  quiet-trello     🔇️ Quiet mode + Trello (filesystem, github, memory, trello)"
        echo "  balanced-trello  ⚡ Balanced mode + Trello (+ brave-search)"
        echo "  current          📋 Show current config"
        echo "  check-trello     🔍 Check Trello credentials"
        echo ""
        echo "Original configs (without Trello):"
        echo "  Use existing switch scripts for non-Trello configs"
        echo ""
        echo -e "${YELLOW}💡 Install Trello MCP first: npm install -g @mseep/server-trello${NC}"
        ;;
esac
