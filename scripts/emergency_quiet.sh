#!/bin/bash

# 🎀 Emergency Fan Quieter for Intel MacBook Pro

echo "🚨 EMERGENCY FAN FIX - Switching to Intel quiet config..."

# Backup current config
CLAUDE_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
if [ -f "$CLAUDE_CONFIG" ]; then
    cp "$CLAUDE_CONFIG" "$CLAUDE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
    echo "💾 Backed up existing config"
fi

# Kill any running MCP processes that might be causing heat
echo "🔪 Killing hot processes..."
pkill -f "playwright" 2>/dev/null
pkill -f "chromium" 2>/dev/null
pkill -f "stability" 2>/dev/null
pkill -f "npx.*server" 2>/dev/null

# Download and install quiet config
echo "📥 Installing emergency quiet config..."
curl -s https://raw.githubusercontent.com/anix-lynch/claude-mcp-intel-configs/main/configs/intel_quiet_config.json > "$CLAUDE_CONFIG"

# Restart Claude Desktop
echo "🔄 Restarting Claude Desktop..."
killall "Claude Desktop" 2>/dev/null
sleep 3
open -a "Claude Desktop"

echo ""
echo "✅ EMERGENCY MODE ACTIVATED"
echo "🌡️ Your fans should calm down in 1-2 minutes"
echo ""
echo "📊 What's running now:"
echo "- ✅ filesystem (file operations)"
echo "- ✅ github (repo management)"  
echo "- ✅ memory (context retention)"
echo "- ❌ No browser automation (no heat!)"
echo ""
echo "🎯 To restore normal operation later:"
echo "   ./scripts/switch_to_balanced.sh"
echo ""
echo "🔗 Repo: https://github.com/anix-lynch/claude-mcp-intel-configs"
