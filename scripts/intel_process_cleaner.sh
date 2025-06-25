#!/bin/bash

# 🧹 Intel MacBook Pro MCP Process Cleaner
# Cleans up accumulated processes that cause fan noise

echo "🧹 Intel MacBook Pro MCP Process Cleaner"
echo "========================================"

# Function to show what we're about to kill
show_processes() {
    echo "🔍 Current MCP-related processes:"
    echo ""
    
    echo "📊 Node.js processes:"
    ps aux | grep -E "(node|npx)" | grep -v grep | awk '{print $2, $3, $4, $11, $12, $13}' || echo "None found"
    
    echo ""
    echo "🌐 Browser processes:"
    ps aux | grep -E "(chromium|chrome|playwright|puppeteer)" | grep -v grep | awk '{print $2, $3, $4, $11, $12, $13}' || echo "None found"
    
    echo ""
    echo "🐍 Python processes:"
    ps aux | grep python | grep -v grep | awk '{print $2, $3, $4, $11, $12, $13}' || echo "None found"
    
    echo ""
}

# Function to clean specific process types
cleanup_browsers() {
    echo "🌐 Cleaning up browser processes..."
    
    # Kill Chromium processes from Playwright/Puppeteer
    pkill -f "chromium" 2>/dev/null && echo "  ✅ Killed Chromium processes"
    pkill -f "chrome.*--remote-debugging" 2>/dev/null && echo "  ✅ Killed debugging Chrome processes"
    
    # Kill Playwright processes
    pkill -f "playwright" 2>/dev/null && echo "  ✅ Killed Playwright processes"
    
    # Kill Puppeteer processes
    pkill -f "puppeteer" 2>/dev/null && echo "  ✅ Killed Puppeteer processes"
    
    # Kill orphaned browser processes
    ps aux | grep -E "(chromium|chrome)" | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null
}

cleanup_node() {
    echo "📦 Cleaning up Node.js MCP processes..."
    
    # Kill all npx server processes
    ps aux | grep "npx.*server" | grep -v grep | awk '{print $2}' | xargs kill -TERM 2>/dev/null
    sleep 2
    ps aux | grep "npx.*server" | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null
    
    # Kill zombie node processes
    ps aux | grep "node.*server" | grep -v grep | awk '{print $2}' | xargs kill -TERM 2>/dev/null
    sleep 2
    ps aux | grep "node.*server" | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null
    
    echo "  ✅ Cleaned up Node.js processes"
}

cleanup_python() {
    echo "🐍 Cleaning up Python MCP processes..."
    
    # Kill Python MCP servers (like Excel MCP)
    ps aux | grep "python.*mcp" | grep -v grep | awk '{print $2}' | xargs kill -TERM 2>/dev/null
    sleep 2
    ps aux | grep "python.*mcp" | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null
    
    echo "  ✅ Cleaned up Python processes"
}

cleanup_caches() {
    echo "🗑️ Cleaning up caches..."
    
    # Check npm cache size
    npm_cache_size=$(du -sm ~/.npm 2>/dev/null | cut -f1)
    if [ "$npm_cache_size" -gt 100 ]; then
        echo "  📦 Clearing npm cache (${npm_cache_size}MB)..."
        npm cache clean --force
        echo "  ✅ npm cache cleared"
    else
        echo "  ℹ️ npm cache is small (${npm_cache_size}MB), skipping"
    fi
    
    # Clear node_modules cache if it exists
    if [ -d ~/.cache/node ]; then
        rm -rf ~/.cache/node
        echo "  ✅ Cleared Node.js cache"
    fi
}

restart_claude() {
    echo "🔄 Restarting Claude Desktop..."
    
    # Kill Claude Desktop
    killall "Claude Desktop" 2>/dev/null
    
    # Wait a moment
    sleep 3
    
    # Restart Claude Desktop
    open -a "Claude Desktop"
    
    echo "  ✅ Claude Desktop restarted"
}

check_temperature() {
    if command -v istats >/dev/null 2>&1; then
        temp=$(istats cpu temp --value-only 2>/dev/null | cut -d. -f1)
        echo "🌡️ Current CPU temperature: ${temp}°C"
    elif command -v osx-cpu-temp >/dev/null 2>&1; then
        temp=$(osx-cpu-temp)
        echo "🌡️ Current CPU temperature: $temp"
    else
        echo "🌡️ Install 'brew install osx-cpu-temp' for temperature monitoring"
    fi
}

# Main execution
main() {
    case "${1:-all}" in
        "browsers"|"browser")
            show_processes
            cleanup_browsers
            ;;
        "node"|"nodejs")
            show_processes
            cleanup_node
            ;;
        "python")
            show_processes
            cleanup_python
            ;;
        "cache"|"caches")
            cleanup_caches
            ;;
        "restart")
            restart_claude
            ;;
        "status"|"show")
            show_processes
            check_temperature
            exit 0
            ;;
        "all"|*)
            show_processes
            echo ""
            read -p "🤔 Proceed with cleanup? (y/N): " confirm
            if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                cleanup_browsers
                cleanup_node
                cleanup_python
                cleanup_caches
                restart_claude
                echo ""
                echo "✅ Cleanup complete!"
                check_temperature
            else
                echo "❌ Cleanup cancelled"
                exit 0
            fi
            ;;
    esac
    
    echo ""
    echo "🎯 Usage: $0 [browsers|node|python|cache|restart|status|all]"
    echo "   browsers - Clean browser processes only"
    echo "   node     - Clean Node.js/npx processes only" 
    echo "   python   - Clean Python MCP processes only"
    echo "   cache    - Clean npm/node caches only"
    echo "   restart  - Restart Claude Desktop only"
    echo "   status   - Show current processes (no cleanup)"
    echo "   all      - Full cleanup (default)"
}

main "$@"
