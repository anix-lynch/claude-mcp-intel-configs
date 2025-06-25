#!/bin/bash

# 🔥 Intel Mac pCloud Thermal Optimizer
# Found the heat source: 100+ folders + videos in root = constant sync!

PCLOUD_DIR="$HOME/pCloud Drive"
DATE=$(date +%Y%m%d)

echo "🔥 INTEL MAC PCLOUD THERMAL OPTIMIZER"
echo "======================================"
echo "🎯 Mission: Reduce sync load to cool down your Intel Mac"
echo ""

# Check current structure
echo "📊 Current pCloud structure analysis..."
total_dirs=$(find "$PCLOUD_DIR" -maxdepth 1 -type d | wc -l)
total_files=$(find "$PCLOUD_DIR" -maxdepth 1 -type f | wc -l)
video_files=$(find "$PCLOUD_DIR" -maxdepth 1 -name "*.mp4" -o -name "*.mov" | wc -l)

echo "📁 Root level directories: $total_dirs"
echo "📄 Root level files: $total_files"  
echo "🎬 Video files in root: $video_files"

if [ "$total_dirs" -gt 50 ]; then
    echo "🚨 WARNING: $total_dirs folders in root = MAJOR heat source!"
fi

if [ "$video_files" -gt 0 ]; then
    echo "🔥 WARNING: Video files in root = continuous indexing heat!"
fi

echo ""
echo "🎯 THERMAL OPTIMIZATION PLAN:"
echo "============================="

# Plan 1: Move video files out of root
optimize_videos() {
    echo "🎬 Moving video files out of root directory..."
    
    mkdir -p "$PCLOUD_DIR/Media/Videos-Root-Cleanup-$DATE"
    
    find "$PCLOUD_DIR" -maxdepth 1 -name "*.mp4" -o -name "*.mov" | while read video; do
        if [ -f "$video" ]; then
            filename=$(basename "$video")
            echo "Moving: $filename"
            mv "$video" "$PCLOUD_DIR/Media/Videos-Root-Cleanup-$DATE/"
        fi
    done
    
    echo "✅ Videos moved to Media/Videos-Root-Cleanup-$DATE/"
}

# Plan 2: Archive old backup folders
archive_old_backups() {
    echo "🗄️ Archiving old backup folders..."
    
    mkdir -p "$PCLOUD_DIR/Archive/Old-Backups-$DATE"
    
    # Move 2022-2023 backups
    old_backups=(
        "2023 DATA backup"
        "Backup APR 2023" 
        "Big Mac OLD_HD backup 2022"
    )
    
    for backup in "${old_backups[@]}"; do
        if [ -d "$PCLOUD_DIR/$backup" ]; then
            echo "Archiving: $backup"
            mv "$PCLOUD_DIR/$backup" "$PCLOUD_DIR/Archive/Old-Backups-$DATE/"
        fi
    done
    
    echo "✅ Old backups archived"
}

# Plan 3: Consolidate Python uploads
consolidate_python() {
    echo "🐍 Consolidating Python upload folders..."
    
    mkdir -p "$PCLOUD_DIR/Development/Python-Uploads-Consolidated-$DATE"
    
    # Find all Python upload folders
    find "$PCLOUD_DIR" -maxdepth 1 -name "*Python*" -o -name "*python*" | while read python_dir; do
        if [ -d "$python_dir" ]; then
            dirname=$(basename "$python_dir")
            echo "Consolidating: $dirname"
            mv "$python_dir" "$PCLOUD_DIR/Development/Python-Uploads-Consolidated-$DATE/"
        fi
    done
    
    echo "✅ Python folders consolidated"
}

# Plan 4: Create logical groupings
create_structure() {
    echo "🗂️ Creating optimized folder structure..."
    
    # Create main categories to reduce root clutter
    mkdir -p "$PCLOUD_DIR/Archive"
    mkdir -p "$PCLOUD_DIR/Active"
    mkdir -p "$PCLOUD_DIR/Media"
    mkdir -p "$PCLOUD_DIR/Development"
    mkdir -p "$PCLOUD_DIR/Travel"
    mkdir -p "$PCLOUD_DIR/Personal"
    
    echo "✅ Structure created"
}

# Plan 5: Country folders → Travel
organize_countries() {
    echo "🌍 Organizing country folders..."
    
    mkdir -p "$PCLOUD_DIR/Travel/Countries"
    
    # List of country folders to move
    countries=(
        "Australia" "Brazil" "China" "Denmark" "Finland" "France" 
        "Germany" "Greece" "Guam" "Ireland" "Italy" "Japan" "Korea"
        "Maldives" "Morrocco" "Peurto Rico" "Russia" "Scottland"
        "Singapore" "Spain" "Sweden" "Switzerland" "Thailand" "UK" "USA"
        "amsterdam" "phillippines"
    )
    
    for country in "${countries[@]}"; do
        if [ -d "$PCLOUD_DIR/$country" ]; then
            echo "Moving: $country → Travel/Countries/"
            mv "$PCLOUD_DIR/$country" "$PCLOUD_DIR/Travel/Countries/"
        fi
    done
    
    echo "✅ Countries organized"
}

# Function to show thermal impact
show_thermal_impact() {
    echo ""
    echo "🌡️ THERMAL IMPACT REDUCTION:"
    echo "============================="
    
    new_root_dirs=$(find "$PCLOUD_DIR" -maxdepth 1 -type d | wc -l)
    reduction=$((total_dirs - new_root_dirs))
    
    echo "📁 Root directories before: $total_dirs"
    echo "📁 Root directories after: $new_root_dirs"
    echo "📉 Reduction: $reduction directories"
    
    if [ "$reduction" -gt 20 ]; then
        echo "🎉 EXCELLENT: Major thermal reduction achieved!"
    elif [ "$reduction" -gt 10 ]; then
        echo "✅ GOOD: Noticeable thermal improvement"
    else
        echo "⚠️ Minimal reduction - consider more aggressive reorganization"
    fi
    
    echo ""
    echo "🔄 Recommended next steps:"
    echo "1. Wait 5-10 minutes for pCloud to finish syncing"
    echo "2. Check fan noise and CPU temperature" 
    echo "3. Run: ./intel_thermal_manager.sh check"
}

# Interactive menu
show_menu() {
    echo ""
    echo "🎀 Choose thermal optimization:"
    echo "=============================="
    echo "1. 🎬 Move video files from root (immediate impact)"
    echo "2. 🗄️ Archive old backup folders (2022-2023)"
    echo "3. 🐍 Consolidate Python upload folders"
    echo "4. 🌍 Organize country folders → Travel/"
    echo "5. 🚀 Do everything (recommended for Intel Mac)"
    echo "6. 📊 Show thermal impact report"
    echo "7. ❌ Exit"
    echo ""
}

# Main execution
main() {
    while true; do
        show_menu
        read -p "Choose option (1-7): " choice
        
        case $choice in
            1) optimize_videos ;;
            2) archive_old_backups ;;
            3) consolidate_python ;;
            4) organize_countries ;;
            5) 
                echo "🚀 Running full thermal optimization..."
                create_structure
                optimize_videos
                archive_old_backups  
                consolidate_python
                organize_countries
                show_thermal_impact
                ;;
            6) show_thermal_impact ;;
            7) 
                echo "👋 Optimization complete!"
                echo "🌡️ Your Intel Mac should run cooler now!"
                exit 0 
                ;;
            *) echo "❌ Invalid option" ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Safety check
if [ ! -d "$PCLOUD_DIR" ]; then
    echo "❌ pCloud Drive not found at $PCLOUD_DIR"
    exit 1
fi

echo "⚠️ IMPORTANT: This will reorganize your pCloud structure"
echo "💾 Current structure will be preserved in organized folders"
echo "🔄 pCloud will need time to sync changes"
echo ""
read -p "🤔 Proceed with thermal optimization? (y/N): " confirm

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    main
else
    echo "❌ Optimization cancelled"
    echo "💡 Your current structure is causing thermal issues due to:"
    echo "   - 100+ folders in root directory"
    echo "   - Video files triggering constant indexing"
    echo "   - Multiple backup processes competing"
fi
