#!/bin/bash

# 📤 pCloud Organization Automation for Intel Mac
# Automatically organize files to free up space and reduce heat

PCLOUD_DIR="$HOME/pCloud Drive"
DATE=$(date +%Y%m%d)

echo "📤 PCLOUD ORGANIZATION WIZARD"
echo "============================="

# Check if pCloud is available
if [ ! -d "$PCLOUD_DIR" ]; then
    echo "❌ pCloud Drive not found at $PCLOUD_DIR"
    echo "💡 Please make sure pCloud is installed and synced"
    exit 1
fi

# Create recommended folder structure
create_folder_structure() {
    echo "🗂️ Creating pCloud folder structure..."
    
    mkdir -p "$PCLOUD_DIR/Archive/Documents-Archive"
    mkdir -p "$PCLOUD_DIR/Archive/Downloads-Archive"  
    mkdir -p "$PCLOUD_DIR/Archive/Projects-Archive"
    mkdir -p "$PCLOUD_DIR/Archive/Media-Archive"
    mkdir -p "$PCLOUD_DIR/Active/Current-Projects"
    mkdir -p "$PCLOUD_DIR/Active/Documents-Working"
    mkdir -p "$PCLOUD_DIR/Active/Resources"
    mkdir -p "$PCLOUD_DIR/MCP-Backups/Config-Backups"
    mkdir -p "$PCLOUD_DIR/MCP-Backups/Scripts-Backups"
    mkdir -p "$PCLOUD_DIR/MCP-Backups/Data-Exports"
    
    echo "✅ Folder structure created"
}

# Function to move old documents
move_old_documents() {
    echo "📁 Moving old documents (>3 months) to pCloud..."
    
    find "$HOME/Documents" -type f -mtime +90 -size +10M | while read file; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            echo "Moving: $filename"
            mv "$file" "$PCLOUD_DIR/Archive/Documents-Archive/"
        fi
    done
    
    echo "✅ Old documents moved"
}

# Function to move large downloads
move_large_downloads() {
    echo "💾 Moving large downloads (>100MB) to pCloud..."
    
    find "$HOME/Downloads" -type f -size +100M | while read file; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            echo "Moving: $filename"
            mv "$file" "$PCLOUD_DIR/Archive/Downloads-Archive/"
        fi
    done
    
    echo "✅ Large downloads moved"
}

# Function to backup MCP configurations
backup_mcp_configs() {
    echo "⚙️ Backing up MCP configurations..."
    
    # Claude Desktop config
    if [ -f "$HOME/Library/Application Support/Claude/claude_desktop_config.json" ]; then
        cp "$HOME/Library/Application Support/Claude/claude_desktop_config.json" \
           "$PCLOUD_DIR/MCP-Backups/Config-Backups/claude_desktop_config_$DATE.json"
    fi
    
    # MCP setup scripts
    if [ -d "$HOME/claude-mcp-setup" ]; then
        cp -r "$HOME/claude-mcp-setup" \
           "$PCLOUD_DIR/MCP-Backups/Scripts-Backups/claude-mcp-setup_$DATE"
    fi
    
    # Intel configs if they exist
    if [ -d "$HOME/claude-mcp-intel-configs" ]; then
        cp -r "$HOME/claude-mcp-intel-configs" \
           "$PCLOUD_DIR/MCP-Backups/Scripts-Backups/claude-mcp-intel-configs_$DATE"
    fi
    
    echo "✅ MCP configurations backed up"
}

# Function to move completed projects
move_old_projects() {
    echo "🗃️ Finding old projects to move..."
    
    for project_dir in "$HOME/projects" "$HOME/dev-workspace"; do
        if [ -d "$project_dir" ]; then
            find "$project_dir" -type d -name "*.git" -mtime +60 | while read git_dir; do
                project_path=$(dirname "$git_dir")
                project_name=$(basename "$project_path")
                
                echo "Found old project: $project_name (last modified >60 days)"
                read -p "Move $project_name to pCloud Archive? (y/n): " confirm
                
                if [[ $confirm == [yY] ]]; then
                    mv "$project_path" "$PCLOUD_DIR/Archive/Projects-Archive/"
                    echo "✅ Moved $project_name to pCloud"
                fi
            done
        fi
    done
}

# Function to archive large media files
move_large_media() {
    echo "🎬 Finding large media files..."
    
    find "$HOME" -type f \( -name "*.mp4" -o -name "*.mov" -o -name "*.avi" -o -name "*.mkv" \) \
         -size +500M -not -path "*/Library/*" -not -path "*/Applications/*" | while read file; do
        
        filename=$(basename "$file")
        filesize=$(du -sh "$file" | cut -f1)
        
        echo "Found large media: $filename ($filesize)"
        read -p "Move to pCloud Archive? (y/n): " confirm
        
        if [[ $confirm == [yY] ]]; then
            mv "$file" "$PCLOUD_DIR/Archive/Media-Archive/"
            echo "✅ Moved $filename to pCloud"
        fi
    done
}

# Function to show space savings
show_space_report() {
    echo ""
    echo "📊 SPACE SAVINGS REPORT"
    echo "======================"
    
    # Calculate space freed
    df -h / | tail -1 | awk '{print "💾 Available space: " $4}'
    
    # Show pCloud usage
    pcloud_size=$(du -sh "$PCLOUD_DIR" 2>/dev/null | cut -f1)
    echo "☁️ pCloud Drive size: $pcloud_size"
    
    echo ""
    echo "🎯 Intel Mac Benefits:"
    echo "- More free space = better thermal performance"
    echo "- Less disk I/O = cooler CPU"
    echo "- Faster file access = less system strain"
    echo "- Files backed up safely in pCloud"
}

# Interactive menu
show_menu() {
    echo ""
    echo "🎀 What would you like to organize?"
    echo "================================="
    echo "1. 🗂️ Create pCloud folder structure"
    echo "2. 📁 Move old documents (>3 months)"
    echo "3. 💾 Move large downloads (>100MB)"
    echo "4. ⚙️ Backup MCP configurations"
    echo "5. 🗃️ Move old projects (>60 days)"
    echo "6. 🎬 Move large media files (>500MB)"
    echo "7. 🚀 Do everything (recommended)"
    echo "8. 📊 Show space report"
    echo "9. ❌ Exit"
    echo ""
}

# Main execution
main() {
    create_folder_structure
    
    while true; do
        show_menu
        read -p "Choose option (1-9): " choice
        
        case $choice in
            1) create_folder_structure ;;
            2) move_old_documents ;;
            3) move_large_downloads ;;
            4) backup_mcp_configs ;;
            5) move_old_projects ;;
            6) move_large_media ;;
            7) 
                echo "🚀 Running full organization..."
                move_old_documents
                move_large_downloads
                backup_mcp_configs
                move_old_projects
                move_large_media
                show_space_report
                ;;
            8) show_space_report ;;
            9) 
                echo "👋 Organization complete!"
                echo "💡 Don't forget to run: ./intel_thermal_manager.sh check"
                exit 0 
                ;;
            *) echo "❌ Invalid option" ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Check prerequisites
echo "🔍 Checking prerequisites..."

# Check available space
available_gb=$(df / | tail -1 | awk '{print int($4/1024/1024)}')
if [ "$available_gb" -lt 20 ]; then
    echo "⚠️ WARNING: Only ${available_gb}GB free - critical for Intel Mac!"
    echo "📤 Strongly recommend running this organization tool"
    echo ""
fi

# Check pCloud sync status
if [ -f "$PCLOUD_DIR/.pcloud" ]; then
    echo "✅ pCloud appears to be synced"
else
    echo "⚠️ pCloud may not be fully synced - proceed with caution"
fi

main
