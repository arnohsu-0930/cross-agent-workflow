---
name: antigravity-second-brain
description: 建立 Obsidian 第二大腦三層結構 + GitHub 版控同步。說「建立第二大腦」「設定知識管理」「三層結構」時載入。
---

# 第二大腦設定（GitHub 同步版）

在公司不能使用 Google Drive 的環境下，將 Obsidian vault 以 **Git + GitHub** 進行版控與同步。

## 三層架構

| 層級 | 資料夾 | 用途 | 頻率 |
|------|--------|------|------|
| 第一層 | `每日筆記/` | 原始想法、會議紀錄 | 每天 |
| 第二層 | `創作庫/` | 整理後產出（影片、懶人包） | 每週 |
| 第三層 | `知識庫/` | 可重用知識（模板、SOP） | 每月 |

## 步驟

### 1. 檢查 vault 路徑
- 讀取 AGENTS.md 或 ANTIGRAVITY.md 中記錄的 Obsidian vault 路徑
- 若無記錄，請使用者提供或自動搜尋含 `.obsidian` 的資料夾
- 確認 vault 已透過 MCPVault 連接

### 2. 檢查三層結構
列出 vault 內是否有以下資料夾及各資料夾檔案數：
- `每日筆記/`
- `創作庫/`
- `知識庫/`

### 3. 補建缺失資料夾
用 Obsidian MCP 建立缺少的資料夾與說明筆記。

### 4. 檢查 Git 狀態
確認 vault 是否已是 Git repo：
- 是：檢查 `git status`，確認遠端指向 GitHub
- 否：初始化 Git repo，建立 `.gitignore`（排除 `.obsidian/workspace.json`、快取檔），連接到 GitHub

### 5. 更新 AGENTS.md / ANTIGRAVITY.md
記錄以下資訊：
```
## Obsidian 第二大腦
- Vault 路徑：<LOCAL_PATH>
- GitHub repo：<REPO_URL>
- 每日筆記：`每日筆記/<日期>.md`
- 創作庫：`創作庫/`
- 知識庫：`知識庫/`
```

### 6. 每週重整流程
每週做一次：
1. 整理每日筆記 → 有價值內容搬到創作庫或知識庫
2. 更新專案進度筆記
3. 清理無用草稿
4. `git add` + `git commit` + `git push` 同步到 GitHub

## 完成回報

- 每日筆記/：✅ 已存在 / 🆕 已建立（N 筆）
- 創作庫/：✅ 已存在 / 🆕 已建立（N 筆）
- 知識庫/：✅ 已存在 / 🆕 已建立（N 筆）
- Git 同步：✅ 已串接 GitHub / ⚠️ 尚未設定
- AGENTS.md：✅ 已記錄
