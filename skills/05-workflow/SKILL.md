---
name: antigravity-workflow
description: 開工/收工/新專案初始化。說「開工」「開始工作」「我來了」「動工」「上工」「開工啦」「繼續」「回來」「收工」「下班」「結束」「休息」「今天就到這」「先這樣」「關機」「打包」「初始化專案」「新專案」「開新專案」「建立專案」「起新案」時載入。
---

# 開工 / 收工 / 新專案初始化（跨 Agent 版）

> 完整定義見 repo 根目錄 `MASTER-WORKFLOW.md`。本 skill 為各 Agent 的可載入版本。
> 核心原則：我（Arno）跨 Agent（Claude Code / Codex / OpenCode / AntiGravity）、跨電腦工作。
> 專案進度用根目錄 **STATUS.md** 接力，里程碑寫進 **Obsidian 第二大腦**。

## 跨 Agent 共用狀態檔 STATUS.md（每個專案唯一真相來源）

每個專案根目錄放 `STATUS.md`，是**所有 Agent、所有電腦共用的唯一真相來源**。任何 agent 在任何電腦打開專案先讀它。
格式：**同步對應表**（專案相對路徑 / git 遠端 URL / Obsidian 筆記 / Google Drive 備份 / 使用的 Agent）/ 完成事項 / 下一步 / 踩坑紀錄 / 環境狀態 / 最後更新（時間 + 更新者）。
「更新者」填當前 Agent 名稱，讓下一個 Agent 知道是誰接力的。

> **黃金原則**：實質內容只寫 STATUS.md 一份；各 agent 的 `CLAUDE.md`/`AGENTS.md`/`ANTIGRAVITY.md` **薄化成指標**，只寫「狀態與路徑請讀 STATUS.md」，不重複寫內容（避免多檔不同步）。
> **跨電腦零落差**：同步對應表不寫死本機絕對路徑（各機家目錄不同），用 `~` 相對描述 + git URL，換電腦 clone 照表重建。

## 開工
0. **詢問第二大腦同步來源**：「(G) GitHub `git pull` `my-second-brain` / (D) Google Drive 確認 / (S) 跳過」→ 依選擇執行。
1. **讀取專案基本資訊**：讀取專案根目錄的 `CLAUDE.md` / `AGENTS.md` / `ANTIGRAVITY.md`（存在哪個讀哪個）。
2. **讀取 STATUS.md**：讀取專案根目錄 `STATUS.md` 了解上個 Agent 做到哪；沒有就視為新專案。
3. **讀取專案筆記**：用 Obsidian MCP 或檔案工具讀取專案駕駛艙筆記的**實際內容**，不可只列檔名。
4. **分析與展示狀態**：回應中展示「目前狀態」「完成/待辦」「下一步/踩坑」。
5. **檢查 Git**：`git status` 與 `git log --oneline -5`。
6. **詢問是否 git pull**：使用者說好才執行。
7. **回報與建議**：彙整回報，不自動 commit/push。

## 收工
> **原則：工作內容自動推導、不要問使用者；收工唯一要問的是「同步推到哪裡」。**
1. **安全檢查**：確保沒有上傳 API key、token、密碼、Firebase 憑證、個資。
2. **自動推導今日紀錄（不要問使用者）**：從本次對話自行整理「完成事項 / 下一步 / 踩坑」。只有在對話完全無法判斷「下一步」時才簡短問一句，其餘一律自行歸納。
3. **更新 STATUS.md**：寫入專案根目錄，含「更新者 = 當前 Agent」。
4. **更新 Obsidian 駕駛艙**：里程碑與踩坑知識寫進 `SecondBrain\<專案名稱>.md`。
5. **詢問同步管道（收工唯一要問使用者的事）**：「要推到哪裡？(G) 只 GitHub /(D) 只 Google Drive /(B) 兩者」。
   - 用 `~/.claude/machine-config.json` 的 `machineType` 決定**預設選項**：`home`→預設 (B) 兩者；`company`→預設 (G) 只 GitHub（Google Drive 被封鎖）。使用者直接 Enter 即採預設。
   - 設定檔不存在 → 先問一次「這是家用電腦嗎？(Y/N)」，家用再偵測 Google Drive，寫入設定檔記住，之後不再問身分。
   - **GitHub**（選 G/B）：專案代碼 `git diff` 確認後只 stage 相關檔案（不用 `git add .`）commit + push；第二大腦切到 vault commit + push 到 `my-second-brain`。
   - **Google Drive**（選 D/B）：第二大腦 vault 與專案資料夾複製到 `googleDrivePath\SecondBrain`（不存在自動建立）；若 `googleDriveInstalled:false` 先提醒安裝、本次改走 GitHub。
6. **chezmoi 同步**（若有用 dotfiles）：`~/.config/opencode/` 等有變動時 `chezmoi add` + `chezmoi apply`。
7. **同步回報**：回報 STATUS.md / Obsidian / 專案代碼 / 第二大腦走了哪個管道。

## 新專案初始化
1. **資訊詢問**（用互動式卡片）：專案名稱、用途、工作資料夾路徑、是否建 GitHub repo（私有/公開/不要）、是否 Google Drive 備份。
2. **自動尋找 Obsidian Vault 路徑**：優先讀 `C:\Users\HsiuH許家修\.gemini\antigravity\mcp_config.json` 的 `mcp.obsidian.command`，解析出 vault 路徑（`C:\Users\HsiuH許家修\Documents\SecondBrain`）；讀到就不再問路徑。
3. **自動建立**（已存在則補齊、不覆蓋）：
   - **`STATUS.md`＝唯一真相**：套用上方格式並**填好同步對應表**（專案相對路徑、Git 遠端 URL、Obsidian 筆記、Google Drive 備份、使用的 Agent）。專案實質資訊只寫這份。
   - **各 agent 入口檔薄化、不重複內容**：Claude→`CLAUDE.md`、Codex/OpenCode→`AGENTS.md`、AntiGravity→`ANTIGRAVITY.md`，內容固定一句「規範見全域工作流程；狀態與路徑讀 STATUS.md」。一次把會用到的 agent 入口都建好。
   - `README.md`、`.gitignore`（排除敏感檔與編譯產物）
   - 初始化本地 Git；需要時 `gh repo create`，把遠端 URL 回填 STATUS.md 對應表
   - 在 Obsidian Vault 下建立「<專案名稱>.md」駕駛艙筆記
   - **驗收**：STATUS.md 對應表無本機絕對路徑（用 `~` + git URL）→ 換電腦 clone 即可無落差接手。
