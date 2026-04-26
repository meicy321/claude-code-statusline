# ☁️💙 Meicy 的 Claude Code 狀態列

一個美觀、資訊豐富的 Claude Code 狀態列，顯示模型資訊、上下文使用量、速率限制、Git 統計和會話資訊。

## ✨ 功能特色

**第一行 - 系統指標：**
- 🤖 模型名稱（Sonnet 4.5、Opus 4.7 等）
- 📊 上下文視窗使用率與彩色進度條（綠 → 黃 → 橙 → 紅）
- ⏰ 5 小時速率限制與倒數計時器
- 📅 7 天速率限制與倒數計時器

**第二行 - 專案資訊：**
- 🌿 Git 分支與修改指示符號（*）
- ➕➖ 自上次提交以來的行數變化（+42/-15）
- 📁 專案名稱
- 📝 最後訊息時間戳記
- 🕐 會話持續時間

## 🚀 快速安裝（Windows）

**單行 PowerShell 指令：**

```powershell
iwr -useb https://raw.githubusercontent.com/meicy321/claude-code-statusline/main/install-statusline.ps1 | iex
```

然後重新啟動 Claude Code！

## 📋 系統需求

- **jq** - JSON 解析器（使用 `scoop install jq` 安裝或從 [jqlang.github.io](https://jqlang.github.io/jq/download/) 下載）
- **Git** - 用於分支和差異統計
- **Git Bash** - 通常隨 Git for Windows 一起安裝

## 🎨 自訂設定

安裝後，編輯 `~/.claude/statusline-command.sh` 來自訂：

```bash
# 更改表情符號（第 15 行）
EMOJI_STR="😊🥗"  # 改成你喜歡的！

# 切換功能（第 16-23 行）
SHOW_MODEL=true
SHOW_CONTEXT_BAR=true
SHOW_RATE_5H=true
SHOW_RATE_7D=true
SHOW_GIT_BRANCH=true
SHOW_GIT_DIFF=true
SHOW_PROJECT=true
SHOW_LAST_MSG=true
```

## 📸 預覽

```
☁️ 💙  │ Sonnet 4.5 │ ██░░░░░░░░░░ 17% │ 4H56m 1% used │ 4D23H 23% used
master* │ +42 │ Video_to_action │ 📝 2026-04-26 14:52 │ 🕐 session:2m
```

## 🛠️ 手動安裝

如果你偏好手動安裝：

1. **下載狀態列腳本：**
   ```bash
   curl -o ~/.claude/statusline-command.sh https://raw.githubusercontent.com/meicy321/claude-code-statusline/main/statusline-command.sh
   ```

2. **下載會話鉤子：**
   ```bash
   mkdir -p ~/.claude/hooks
   curl -o ~/.claude/hooks/session-start.sh https://raw.githubusercontent.com/meicy321/claude-code-statusline/main/hooks/session-start.sh
   ```

3. **更新 settings.json**（`~/.claude/settings.json`）：
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

4. **重新啟動 Claude Code**

## 🐛 疑難排解

**沒有顯示狀態列：**
- 確保你已經重新啟動 Claude Code（完全關閉並重新開啟）
- 檢查 `jq` 是否已安裝：`jq --version`
- 確認腳本存在：`ls ~/.claude/statusline-command.sh`

**沒有顯示百分比：**
- 安裝 `jq`：`scoop install jq`
- 安裝 jq 後重新啟動 Claude Code

**沒有顯示會話持續時間：**
- 確保 SessionStart 鉤子已安裝並在 settings.json 中設定

## 📝 致謝

基於 [Raymond Hou 的 Starter Kit #06](https://github.com/Raymondhou0917/claude-code-resources)  
由 Meicy 自訂與打包

## 📄 授權

CC BY-NC-SA 4.0 - 免費供個人使用，禁止商業用途
