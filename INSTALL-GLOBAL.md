# INSTALL-GLOBAL — 給 AI Agent 的全域安裝指令

> **你是一個 AI Agent（Claude Code / Codex / OpenCode / AntiGravity）。**
> 使用者 Arno 把這個 repo 丟給你，目的是：讓本工作流程成為你的**全域技能**，
> 之後他開任何專案、在任何電腦上，你都自動遵守，**他不必每次重新提醒你**。

請依下列步驟自我安裝，**不要只是口頭回覆「我知道了」**——必須實際寫入你的全域設定檔。

---

## 步驟一：讀取唯一真相來源

讀取本 repo 的 `MASTER-WORKFLOW.md`，那是完整的工作流程定義。

## 步驟二：依「你是哪個 Agent」寫進對應的全域設定檔

判斷你自己是哪個 Agent，把 `MASTER-WORKFLOW.md` 的內容（或一段「請遵守本工作流程」的指引 + 完整流程）寫進**你自己的全域設定檔**。已有內容就「附加」，不要覆蓋既有設定。

| 你是 | 寫進這個全域設定檔（Windows） |
|------|------------------------------|
| **Claude Code** | `C:\Users\HsiuH許家修\.claude\CLAUDE.md` |
| **Codex** | `C:\Users\HsiuH許家修\.codex\AGENTS.md` |
| **OpenCode** | `C:\Users\HsiuH許家修\.config\opencode\AGENTS.md` |
| **AntiGravity** | `C:\Users\HsiuH許家修\.gemini\antigravity\global_skills\antigravity-workflow\SKILL.md`（更新既有 skill） |

> 路徑中的使用者名稱若不同（換電腦時），請以實際 `~`（家目錄）為準。

## 步驟三：確認關鍵設定就位

- Obsidian MCP（mcpvault）指向 `C:\Users\HsiuH許家修\Documents\SecondBrain`。
- 第二大腦 GitHub repo：`https://github.com/arnohsu-0930/my-second-brain`。
- 若該電腦可用 Google Drive，備份路徑為 `C:\Users\HsiuH許家修\Google Drive\SecondBrain`（不存在則收工同步時自動建立）。

## 步驟四：回報

裝完後明確告訴 Arno：
> 「已把跨 Agent 工作流程裝進我的全域設定（<檔案路徑>）。以後你開任何專案我都會自動遵守開工 / 收工 / 初始化流程，並用 STATUS.md 跟其他 Agent 接力，不用再提醒我。」

---

## 各 Agent 全域設定機制速查

- **Claude Code**：`~/.claude/CLAUDE.md` 是全域指令，每次啟動自動載入。
- **Codex**：`~/.codex/AGENTS.md` 是全域指令檔。
- **OpenCode**：`~/.config/opencode/AGENTS.md` 是全域指令檔。
- **AntiGravity**：`~/.gemini/antigravity/global_skills/` 下的 skill 為全域技能；更新 `antigravity-workflow/SKILL.md` 即可。
