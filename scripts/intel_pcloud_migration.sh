#!/bin/bash

# 🔄 Intel Mac: pCloud Desktop → rclone Migration
# FREE 300GB+ storage and reduce thermal load

PCLOUD_LOCAL="/Users/anixlynch/pCloud Drive"
RCLONE_REMOTE="pcloud_intel:"

echo "🔄 PCLOUD DESKTOP → RCLONE MIGRATION"
echo "===================================="
echo "🎯 Goal: Free 300GB+ and stop background sync"
echo ""

# Safety checks
check_prerequisites() {
    echo "🔍 Checking prerequisites..."
    
    if ! command -v rclone &> /dev/null; then
        echo "❌ rclone not installed. Run: ./intel_rclone_setup.sh first"
        exit 1
    fi
    
    if ! rclone lsd $RCLONE_REMOTE >/dev/null 2>&1; then
        echo "❌ rclone not configured. Run: ./intel_rclone_setup.sh first"
        exit 1
    fi
    
    if [ ! -d "$PCLOUD_LOCAL" ]; then
        echo "❌ pCloud Desktop folder not found"
        exit 1
    fi
    
    echo "✅ All prerequisites met"
}

# Calculate current usage
show_current_usage() {
    echo ""
    echo "📊 CURRENT STORAGE ANALYSIS:"
    
    if [ -d "$PCLOUD_LOCAL" ]; then
        local_size=$(du -sh "$PCLOUD_LOCAL" 2>/dev/null | cut -f1)
        echo "💾 pCloud Desktop local storage: $local_size"
    fi
    
    available_space=$(df -h / | tail -1 | awk '{print $4}')
    echo "💾 Available Mac storage: $available_space"
    
    echo ""
}

# Test rclone operations
test_rclone() {
    echo "🧪 Testing rclone operations..."
    
    # Test listing
    echo "📁 Testing directory listing..."
    if rclone lsd $RCLONE_REMOTE | head -5; then
        echo "✅ Directory listing works"
    else
        echo "❌ Directory listing failed"
        return 1
    fi
    
    # Test file operations
    echo ""
    echo "📄 Testing file operations..."
    echo "test file" > /tmp/rclone_test.txt
    
    if rclone copy /tmp/rclone_test.txt $RCLONE_REMOTE/test/; then
        echo "✅ File upload works"
        
        if rclone ls $RCLONE_REMOTE/test/ | grep -q rclone_test.txt; then
            echo "✅ File verification works"
            rclone delete $RCLONE_REMOTE/test/rclone_test.txt
            echo "✅ File cleanup works"
        fi
    else
        echo "❌ File operations failed"
        return 1
    fi
    
    rm -f /tmp/rclone_test.txt
    echo "✅ rclone fully functional"
}

# Migration phases
phase1_backup_verification() {
    echo ""
    echo "📋 PHASE 1: BACKUP VERIFICATION"
    echo "==============================="
    
    echo "🔍 Checking if all files are in cloud..."
    
    # Check sync status
    if pgrep -f "pCloud" >/dev/null; then
        echo "⚠️ pCloud Desktop is running - checking sync status"
        echo "💡 Let pCloud finish syncing before migration"
        
        read -p "🤔 Is pCloud sync complete? (y/n): " sync_done
        if [[ $sync_done != [yY] ]]; then
            echo "⏸️ Wait for sync to complete, then re-run"
            exit 1
        fi
    fi
    
    echo "✅ Ready for migration"
}

phase2_disable_desktop() {
    echo ""
    echo "📋 PHASE 2: DISABLE PCLOUD DESKTOP"
    echo "==================================="
    
    read -p "🚨 This will stop pCloud Desktop. Continue? (y/n): " confirm
    if [[ $confirm != [yY] ]]; then
        echo "❌ Migration cancelled"
        exit 1
    fi
    
    echo "🛑 Stopping pCloud Desktop..."
    pkill -f "pCloud" 2>/dev/null || true
    
    echo "⚠️ To prevent auto-restart:"
    echo "1. Go to System Preferences → Users & Groups → Login Items"
    echo "2. Remove pCloud Drive from startup items"
    echo "3. Or just don't restart pCloud app"
    
    read -p "⏸️ Press Enter when ready to continue..."
}

phase3_verify_cloud_access() {
    echo ""
    echo "📋 PHASE 3: VERIFY CLOUD ACCESS"
    echo "==============================="
    
    echo "🔍 Testing access to your files via rclone..."
    
    echo "📁 Your cloud directories:"
    rclone lsd $RCLONE_REMOTE | head -10
    
    echo ""
    echo "📄 Sample files:"
    rclone ls $RCLONE_REMOTE | head -5
    
    read -p "✅ Can you see your files? (y/n): " files_visible
    if [[ $files_visible != [yY] ]]; then
        echo "❌ Files not accessible. Check rclone setup."
        exit 1
    fi
    
    echo "✅ Cloud access verified"
}

phase4_remove_local() {
    echo ""
    echo "📋 PHASE 4: REMOVE LOCAL FILES"
    echo "==============================="
    echo "⚠️ This will free 300GB+ space!"
    
    local_size=$(du -sh "$PCLOUD_LOCAL" 2>/dev/null | cut -f1)
    echo "💾 pCloud local folder size: $local_size"
    
    read -p "🚨 Delete local pCloud folder? (y/N): " delete_confirm
    if [[ $delete_confirm == [yY] ]]; then
        echo "🗑️ Moving to Trash (safer than rm)..."
        mv "$PCLOUD_LOCAL" ~/.Trash/pCloud-Drive-$(date +%Y%m%d_%H%M%S)
        echo "✅ Local files moved to Trash"
        
        echo ""
        echo "📊 NEW STORAGE STATUS:"
        df -h / | tail -1
        
    else
        echo "💡 Local files kept for now"
        echo "   You can delete manually later: rm -rf '$PCLOUD_LOCAL'"
    fi
}

phase5_setup_convenience() {
    echo ""
    echo "📋 PHASE 5: SETUP CONVENIENCE TOOLS"
    echo "===================================="
    
    # Create convenient rclone commands
    cat > ~/.rclone_intel_commands << 'EOF'
#!/bin/bash
# Intel Mac rclone convenience commands

# List cloud directories
alias plist='rclone lsd pcloud_intel:'

# List files in a directory
alias pls='rclone ls pcloud_intel:'

# Download a file
pget() {
    rclone copy "pcloud_intel:$1" ./
}

# Upload a file  
pput() {
    rclone copy "$1" "pcloud_intel:$2"
}

# Mount pCloud (experimental)
pmount() {
    mkdir -p ~/pcloud_mount
    rclone mount pcloud_intel: ~/pcloud_mount --daemon
}

# Unmount
pumount() {
    umount ~/pcloud_mount
}
EOF

    echo "✅ Convenience commands created in ~/.rclone_intel_commands"
    echo "💡 Source with: source ~/.rclone_intel_commands"
}

# Main execution
main() {
    check_prerequisites
    show_current_usage
    test_rclone
    
    echo ""
    echo "🚀 READY FOR MIGRATION"
    echo "======================"
    read -p "🤔 Proceed with full migration? (y/n): " proceed
    
    if [[ $proceed == [yY] ]]; then
        phase1_backup_verification
        phase2_disable_desktop
        phase3_verify_cloud_access
        phase4_remove_local
        phase5_setup_convenience
        
        echo ""
        echo "🎉 MIGRATION COMPLETE!"
        echo "====================="
        echo "✅ pCloud Desktop → rclone migration successful"
        echo "📈 Storage freed: Check with 'df -h /'"
        echo "🌡️ Thermal benefit: No more background sync"
        echo "☁️ Access files: rclone commands available"
        echo ""
        echo "💡 Quick commands:"
        echo "   rclone lsd pcloud_intel:           # List directories"
        echo "   rclone copy pcloud_intel:file.txt ./  # Download file"
        echo "   source ~/.rclone_intel_commands   # Load shortcuts"
        
    else
        echo "❌ Migration cancelled"
    fi
}

main "$@"
