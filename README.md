# ☁️💙 Meicy's Claude Code Statusline

A beautiful, informative statusline for Claude Code showing model info, context usage, rate limits, git stats, and session info.

## ✨ Features

**Line 1 - System Metrics:**
- 🤖 Model name (Sonnet 4.5, Opus 4.7, etc.)
- 📊 Context window usage with colored progress bar (green → yellow → orange → red)
- ⏰ 5-hour rate limit with countdown timer
- 📅 7-day rate limit with countdown timer

**Line 2 - Project Info:**
- 🌿 Git branch with dirty indicator (*)
- ➕➖ Line changes since last commit (+42/-15)
- 📁 Project name
- 📝 Last message timestamp
- 🕐 Session duration

## 🚀 Quick Install (Windows)

**One-line PowerShell command:**

```powershell
iwr -useb https://raw.githubusercontent.com/meicy321/claude-code-statusline/main/install-statusline.ps1 | iex
```

Then restart Claude Code!

## 📋 Requirements

- **jq** - JSON parser (install with `scoop install jq` or download from [jqlang.github.io](https://jqlang.github.io/jq/download/))
- **Git** - For branch and diff stats
- **Git Bash** - Usually comes with Git for Windows

## 🎨 Customization

After installation, edit `~/.claude/statusline-command.sh` to customize:

```bash
# Change emojis (line 15)
EMOJI_STR="😊🥗"  # Change to whatever you like!

# Toggle features (lines 16-23)
SHOW_MODEL=true
SHOW_CONTEXT_BAR=true
SHOW_RATE_5H=true
SHOW_RATE_7D=true
SHOW_GIT_BRANCH=true
SHOW_GIT_DIFF=true
SHOW_PROJECT=true
SHOW_LAST_MSG=true
```

## 📸 Preview

```
☁️ 💙  │ Sonnet 4.5 │ ██░░░░░░░░░░ 17% │ 4H56m 1% used │ 4D23H 23% used
master* │ +42 │ Video_to_action │ 📝 2026-04-26 14:52 │ 🕐 session:2m
```

## 🛠️ Manual Installation

If you prefer to install manually:

1. **Download statusline script:**
   ```bash
   curl -o ~/.claude/statusline-command.sh https://raw.githubusercontent.com/YOUR-USERNAME/YOUR-REPO/main/statusline-command.sh
   ```

2. **Download session hook:**
   ```bash
   mkdir -p ~/.claude/hooks
   curl -o ~/.claude/hooks/session-start.sh https://raw.githubusercontent.com/YOUR-USERNAME/YOUR-REPO/main/hooks/session-start.sh
   ```

3. **Update settings.json** (`~/.claude/settings.json`):
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "bash ~/.claude/statusline-command.sh"
     },
     "hooks": {
       "SessionStart": [
         {
           "type": "command",
           "command": "bash ~/.claude/hooks/session-start.sh"
         }
       ]
     }
   }
   ```

4. **Restart Claude Code**

## 🐛 Troubleshooting

**No statusline showing:**
- Make sure you've restarted Claude Code (fully close and reopen)
- Check that `jq` is installed: `jq --version`
- Verify the script exists: `ls ~/.claude/statusline-command.sh`

**No percentages showing:**
- Install `jq`: `scoop install jq`
- Restart Claude Code after installing jq

**Session duration not showing:**
- Make sure the SessionStart hook is installed and configured in settings.json

## 📝 Credits

Based on [Raymond Hou's Starter Kit #06](https://github.com/Raymondhou0917/claude-code-resources)  
Customized and packaged by Meicy

## 📄 License

CC BY-NC-SA 4.0 - Free for personal use, no commercial use
