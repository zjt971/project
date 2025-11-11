# 再保系統專案啟動會議紀錄

- **會議編號**：RI-1-1
- **日期**：2025-09-25
- **時間**：09:30 – 12:00（UTC+08）
- **地點**：台北總部 15F Strategy Room / Microsoft Teams
- **主持人**：Tao Yu（PMO）
- **記錄人**：Scrum Master（代記：Tao Yu 和他的 GPT 智能助手）

---

## 1. 與會人員

| 角色 | 代表人員 | 出席狀態 |
|---|---|---|
| Sponsor | Ran Guo | 出席 |
| Steering Committee | Qili Zhang、EIS 合作夥伴代表 | 出席 |
| PMO / Product | Tao Yu、Product Ops 團隊 | 出席 |
| Scrum Master | 指派中（由臨時代理出席） | 出席 |
| Architecture & Security | Architecture Lead、Security Lead | 出席 |
| Engineering Leads | Frontend Lead、Backend Lead、DevOps Lead | 出席 |
| Data & AI | Data Lead、AI/ML Lead | 出席 |
| Finance & IFRS17 | Finance SME、Reporting Lead | 出席 |
| Claims & Operations | Claims SME、Operations Lead | 出席 |

---

## 2. 議程回顧與討論重點

1. **專案願景與 KPI 對齊**
   - 重申目標：2026-10-30 完成 MVP，上線後 Hypercare 至 2026-11-13。
   - KPI：月結效率提升 50%、對帳錯誤率下降 90%、IFRS17 報表自動化。

2. **PRD 與 MVP 範圍重點**
   - 覆蓋 Treaty、Facultative、分保引擎、理賠攤回、SoA、IFRS17 模組。
   - 確認 AI 原型與資料遷移列為 MVP 內項目。

3. **里程碑與 Scrum 節奏**
   - 採 3 週 Sprint，自 2025-09-29 起。
   - Milestone 對應 Sprint 規劃（M1～M8）獲得 Steering Committee 認可。

4. **架構與整合藍圖**
   - 架構團隊預計於 Sprint 2 完成藍圖評審。
   - 決議使用 API Gateway + Event-driven 整合；需與核心系統確認頻寬需求。

5. **資料、AI、IFRS17 支援**
   - Data Lead 提出歷史資料樣本需於 2026-03-16 前到位。
   - AI 團隊要求提早確認資料隱私與模型稽核流程。
   - Finance SME 要求在 Sprint 14 前鎖定 IFRS17 報表模板。

6. **DevOps、資安與品質治理**
   - DevOps 將於 Sprint 2 完成 CI/CD 原型。
   - Security Lead 安排 Sprint 3 的威脅建模工作坊。
   - DoR/DoD 草案獲初步認可，待 Sprint 4 正式採用。

7. **Product Backlog 與下一步**
   - PO 展示初版 Backlog 優先序（RI- 系列故事）。
   - 確認 Sprint 0 聚焦 Backlog Refinement 與架構工作坊。
   - 風險登錄表與溝通矩陣於 2025-10-05 前更新。

---

## 3. 決議事項
- 確認專案里程碑與 Scrum 節奏安排，無需調整。
- 核可 DoR/DoD 草案，Sprint 4 起強制使用。
- 同意採用共用 API 模擬服務支援前期開發。
- Steering Committee 每月一次，PI Sync 兩週一次。
- 資料隱私審核交由 Legal/Compliance 與 Data Lead 協同進行，於 2025-11-15 前完成初審。

---

## 4. 風險與待解議題
- **R-01**：外部系統 API 規格尚未完全提供 → Integration Lead 與 EIS 代表於 2025-10-11 前確認交付時程。
- **R-02**：AI 模型所需資料可能涉及個資 → Legal/Compliance 需審核資料使用範圍（Action Item #A05）。
- **Open Issue O-01**：Scrum Master 正式指派尚未完成 → PMO 與 HR 於 2025-09-30 前完成。
- **Open Issue O-02**：Hypercare KPI 將在 Sprint 6 前確認指標與量測方法。

---

## 5. 後續行動（詳見 Action Item Tracker）
- A01、A02：PMO 於 2025-09-24 前完成 Kickoff 資料包與邀請函發送。
- A03：Scrum Master 於 2025-09-27 前完成工具設定。
- A04：Data Lead 於 2025-11-01 前提交資料需求清單。
- A05：Legal/Compliance 於 2025-11-15 前完成資料隱私審核。
- 更多詳情請參閱 `PM-ACTION-001-行動項目.md`。

---

## 6. 會議結語
- Sponsor 對團隊投入表示肯定，要求持續對齊商業價值與合規要求。
- 下次關鍵檢視點：Sprint 1 Review（2025-10-17），確認 Backlog 與工具建置進度。

---

## 7. 附錄
- Kickoff 簡報（連結：待上傳）
- Product Backlog 初稿（參考 `PM-PLAN-002-Sprint計劃.md`）
- 風險登錄表（待更新）
- 錄影存檔（Teams 連結：待分享）

---

> 若會議紀錄有需修訂之處，請於 2025-09-29 前告知 PMO。
