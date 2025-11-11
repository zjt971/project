# RI-BL-1 初版 Product Backlog

> 任務來源：`../PM-REPORT-001-任務追蹤.md`。依據 PRD (`RI/requirement/EIS-REINS-PRD-001.md`) 與 Scrum 計畫 (`PM-PLAN-002-Sprint計劃.md`)，整理 MVP 初版 Product Backlog，供 Sprint Planning 與 Refinement 使用。

---

## 1. Backlog 格式說明
- **欄位**：
  - `Story ID`：採 `US-RI-<序號>`（User Story for Reinsurance Initiative）格式，與任務編號區分。
  - `Title`：User Story 摘要，以「身為/我要/以便」格式。
  - `Business Value`：高/中/低（初估）。
  - `Risk/Complexity`：高/中/低。
  - `Dependencies`：需先完成的 Story 或外部條件。
  - `Target Sprint`：預計安排的 Sprint（可調整）。
- Story Point 將於 Sprint Planning/Refinement 時決定。

---

## 2. MVP Backlog 清單

| Story ID | Title | Business Value | Risk/Complexity | Dependencies | Target Sprint |
|---|---|---|---|---|---|
| US-RI-001 | 身為 PMO，我需要一份核准的專案章程，以便統一專案目標與治理方向 | 高 | 中 | Kickoff 完成 | Sprint 1 |
| US-RI-002 | 身為 Product Ops，我需要完整的溝通矩陣，以便正確通知干係人 | 高 | 中 | RI-2-1 | Sprint 1 |
| US-RI-003 | 身為 Scrum Master，我需要風險登錄與審視節奏，以便掌握專案風險 | 高 | 中 | RI-4-1、RI-4-2 | Sprint 1 |
| US-RI-004 | 身為 Treaty 經理，我要建立合約主檔 CRUD，以便管理再保合約 | 高 | 高 | 架構/環境就緒 | Sprint 5 |
| US-RI-005 | 身為合約審批者，我要有審批流程與通知，以便控制合約版本 | 高 | 高 | US-RI-004 | Sprint 6 |
| US-RI-006 | 身為合約使用者，我要查看合約版本歷史，以便追溯變更 | 中 | 中 | US-RI-004 | Sprint 5 |
| US-RI-007 | 身為使用者，我要操作友善的 Treaty UI，以便快速建維合約 | 高 | 中 | US-RI-004、US-RI-005 | Sprint 6 |
| US-RI-008 | 身為臨分專員，我要快速建立臨分案，以便處理特殊風險 | 高 | 高 | US-RI-007 | Sprint 7 |
| US-RI-009 | 身為臨分專員，我要知道是否已有合約涵蓋該風險，以便避免重複 | 高 | 中 | US-RI-008 | Sprint 7 |
| US-RI-010 | 身為臨分專員，我要管理臨分報價與文件，以便追蹤紀錄 | 中 | 中 | US-RI-008 | Sprint 7 |
| US-RI-011 | 身為核保人，我需要多幣別支持，以便計算國際再保案 | 高 | 中 | US-RI-008 | Sprint 7 |
| US-RI-012 | 身為再保分析師，我要自動計算分保保費，以便提升效率 | 高 | 高 | Treaty/Facultative 資料 | Sprint 9 |
| US-RI-013 | 身為財務，我要準確的佣金 / 費用計算，以便核對收益 | 高 | 高 | US-RI-012 | Sprint 9 |
| US-RI-014 | 身為核保人，我要有試算 API，以便預估再保影響 | 高 | 中 | US-RI-012 | Sprint 10 |
| US-RI-015 | 身為品質稽核，我要審核分保結果並保留版本，以便追溯 | 中 | 中 | US-RI-014 | Sprint 10 |
| US-RI-016 | 身為理賠專員，我要匯入再保理賠案，以便進行攤回 | 高 | 高 | Data Pipeline | Sprint 11 |
| US-RI-017 | 身為理賠專員，我要追蹤再保人回覆，以便掌握回收狀態 | 中 | 中 | US-RI-016 | Sprint 11 |
| US-RI-018 | 身為財務，我要自動生成 SoA，以便結算與對帳 | 高 | 高 | US-RI-016、US-RI-017 | Sprint 12 |
| US-RI-019 | 身為財務，我要調整 SoA 分錄，以便修正差異 | 中 | 中 | US-RI-018 | Sprint 12 |
| US-RI-020 | 身為分析師，我要 AI 協助解析合約條款，以便快速掌握內容 | 中 | 高 | 資料標註 | Sprint 13 |
| US-RI-021 | 身為風控，我要異常分保偵測，以便早期提出警示 | 中 | 高 | US-RI-020 | Sprint 13 |
| US-RI-022 | 身為管理者，我要洞察 Dashboard，以便掌握營運指標 | 中 | 中 | US-RI-020、US-RI-021 | Sprint 13 |
| US-RI-023 | 身為財務，我要 IFRS17 資料模型，以便符合報表準則 | 高 | 高 | Data 準備 | Sprint 14 |
| US-RI-024 | 身為財務，我要自動化 IFRS17 報表，以便快速完成月結 | 高 | 高 | US-RI-023 | Sprint 15 |
| US-RI-025 | 身為資料團隊，我要匯入工具，以便遷移歷史資料 | 中 | 中 | US-RI-023 | Sprint 16 |
| US-RI-026 | 身為 QA，我要資料品質檢核，以便確保遷移準確 | 中 | 中 | US-RI-025 | Sprint 16 |
| US-RI-027 | 身為 QA，我要 SIT 測試腳本與執行，以便驗證整合品質 | 高 | 中 | 核心模組完備 | Sprint 17 |
| US-RI-028 | 身為業務，我要 UAT 支援與培訓，以便順利上線 | 高 | 中 | SIT 完成 | Sprint 17 |
| US-RI-029 | 身為 DevOps，我要 Cutover 計畫，以便順利上線 | 高 | 中 | SIT/UAT | Sprint 18 |
| US-RI-030 | 身為 SRE，我要上線監控與告警，以便掌握系統健康 | 高 | 中 | Cutover 準備 | Sprint 18 |
| US-RI-031 | 身為 PMO，我要上線執行與驗證，以便達成 MVP 目標 | 高 | 中 | Sprint 18 | Sprint 19 |
| US-RI-032 | 身為 Support，我要 Hypercare 支援流程，以便穩定營運 | 中 | 中 | Sprint 19 | Sprint 20 |

---

## 3. 後續 Refinement 建議
- 每週 Backlog Refinement 時，確認 Business Value、依賴關係與估點。
- 重要議題（如 AI/IFRS17）需同步多方干係人確保需求一致。
- 視市場或合規變化調整優先序，並更新此文件版本紀錄。
- 保持至少 2 個 Sprint 的 Ready Stories（DoR 通過）。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 初版 MVP Product Backlog | Tao Yu 和他的 GPT 智能助手 |
| v0.2 | 2025-09-12 | 更新 Story ID 格式為 `US-RI-` 前綴 | Tao Yu 和他的 GPT 智能助手 |
| v0.3 | 2025-09-12 | Story ID 重新依序編號（US-RI-001～032） | Tao Yu 和他的 GPT 智能助手 |
