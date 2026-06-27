# cross-agent-workflow STATUS

## 完成事項
- 家用電腦（DESKTOP-GDHOP9T）一鍵腳本安裝完成：Claude Code + OpenCode + AntiGravity 三 agent 設定檔
- 環境到位：gh CLI v2.95.0（已登入 arnohsu-0930）、Obsidian 1.12.7、SecondBrain vault、machine-config 記為 home
- 腳本補強：裝完設定檔後提示程式本體需自裝、gh PATH 需重開 PowerShell（commit e010cc7）
- 收工流程定案：工作內容自動推導、只問同步管道（G/D/B），改 MASTER-WORKFLOW 與 05-workflow SKILL（commit e6b9050、72b5eef）
- 修正中文亂碼根因：Codex/OpenCode 設定檔改用明確 UTF8 讀寫，抽出 Write-Utf8 函式（commit 92d0296）
- 本機壞掉的 OpenCode AGENTS.md 已用正確 UTF8 重建

## 下一步
- 自行安裝 OpenCode 程式本體：`npm install -g opencode-ai`（需先有 Node.js）
- 自行安裝 AntiGravity 2.0 桌面版
- Codex 訂閱後完成全域安裝
- 各 Agent 開新對話驗收「開工」與新版「收工」流程

## 踩坑紀錄
- gh 用 winget 裝好後，同一個 PowerShell 視窗找不到 gh（PATH 未刷新）→ 重開 PowerShell 即可
- 一鍵腳本只裝設定檔、不裝程式本體，OpenCode / AntiGravity 要另外自行安裝
- PowerShell 5.1 在中文 Windows 用 `Get-Content -Raw`（無 -Encoding）讀 UTF-8 會變 CP950 亂碼 → 已改 `[IO.File]::ReadAllText/WriteAllText` 明確 UTF8

## 環境狀態
- 機器：DESKTOP-GDHOP9T（home，syncMode=both，但 googleDriveInstalled=false）
- 已裝設定檔：Claude Code（~/.claude）、OpenCode（~/.config/opencode）、AntiGravity（~/.gemini/antigravity/global_skills）
- 待裝程式本體：OpenCode、AntiGravity 2.0 桌面版

## 最後更新
- 時間：2026-06-27
- 更新者：Claude Code
