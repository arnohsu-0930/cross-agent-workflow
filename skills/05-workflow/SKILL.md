---
name: antigravity-workflow
description: AntiGravity 開工/收工/新專案初始化流程。說「開工」「收工」「初始化專案」時載入。
---

# 開工 / 收工 / 新專案初始化

## 開工
1. 讀取專案根目錄的 `ANTIGRAVITY.md`。
2. 讀取專案筆記（Obsidian 專案駕駛艙）。
3. 執行 `git status` + 最近一次 commit 檢查。
4. 回報當前狀態與建議下一步，且不自動進行 pull/commit/push。

## 收工
1. **安全檢查**：檢查代碼與筆記，確保沒有上傳敏感資料（API key、token、密碼、Firebase 憑證、學生真名）。
2. **更新筆記**：更新 Obsidian 專案駕駛艙（寫入完成事項、下一步、踩坑記錄）。
3. **專案規則**：只有在規則或路徑改變時才更新 `ANTIGRAVITY.md`。
4. **詢問同步管道**：主動詢問使用者：「請問您今天的筆記要同步到：(1) GitHub (2) Google Drive (3) 兩者皆同步？」
   - **選 GitHub**：只執行 Git commit 並 push 到 GitHub。
   - **選 Google Drive**：若有設定 Google Drive 備份路徑，將筆記複製到對應的 Google Drive 同步資料夾中。
   - **選 兩者皆同步**：同時執行上述兩項操作。
5. **Git 提交**：檢查 `git status` 和 `git diff`，只 stage 與本次工作相關的檔案，不使用 `git add .` 無差別提交。
6. **同步回報**：完成後回報同步結果。

## 新專案初始化
1. **資訊詢問**：主動詢問使用者以下資料：
   - 專案名稱
   - 專案用途與功能簡介
   - 工作資料夾路徑（確認是否為目前的目錄，還是要新建子資料夾）
   - 是否需要建立 GitHub 儲存庫（私有/公開/不需要）
   - 是否有 Google Drive 備份需求
2. **自動建立**：建立以下項目（若已存在，則盤點並補齊缺口，不覆蓋既有設定）：
   - `ANTIGRAVITY.md`（寫入專案入口資訊、Obsidian 筆記路徑、Git 雲端庫路徑、Google Drive 備份路徑）
   - `README.md`（寫入專案名稱與簡介）
   - `.gitignore`（預設排除敏感檔案與編譯產物）
   - 初始化本地 Git 儲存庫
   - 線上建立 GitHub Repository（若使用者需要）
   - 在指定的 Obsidian Vault 下建立「專案駕駛艙.md」
