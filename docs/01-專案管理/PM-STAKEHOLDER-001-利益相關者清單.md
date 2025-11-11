# RI-2-1 再保系統干係人登錄清單 / Stakeholder Register

> 任務來源：`PM-REPORT-001-任務追蹤.md`（Sprint 1）。目的：建立干係人資料、角色、期望與溝通偏好，以支援溝通矩陣與治理流程。

---

## 1. 干係人摘要

| 分類 | 干係人群組 | 主要目標 | 參與模式 |
|---|---|---|---|
| 策略層 | 贊助人、Steering Committee | 戰略指導、資源配置、決策核可 | 月度 Steering Review、重大議題決策 |
| 產品層 | PO、Product Ops、業務代表 | 需求優先序、價值實現、用戶體驗 | Sprint Review、Backlog Refinement |
| 技術層 | Architecture、Engineering、DevOps | 架構設計、開發交付、平台維運 | 每日站會、技術工作坊、PI Sync |
| 支援層 | Finance、Compliance、Legal、Data | IFRS17、合規、資料治理 | 每月合規檢視、專題工作坊 |
| 使用者層 | 核保、再保、理賠、財務操作人員 | 實際使用系統、提供回饋 | UAT、培訓、Hypercare 支援 |
| 外部合作 | EIS、外部再保人/系統廠商 | 整合介面、資料交換 | 整合會議、API 對接 |

---

## 2. 干係人明細

| ID | 姓名 / 部門 | 角色 / 職稱 | 主要責任 | 影響力/關注度 | 溝通偏好 | 頻率 | 備註 |
|---|---|---|---|---|---|---|---|
| ST-01 | Ran Guo / COO Office | Sponsor | 戰略方向、資源支持、Go/No-Go | 高 / 高 | Email + 月會 | 月度 Steering Review | 需提前提供 KPI 與決策議題 |
| ST-02 | Qili Zhang / Finance | Steering Committee (CFO) | 財務治理、IFRS17 決策 | 高 / 高 | Email + 面談 | 月度 Steering Review | 關注報表準確性與合規 |
| ST-03 | EIS 代表 | Steering Committee | 核心系統整合協作 | 中 / 高 | Teams | 雙週整合會議 | 需明確 API 時程 |
| ST-04 | Tao Yu / PMO | Product Owner & PMO Lead | 需求優先序、Roadmap、溝通治理 | 高 / 高 | Teams + 面談 | 每日/週 | 主要窗口 |
| ST-05 | Product Ops 團隊 | Product Ops | 需求彙整、溝通矩陣、培訓支援 | 中 / 中 | Teams + Confluence | 週會 | 與業務、用戶密切互動 |
| ST-06 | Scrum Master（待指派） | Scrum Master | 敏捷節奏、障礙排除 | 中 / 高 | Teams + Daily Sync | 每日 | 指派後更新 |
| ST-07 | Architecture Lead | 技術架構 | 架構藍圖、整合設計、技術決策 | 高 / 中 | 技術工作坊 | 週會 | 與 Security Lead 協同 |
| ST-08 | Security Lead | 資安負責人 | 威脅建模、資安審核、合規檢查 | 中 / 高 | Email + 會議 | Sprint 3 起密集 | 與 Legal/Compliance 合作 |
| ST-09 | Backend/Frontend Tech Leads | 工程領導 | 模組開發、技術方案 | 中 / 中 | Daily Standup | 每日 | 各 Squad 代表 |
| ST-10 | DevOps Lead / SRE | 平台與運維 | CI/CD、環境、監控、Cutover | 中 / 中 | Teams + 任務板 | 每週 | Hypercare 期間為主力 |
| ST-11 | Data Lead | 資料治理 | 資料需求、遷移、品質檢核 | 中 / 中 | Teams + Data Workshop | 雙週 | 與 AI、Finance 密切合作 |
| ST-12 | AI/ML Lead | AI 能力 | 模型設計、訓練、部署 | 中 / 中 | AI Sync | 週會 | 需資安與資料支持 |
| ST-13 | Finance SME / IFRS17 | 財務代表 | 報表需求、審核、校驗 | 中 / 高 | Email + Workshop | 週 / 月 | 關注報表準確、合規 |
| ST-14 | Compliance / Legal | 合規法務 | 資料隱私、契約條款、稽核 | 中 / 高 | Email + 法遵會議 | 月會 | 需及早同步 AI/資料用途 |
| ST-15 | Claims SME | 理賠業務 | 理賠流程需求、UAT 執行 | 中 / 中 | Teams + Workshop | 週會 | 需 SoA 團隊支援 |
| ST-16 | Operations Lead | 運營支援 | 上線準備、Hypercare 管理 | 中 / 中 | Teams + Cutover Meeting | Sprint 18 起 | 指標需要與 Ops KPI 對齊 |
| ST-17 | 核保/再保使用者代表 | 業務使用者 | 系統體驗、UAT 回饋 | 低 / 高 | 面談 + 訓練 | Sprint 13 起 | 需引導回饋流程 |
| ST-18 | 外部再保人代表 | External Partner | 資料交換、SoA 對帳 | 低 / 中 | Email + 月會 | 月度 | 視合作協議確定參與度 |

---

## 3. 溝通與互動建議
- **Steering Committee**：提供月度進度報告與 KPI 摘要，重大議題於會前 3 日送交。
- **產品/技術團隊**：透過 Scrum 儀式（Daily、Review、Retrospective）與每兩週的 PI Sync 對齊。
- **財務/合規團隊**：建立固定工作坊（IFRS17、資料隱私）以追蹤需求與風險。
- **使用者代表**：於 UAT、培訓及 Hypercare 期間保持密切聯繫，確保用戶採納。
- **外部合作夥伴**：明確界定資料交換流程與 SLA，避免整合阻塞。

---

## 4. 後續維護
- Product Ops 於每季度（或人員職責變動時）更新此清單。
- 與 `RI-2-2` 溝通矩陣、`RI-1-3` 專案章程同步，以保持角色一致性。
- 若新增干係人，需在任務追蹤表中建立對應 Action Item。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 建立初版干係人登錄清單 | Tao Yu 和他的 GPT 智能助手 |
