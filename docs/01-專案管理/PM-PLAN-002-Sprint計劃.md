# 再保系統 Scrum Sprint 計畫 / Reinsurance System Scrum Plan

> 版本：2025-02-14。此計畫與最新專案計畫書 (`PM-PLAN-001-專案計劃.md`) 及 PRD/FRD 對齊，採 3 週 Sprint 固節奏。所有時間描述皆以 Sprint 序號表示，不再給出固定日曆日期；實際日期於 Sprint Planning 會議鎖定並同步於任務追蹤板。

---

## 1. Sprint 節奏與治理 / Cadence & Governance
- **Sprint 長度**：3 週；Sprint Planning（<= 4 小時）→ 迭代執行 → Sprint Review & Retro。
- **共通儀式**：每日站會、每週 Backlog Refinement、雙週 PI Sync、月度 Steering Review。
- **分工角色**：PO 決定優先序並維護 Backlog；Scrum Master 促進節奏並排除障礙；Architecture Lead 守護 ADR 與技術決策；Squad 共同守護 DoD。
- **主要工件**：Product Backlog、Sprint Backlog、Working Agreement、定義之 ADR / UIUX 指南；所有任務以 `PM-REPORT-001-任務追蹤.md` 為準。
- **Definition of Done**：程式碼合併至主線、通過單元 + 整合測試、更新對應 ADR/指引、完成文件與操作手冊、部署腳本可自動執行。

---

## 2. Sprint 路線圖 / Sprint Roadmap

| Sprint | 主題 Theme | 核心交付 | 狀態 | 備註 |
|--------|-----------|----------|------|------|
| S0 | 啟動與治理基線 | 專案章程、干係人矩陣、Markdown 內容結構 | ✅ 完成 | 所有啟動文檔已合併。 |
| S1 | 規格與設計基線 | PRD/FRD 重整、UIUX v0.4、ADR-001~004 更新 | ✅ 完成 | FIGMA 對齊規範已公布。 |
| S2 | 平台骨架與兩大模組 POC | App Shell / Navigation、Server Action 分層、再保人 & 合約 CRUD | 🔄 進行中 | 功能 Demo 已可運行，等待視覺回歸測試與資料種子調整。 |
| S3 | 臨分與分保引擎設計 | 領域模型、計算規則、接口定義 | ⏳ 未開始 | 需與精算/核保團隊工作坊。 |
| S4 | 臨分開發迭代 | 臨分建檔流程、報價文件、審批串接 | ⏳ 未開始 | 依 FRD `EIS-REINS-FRD-FA.md`。 |
| S5 | 分保計算引擎開發 | 計算規則引擎、佣金/費用邏輯、試算 API | ⏳ 未開始 | 與 S4 並行，強調自動化測試。 |
| S6 | 分入再保與理賠攤回 | 分入流程、攤回追蹤、共用資料模型 | ⏳ 未開始 | 需沿用再保人資料與合約規則。 |
| S7 | SoA & IFRS17 | 結算流程、自動化報表、資料導入支援 | ⏳ 未開始 | 將建置批次與匯入模組。 |
| S8 | 平台強化 & Integration | API 管理、權限稽核、監控、整合測試 | ⏳ 未開始 | 對齊 ADR-006、開發手冊。 |
| S9 | UAT 準備與 Hypercare | UAT 場景、移轉計畫、上線手冊 | ⏳ 未開始 | 攜手營運單位共同執行。 |

---

## 3. Sprint 主題細節 / Sprint Theme Details

### S0 啟動與治理基線（✅ 完成）
- Kickoff Workshop、角色與溝通矩陣建立。
- Markdown 結構 (`RI-3-1`)、文件維運流程 (`RI-3-2`) 完成。
- 風險登錄 (`RI-4-1`) 與稽核節奏 (`RI-4-2`) 已運作。

### S1 規格與設計基線（✅ 完成）
- PRD 重新整理：更新模組範圍、UC 順序、Figma 參考。
- FRD 依模組拆分 (`requirement/EIS-REINS-FRD-*.md`) 完成。
- UIUX 指南 (`../08-用戶界面/UI-GUIDE-001-界面設計指南.md`) 與 App Shell 樣板確立。
- ADR-006 Git Branching Strategy、開發手冊 (`../03-開發指南/DEV-GUIDE-001-開發人員手冊.md`) 發布。

### S2 平台骨架與兩大模組 POC（🔄 進行中）
- App Shell、Top Navigation、Sidebar、PageContainer fluid 佈局完成。
- 共用 SectionCard、FormGrid、Alert、DeleteEntityButton 已抽象化。
- Treaty / Reinsurer 模組：Server Action + Service Layer + Prisma 實作；單元測試與整合測試綠燈。
- 未竟事項：視覺回歸測試、響應式尺寸驗證、共用表單元件說明文補齊。

### S3 臨分與分保引擎設計（⏳ 未開始）
- 工作坊：臨分流程拆解、分保規則 catalog、資料模型合併。
- 產出：ADR-0XX 臨分架構、規則引擎藍圖、API 合約草稿。
- 依賴：S2 完成後共用元件穩定、資料字典初稿。

### S4 臨分開發迭代（⏳ 未開始）
- 目標：臨分建立/維護、報價模板、審批流程、文件管理。
- 測試：建立臨分專用的整合測試情境與文件上傳模擬。

### S5 分保計算引擎開發（⏳ 未開始）
- 目標：完成保費/賠款/佣金核心邏輯、版本控管與試算 API。
- 測試策略：以契約樣本建立黃金案例、以自動化試算驗證計算結果。

### S6 分入再保與理賠攤回（⏳ 未開始）
- 目標：分入合約建檔、核保資料錄入、再保回覆追蹤、攤回對帳。
- 共同元件：沿用再保人主檔、共通系統資訊區塊、歷史作業紀錄。

### S7 SoA & IFRS17（⏳ 未開始）
- 目標：SoA 自動化、IFRS17 報表匯出、批次匯入/資料治理。
- 須擬定：批次排程策略、報表驗證流程、與財會協作節點。

### S8 平台強化 & Integration（⏳ 未開始）
- 內容：API 管理 (ADR-003/006 延伸)、權限稽核、監控告警、部署自動化。
- Definition of Ready：對應模組皆具備稽核事件與系統資訊欄位。

### S9 UAT 與 Hypercare（⏳ 未開始）
- 準備 UAT 場景、資料匿名化策略、操作手冊、Hypercare Runbook。
- 目標：UAT 通過率 ≥ 95%，Hypercare 期內重大缺陷 = 0。

---

## 4. Backlog 管理與優先序準則
- Backlog 以模組為主線：再保人 → 合約 → 臨分 → 分保 → 分入 → 理賠 → SoA/IFRS17 → 平台治理。
- 優先序依下列條件調整：
  1. 關鍵業務流程優先（再保人、合約、臨分、分保引擎）。
  2. 平台性質（權限、稽核、監控）需在模組完成後立即補齊，避免技術債。
  3. 每個 Sprint 保留 20% 容量處理技術負債或緊急需求。
- Backlog 變更需更新 FRD/ADR，並於 Sprint Planning 確認影響。

---

## 5. Definition of Ready (DoR)
- User Story 具備明確的業務背景、AC、UI/資料來源（連結至 PRD/FRD、UIUX）。
- 介面契約 / Domain Model 已於 ADR 或資料字典敲定。
- 測試策略（單元、整合、E2E）已指定負責人與檢驗方式。
- 如果故事涉及跨模組，需於 Refinement 完成依賴協調。

---

## 6. 持續改善 / Continuous Improvement
- Retro 行動項目紀錄於 `PM-REPORT-001-任務追蹤.md`「持續維運」區段，並設定負責人與驗收方式。
- 每兩個 Sprint 重新檢視：
  - DoD / DoR 是否需調整。
  - UIUX 指南與 ADR 是否與實作同步。
  - 測試覆蓋率與自動化程度。

---

> 文件維護：Scrum Master（節奏）、Architecture Lead（技術標準）、Product Owner（優先序），實際編撰者為 Tao Yu 和他的 GPT 智能助手。若本文件與 PRD/FRD 不一致，以最新 PRD/FRD 與 ADR 為準。
