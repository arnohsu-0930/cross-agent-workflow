# Anti-Gravity 懶人包 #09：服務連接與工作流程設定

> 版本：v1.5
> 更新日期：2026-06-08
> 語系偏好：繁體中文（Taiwan）

這份懶人包的目標，是讓 Anti-Gravity 使用者能安全連接 NotebookLM、Firebase、GitHub、Obsidian，並建立「開工 / 收工 / 新專案初始化」工作流程。本版本已加回了 Obsidian MCPVault 一鍵整合，並新增了開收工時的「雙備份同步選項（GitHub + Google Drive）」以及「Windows 繁體中文環境下全域技能疑難排解指南」。

---

## 先備條件

- [ ] 已安裝 Anti-Gravity 或可使用 MCP 的 AI 編碼助理
- [ ] 已安裝 Git
- [ ] 已安裝 GitHub CLI（`gh`）
- [ ] 已安裝 Node.js / npm
- [ ] 已安裝 Python 或 `uv`
- [ ] 有 Google 帳號，可登入 NotebookLM / Firebase
- [ ] 有 GitHub 帳號
- [ ] 已有 Obsidian vault，或知道筆記本資料夾位置

---

## 一、連接 NotebookLM

### 安裝 NotebookLM MCP CLI

建議優先用 `uv` 安裝：
```powershell
uv tool install notebooklm-mcp-cli
nlm --version
```

### 重新登入 Google 帳號
```powershell
nlm logout
nlm login
```
驗證：
```powershell
nlm doctor
nlm list
```

### 註冊 MCP
在 `C:\Users\<使用者>\.gemini\antigravity\mcp_config.json` 中加入：
```json
{
  "mcp": {
    "notebooklm": {
      "type": "local",
      "command": ["nlm", "mcp"],
      "enabled": true
    }
  }
}
```

---

## 二、連接 GitHub

### 登入 GitHub CLI
```powershell
gh auth status
gh auth login --web --git-protocol https
```

### 設定 Git 使用者
```powershell
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

---

## 三、連接 Firebase

### 安裝與登入
```powershell
npx.cmd -y firebase-tools@latest login
npx.cmd -y firebase-tools@latest projects:list
```

### 註冊 Firebase MCP
在 `mcp_config.json` 中加入：
```json
{
  "mcp": {
    "firebase": {
      "type": "local",
      "command": ["npx.cmd", "-y", "firebase-tools@latest", "mcp"],
      "enabled": true
    }
  }
}
```

---

## 四、連接 Obsidian

### 安裝 MCPVault
```powershell
npm.cmd install -g @bitbonsai/mcpvault
where.exe mcpvault
```

### 註冊 Obsidian MCP
在 `mcp_config.json` 中加入您的 Obsidian Vault 路徑：
```json
{
  "mcp": {
    "obsidian": {
      "type": "local",
      "command": [
        "C:\\Users\\<使用者>\\AppData\\Roaming\\npm\\mcpvault.cmd",
        "C:\\Users\\<使用者>\\Documents\\SecondBrain"
      ],
      "enabled": true
    }
  }
}
```

---

## 五、生圖

建議提示格式：
```text
生成一張圖片：
用途：
尺寸比例：
主題：
畫面內容：
風格：
色彩：
限制：
輸出位置：
```

---

## 六、開工 / 收工 / 新專案初始化工作流

### 1. 開工 (Start Work)
使用者說「開工」時，AI 應：
1. 讀取專案根目錄的 `ANTIGRAVITY.md`。
2. 讀取 Obsidian 專案駕駛艙。
3. 執行 `git status` 與最近 commit 檢查。
4. 回報目前狀態與建議下一步，不自動 pull/commit/push。

### 2. 收工 (Finish Work) — 支援雙重同步管道
使用者說「收工」時，AI 應：
1. **安全檢查**：檢查敏感資料（API key、token、憑證、學生真名），嚴禁提交至 GitHub。
2. **更新筆記**：更新 Obsidian 專案駕駛艙（寫入完成事項、下一步、踩坑）。
3. **詢問同步備份方式**：主動詢問使用者：**「請問您今天的筆記要同步到：(1) GitHub (2) Google Drive (3) 兩者皆同步？」**
   - **選 GitHub**：將專案代碼與筆記 Git Commit 並 Push 到您的 GitHub 儲存庫。
   - **選 Google Drive**：若 `ANTIGRAVITY.md` 中有設定 Google Drive 備份路徑，自動將筆記檔案複製到對應的雲端硬碟同步資料夾中。
   - **選 兩者皆同步**：同時執行上述兩項操作。
4. **Git 提交**：檢查 `git status` 與 diff，只 stage 相關檔案，拒絕 `git add .` 無差別提交。
5. **回報狀態**：回報同步結果。

### 3. 新專案初始化 (Project Initialization)
當使用者在**任何空資料夾**說「初始化專案」時，AI 應：
1. 詢問專案名稱、用途、是否需要 GitHub 儲存庫、是否需要 Google Drive 備份。
2. 建立並補齊：
   - `ANTIGRAVITY.md`
   - `README.md`
   - `.gitignore`
   - 本地 Git 儲存庫與雲端 GitHub 連結（若需要）
   - Obsidian 專案駕駛艙筆記

---

## 建議的 ANTIGRAVITY.md 範本

```markdown
# <專案名稱> - ANTIGRAVITY.md

## 專案入口
專案名稱：
專案用途：
主要工作目錄：
GitHub repo：
預設 branch：

## Obsidian 對應筆記與備份管道
Obsidian vault：C:\Users\<使用者>\Documents\SecondBrain
專案駕駛艙：C:\Users\<使用者>\Documents\SecondBrain\<專案名稱>.md
Google Drive 備份路徑：G:\我的雲端硬碟\SecondBrain\ (若需要，請填寫此路徑)

## 工作規則
- 回應使用繁體中文。
- 涉及檔案操作時回報完整產出位置。
- 使用 PowerShell 語法。
- 開工時讀本檔、讀 Obsidian 駕駛艙、檢查 Git 狀態。
- 收工時詢問備份管道，更新 Obsidian，檢查 diff 後只提交相關檔案。
```

---

## 七、Windows 繁體中文環境全域技能安裝與疑難排解

在 Windows 繁體中文環境下（系統預設編碼為 CP950/Big5），將技能設定為全域適用時，常會遇到以下兩個問題：

### 1. 全域技能讀取亂碼（YAML 解析錯誤）
* **現象**：寫入 `SKILL.md` 內的中文（如「開工」、「初始化專案」）被 Agent 讀成亂碼，導致輸入指令時 AI 沒有任何反應，或是退回到系統預設模板。
* **原因**：Antigravity 後台的 YAML 解析器**嚴格要求 UTF-8 編碼**。如果在 Windows 本地端使用 CP950（Big5）格式寫入或開啟，會導致解析器解析 YAML 失敗而忽略該技能。
* **解法**：請確保所有 global 技能目錄（如 `~/.gemini/config/skills/` 與 `~/.gemini/antigravity/skills/`）底下的 `SKILL.md` **必須儲存為無 BOM 的標準 UTF-8 編碼**。
  *(注意：在 Windows PowerShell 終端機中，執行 `Get-Content` 印出內容時可能會因為主控台是 Big5 而顯示亂碼，這並不影響後台解析器以 UTF-8 正確讀取。)*

### 2. 核心全域技能路徑
為確保不論在何處開啟 Antigravity 都能讀取到技能，必須將技能放置於以下兩個全域路徑下：
* **標準全域路徑**：`C:\Users\<使用者>\.gemini\antigravity\skills\`
* **使用者配置路徑**：`C:\Users\<使用者>\.gemini\config\skills\`

### 3. 空白資料夾的系統卡片攔截
* **現象**：開啟一個全新、完全空白的資料夾並輸入「初始化專案」時，AI 沒有讀取全域技能，而是彈出「請選擇你想要初始化的專案類型：1. 靜態網站 2. React...」的引導卡片選單。
* **原因**：因為資料夾全空，AI 會判定為「空白工作區」，並呼叫預設的問卷工具。
* **解法**：
  - **方法一**：直接點選彈出卡片右下角的 **`Skip`（跳過）**，系統就會關閉預設問卷，並把您的「初始化專案」指令傳送給 AI，AI 就會成功讀取全域技能並進入懶人包初始化引導。
  - **方法二**：在開始對話前，先在資料夾隨便建一個檔案（如 `README.md`），資料夾不為空，就不會觸發系統預設引導。
