# RI-1-3 再保系統專案章程草案 / Project Charter Draft

> 任務來源：`PM-REPORT-001-任務追蹤.md`（Sprint 1 任務）。目的：於 2025-10-03 前提供專案章程草稿，供 PO 與 Scrum Master 校稿。

---

## 1. 專案基本資訊
- **專案名稱**：再保系統（Reinsurance System）
- **專案編號**：EIS-REINS-PRJ-001
- **贊助人 / Sponsor**：Ran Guo（COO）
- **產品負責人 / Product Owner**：Tao Yu
- **專案管理 / PMO Lead**：Tao Yu
- **Scrum Master**：待正式指派（暫由 PMO 代理）
- **專案期間**：2025-09-25 ～ 2026-11-13（含 Hypercare）
- **版本目標**：2026-10-30 MVP 上線，Hypercare 支援至 2026-11-13

---

## 2. 專案背景與願景
- 源於再保業務對自動化、合規與跨國規模的需求，需提供獨立且可插拔的再保系統。
- 以台灣壽險/產險市場為優先，兼顧全球擴充與跨系統整合。
- 結合 AI 輔助分析（合約解析、異常偵測）以提升核保與對帳效率。
- 參照 PRD（`RI/requirement/EIS-REINS-PRD-001.md`）與 Project Plan（`PM-PLAN-001-專案計劃.md`）之願景與範疇。

---

## 3. 目標與成功指標（KPI）

| 領域 | KPI 指標 | 目標值 |
|---|---|---|
| 對帳效率 | 月結處理時間縮短 | ≥ 50% |
| 合規品質 | 再保對帳錯誤率 | ≤ 10%（降低 90%） |
| 報表自動化 | IFRS17 報表產出時間 | < 4 小時 |
| 使用者採用 | 核保/再保人員使用率 | ≥ 80% |
| 系統運維 | MVP 上線後重大缺陷 | 0 件（Hypercare 期間） |

---

## 4. 範疇概述

### 4.1 主要交付範圍
- **合約管理（Treaty Management）**
- **臨分管理（Facultative Management）**
- **分保計算引擎（Cession Engine）**
- **理賠攤回與再保 SoA**
- **IFRS17 報表服務**
- **AI/ML 功能：條款解析、異常偵測、Insights Dashboard**
- **資料遷移與稽核**
- **權限、稽核、DevOps 基礎設施**

### 4.2 非範圍（Phase 1）
- 產險理賠自動化流程
- 再保人外部 Portal
- 全球擴充客製（Phase 2 另案）

---

## 5. 里程碑與時程摘要

| 里程碑 | 目標日期 | 摘要 |
|---|---|---|
| M1 | 2025-09-25 | 專案啟動完成 |
| M2 | 2025-11-28 | 架構與整合設計就緒 |
| M3 | 2025-12-12 | MVP 範圍凍結 |
| M4 | 2026-04-17 | 核心模組 Beta |
| M5 | 2026-06-19 | AI & 理賠/SoA Alpha |
| M6 | 2026-08-21 | IFRS17 & 資料遷移準備完成 |
| M7 | 2026-09-25 | SIT & UAT 通過 |
| M8 | 2026-10-30 / 2026-11-13 | MVP 上線 & Hypercare |

（詳細請參考 `PM-PLAN-001-專案計劃.md` 與 `reinsurance-system-scrum-plan.md`）

---

## 6. 專案治理與角色責任

| 角色 | 職責 | 主要人員 |
|---|---|---|
| Steering Committee | 策略決策、資源調度、重大變更批准 | Sponsor、CFO、EIS 代表 |
| PMO / Product | 需求優先序、Roadmap、溝通與風險治理 | Tao Yu、Product Ops |
| Scrum Master | 敏捷節奏、障礙排除、持續改善 | 待指派（暫由 PMO 代理） |
| Architecture Board | 架構藍圖、整合策略、資安控管 | Architecture Lead、Security Lead |
| Engineering Squads | 開發與測試（Treaty/Facultative、Cession、Reporting、AI） | 各模組 Tech Lead |
| Data & AI | 資料治理、模型研發、品質監控 | Data Lead、AI/ML Lead |
| Finance & Compliance | IFRS17、合規審查、報表驗證 | Finance SME、Compliance |
| Operations & Support | 上線準備、Hypercare、運維交接 | Operations Lead、Support |

---

## 7. 主要利害關係人與溝通
- **贊助人**：每月 Steering Review 報告。
- **產品與業務團隊**：每次 Sprint Review、Backlog Refinement。
- **技術團隊**：每日站會、技術工作坊、PI Sync。
- **財務/合規**：每月合規 Checkpoint、IFRS17 工作坊。
- **外部合作夥伴（EIS 等）**：整合會議、API Share-out。
- 詳細名單與接觸方式將於 `RI-2-1` 與 `RI-2-2` 任務提供。

---

## 8. 風險與假設

### 8.1 主要風險
- 整合規格延遲 → 需建立 API 模擬伺服器與契約測試。
- AI 模型資料不足 → 需及早進行資料蒐集與隱私審核。
- IFRS17 報表需求變動 → 2025-12-12 前凍結並建立變更流程。
- 關鍵人力不足 → 建立備援計畫與知識庫。

### 8.2 關鍵假設
- 核心系統資料介接於 2025-10-24 前敲定。
- DevOps 平台於 2025-10-31 前就緒。
- 歷史資料樣本於 2026-03-16 前取得。
- 主要干係人能參與 Sprint Review 與 Steering Review。

---

## 9. 預算與資源概述（初稿）
- 人力：核心 Squad 4 組（Treaty/Facultative、Cession、Reporting/IFRS17、AI/Insights），每組 5~7 人。
- 支援：PMO/Product Ops、QA、DevOps、Data、Compliance。
- 工具與平台：雲端環境、CI/CD、監控、AI 運算資源。
- 詳細成本分攤與預算將由財務部門於 2025-Q4 內提供。

---

## 10. 核可與修訂

| 角色 | 行動 | 狀態 |
|---|---|---|
| Product Owner | 審閱與建議 | 待確認 |
| Scrum Master | 流程校稿 | 待確認 |
| Sponsor | 核可並啟動專案 | 待確認 |

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 初版章程草稿 | Tao Yu 和他的 GPT 智能助手 |
