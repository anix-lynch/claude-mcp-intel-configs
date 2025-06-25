#!/bin/bash

# 🌡️ Intel MacBook Pro Temperature Monitor & Auto-Cooler
# Monitors CPU temp and automatically switches to quieter configs

# Temperature thresholds (Celsius)
TEMP_WARNING=75
TEMP_CRITICAL=85
TEMP_EMERGENCY=90

# Config paths
CLAUDE_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
REPO_URL="https://raw.githubusercontent.com/anix-lynch/claude-mcp-intel-configs/main/configs"

check_temperature() {
    # Get CPU temperature (requires installing temperature monitor)
    if command -v istats >/dev/null 2>&1; then
        temp=$(istats cpu temp --value-only 2>/dev/null | cut -d. -f1)
    elif command -v osx-cpu-temp >/dev/null 2>&1; then
        temp=$(osx-cpu-temp | grep -o '[0-9]*' | head -1)
    else
        # Fallback: estimate from CPU usage
        cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')
        if [ "$cpu_usage" -gt 80 ]; then
            temp=85  # Assume high temp with high CPU
        elif [ "$cpu_usage" -gt 50 ]; then
            temp=75
        else
            temp=65
        fi
    fi
    echo "$temp"
}

get_current_config() {
    if grep -q "playwright\\|puppeteer\\|stability" "$CLAUDE_CONFIG" 2>/dev/null; then
        echo "power"
    elif grep -q "brave-search" "$CLAUDE_CONFIG" 2>/dev/null; then
        echo "balanced"
    elif grep -q "github" "$CLAUDE_CONFIG" 2>/dev/null; then
        echo "quiet"
    else
        echo "unknown"
    fi
}

switch_config() {
    local config_type=$1
    echo "🔄 Switching to $config_type config due to temperature..."
    
    # Backup current config
    cp "$CLAUDE_CONFIG" "$CLAUDE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null
    
    # Download and apply new config
    curl -s "$REPO_URL/intel_${config_type}_config.json" > "$CLAUDE_CONFIG"
    
    # Restart Claude Desktop
    killall "Claude Desktop" 2>/dev/null
    sleep 2
    open -a "Claude Desktop"
    
    echo "✅ Switched to $config_type mode"
}

cleanup_processes() {
    echo "🧹 Cleaning up hot processes..."
    
    # Kill browser processes from MCP
    pkill -f "chromium" 2>/dev/null
    pkill -f "playwright" 2>/dev/null
    pkill -f "puppeteer" 2>/dev/null
    
    # Clean up zombie npx processes
    ps aux | grep "npx.*server" | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null
    
    # Clear npm cache if it's large
    npm_cache_size=$(du -sm ~/.npm 2>/dev/null | cut -f1)
    if [ "$npm_cache_size" -gt 500 ]; then
        echo "🗑️ Clearing large npm cache ($npm_cache_size MB)..."
        npm cache clean --force
    fi
}

main() {
    echo "🌡️ Intel MacBook Pro Temperature Monitor"
    echo "=========================================="
    
    temp=$(check_temperature)
    current_config=$(get_current_config)
    
    echo "🌡️ Current CPU temp: ${temp}°C"
    echo "⚙️ Current config: $current_config"
    
    if [ "$temp" -ge "$TEMP_EMERGENCY" ]; then
        echo "🚨 EMERGENCY: Temperature $temp°C >= $TEMP_EMERGENCY°C"
        cleanup_processes
        switch_config "quiet"
        echo "💨 All non-essential processes killed!"
        
    elif [ "$temp" -ge "$TEMP_CRITICAL" ]; then
        echo "⚠️ CRITICAL: Temperature $temp°C >= $TEMP_CRITICAL°C"
        if [ "$current_config" != "quiet" ]; then
            cleanup_processes
            switch_config "quiet"
        fi
        
    elif [ "$temp" -ge "$TEMP_WARNING" ]; then
        echo "🔶 WARNING: Temperature $temp°C >= $TEMP_WARNING°C"
        if [ "$current_config" = "power" ]; then
            switch_config "balanced"
        fi
        
    else
        echo "✅ Temperature normal ($temp°C)"
        # Could auto-upgrade config here if desired
    fi
    
    echo ""
    echo "🎯 Recommendations:"
    if [ "$temp" -ge "$TEMP_WARNING" ]; then
        echo "- Close other applications"
        echo "- Check Activity Monitor for CPU hogs"
        echo "- Consider using external cooling"
    else
        echo "- Temperature is healthy"
        echo "- Safe to use balanced or power configs if needed"
    fi
}

# Install temperature monitoring tool if needed
install_temp_monitor() {
    if ! command -v istats >/dev/null 2>&1 && ! command -v osx-cpu-temp >/dev/null 2>&1; then
        echo "📦 Installing temperature monitor..."
        if command -v brew >/dev/null 2>&1; then
            brew install osx-cpu-temp
        else
            echo "⚠️ Please install Homebrew or istats for accurate temperature monitoring"
        fi
    fi
}

# Run based on arguments
case "${1:-check}" in
    "install")
        install_temp_monitor
        ;;
    "monitor")
        while true; do
            main
            echo "⏱️ Checking again in 30 seconds... (Ctrl+C to stop)"
            sleep 30
            clear
        done
        ;;
    "check"|*)
        main
        ;;
esac
