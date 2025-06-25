# 🎀 Bchan's Intel MacBook Pro MCP Configs ✨

*Because Intel Macs deserve configs that don't sound like jet engines* 🛩️

## 🌡️ Why Intel-Specific Configs?

**Intel MacBook Pro 2018 Reality Check:**
- 🔥 Gets hot with heavy MCP servers
- 🧠 Limited RAM compared to M4
- 🔋 Battery drains faster with intensive processes
- 💨 Fans go BRRRR with Playwright/Puppeteer

**M4 vs Intel MCP Philosophy:**
- **M4**: "Add ALL the servers!" ⚡
- **Intel**: "Add smart, stay cool" 🌡️

## 📦 Available Configurations

### 🔇️ **Quiet Mode** (`configs/intel_quiet_config.json`)
*The "Silent Productivity" Edition*
- ✅ filesystem (file operations)
- ✅ github (repo management)  
- ✅ memory (context retention)
- ❌ No browser automation (no fan noise!)
- **Perfect for**: Daily coding, writing, file management

### ⚡ **Balanced Mode** (`configs/intel_balanced_config.json`)
*The "Smart Power" Edition*
- ✅ All Quiet Mode tools
- ✅ brave-search (lightweight web search)
- ✅ notion (if you need it)
- ❌ Still no browser automation
- **Perfect for**: Research mode, content creation

### 🔥 **Power Mode** (`configs/intel_power_config.json`)
*The "Occasional Beast" Edition*
- ✅ All Balanced Mode tools
- ⚠️ puppeteer (use sparingly!)
- ⚠️ playwright (emergency use only)
- **Perfect for**: Web scraping sessions (then switch back!)

### 🚨 **Emergency Quiet** (`configs/intel_emergency_config.json`)
*The "Save My Fans" Edition*
- ✅ filesystem only
- **Perfect for**: When everything is too hot

## 🔄 Quick Switch Commands

```bash
# Clone this repo
git clone https://github.com/anix-lynch/claude-mcp-intel-configs.git
cd claude-mcp-intel-configs

# Make scripts executable
chmod +x scripts/*.sh

# Quick switches
./scripts/switch_to_quiet.sh     # 🔇️ Silent mode
./scripts/switch_to_balanced.sh  # ⚡ Smart mode  
./scripts/switch_to_power.sh     # 🔥 Beast mode
./scripts/emergency_quiet.sh     # 🚨 Fan emergency
```

## 📊 Performance Guide

### 🌡️ Temperature Monitoring
```bash
# Watch your CPU temp while testing configs
sudo powermetrics -n 1 -i 1000 --samplers smc | grep -i temp

# Check what's using CPU
top -o cpu
```

### 🔋 Battery Life Tips
- Use Quiet Mode for maximum battery life
- Switch to Power Mode only when needed
- Close Claude Desktop when not using MCP
- Monitor Activity Monitor for runaway processes

## 🎯 Intel-Specific Optimizations

**What We Removed from M4 Configs:**
- ❌ `playwright-stealth` (🔥🔥🔥 Fan killer)
- ❌ `stability-ai` (🔥🔥 CPU intensive)
- ❌ `excel MCP` (🔥 Python overhead)
- ❌ Multiple simultaneous automation tools

**What We Kept:**
- ✅ Core productivity tools
- ✅ Lightweight web search  
- ✅ Essential file operations
- ✅ Smart memory management

## 🛠 Installation Guide

### First Time Setup
```bash
# 1. Install Node.js MCP servers
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-github  
npm install -g @modelcontextprotocol/server-memory
npm install -g brave-search-mcp

# 2. Clone this repo
git clone https://github.com/anix-lynch/claude-mcp-intel-configs.git

# 3. Run setup
cd claude-mcp-intel-configs
./scripts/setup_intel_mcp.sh
```

### Daily Usage
```bash
# Start your day
./scripts/switch_to_quiet.sh

# Need web scraping?
./scripts/switch_to_power.sh
# (remember to switch back!)

# Fans too loud?
./scripts/emergency_quiet.sh
```

## 🎀 API Keys Setup

1. **GitHub Token**: 
   - Go to github.com → Settings → Developer settings → Personal access tokens
   - Create token with `repo` access
   - Add to config: `"GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token"`

2. **Brave Search** (optional):
   - Get free API key from brave.com/search/api
   - Add to config: `"BRAVE_API_KEY": "your_key"`

## 🔍 Troubleshooting

### Fans Still Loud?
```bash
# Check for runaway processes
ps aux | grep -E "(node|npx|python|chrome)" | grep -v grep

# Kill all MCP processes
pkill -f "npx.*server"

# Emergency reset
./scripts/emergency_quiet.sh
```

### MCP Not Working?
```bash
# Check Claude config location
ls -la ~/Library/Application\ Support/Claude/

# Validate JSON
python -m json.tool ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Restart Claude
killall "Claude Desktop" && open -a "Claude Desktop"
```

## 🤝 Contributing

Found a config that keeps your Intel Mac cool? Submit a PR!

**Guidelines:**
- Test on actual Intel MacBook Pro
- Monitor fan speed during testing
- Include temperature notes
- Document battery impact

---

*Optimized for Intel MacBook Pro 2018-2020 by Bchan* 🎀  
*Sister repo to [claude-mcp-configs](https://github.com/anix-lynch/claude-mcp-configs) (M4 edition)*
