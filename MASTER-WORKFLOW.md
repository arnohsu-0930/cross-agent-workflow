# MASTER-WORKFLOW — Arno 的跨 Agent 全域工作流程

> **這是唯一真相來源（Single Source of Truth）。**
> 任何 AI Agent（Claude Code / Codex / OpenCode / AntiGravity）讀到這份文件，
> 都必須依 `INSTALL-GLOBAL.md` 把本檔內容安裝進「自己的全域設定檔」，
> 安裝後，使用者開啟任何專案都自動生效，**不需要再於每個專案重新設定**。

---

## 0. 使用者背景（每個 Agent 都要知道）

- 使用者：**Arno**（GitHub 帳號 `arnohsu-0930`）。
- 我**同時使用多個 AI Agent**：Claude Code、Codex、OpenCode、AntiGravity。
- 我在**多台電腦**間切換工作：
  - **公司電腦**：封鎖 Google Drive，只能用 **GitHub** 同步。
  - **家裡電腦**：可以用 **Google Drive**，也可以用 GitHub。
- 因此所有跨裝置同步**必須詢問我**要用哪個管道，不要自己假設。

---

## 1. 跨 Agent 共用狀態檔：STATUS.md

每個專案根目錄放一個 `STATUS.md`，這是**所有 Agent 共用的接力棒**。
不管哪個 Agent 打開專案，先讀它就知道別的 Agent 做到哪。

`STATUS.md` 格式：

```markdown
# <專案名稱> STATUS

## 完成事項
- ...

## 下一步
- ...

## 踩坑紀錄
- ...

## 環境狀態
- ...

## 最後更新
- 時間：YYYY-MM-DD
- 更新者：<Claude Code / Codex / OpenCode / AntiGravity>
```

**兩層紀錄分工：**
- `STATUS.md`（專案根目錄）→ 給 Agent 快速讀寫的「當前進度接力棒」，跟著專案 repo 走。
- **Obsidian 第二大腦**（駕駛艙筆記）→ 跨專案總覽、長期里程碑、踩坑知識庫。
- 收工時**兩者都更新**：STATUS.md 寫當前狀態，Obsidian 寫里程碑。

---

## 2. 重要路徑

| 項目 | 路徑 |
|------|------|
| Obsidian Vault（第二大腦） | `C:\Users\HsiuH許家修\Documents\SecondBrain` |
| 第二大腦 GitHub repo | `https://github.com/arnohsu-0930/my-second-brain`（private） |
| 第二大腦 Google Drive 備份 | `C:\Users\HsiuH許家修\Google Drive\SecondBrain`（家裡電腦用，若不存在則自動建立） |
| 各專案進度檔 | `<專案根目錄>\STATUS.md` |
| Obsidian 駕駛艙筆記 | `SecondBrain\<專案名稱>.md` |

> Obsidian Vault 本身已是 git repo，遠端指向 `my-second-brain`。

---

## 3. 開工流程（使用者說「開工」「繼續」「回來」等）

1. **詢問同步來源**：「第二大腦要從哪裡拉最新版？(G) GitHub `git pull` / (D) Google Drive 確認 / (S) 跳過」→ 依選擇執行。
2. 讀取當前資料夾的 `CLAUDE.md` / `AGENTS.md` / `ANTIGRAVITY.md`（存在哪個讀哪個）。
3. 讀取當前資料夾的 `STATUS.md`（沒有就說明這是新專案）。
4. 用 Obsidian MCP 或檔案工具讀取該專案的駕駛艙筆記**實際內容**（不可只列檔名）。
5. 執行 `git status` 與 `git log --oneline -5`。
6. **回報開工 Briefing**：專案名稱、上次完成事項、下一步、踩坑、Git 狀態、建議現在做什麼。
7. **不自動** pull / commit / push 或任何寫入（pull 要先問過）。

---

## 4. 收工流程（使用者說「收工」「下班」「先這樣」等）

1. **安全檢查**：掃描程式碼與筆記，確保沒有 API key、token、密碼、Firebase 憑證、個資外洩。
2. **詢問我**：今天完成了什麼、下一步、踩了什麼坑。
3. 更新專案根目錄 `STATUS.md`（含「更新者」欄位填入當前 Agent 名稱）。
4. 更新 Obsidian 駕駛艙筆記 `SecondBrain\<專案名稱>.md`（里程碑、踩坑知識）。
5. **同步（只問一次管道，專案代碼＋第二大腦一起做）**：
   問一題：「今天的進度要同步到哪？(1) GitHub (2) Google Drive (3) 兩者 (4) 跳過」。
   使用者選定後，**專案代碼與第二大腦兩者都照這個選擇同步**，不要拆成兩題分開問。
   - **選 GitHub**：
     - 專案代碼：`git diff` 確認後只 stage 本次相關檔案（**不用 `git add .`**），commit + push 到專案 repo；若專案無遠端庫則僅本地 commit，不報錯。
     - 第二大腦：切到 vault 目錄，commit + push 到 `my-second-brain`。
   - **選 Google Drive**：把第二大腦 vault 與專案資料夾複製到 `C:\Users\HsiuH許家修\Google Drive\SecondBrain`（資料夾不存在就自動建立）。
   - **選 兩者**：上面 GitHub 與 Google Drive 都做。
   > 提醒：公司電腦封鎖 Google Drive，請選 (1)；家裡電腦可選 (2) 或 (3)。
6. **回報**同步結果（專案代碼 / STATUS.md / Obsidian + 走了哪個管道）。

---

## 5. 初始化專案流程（使用者說「初始化專案」「新專案」等）

1. **詢問**：專案名稱、用途、工作資料夾路徑、是否要 GitHub repo（私有/公開/不要）、是否要 Google Drive 備份。
2. **自動建立**（已存在則補齊缺口、不覆蓋）：
   - `STATUS.md`（跨 Agent 狀態檔，套用第 1 節格式）
   - 該 Agent 的專案說明檔（Claude→`CLAUDE.md`、Codex/OpenCode→`AGENTS.md`、AntiGravity→`ANTIGRAVITY.md`）
   - `README.md`、`.gitignore`（排除敏感檔案與編譯產物）
   - 初始化本地 git
   - 若需要：`gh repo create`
   - 在 Obsidian Vault 下建立「<專案名稱>.md」駕駛艙筆記
3. 在新建的專案說明檔頂部加一行，指向本工作流程，讓未來其他 Agent 也知道規範。

---

## 6. 跨 Agent / 跨電腦保證

- **跨 Agent**：本流程已裝進每個 Agent 的全域設定（見 `INSTALL-GLOBAL.md`），所以 Claude Code / Codex / OpenCode / AntiGravity 行為一致。
- **跨電腦**：換新電腦時，把本 repo 丟給任一 Agent 並說「請依 INSTALL-GLOBAL.md 安裝」，它會把本流程重新裝進該電腦的全域設定；第二大腦內容則透過 `my-second-brain` GitHub repo（或 Google Drive）取回。
