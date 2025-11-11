# RI-2-2 溝通矩陣 / Communication Matrix

> 任務來源：`PM-REPORT-001-任務追蹤.md`。依據干係人登錄清單（`PM-STAKEHOLDER-001-利益相關者清單.md`）建立正式溝通計畫，供專案團隊及管理層參考。

---

## 1. 溝通原則
- **透明性**：重大議題、風險與決策須在 24 小時內同步相關干係人。
- **節奏性**：依 Scrum 儀式與治理節點排程，避免資訊遺漏或重複。
- **可追溯**：所有文件、會議紀錄以 Markdown + Git 管理，確保版本一致。
- **雙向溝通**：鼓勵干係人提供回饋，透過 Action Items 或 Refinement Meeting 收斂。

---

## 2. 溝通矩陣表

| 溝通對象 | 目的 | 內容範疇 | 形式 / 渠道 | 頻率 | 負責人 | 輸出文件/連結 |
|---|---|---|---|---|---|---|
| Steering Committee（贊助人、CFO、EIS 代表） | 提供專案策略進度、重大議題決策 | 里程碑進度、KPI、風險、預算 | 月度 Steering Review 會議 + Email 報告 | 每月最後一週 | PMO（Tao Yu） | `PM-PLAN-001-專案計劃.md` 更新摘要、會議紀錄（會議檔案） |
| 贊助人（Ran Guo） | 即時掌握專案狀態、Go/No-Go 決策 | KPI、資源需求、重大風險 | Email / 面談 | 需要時（≥ 每兩週一次） | PMO | 呈報資料包、Action Item 更新 |
| Product Ops & 業務代表 | 對齊需求優先序、Backlog 更新 | Product Backlog、Sprint 目標、用戶回饋 | Backlog Refinement、Product Sync | 每週 | Product Ops Lead | `PM-PLAN-002-Sprint計劃.md`、Backlog 輸出檔 |
| Scrum 團隊（全部 Squad） | 協同開發、同步進度與阻礙 | Sprint 目標、任務狀態、阻礙 | Daily Standup (Teams)、Sprint Planning/Review/Retro | Daily / 每 Sprint | Scrum Master | `PM-REPORT-001-任務追蹤.md`、Sprint 紀錄 |
| Architecture & DevOps | 技術規劃、整合與平台準備 | 架構藍圖、API、環境、資安 | Architecture Workshop / DevOps Sync | 每兩週 | Architecture Lead / DevOps Lead | `PM-PLAN-001-專案計劃.md` 架構章節、架構/DevOps 紀要 |
| Data & AI/ML 團隊 | 資料需求、模型開發與稽核 | 資料樣本、AI 模型、隱私合規 | Data Workshop、AI Sync | 每週 | Data Lead / AI Lead | `PM-PLAN-003-團隊目標與風險.md`、資料需求清單 |
| Finance / IFRS17 / Compliance | 合規與報表需求、審核成果 | IFRS17 報表、合規議題、稽核結果 | IFRS17 工作坊、合規會議 | 每月 / 需要時 | Finance SME / Compliance Officer | IFRS17 文件、合規報告、`PM-ACTION-001-行動項目.md` |
| 使用者代表（核保、再保、理賠、財務） | 蒐集使用回饋、培訓安排 | 功能 Demo、UAT 進度、培訓資源 | Sprint Review、UAT Workshop、訓練課程 | 每 Sprint / UAT 期間 | Product Ops / Training Lead | UAT 記錄、培訓教材、Hypercare 計畫 |
| 外部合作夥伴（EIS、再保人） | 整合進度、介面對接 | API 規格、整合時程、資料交換 | 整合會議、Email 更新 | 雙週 / 依整合節點 | Integration Lead | API 契約、整合狀態紀錄 |

---

## 3. 通知與升級路徑
- **重大風險 / 阻礙**：由 Scrum Master 於辨識後 24 小時內通知 PMO → Sponsor → Steering Committee。
- **需求變更**：PO 收到新需求後，提交 CCB（Change Control Board）評估，並於下一次 Steering Review 報告。
- **資安事件**：Security Lead 立即通知 Architecture Lead、PMO 與 Sponsor，並啟動資安事件流程。
- **上線問題**：Hypercare 期間由 Operations Lead 與 Support Team 第一時間處理，必要時升級至 Steering Committee。

---

## 4. 例行會議清單

| 會議名稱 | 主持人 | 參與者 | 週期 | 主要內容 | 參考檔案 |
|---|---|---|---|---|---|
| Steering Review | Sponsor / PMO | Steering Committee、PO、Scrum Master | 每月 | 里程碑進度、決策議題、風險審視 | 會議紀錄、報告簡報 |
| PI Sync | Scrum Master | Squad Leads、Architecture、DevOps、PO | 每兩週 | Sprint 進度、依賴、風險、整合 | `PM-REPORT-001-任務追蹤.md` |
| Backlog Refinement | Product Ops / PO | PO、Scrum Master、各 Squad 代表 | 每週 | Backlog 更新、Story Refinement、優先序 | Backlog 檔案、`PM-PLAN-002-Sprint計劃.md` |
| Architecture/DevOps Workshop | Architecture Lead | Architecture、DevOps、Security、Integration | 每兩週 | 架構藍圖、環境、資安、整合議題 | 架構圖、API 契約 |
| Data & AI Workshop | Data Lead | Data、AI/ML、Finance、Compliance | 每週 | 資料需求、模型進度、合規 | 資料需求表、AI 模型說明 |
| QA/Testing Sync | QA Lead | QA、Squad 測試代表、Product Ops | 每週 | 測試進度、缺陷、DoR/DoD 檢查 | 測試計畫、缺陷清單 |
| UAT & Training Briefing | Training Lead | Product Ops、使用者代表、Support | UAT 期間 | UAT 計畫、培訓安排、支援流程 | UAT 手冊、培訓教材 |

---

## 5. 維護與更新
- Product Ops 負責每季度（或干係人改動時）更新溝通矩陣。
- 與干係人登錄表、專案章程連動；版本更新需在任務追蹤表備註。
- 重大更新須透過 Teams/Slack 廣播通知全體成員。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 初版溝通矩陣 | Tao Yu 和他的 GPT 智能助手 |
