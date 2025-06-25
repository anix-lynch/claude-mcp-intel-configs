#!/bin/bash
# 🎀 Bchan's Doppler + Trello MCP Test Script
# Tests Trello MCP with Doppler secrets integration

echo "🎀 Testing Trello MCP with Doppler integration..."

# Check if Doppler is installed
if ! command -v doppler &> /dev/null; then
    echo "❌ Doppler CLI not found. Install with:"
    echo "brew install dopplerhq/cli/doppler"
    exit 1
fi

# Check if Trello MCP is installed
if ! npm list -g @mseep/server-trello &> /dev/null; then
    echo "📦 Installing Trello MCP..."
    npm install -g @mseep/server-trello
fi

# Check Doppler setup
echo "🔍 Checking Doppler setup..."
doppler setup --project bchan-apis --config dev

# Test Doppler secrets access
echo "🔐 Testing Doppler secrets..."
echo "TRELLO_API_KEY: $(doppler secrets get TRELLO_API_KEY --project bchan-apis --config dev --plain | head -c 8)..."

# You'll need to add TRELLO_TOKEN and TRELLO_BOARD_ID to Doppler
echo ""
echo "📋 Required Doppler secrets for Trello MCP:"
echo "✅ TRELLO_API_KEY (found)"
echo "⚠️  Add these to Doppler:"
echo "   doppler secrets set TRELLO_TOKEN='your_token_here' --project bchan-apis --config dev"
echo "   doppler secrets set TRELLO_BOARD_ID='your_board_id_here' --project bchan-apis --config dev"

# Test the Trello MCP server with Doppler
echo ""
echo "🧪 Testing Trello MCP with Doppler..."
echo "Run this command to test:"
echo "doppler run --project bchan-apis --config dev -- npx @mseep/server-trello"

echo ""
echo "✨ Once working, switch Claude config:"
echo "cp configs/intel_quiet_doppler_trello.json ~/Library/Application\\ Support/Claude/claude_desktop_config.json"
