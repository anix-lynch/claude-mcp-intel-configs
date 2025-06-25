#!/bin/bash

# 🗂️ Intel MacBook Pro Storage Analyzer & pCloud Organizer
# Like DaisyDisk but optimized for MCP users with Intel Macs

echo "💾 INTEL MAC STORAGE ANALYZER"
echo "============================="

# Colors for output
RED='\033[0;31m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Function to get directory size in human readable format
get_size() {
    du -sh "$1" 2>/dev/null | cut -f1
}

# Function to get directory size in MB for sorting
get_size_mb() {
    du -sm "$1" 2>/dev/null | cut -f1
}

# Check available space
echo "🔍 Current Storage Status:"
df -h / | tail -1 | awk '{print "Used: " $3 " / Available: " $4 " (" $5 " full)"}'
echo ""

# Check if low on space (Intel Mac needs 20%+ free for good performance)
available_space=$(df / | tail -1 | awk '{print $4}')
total_space=$(df / | tail -1 | awk '{print $2}')
usage_percent=$(echo "scale=0; $available_space * 100 / $total_space" | bc)

if [ "$usage_percent" -lt 20 ]; then
    echo -e "${RED}⚠️ WARNING: Less than 20% free space - this makes Intel Macs run HOT!${NC}"
    echo "💡 Recommendation: Free up space immediately for better thermal performance"
    echo ""
fi

echo "🔥 TOP STORAGE HOGS (likely causing heat):"
echo "=========================================="

# Analyze major directories
declare -A dir_sizes
declare -A dir_priorities

# Home directory analysis
dirs_to_check=(
    "$HOME/Downloads"
    "$HOME/Documents" 
    "$HOME/Desktop"
    "$HOME/.npm"
    "$HOME/.cache"
    "$HOME/Library/Caches"
    "$HOME/.local"
    "$HOME/node_modules"
    "$HOME/projects"
    "$HOME/dev-workspace"
    "$HOME/.Trash"
    "$HOME/.chromium-browser-snapshots"
    "$HOME/.docker"
    "$HOME/iCloud Drive (Archive)"
    "$HOME/pCloud Drive"
)

echo "📊 Scanning directories..."
for dir in "${dirs_to_check[@]}"; do
    if [ -d "$dir" ]; then
        size_mb=$(get_size_mb "$dir")
        size_human=$(get_size "$dir")
        dir_name=$(basename "$dir")
        
        # Categorize by priority and heat impact
        priority="LOW"
        heat_impact="🌡️"
        
        case "$dir_name" in
            "Downloads"|"Documents"|"Desktop")
                if [ "$size_mb" -gt 1000 ]; then
                    priority="HIGH"
                    heat_impact="🔥🔥"
                fi
                ;;
            ".npm"|".cache"|"Caches"|"node_modules"|".chromium-browser-snapshots")
                if [ "$size_mb" -gt 500 ]; then
                    priority="HIGH"
                    heat_impact="🔥🔥🔥"
                fi
                ;;
            ".Trash")
                if [ "$size_mb" -gt 100 ]; then
                    priority="IMMEDIATE"
                    heat_impact="🔥🔥🔥"
                fi
                ;;
            ".docker"|"projects"|"dev-workspace")
                if [ "$size_mb" -gt 2000 ]; then
                    priority="MEDIUM"
                    heat_impact="🔥"
                fi
                ;;
        esac
        
        printf "%-30s %10s %15s %s\n" "$dir_name" "$size_human" "$priority" "$heat_impact"
    fi
done

echo ""
echo "🚨 IMMEDIATE ACTIONS (Intel Mac Heat Reduction):"
echo "=============================================="

# Check trash
trash_size=$(get_size_mb "$HOME/.Trash")
if [ "$trash_size" -gt 100 ]; then
    echo -e "${RED}1. Empty Trash: $(get_size "$HOME/.Trash") - FREE SPACE NOW!${NC}"
    echo "   Command: rm -rf ~/.Trash/*"
fi

# Check npm cache
npm_size=$(get_size_mb "$HOME/.npm")
if [ "$npm_size" -gt 200 ]; then
    echo -e "${ORANGE}2. Clear npm cache: $(get_size "$HOME/.npm") - Reduces MCP heat${NC}"
    echo "   Command: npm cache clean --force"
fi

# Check system caches
cache_size=$(get_size_mb "$HOME/Library/Caches")
if [ "$cache_size" -gt 500 ]; then
    echo -e "${ORANGE}3. Clear system caches: $(get_size "$HOME/Library/Caches")${NC}"
    echo "   Command: rm -rf ~/Library/Caches/*"
fi

# Check Downloads
downloads_size=$(get_size_mb "$HOME/Downloads")
if [ "$downloads_size" -gt 1000 ]; then
    echo -e "${RED}4. Clean Downloads: $(get_size "$HOME/Downloads") - Move to pCloud${NC}"
    echo "   Check for: Large files, old installers, MCP downloads"
fi

echo ""
echo "📤 PCLOUD ORGANIZATION STRATEGY:"
echo "==============================="

echo "🗂️ Recommended pCloud folder structure:"
cat << 'EOF'
pCloud Drive/
├── Archive/
│   ├── Documents-Archive/     # Old documents (>6 months)
│   ├── Downloads-Archive/     # Large downloads to keep
│   ├── Projects-Archive/      # Completed projects
│   └── Media-Archive/         # Large media files
├── Active/
│   ├── Current-Projects/      # Working projects
│   ├── Documents-Working/     # Frequently used docs
│   └── Resources/             # Reference materials
└── MCP-Backups/
    ├── Config-Backups/        # MCP configurations
    ├── Scripts-Backups/       # Custom scripts
    └── Data-Exports/          # Exported data
EOF

echo ""
echo "💡 INTEL MAC OPTIMIZATION MOVES:"
echo "==============================="

cat << 'EOF'
📁 Move to pCloud (upload these):
• Documents/ older than 3 months
• Downloads/ larger than 100MB
• Old project folders
• Large media files
• MCP server logs
• Unused git repositories

🗑️ Safe to delete (frees up space + reduces heat):
• ~/.npm cache (regenerates automatically)
• ~/Library/Caches/* (system will recreate)
• ~/.Trash/* (obviously)
• ~/.chromium-browser-snapshots (from Playwright)
• Old Docker images
• Unused node_modules folders

⚡ Keep local (for performance):
• Current project files
• Active MCP configurations
• Recently used documents
• System files
• Applications
EOF

echo ""
echo "🛠️ AUTOMATED CLEANUP COMMANDS:"
echo "============================"

cat << 'COMMANDS'
# Emergency space recovery (Intel Mac cooling)
rm -rf ~/.Trash/*
npm cache clean --force
rm -rf ~/Library/Caches/*
docker system prune -af

# Find large files to move to pCloud
find ~ -type f -size +100M -not -path "*/Library/*" -not -path "*/Applications/*"

# Find old files to archive
find ~/Downloads -type f -mtime +30
find ~/Documents -type f -mtime +90

# Check what's using space right now
du -sh ~/* | sort -hr | head -20
COMMANDS

echo ""
echo "🎯 Why This Helps Your Intel Mac:"
echo "- More free space = less disk I/O = less heat"
echo "- Faster file access = CPU works less"
echo "- Less Spotlight indexing = cooler system"
echo "- Room for virtual memory = no thermal throttling"
echo ""
echo "🔗 Next: Run the thermal manager after cleanup:"
echo "   ./scripts/intel_thermal_manager.sh check"
