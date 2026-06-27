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
  - **家裡電腦**：GitHub + **Google Drive** 兩者都同步。

### 0.1 機器身分（每台電腦記一次，之後自動）

每台電腦在 `~/.claude/machine-config.json` 記住自己是家用還是公司電腦，**收工同步管道由它自動決定，不用每次問**：

```json
{
  "machineType": "home",          // "home"=家用 / "company"=公司
  "syncMode": "both",             // home→"both"(GitHub+GDrive) / company→"github"
  "googleDriveInstalled": false,  // 家用電腦才需要；偵測到 Google Drive 後設 true
  "googleDrivePath": "",          // 例 "G:\\My Drive" 或 "C:\\Users\\<你>\\Google Drive"
  "vaultPath": "C:\\Users\\<你>\\Documents\\SecondBrain"
}
```

**判斷規則：**
- 設定檔**已存在** → 直接照它走，不再問。
- 設定檔**不存在**（新電腦第一次）→ 問一次：「這是家用電腦嗎？(Y/N)」
  - 答 **是（家用）** → `machineType: "home"`，並偵測是否裝了 Google Drive for Desktop：
    - 有裝 → `googleDriveInstalled: true` + 填 `googleDrivePath`，收工走 GitHub + Google Drive。
    - 沒裝 → `googleDriveInstalled: false`，提醒安裝，**收工暫時只走 GitHub**，裝好後改 true 即自動雙同步。
  - 答 **否（公司）** → `machineType: "company"`，收工只走 GitHub（Google Drive 被封鎖）。
- 寫入 machine-config.json 後**記住**，下次同一台電腦不再問。

### 0.2 打字縮寫（不分大小寫；Agent 回覆時一律用全名）

| 縮寫 | 全名 |
|---|---|
| `aa` | AntiGravity 2.0 agent |
| `ob` | Obsidian |
| `op` | OpenCode agent |
| `cc` | Claude Code agent |

> Arno 打縮寫，Agent 理解即可；但 Agent 回覆提到某 agent / 模型時，要用全名（例：回「Claude Code」不可縮成 cc）。

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
| Obsidian Vault（第二大腦） | `~/Documents/SecondBrain`（以實際家目錄為準，見 machine-config 的 `vaultPath`） |
| 第二大腦 GitHub repo | `https://github.com/arnohsu-0930/my-second-brain`（private） |
| 第二大腦 Google Drive 備份 | machine-config 的 `googleDrivePath\SecondBrain`（家用電腦才有，若不存在則自動建立） |
| 機器身分設定檔 | `~/.claude/machine-config.json`（記住家用/公司 + 同步管道） |
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
5. **同步（依 `machine-config.json` 自動決定管道，不用每次問；專案代碼＋第二大腦一起做）**：
   讀 `~/.claude/machine-config.json` 的 `machineType` 決定：
   - **`home`（家用電腦）→ GitHub + Google Drive 都同步。**
     - 若 `googleDriveInstalled: false` → 提醒「Google Drive 尚未安裝，本次先只推 GitHub；裝好登入後設定改 true 即自動雙同步」，本次走 GitHub。
   - **`company`（公司電腦）→ 只走 GitHub**（Google Drive 被封鎖）。
   - 若設定檔不存在 → 先依第 0.1 節問一次並寫入，再依結果同步。
   - **GitHub 動作**：
     - 專案代碼：`git diff` 確認後只 stage 本次相關檔案（**不用 `git add .`**）commit + push 到專案 repo；若無遠端庫則僅本地 commit，不報錯。
     - 第二大腦：切到 vault 目錄 commit + push 到 `my-second-brain`。
   - **Google Drive 動作**：把第二大腦 vault 與專案資料夾複製到 `googleDrivePath\SecondBrain`（不存在就自動建立）。
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
