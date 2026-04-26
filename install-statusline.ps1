# ═══════════════════════════════════════════════════════════════
# Meicy's Claude Code Statusline - One-Line Installer
# ═══════════════════════════════════════════════════════════════
# Usage: iwr -useb YOUR-GITHUB-RAW-URL/install-statusline.ps1 | iex
# ═══════════════════════════════════════════════════════════════

Write-Host "🎨 Installing Meicy's Claude Code Statusline..." -ForegroundColor Cyan

# Paths
$claudeDir = "$HOME\.claude"
$statuslineScript = "$claudeDir\statusline-command.sh"
$settingsFile = "$claudeDir\settings.json"
$hooksDir = "$claudeDir\hooks"
$sessionStartFile = "$hooksDir\session-start.sh"

# Create .claude directory if it doesn't exist
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
}

# Create hooks directory if it doesn't exist
if (-not (Test-Path $hooksDir)) {
    New-Item -ItemType Directory -Path $hooksDir -Force | Out-Null
}

# Download statusline script
Write-Host "📥 Downloading statusline script..." -ForegroundColor Yellow
$statuslineUrl = "https://raw.githubusercontent.com/meicy321/claude-code-statusline/main/statusline-command.sh"
try {
    Invoke-WebRequest -Uri $statuslineUrl -OutFile $statuslineScript
    Write-Host "✅ Statusline script installed to: $statuslineScript" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to download statusline script: $_" -ForegroundColor Red
    exit 1
}

# Download session-start hook
Write-Host "📥 Downloading session-start hook..." -ForegroundColor Yellow
$hookUrl = "https://raw.githubusercontent.com/meicy321/claude-code-statusline/main/hooks/session-start.sh"
try {
    Invoke-WebRequest -Uri $hookUrl -OutFile $sessionStartFile
    Write-Host "✅ Session-start hook installed" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Session-start hook download failed (optional): $_" -ForegroundColor Yellow
}

# Update settings.json
Write-Host "⚙️  Configuring settings.json..." -ForegroundColor Yellow

if (Test-Path $settingsFile) {
    # Read existing settings
    $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
} else {
    # Create new settings object
    $settings = @{
        '$schema' = "https://json.schemastore.org/claude-code-settings.json"
    } | ConvertTo-Json | ConvertFrom-Json
}

# Add statusLine configuration
$settings | Add-Member -MemberType NoteProperty -Name "statusLine" -Value @{
    type = "command"
    command = "bash ~/.claude/statusline-command.sh"
} -Force

# Add SessionStart hook if session-start.sh was downloaded successfully
if (Test-Path $sessionStartFile) {
    if (-not $settings.hooks) {
        $settings | Add-Member -MemberType NoteProperty -Name "hooks" -Value @{} -Force
    }
    $settings.hooks | Add-Member -MemberType NoteProperty -Name "SessionStart" -Value @(
        @{
            type = "command"
            command = "bash ~/.claude/hooks/session-start.sh"
        }
    ) -Force
}

# Save settings
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile -Encoding UTF8
Write-Host "✅ settings.json updated" -ForegroundColor Green

# Check for jq
Write-Host "`n🔍 Checking dependencies..." -ForegroundColor Yellow
$jqPath = Get-Command jq -ErrorAction SilentlyContinue
if (-not $jqPath) {
    Write-Host "⚠️  'jq' is required but not found." -ForegroundColor Yellow
    Write-Host "   Install it with: scoop install jq" -ForegroundColor Cyan
    Write-Host "   Or download from: https://jqlang.github.io/jq/download/" -ForegroundColor Cyan
} else {
    Write-Host "✅ jq is installed: $($jqPath.Source)" -ForegroundColor Green
}

# Final instructions
Write-Host "`n" -NoNewline
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  🎉 Installation Complete!                                ║" -ForegroundColor Cyan
Write-Host "╠═══════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
Write-Host "║                                                           ║" -ForegroundColor Cyan
Write-Host "║  Next steps:                                              ║" -ForegroundColor White
Write-Host "║  1. Restart Claude Code to see your new statusline        ║" -ForegroundColor White
Write-Host "║  2. Customize emojis in:                                  ║" -ForegroundColor White
Write-Host "║     $HOME\.claude\statusline-command.sh              ║" -ForegroundColor Gray
Write-Host "║                                                           ║" -ForegroundColor Cyan
Write-Host "║  Your statusline will show:                               ║" -ForegroundColor White
Write-Host "║  • Model name                                             ║" -ForegroundColor White
Write-Host "║  • Context window usage (colored progress bar)            ║" -ForegroundColor White
Write-Host "║  • 5-hour & 7-day rate limits                             ║" -ForegroundColor White
Write-Host "║  • Git branch & diff stats                                ║" -ForegroundColor White
Write-Host "║  • Project name                                           ║" -ForegroundColor White
Write-Host "║  • Last message time & session duration                   ║" -ForegroundColor White
Write-Host "║                                                           ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
