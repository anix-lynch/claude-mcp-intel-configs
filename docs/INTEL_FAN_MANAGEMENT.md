# 🔥 Intel MacBook Pro Fan Management Scripts

*Advanced cooling management for Intel Macs running Claude MCP*

## 🌡️ Intel-Specific Fan Problems

**Why Intel Macs Get Hot:**
- Older thermal design (2018-2020 generation)
- Intel CPU inherently runs hotter than M-series
- Accumulated processes over time
- Browser automation = instant furnace 🔥
- Memory leaks in long-running MCP servers

## 🛠 Intel-Specific Solutions

### 1. 🌡️ **Thermal Manager** (`intel_thermal_manager.sh`)
*Intelligent temperature monitoring with auto-config switching*

```bash
# Check current temperature
./scripts/intel_thermal_manager.sh check

# Continuous monitoring (auto-switches configs)
./scripts/intel_thermal_manager.sh monitor

# Install temperature monitoring tools
./scripts/intel_thermal_manager.sh install
```

**How it works:**
- 🌡️ **75°C+**: Warning - switches from power to balanced
- 🔥 **85°C+**: Critical - switches to quiet mode  
- 🚨 **90°C+**: Emergency - kills all processes, quiet mode only

### 2. 🧹 **Process Cleaner** (`intel_process_cleaner.sh`)
*Targeted cleanup of fan-causing processes*

```bash
# Full cleanup (recommended daily)
./scripts/intel_process_cleaner.sh

# Specific cleanups
./scripts/intel_process_cleaner.sh browsers  # Kill browser processes
./scripts/intel_process_cleaner.sh node     # Kill Node.js/npx processes
./scripts/intel_process_cleaner.sh python   # Kill Python MCP processes
./scripts/intel_process_cleaner.sh cache    # Clear npm/node caches

# Just show what's running
./scripts/intel_process_cleaner.sh status
```

### 3. 🚨 **Emergency Quiet** (`emergency_quiet.sh`)
*One-click fan fix*

```bash
# When fans are screaming
./scripts/emergency_quiet.sh

# Or from anywhere:
curl -s https://raw.githubusercontent.com/anix-lynch/claude-mcp-intel-configs/main/scripts/emergency_quiet.sh | bash
```

## 📊 Daily Intel Mac Workflow

### Morning Routine:
```bash
# 1. Clean up overnight processes
./scripts/intel_process_cleaner.sh

# 2. Check temperature 
./scripts/intel_thermal_manager.sh check

# 3. Start with quiet config
cp configs/intel_quiet_config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Work Session:
```bash
# Need web scraping? Use power mode briefly
cp configs/intel_power_config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json

# ⚠️ Watch temperature!
./scripts/intel_thermal_manager.sh check

# Switch back when done
cp configs/intel_balanced_config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### End of Day:
```bash
# Full cleanup before closing laptop
./scripts/intel_process_cleaner.sh
```

## 🔍 Advanced Monitoring

### Install Temperature Tools:
```bash
# Option 1: iStats (more detailed)
sudo gem install iStats

# Option 2: osx-cpu-temp (lightweight)
brew install osx-cpu-temp

# Option 3: Manual monitoring
sudo powermetrics -n 1 -i 1000 --samplers smc | grep -i temp
```

### Watch Resource Usage:
```bash
# Top CPU processes
top -o cpu -n 10

# MCP-specific processes
ps aux | grep -E "(npx|node|python|chromium)" | grep -v grep

# Memory usage
vm_stat | grep "Pages free"
```

## ⚠️ Emergency Procedures

### 🚨 **When Fans Won't Stop:**
1. Run emergency script: `./scripts/emergency_quiet.sh`
2. Force kill all processes: `./scripts/intel_process_cleaner.sh browsers`
3. Clear all caches: `./scripts/intel_process_cleaner.sh cache`
4. Restart Mac if needed

### 🔥 **When Temperature is Critical:**
1. Close all other applications
2. Run: `./scripts/intel_thermal_manager.sh monitor`
3. Use only filesystem MCP server
4. Consider external cooling

### 🧊 **Cooling Optimization:**
- Use laptop stand for airflow
- External keyboard/mouse to keep hands off hot laptop
- Fan control apps like Macs Fan Control
- Monitor Activity Monitor regularly

## 📈 Performance Tips

### Config Strategy:
- **Daily work**: Quiet mode (filesystem + github + memory)
- **Research**: Balanced mode (+ brave-search)
- **Web scraping**: Power mode (use sparingly!)
- **Emergency**: Filesystem only

### Process Management:
- Restart Claude Desktop daily
- Clear npm cache weekly
- Monitor for zombie processes
- Use thermal manager for auto-switching

### Hardware Considerations:
- Clean laptop vents monthly
- Check thermal paste if > 3 years old
- Monitor battery health (heat damages batteries)
- Consider external cooling solutions

---

*These scripts are specifically designed for Intel MacBook Pro 2018-2020 models*  
*M-series Mac users should use the main [claude-mcp-configs](https://github.com/anix-lynch/claude-mcp-configs) repo*
