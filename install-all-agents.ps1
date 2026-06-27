# ============================================================
# Arno 的跨 Agent 懶人包一鍵安裝腳本（四 agent 通用）
# 來源：https://github.com/arnohsu-0930/cross-agent-workflow
# 一鍵執行：irm https://raw.githubusercontent.com/arnohsu-0930/cross-agent-workflow/main/install-all-agents.ps1 | iex
# 會安裝：Claude Code / Codex / OpenCode / AntiGravity 四個 agent 的全域工作流程
# ============================================================

$GITHUB_USER = "arnohsu-0930"
$SECOND_BRAIN_REPO = "my-second-brain"
$VAULT_PATH = "$env:USERPROFILE\Documents\SecondBrain"
$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$SKILLS_DIR = "$CLAUDE_DIR\skills"
$CONFIG_FILE = "$CLAUDE_DIR\machine-config.json"

Write-Host "`n=== Arno 跨 Agent 懶人包安裝（Claude Code / Codex / OpenCode / AntiGravity）===" -ForegroundColor Cyan

# ── 0. 家用 / 公司電腦偵測（寫進 machine-config.json，記住身分）──
Write-Host "`n[0/7] 判斷電腦類型..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force $CLAUDE_DIR | Out-Null
$machineConfig = @{}
if (Test-Path $CONFIG_FILE) {
    $machineConfig = Get-Content $CONFIG_FILE -Raw | ConvertFrom-Json
    Write-Host "  已有設定：machineType = $($machineConfig.machineType)" -ForegroundColor Green
} else {
    $answer = Read-Host "  這是家用電腦嗎？(Y=家用 / N=公司)"
    $isHome = $answer -match '^[Yy]'
    $cfg = [ordered]@{
        machineName         = $env:COMPUTERNAME
        machineType         = if ($isHome) { "home" } else { "company" }
        syncMode            = if ($isHome) { "both" } else { "github" }
        githubEnabled       = $true
        googleDriveInstalled= $false
        googleDrivePath     = ""
        vaultPath           = $VAULT_PATH
    }
    if ($isHome) {
        $gdPaths = @("$env:USERPROFILE\Google Drive","$env:USERPROFILE\GoogleDrive","G:\My Drive","G:\我的雲端硬碟","C:\Google Drive")
        $gd = $gdPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
        if ($gd) {
            $cfg.googleDriveInstalled = $true; $cfg.googleDrivePath = $gd
            Write-Host "  家用電腦，偵測到 Google Drive：$gd → 收工同步 GitHub + Google Drive" -ForegroundColor Green
        } else {
            Write-Host "  家用電腦，但未偵測到 Google Drive for Desktop。" -ForegroundColor Yellow
            Write-Host "  → 收工暫時只走 GitHub；裝好登入後把 machine-config 的 googleDriveInstalled 改 true 即自動雙同步。" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  公司電腦 → 收工只走 GitHub（Google Drive 被封鎖）。" -ForegroundColor Green
    }
    $machineConfig = [pscustomobject]$cfg
    $machineConfig | ConvertTo-Json | Set-Content $CONFIG_FILE -Encoding utf8
    Write-Host "  已記住身分：$CONFIG_FILE" -ForegroundColor Green
}

# ── 1. 安裝 gh CLI ──
Write-Host "`n[1/7] 安裝 GitHub CLI..." -ForegroundColor Yellow
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    winget install GitHub.cli --silent --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else { Write-Host "  已安裝，略過" -ForegroundColor Green }

# ── 2. 安裝 Obsidian ──
Write-Host "`n[2/7] 安裝 Obsidian..." -ForegroundColor Yellow
if (-not (Get-Command obsidian -ErrorAction SilentlyContinue)) {
    winget install Obsidian.Obsidian --silent --accept-package-agreements --accept-source-agreements
} else { Write-Host "  已安裝，略過" -ForegroundColor Green }

# ── 3. GitHub 認證 ──
Write-Host "`n[3/7] 檢查 GitHub 認證..." -ForegroundColor Yellow
if ((gh auth status 2>&1) -match "not logged") {
    Write-Host "  開啟瀏覽器進行認證（複製畫面驗證碼，按 Authorize）..." -ForegroundColor Magenta
    gh auth login --web --hostname github.com --git-protocol https
} else { Write-Host "  已登入，略過" -ForegroundColor Green }

# ── 4. 同步第二大腦 ──
Write-Host "`n[4/7] 同步第二大腦..." -ForegroundColor Yellow
if (-not (Test-Path $VAULT_PATH)) {
    gh repo clone "$GITHUB_USER/$SECOND_BRAIN_REPO" $VAULT_PATH
    Write-Host "  Clone 完成：$VAULT_PATH" -ForegroundColor Green
} else {
    Push-Location $VAULT_PATH; git pull; Pop-Location
    Write-Host "  git pull 完成" -ForegroundColor Green
}

# ── 5. 取得懶人包最新內容 ──
Write-Host "`n[5/7] 取得懶人包最新內容..." -ForegroundColor Yellow
$tmpDir = "$env:TEMP\caw-install"
if (Test-Path $tmpDir) { Remove-Item $tmpDir -Recurse -Force }
gh repo clone "$GITHUB_USER/cross-agent-workflow" $tmpDir 2>&1 | Out-Null
$master = "$tmpDir\MASTER-WORKFLOW.md"
$header = "> 本檔由 cross-agent-workflow 懶人包自動安裝。真相來源：https://github.com/$GITHUB_USER/cross-agent-workflow`n`n"

# ── 6. 裝進選定的 Agent 的全域設定（先問要裝哪幾個）──
Write-Host "`n[6/7] 要安裝到哪些 Agent？" -ForegroundColor Yellow
Write-Host "  1 = Claude Code   2 = Codex   3 = OpenCode   4 = AntiGravity"
$sel = Read-Host "  輸入代號(可多選，逗號分隔，例 1,2,4)；直接 Enter = 全部"
if ([string]::IsNullOrWhiteSpace($sel)) {
    $picks = @("1","2","3","4")
} else {
    $picks = $sel -split '[,\s]+' | Where-Object { $_ -match '^[1-4]$' }
}
if (-not $picks) { Write-Host "  沒有有效選擇，預設全部裝。" -ForegroundColor Yellow; $picks = @("1","2","3","4") }
Write-Host "  將安裝：$($picks -join ', ')" -ForegroundColor Green

# 6a. Claude Code → ~/.claude/CLAUDE.md + skills/
if ($picks -contains "1") {
    Copy-Item $master "$CLAUDE_DIR\CLAUDE.md" -Force
    New-Item -ItemType Directory -Force $SKILLS_DIR | Out-Null
    Get-ChildItem "$tmpDir\skills" -Recurse -Filter "SKILL.md" | ForEach-Object {
        $name = $_.Directory.Name -replace '^\d+-', ''
        Copy-Item $_.FullName "$SKILLS_DIR\$name.md" -Force
    }
    Write-Host "  ✅ Claude Code：CLAUDE.md + skills/" -ForegroundColor Green
}

# 6b. Codex → ~/.codex/AGENTS.md
if ($picks -contains "2") {
    $codexDir = "$env:USERPROFILE\.codex"
    New-Item -ItemType Directory -Force $codexDir | Out-Null
    ($header + (Get-Content $master -Raw)) | Set-Content "$codexDir\AGENTS.md" -Encoding utf8
    Write-Host "  ✅ Codex：~/.codex/AGENTS.md" -ForegroundColor Green
}

# 6c. OpenCode → ~/.config/opencode/AGENTS.md
if ($picks -contains "3") {
    $opencodeDir = "$env:USERPROFILE\.config\opencode"
    New-Item -ItemType Directory -Force $opencodeDir | Out-Null
    ($header + (Get-Content $master -Raw)) | Set-Content "$opencodeDir\AGENTS.md" -Encoding utf8
    Write-Host "  ✅ OpenCode：~/.config/opencode/AGENTS.md" -ForegroundColor Green
    Write-Host "  ⚠️  OpenCode 程式本體需自行安裝（本腳本只裝設定檔）：" -ForegroundColor Yellow
    Write-Host "       npm install -g opencode-ai" -ForegroundColor Yellow
    Write-Host "     若尚未安裝 Node.js，請先至 https://nodejs.org 下載安裝。" -ForegroundColor Yellow
}

# 6d. AntiGravity → ~/.gemini/antigravity/global_skills/
if ($picks -contains "4") {
    $agDir = "$env:USERPROFILE\.gemini\antigravity\global_skills\antigravity-workflow"
    New-Item -ItemType Directory -Force $agDir | Out-Null
    $wf = "$tmpDir\skills\05-workflow\SKILL.md"
    if (Test-Path $wf) { Copy-Item $wf "$agDir\SKILL.md" -Force }
    Get-ChildItem "$tmpDir\skills" -Recurse -Filter "SKILL.md" | ForEach-Object {
        $name = $_.Directory.Name
        $dest = "$env:USERPROFILE\.gemini\antigravity\global_skills\$name"
        New-Item -ItemType Directory -Force $dest | Out-Null
        Copy-Item $_.FullName "$dest\SKILL.md" -Force
    }
    Write-Host "  ✅ AntiGravity：~/.gemini/antigravity/global_skills/" -ForegroundColor Green
    Write-Host "  ⚠️  AntiGravity 程式本體需自行安裝（本腳本只裝技能設定檔）：" -ForegroundColor Yellow
    Write-Host "       請至官方網站下載並安裝 AntiGravity 2.0 桌面版（aa2.0）。" -ForegroundColor Yellow
    Write-Host "       安裝後，aa2.0 啟動時會自動讀取 ~/.gemini/antigravity/global_skills/ 裡的技能。" -ForegroundColor Yellow
}

Remove-Item $tmpDir -Recurse -Force

# ── 7. 完成報告 ──
Write-Host "`n[7/7] 完成！" -ForegroundColor Cyan
Write-Host "`n=== 安裝完成 ===" -ForegroundColor Cyan
$mt = if ($machineConfig.machineType) { $machineConfig.machineType } else { "?" }
Write-Host "電腦類型：$mt（home=GitHub+GoogleDrive / company=只GitHub）"
Write-Host "第二大腦：$VAULT_PATH"
$names = @{ "1"="Claude Code"; "2"="Codex"; "3"="OpenCode"; "4"="AntiGravity" }
$installed = ($picks | ForEach-Object { $names[$_] }) -join " / "
Write-Host "本次安裝的 Agent：$installed"
Write-Host "`n以上 agent 現在都會自動遵守開工/收工/初始化流程，並用 STATUS.md 接力。"
Write-Host "`n── 注意事項 ──" -ForegroundColor Cyan
Write-Host "本腳本只安裝「工作流程設定檔」，以下程式本體需自行安裝（裝過就不用重裝）：" -ForegroundColor Yellow
if ($picks -contains "3") { Write-Host "  • OpenCode 程式本體：npm install -g opencode-ai（需先裝 Node.js）" -ForegroundColor Yellow }
if ($picks -contains "4") { Write-Host "  • AntiGravity 2.0（aa2.0）桌面版：請至官方網站下載安裝" -ForegroundColor Yellow }
Write-Host "`ngh CLI 已安裝於本次 PowerShell 工作階段。若新開終端機找不到 gh 指令，請重開 PowerShell 即可（winget 已寫入系統 PATH，重開後自動生效）。" -ForegroundColor Cyan
Write-Host "可選追加：NotebookLM (uv tool install notebooklm-mcp-cli && nlm login)、MCPVault (npm install -g @bitbonsai/mcpvault)"
