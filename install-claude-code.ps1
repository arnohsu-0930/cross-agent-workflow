# ============================================================
# Arno 的 Claude Code 懶人包一鍵安裝腳本
# 來源：https://github.com/arnohsu-0930/cross-agent-workflow
# 用法：以 PowerShell 執行此腳本（需先有 git）
# ============================================================

$GITHUB_USER = "arnohsu-0930"
$SECOND_BRAIN_REPO = "my-second-brain"
$VAULT_PATH = "$env:USERPROFILE\Documents\SecondBrain"
$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$SKILLS_DIR = "$CLAUDE_DIR\skills"
$CONFIG_FILE = "$CLAUDE_DIR\machine-config.json"

Write-Host "`n=== Arno 懶人包安裝開始 ===" -ForegroundColor Cyan

# ── 0. 家用 / 公司電腦偵測 ──
Write-Host "`n[0/6] 判斷電腦類型..." -ForegroundColor Yellow
$machineConfig = @{}

if (Test-Path $CONFIG_FILE) {
    $machineConfig = Get-Content $CONFIG_FILE | ConvertFrom-Json -AsHashtable -ErrorAction SilentlyContinue
    if (-not $machineConfig) { $machineConfig = @{} }
    Write-Host "  已有設定：$($machineConfig | ConvertTo-Json -Compress)" -ForegroundColor Green
} else {
    $answer = Read-Host "  這是家用電腦嗎？(Y/N)"
    $isHome = $answer -match '^[Yy]'
    $machineConfig["isHome"] = $isHome
    $machineConfig["machineName"] = $env:COMPUTERNAME

    if ($isHome) {
        # 偵測 Google Drive
        $gdPaths = @(
            "$env:USERPROFILE\Google Drive",
            "$env:USERPROFILE\GoogleDrive",
            "C:\Google Drive"
        )
        $gdPath = $gdPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

        if ($gdPath) {
            Write-Host "  偵測到 Google Drive：$gdPath" -ForegroundColor Green
            $machineConfig["googleDrivePath"] = $gdPath
        } else {
            Write-Host "  未偵測到 Google Drive，請確認已安裝並登入 Google Drive for Desktop" -ForegroundColor Yellow
            $gdManual = Read-Host "  Google Drive 路徑（直接 Enter 略過）"
            if ($gdManual) { $machineConfig["googleDrivePath"] = $gdManual }
        }
        $machineConfig["syncMode"] = "both"   # GitHub + Google Drive
    } else {
        $machineConfig["syncMode"] = "github"  # 僅 GitHub
        Write-Host "  公司電腦模式：僅同步 GitHub" -ForegroundColor Green
    }

    $machineConfig | ConvertTo-Json | Set-Content $CONFIG_FILE -Encoding utf8
    Write-Host "  設定已儲存：$CONFIG_FILE" -ForegroundColor Green
}

# ── 1. 安裝 gh CLI ──
Write-Host "`n[1/6] 安裝 GitHub CLI..." -ForegroundColor Yellow
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue
if (-not $ghInstalled) {
    winget install GitHub.cli --silent --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else { Write-Host "  gh CLI 已安裝 ($(gh --version | Select-Object -First 1))，略過" -ForegroundColor Green }

# ── 2. 安裝 Obsidian ──
Write-Host "`n[2/6] 安裝 Obsidian..." -ForegroundColor Yellow
$obsPath = Get-Command obsidian -ErrorAction SilentlyContinue
if (-not $obsPath) {
    winget install Obsidian.Obsidian --silent --accept-package-agreements --accept-source-agreements
    Write-Host "  Obsidian 安裝完成" -ForegroundColor Green
} else { Write-Host "  Obsidian 已安裝，略過" -ForegroundColor Green }

# ── 3. GitHub 認證 ──
Write-Host "`n[3/6] 檢查 GitHub 認證..." -ForegroundColor Yellow
$authStatus = gh auth status 2>&1
if ($authStatus -match "not logged") {
    Write-Host "  開啟瀏覽器進行認證..." -ForegroundColor Magenta
    gh auth login --web --hostname github.com
} else { Write-Host "  已登入 GitHub，略過" -ForegroundColor Green }

# ── 4. Clone my-second-brain ──
Write-Host "`n[4/6] 同步第二大腦..." -ForegroundColor Yellow
if (-not (Test-Path $VAULT_PATH)) {
    New-Item -ItemType Directory -Force (Split-Path $VAULT_PATH) | Out-Null
    gh repo clone "$GITHUB_USER/$SECOND_BRAIN_REPO" $VAULT_PATH
    Write-Host "  Clone 完成：$VAULT_PATH" -ForegroundColor Green
} else {
    Push-Location $VAULT_PATH
    git pull
    Pop-Location
    Write-Host "  git pull 完成：$VAULT_PATH" -ForegroundColor Green
}

# ── 5. 安裝 Claude Code 全域設定 ──
Write-Host "`n[5/6] 安裝 Claude Code 全域設定..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force $SKILLS_DIR | Out-Null

$tmpDir = "$env:TEMP\cross-agent-workflow"
if (Test-Path $tmpDir) { Remove-Item $tmpDir -Recurse -Force }
gh repo clone "$GITHUB_USER/cross-agent-workflow" $tmpDir

Copy-Item "$tmpDir\MASTER-WORKFLOW.md" "$CLAUDE_DIR\CLAUDE.md" -Force
Write-Host "  CLAUDE.md 已更新" -ForegroundColor Green

Get-ChildItem "$tmpDir\skills" -Recurse -Filter "SKILL.md" | ForEach-Object {
    $skillName = $_.Directory.Name -replace '^\d+-', ''
    Copy-Item $_.FullName "$SKILLS_DIR\$skillName.md" -Force
    Write-Host "  Skill 安裝：$skillName" -ForegroundColor Green
}
Remove-Item $tmpDir -Recurse -Force

# ── 6. Google Drive 同步（家用電腦）──
if ($machineConfig["isHome"] -and $machineConfig["googleDrivePath"]) {
    Write-Host "`n[6/6] 同步到 Google Drive..." -ForegroundColor Yellow
    $gdSecondBrain = "$($machineConfig['googleDrivePath'])\SecondBrain"
    if (-not (Test-Path $gdSecondBrain)) { New-Item -ItemType Directory -Force $gdSecondBrain | Out-Null }
    Copy-Item "$VAULT_PATH\*" $gdSecondBrain -Recurse -Force
    Write-Host "  Google Drive 同步完成：$gdSecondBrain" -ForegroundColor Green
} else {
    Write-Host "`n[6/6] 公司電腦，略過 Google Drive 同步" -ForegroundColor Gray
}

# ── 完成報告 ──
Write-Host "`n=== 安裝完成 ===" -ForegroundColor Cyan
Write-Host "電腦類型：$(if ($machineConfig['isHome']) { '家用（GitHub + Google Drive）' } else { '公司（僅 GitHub）' })"
Write-Host "Vault 路徑：$VAULT_PATH"
Write-Host "CLAUDE.md：$CLAUDE_DIR\CLAUDE.md"
Write-Host "Skills：$SKILLS_DIR"
Write-Host "`n可選追加安裝："
Write-Host "  NotebookLM：uv tool install notebooklm-mcp-cli && nlm login"
Write-Host "  MCPVault  ：npm install -g @bitbonsai/mcpvault"
Write-Host "  開啟 Obsidian，Vault 指向 $VAULT_PATH"
