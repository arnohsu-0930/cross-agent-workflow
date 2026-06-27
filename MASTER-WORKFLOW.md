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

## 1. 跨 Agent 共用狀態檔：STATUS.md（每個專案的唯一真相來源）

每個專案根目錄放一個 `STATUS.md`，這是**所有 Agent、所有電腦共用的唯一真相來源（Single Source of Truth）**。
不管哪個 Agent、在哪台電腦打開專案，**第一件事就是讀它**，立刻知道：這專案在哪、推到哪、別的 Agent 做到哪。

> **黃金原則：實質內容只寫在 STATUS.md 一份。**
> 各 Agent 的專案說明檔（`CLAUDE.md` / `AGENTS.md` / `ANTIGRAVITY.md`）一律**薄化**成「指標」，
> 只寫一句「本專案規範見全域工作流程；當前狀態與路徑請讀 `STATUS.md`」，
> **不重複寫專案內容**——避免多 agent / 多檔不同步、自相矛盾。

`STATUS.md` 格式：

```markdown
# <專案名稱> STATUS

> 本檔 = 本專案唯一真相來源。任何 Agent / 任何電腦打開本專案先讀這裡。

## 同步對應表（換電腦時靠這張表對照，不依賴本機絕對路徑）
| 項目 | 位置 |
|------|------|
| 專案資料夾 | 以各機 `~`（家目錄）為準；本專案相對位置：<例 ~/projects/xxx> |
| Git 遠端 | <repo url，例 https://github.com/arnohsu-0930/xxx> |
| Obsidian 駕駛艙筆記 | `SecondBrain\<專案名稱>.md` |
| Google Drive 備份 | `<googleDrivePath>\SecondBrain\<專案名稱>`（家用電腦才有） |
| 使用的 Agent | Claude Code / Codex / OpenCode / AntiGravity（實際用到的） |

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

> **跨電腦零落差關鍵**：同步對應表**不要寫死本機絕對路徑**（`C:\Users\User\…` 跟 `C:\Users\HsiuH許家修\…` 每台不同）。
> 一律用「以家目錄 `~` 為準的相對描述」+ git 遠端 URL，換電腦 clone 下來照表即可重建，不會落差。

**兩層紀錄分工：**
- `STATUS.md`（專案根目錄）→ **唯一真相**：當前狀態、路徑、進度，跟著專案 repo 走，git 一推即跨電腦同步。
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

> **收工原則：工作內容「自動推導、不要問使用者」；唯一要問的只有「同步推到哪裡」。**
> Agent 從本次對話自行整理「完成事項 / 下一步 / 踩坑」，不要反問使用者「你今天做了什麼」。

1. **安全檢查**：掃描程式碼與筆記，確保沒有 API key、token、密碼、Firebase 憑證、個資外洩。
2. **自動推導今日紀錄（不要問使用者）**：從本次對話整理出「完成事項、下一步、踩坑」。只有在對話中完全無法判斷「下一步」時，才簡短問一句下一步；完成事項與踩坑一律自行歸納。
3. 更新專案根目錄 `STATUS.md`（含「更新者」欄位填入當前 Agent 名稱）。
4. 更新 Obsidian 駕駛艙筆記 `SecondBrain\<專案名稱>.md`（里程碑、踩坑知識）。
5. **詢問同步管道（這是收工唯一要問使用者的事）**：
   「要推到哪裡？(G) 只 GitHub /(D) 只 Google Drive /(B) 兩者都推」
   - 用 `~/.claude/machine-config.json` 的 `machineType` 決定**預設選項**並標示出來：`home`→預設 (B) 兩者；`company`→預設 (G) 只 GitHub（Google Drive 被封鎖，不建議選 D/B）。使用者直接 Enter 即採預設。
   - 若設定檔不存在 → 先依第 0.1 節問一次身分並寫入，再依結果給預設。
   - **GitHub 動作**（選 G 或 B 時執行）：
     - 專案代碼：`git diff` 確認後只 stage 本次相關檔案（**不用 `git add .`**）commit + push 到專案 repo；若無遠端庫則僅本地 commit，不報錯。
     - 第二大腦：切到 vault 目錄 commit + push 到 `my-second-brain`。
   - **Google Drive 動作**（選 D 或 B 時執行）：把第二大腦 vault 與專案資料夾複製到 `googleDrivePath\SecondBrain`（不存在就自動建立）。若 `googleDriveInstalled: false` → 提醒「Google Drive 尚未安裝，本次無法推 D，先走 GitHub；裝好登入後把設定改 true」。
6. **回報**同步結果（專案代碼 / STATUS.md / Obsidian + 實際走了哪個管道）。

---

## 5. 初始化專案流程（使用者說「初始化專案」「新專案」等）

1. **詢問**：專案名稱、用途、工作資料夾路徑、是否要 GitHub repo（私有/公開/不要）、是否要 Google Drive 備份。
2. **自動建立**（已存在則補齊缺口、不覆蓋）：
   - **`STATUS.md`＝唯一真相來源**（套用第 1 節格式，**並填好「同步對應表」**：專案相對路徑、git 遠端 URL、Obsidian 筆記、Google Drive 備份、使用的 Agent）。專案的實質資訊只寫這一份。
   - **各 Agent 的專案說明檔一律「薄化」**，只放指標、**不重複寫專案內容**：
     - 內容固定為一句：「本專案規範見全域工作流程（cross-agent-workflow）；當前狀態、路徑與進度一律讀同目錄的 `STATUS.md`。」
     - 一次把**會用到的 agent 入口檔都建好**（不只當前 agent）：Claude→`CLAUDE.md`、Codex/OpenCode→`AGENTS.md`、AntiGravity→`ANTIGRAVITY.md`。這樣換哪個 agent 開專案，都讀得到自己的入口、再被導向 STATUS.md。
   - `README.md`、`.gitignore`（排除敏感檔案與編譯產物）
   - 初始化本地 git
   - 若需要：`gh repo create`（私有為主）並 push，把遠端 URL 回填進 STATUS.md 同步對應表
   - 在 Obsidian Vault 下建立「<專案名稱>.md」駕駛艙筆記
3. **驗收「換電腦零落差」**：確認 STATUS.md 同步對應表沒有寫死本機絕對路徑（用 `~` 相對描述 + git URL），且各 agent 薄入口檔都指向 STATUS.md。
   → 之後任何電腦只要 `git clone` 專案 + 已安裝全域工作流程，讀 STATUS.md 就能無落差接手。

---

## 6. 跨 Agent / 跨電腦保證

- **跨 Agent**：本流程已裝進每個 Agent 的全域設定（見 `INSTALL-GLOBAL.md`），所以 Claude Code / Codex / OpenCode / AntiGravity 行為一致。
- **跨電腦（兩層都要顧，才能真正零落差）**：
  1. **全域工作流程層**：換新電腦時，把本 repo 丟給任一 Agent 說「請依 INSTALL-GLOBAL.md 安裝」（或跑一鍵腳本），把本流程重新裝進該電腦的全域設定。
  2. **專案層**：`git clone` 專案 repo → 讀根目錄 `STATUS.md`（唯一真相 + 同步對應表）→ 立刻知道專案在哪、推到哪、做到哪，**無落差接手**。
  3. **第二大腦層**：透過 `my-second-brain` GitHub repo（或家用電腦的 Google Drive）取回 Obsidian 筆記。
- **零落差檢查清單**：①全域流程已裝 ②專案已 clone 且 STATUS.md 同步對應表不含本機絕對路徑 ③第二大腦已拉最新 → 三項齊全即可在任何電腦、任何 Agent 無縫接力。

---

## 7. 指揮其他 Agent（Claude Code 當規劃者/指揮者，省 Claude Code 額度）

**核心原則**：Claude Code（Opus 4.8）負責**規劃、拆解、驗收**；繁重執行**派給較省的 agent**。執行者太笨或任務太關鍵時，Claude Code 才親自做。

### 兩種派工模式
- **A. 直接 CLI 遙控**（Claude Code 自己呼叫子程序、收回 stdout）：
  - OpenCode：`opencode run --model <provider/model> "任務"`
  - Codex：`codex exec "任務"`（加 `--json` 出 JSONL）
- **B. 接力轉接**（Claude Code 產出**現成可貼的 prompt + 交辦清單**，使用者複製貼到該 agent 執行，結果再回報給 Claude Code 驗收）：
  - **AntiGravity 2.0**：在 **Windows 背景遙控不可行**（agy 有 non-TTY 不輸出的毛病，winpty 也因無主控台失敗，實測 2026-06-27）。故 aa 一律走 B 模式：Claude Code 給 prompt，使用者貼到 aa 跑。**好處：不浪費付費的 aa 額度在通不了的遙控上。**

### 派工時選哪個執行者（依任務性質，Claude Code 主動推薦）
| 任務性質 | 推薦執行者 / 模型 | 模式 |
|---|---|---|
| 上網查證、找地址/法人/事實、推理重、多模態 | **AntiGravity 2.0（Gemini 3 Pro）**——付費、有網路、最強 | B 接力貼上 |
| 大量寫 code / 改 code / 低風險例行 | **OpenCode + Qwen3 Coder**（OpenRouter 免費，最強免費 coding） | A 直接 CLI |
| 要 reasoning 的 code | **OpenCode + DeepSeek V4 Flash**（OpenRouter 免費，原生推理） | A 直接 CLI |
| agentic 寫 code（256K context） | **OpenCode + North Mini Code**（OpenCode Zen 免費） | A 直接 CLI |
| CI / pipeline / 結構化 code 任務 | **Codex**（`codex exec`，可 pipe/JSON） | A 直接 CLI |
| 高難度、跨檔案、要把關驗收 | **Claude Code 親自做** | — |
> 免費模型限制約 20 次/分、200 次/天；確切模型 slug 用 `opencode models` 查。

### 交辦清單格式（Claude Code 產給任何執行者時都要包含）
執行者**沒有本對話的上下文**，prompt 必須自帶齊全：
1. **目標**（一句話）
2. **背景與檔案路徑**（絕對路徑、相關檔、現況）
3. **具體步驟**
4. **完成標準 / 驗收點**
5. **限制**（不要動什麼、不要 `git add .`、不要碰金鑰）

### 注意
- **A 模式**需要該執行者 CLI 已裝在本機（`opencode` / `codex`）。
- **B 模式**只需 aa 開著；Claude Code 把 prompt 用程式碼區塊輸出方便整段複製。
- 派工後 Claude Code 要**驗收**執行者的產出（讀檔/跑測試），不合格就退回重派或親自修。
