---
name: antigravity-browser
description: 安裝瀏覽器控制工具（Playwright MCP + open-computer-use）。說「裝瀏覽器控制」「瀏覽器自動化」時載入。
---

# 瀏覽器控制

讓 AI 控制瀏覽器和桌面應用。

## 步驟

### 1. Playwright MCP
在 MCP 設定檔中加入：
```json
"playwright": {
  "type": "local",
  "command": ["npx", "-y", "@playwright/mcp"],
  "enabled": true
}
```

### 2. open-computer-use
```bash
npm install -g open-computer-use
```
> ⚠️ Windows 需手動編輯設定檔，不能用 `install-opencode-mcp`。

加入 MCP 設定檔：
```json
"open-computer-use": {
  "type": "local",
  "command": ["open-computer-use", "mcp"],
  "enabled": true
}
```

### 3. 驗證
- Playwright: 「開啟 https://example.com 並告訴我標題」
- open-computer-use: 「截圖我的桌面」

回報格式：Playwright 狀態、open-computer-use 狀態、兩個工具的啟動測試結果。
