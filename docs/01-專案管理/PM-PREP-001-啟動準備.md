# RI-1-1 再保系統專案 Kickoff 議程與資料準備

> 任務說明：依據 `PM-REPORT-001-任務追蹤.md`，完成專案啟動會議（Kickoff）議程與相關資料準備，支援 M1 里程碑。

---

## 1. 會議基礎資訊
- **會議名稱**：再保系統專案啟動會議 / Reinsurance System Project Kickoff
- **日期**：2025-09-25（四）
- **時間**：09:30 – 12:00（台北時間）
- **地點 / 形式**：
  - 現場：台北總部 15F Strategy Room
  - 線上：Microsoft Teams（連結將於 2025-09-23 前發布）
- **主持人**：Tao Yu（PMO）
- **記錄人**：Scrum Master（待定）

---

## 2. 會議目標
1. 對齊專案願景、核心里程碑與關鍵成功指標（KPI）。
2. 確認跨部門角色與責任、溝通治理機制。
3. 檢視高層需求與 PRD 重點，確保 MVP 範疇一致。
4. 發佈初版 Product Backlog 與下一步規劃。
5. 驗證 DevOps、資料、資安等支援需求與時程。

---

## 3. 參與角色與代表

| 角色 | 代表人員 | 主要責任 |
|---|---|---|
| 專案贊助人 / Sponsor | Ran Guo（COO） | 提供戰略方向、資源調配 |
| Steering Committee | Qili Zhang（CFO）、Ran Guo（COO）、EIS 合作夥伴代表 | 重大決策審議、跨部門協調 |
| PMO / Product | Tao Yu（PO/PMO Lead）、Product Ops 团隊 | 專案治理、需求優先序、交付節奏 |
| Scrum Master | 指派中 | 敏捷流程推動、移除障礙 |
| Architecture & Security | Architecture Lead、Security Lead | 架構藍圖、整合策略、資安控管 |
| Engineering Squads | 前後端 Tech Lead、DevOps 代表 | 模組設計與開發、平台支援 |
| Data & AI | Data Lead、AI/ML Lead | 資料治理、模型開發 |
| Finance & IFRS17 | Finance SME、Reporting Lead | 報表需求、合規確認 |
| Claims & Operations | Claims SME、Operations Lead | 業務流程需求、上線支援 |

---

## 4. Kickoff 詳細議程

| 時間 | 議程主題 | 主講人 / 負責人 | 備註 |
|---|---|---|---|
| 09:30 – 09:40 | 開場與與會介紹 | PMO | 會議目的、議程預告 |
| 09:40 – 10:00 | 專案願景、目標 & KPI | Sponsor / PMO | 成功指標、預期效益、治理架構 |
| 10:00 – 10:20 | PRD 重點回顧與 MVP 範圍 | PO | 主要 Use Cases、非功能需求摘要 |
| 10:20 – 10:35 | 里程碑、甘特圖與 Scrum 節奏 | PMO / Scrum Master | Milestone、迭代節奏、儀式安排 |
| 10:35 – 10:50 | 架構與整合藍圖初探 | Architecture Lead | 系統邊界、整合摸擬、風險提示 |
| 10:50 – 11:05 | 資料、AI、IFRS17 支援需求 | Data Lead / AI Lead / Finance SME | 重要資料需求、模型策略、報表預期 |
| 11:05 – 11:20 | DevOps、資安與品質治理 | DevOps Lead / Security Lead / QA Lead | Pipeline、資安要求、DoR/DoD 草案 |
| 11:20 – 11:40 | Product Backlog 與下一步計畫 | PO / Scrum Master | 初版 Backlog、Sprint 0 任務、風險統整 |
| 11:40 – 11:55 | 問答與風險/議題蒐集 | 全體 | 記錄開放式問題與阻礙 |
| 11:55 – 12:00 | 總結與行動項目 | Sponsor / PMO | 重點回顧、行動列單、後續節點 |

---

## 5. 會議資料包內容
- 開場簡報（含願景、KPI、治理架構）。
- PRD 摘要手冊：核心 Use Case、資料模型重點、AI/IFRS17 範疇。
- 里程碑與 Scrum 計畫圖表（Mermaid 甘特圖摘要）。
- 初版 Product Backlog 清單（`PM-PLAN-002-Sprint計劃.md` / Jira 匯出）。
- 整合架構草圖與 API 接口清單草案。
- 風險登錄表（初版）與問題記錄模板。
- DevOps/資安合規要求摘要與 DoR/DoD 草案。
- 會議紀錄模板與後續跟進清單。

---

## 6. 會議前後行動項目

### 6.1 會前（Due: 2025-09-24）
- PMO：完成簡報草稿並取得 Sponsor 確認。
- Scrum Master：確認線上會議連結、音訊/錄影設定。
- Product Ops：蒐集干係人最新聯絡資訊，寄送邀請函。
- Data/Architecture/DevOps Lead：提供 1-2 頁重點摘要納入資料包。

### 6.2 會後（Due: 2025-09-26）
- Scrum Master：發布會議紀錄與行動項目負責人。
- PMO：更新風險登錄表與溝通矩陣。
- PO：同步 Product Backlog 更新與 Sprint 1 計畫草案。
- DevOps：確認環境建置需求並安排後續會議。

---

## 7. 待決議議題（Kickoff Q&A）
- 定義 Steering Committee 例會頻率與形式。
- 確認跨系統整合窗口與溝通節點。
- 資安穿透測試與合規稽核時間表。
- AI 模型監管與資料隱私審核流程。
- Hypercare 結束後的運維 KPI 與責任切換。

---

## 8. 版本紀錄

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 初版草稿，供 PMO 審閱 | Tao Yu 和他的 GPT 智能助手（依指示產出） |
