#!/bin/bash

# 🔧 Intel Mac rclone pCloud Setup
# Thermal-optimized for Intel MacBook Pro 2018

echo "🔧 INTEL MAC RCLONE PCLOUD SETUP"
echo "================================="
echo "🎯 Goal: Replace pCloud Desktop with rclone (free 300GB+ space)"
echo ""

# Check if rclone is installed
if ! command -v rclone &> /dev/null; then
    echo "📦 Installing rclone..."
    if command -v brew &> /dev/null; then
        brew install rclone
    else
        echo "⚠️ Homebrew not found. Installing via curl..."
        curl https://rclone.org/install.sh | sudo bash
    fi
else
    echo "✅ rclone already installed: $(rclone version | head -1)"
fi

echo ""
echo "🔧 Setting up pCloud OAuth..."
echo ""
echo "📋 MANUAL SETUP STEPS:"
echo "1. Run: rclone config"
echo "2. Choose: n (New remote)"
echo "3. name> pcloud_intel"
echo "4. Storage> pcloud"
echo "5. client_id> [PRESS ENTER - leave blank]"
echo "6. client_secret> [PRESS ENTER - leave blank]"
echo "7. Edit advanced config? n"
echo "8. Use web browser? y"
echo "9. [Complete OAuth in browser]"
echo "10. Keep remote? y"
echo ""

read -p "🤔 Ready to run rclone config? (y/n): " ready

if [[ $ready == [yY] ]]; then
    echo "🚀 Starting rclone config..."
    rclone config
    
    echo ""
    echo "🧪 Testing connection..."
    if rclone lsd pcloud_intel: >/dev/null 2>&1; then
        echo "✅ SUCCESS! pCloud connected via rclone"
        
        echo ""
        echo "📊 Your pCloud directories:"
        rclone lsd pcloud_intel: | head -10
        
        echo ""
        echo "🎯 NEXT STEPS:"
        echo "1. Test file operations"
        echo "2. Plan migration from pCloud Desktop"
        echo "3. Free up Intel Mac storage"
        
    else
        echo "❌ Connection failed. Please check setup."
    fi
else
    echo "💡 When ready, run: rclone config"
    echo "   Then test with: rclone lsd pcloud_intel:"
fi

echo ""
echo "🌡️ THERMAL TIP: Once working, you can disable pCloud Desktop"
echo "   to stop background sync and cool down your Intel Mac!"
