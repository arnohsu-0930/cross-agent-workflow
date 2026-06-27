---
name: orchestrate-agents
description: Claude Code 當指揮者派工給其他 agent 省額度。說「派工」「指揮」「叫 OpenCode/Codex/AntiGravity 做」「分擔任務」「省額度」「找執行者」時載入。
---

# 指揮其他 Agent（Claude Code 規劃、別人執行）

> 完整定義見 `MASTER-WORKFLOW.md` 第 7 節。核心：Claude Code (Opus 4.8) 規劃+驗收，繁重執行派給省額度 agent。

## 兩種派工模式
- **A 直接 CLI 遙控**（Claude Code 跑、收 stdout）：
  - OpenCode：`opencode run --model <provider/model> "任務"`
  - Codex：`codex exec "任務"`（`--json` 出 JSONL）
- **B 接力轉接**（Claude Code 產 prompt，使用者貼給 agent）：
  - **AntiGravity 2.0**：Windows 背景遙控不可行（agy non-TTY 不輸出，實測 2026-06-27）→ 一律走 B。Claude Code 用程式碼區塊輸出整段可貼 prompt，使用者貼到 aa 跑、回報結果。

## 選執行者（依任務）
| 任務 | 推薦 | 模式 |
|---|---|---|
| 上網查證/找地址法人/推理重 | AntiGravity 2.0 (Gemini 3 Pro，付費有網路) | B |
| 大量寫/改 code、例行 | OpenCode + Qwen3 Coder (免費) | A |
| 要推理的 code | OpenCode + DeepSeek V4 Flash (免費) | A |
| agentic 寫 code | OpenCode + North Mini Code (Zen 免費) | A |
| CI/結構化 code | Codex (codex exec) | A |
| 高難度/跨檔/要把關 | Claude Code 親自做 | — |

## 交辦清單格式（執行者沒上下文，要自帶齊全）
1. 目標（一句話）2. 背景與絕對檔案路徑 3. 具體步驟 4. 完成標準/驗收點 5. 限制（不要動什麼、別 `git add .`、別碰金鑰）

## 派工後
Claude Code 要**驗收**產出（讀檔/跑測試），不合格退回重派或親自修。
