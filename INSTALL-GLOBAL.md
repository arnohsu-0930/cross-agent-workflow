# INSTALL-GLOBAL — 給 AI Agent 的全域安裝指令

> **你是一個 AI Agent（Claude Code / Codex / OpenCode / AntiGravity）。**
> 使用者 Arno 把這個 repo 丟給你，目的是：讓本工作流程成為你的**全域技能**，
> 之後他開任何專案、在任何電腦上，你都自動遵守，**他不必每次重新提醒你**。

請依下列步驟自我安裝，**不要只是口頭回覆「我知道了」**——必須實際寫入全域設定檔。

---

## ⚡ 最快路徑：一鍵安裝腳本（會先問要裝哪幾個 agent）

新電腦只要在 PowerShell 跑這一行：

```powershell
irm https://raw.githubusercontent.com/arnohsu-0930/cross-agent-workflow/main/install-all-agents.ps1 | iex
```

腳本會做：
1. 問一次「這是家用電腦嗎？(Y/N)」→ 寫進 `~/.claude/machine-config.json` 記住，之後不再問。
2. 家用 → 同步 GitHub + Google Drive（偵測 Google Drive 路徑）；公司 → 只同步 GitHub。
3. 安裝 gh CLI、Obsidian；`gh auth login`（瀏覽器點一下 Authorize）。
4. clone `my-second-brain` → `~/Documents/SecondBrain`。
5. **問你「要裝哪幾個 agent？」**（1=Claude Code 2=Codex 3=OpenCode 4=AntiGravity，可多選，Enter=全部），只裝你選的：
   - Claude Code → `~/.claude/CLAUDE.md` + `~/.claude/skills/`
   - Codex → `~/.codex/AGENTS.md`
   - OpenCode → `~/.config/opencode/AGENTS.md`
   - AntiGravity → `~/.gemini/antigravity/global_skills/`

> ⚠️ 每台電腦都要各跑一次（設定檔是本機的，不會跨電腦自動出現）。裝過的電腦不用再裝。

> 📌 **若你是 AI Agent 透過讀本檔安裝**（非跑腳本）：動手前**務必先問使用者「要裝進哪幾個 agent 的全域設定？」**，依選擇安裝，不要預設全裝。

裝完後追加（可選）：NotebookLM `uv tool install notebooklm-mcp-cli && nlm login`、MCPVault `npm install -g @bitbonsai/mcpvault`。

---

## 手動路徑（非 Claude Code，或想自己控制）

### 步驟一：讀取唯一真相來源
讀取本 repo 的 `MASTER-WORKFLOW.md`，那是完整的工作流程定義。

### 步驟二：依「你是哪個 Agent」寫進對應的全域設定檔
判斷你自己是哪個 Agent，把 `MASTER-WORKFLOW.md` 的內容寫進**你自己的全域設定檔**。已有內容就「附加」，不要覆蓋。

| 你是 | 寫進這個全域設定檔（以實際家目錄 `~` 為準） |
|------|------------------------------|
| **Claude Code** | `~/.claude/CLAUDE.md` + `~/.claude/skills/` |
| **Codex** | `~/.codex/AGENTS.md` |
| **OpenCode** | `~/.config/opencode/AGENTS.md` |
| **AntiGravity** | `~/.gemini/antigravity/global_skills/antigravity-workflow/SKILL.md` |

> 路徑中的使用者名稱每台電腦不同，一律以實際 `~`（家目錄）為準，不要寫死。

### 步驟三：確認關鍵設定就位
- Obsidian MCP（mcpvault）指向 `~/Documents/SecondBrain`。
- 第二大腦 GitHub repo：`https://github.com/arnohsu-0930/my-second-brain`。
- 機器身分寫進 `~/.claude/machine-config.json`（`machineType: "home"` 或 `"company"`）：
  - **home** → 收工同步 GitHub + Google Drive（`googleDrivePath`，未安裝則提醒）。
  - **company** → 只同步 GitHub（Google Drive 被封鎖）。

### 步驟四：回報
裝完後明確告訴 Arno：
> 「已把跨 Agent 工作流程裝進全域設定（<檔案路徑>）。以後你開任何專案我都會自動遵守開工 / 收工 / 初始化流程，並用 STATUS.md 跟其他 Agent 接力，不用再提醒我。」

---

## 各 Agent 全域設定機制速查
- **Claude Code**：`~/.claude/CLAUDE.md` 全域指令 + `~/.claude/skills/` 技能，每次啟動自動載入。
- **Codex**：`~/.codex/AGENTS.md` 全域指令檔。
- **OpenCode**：`~/.config/opencode/AGENTS.md` 全域指令檔。
- **AntiGravity**：`~/.gemini/antigravity/global_skills/` 下的 skill 為全域技能。
