# RI-5-2 架構藍圖審查清單 / Architecture Blueprint Review Checklist

> 任務目的：支援 `RI-5-2`（Sprint 2），在架構工作坊成果基礎上，進行正式審查與核可流程，確保架構藍圖符合專案目標與非功能需求。

---

## 1. 審查會議資訊
- **會議名稱**：Architecture Blueprint Review & Sign-off
- **日期**：2025-11-04（建議於 Sprint 2 第 3 週舉行）
- **時間**：14:00 – 16:00（UTC+08）
- **主持人**：Architecture Lead
- **審查委員**：
  - Sponsor / Steering Committee 代表（可指派 Architecture Board 成員）
  - Product Owner / PMO
  - Security Lead
  - DevOps Lead
  - Data Lead、AI/ML Lead
  - Integration Lead
  - Compliance/Legal 代表（針對資料/合規議題）

---

## 2. 審查輸入（Prerequisites）
- `RI-5-1` 架構工作坊產出：
  - 應用、資料、整合視圖的架構草圖
  - 技術決策清單（ADR 初稿）
- `RI-6-1` 資料需求彙整與敏感資料分類
- 非功能需求清單（性能、可用性、安全性等）
- 外部整合需求與 SLA 假設
- 風險登錄表 (`../01-專案管理/PM-RISK-001-風險登錄.md`)

---

## 3. 審查檢核項目

### 3.1 架構涵蓋性
- [ ] 是否明確界定各模組/微服務邊界（Treaty、Facultative、Cession、Claims/SoA、IFRS17、AI 等）？
- [ ] 是否定義核心資料流與資料存放位置（ OLTP、Data Lake、報表倉儲）？
- [ ] 是否涵蓋上游/下游整合介面（EIS、外部再保、會計系統等）？

### 3.2 非功能需求
- [ ] 性能與延遲需求（試算 API、SoA 生成、報表）是否有對應方案？
- [ ] 可用性與容錯策略（多 AZ、故障轉移、備援）是否完善？
- [ ] 安全性與存取控制模型是否對照資安基線？
- [ ] 可維運性：監控、告警、日誌、配置管理、災難復原計畫是否涵蓋？

### 3.3 資料與合規
- [ ] 敏感資料分類與處理方式（加密、遮罩、存取控制）是否符合政策？
- [ ] 資料遷移策略與歷史資料保留需求是否反映在架構上？
- [ ] AI 模型與資料使用是否符合隱私與監理要求？

### 3.4 技術決策與風險
- [ ] 關鍵技術選型（語言、框架、資料庫、消息系統、API Gateway）是否清楚記錄？
- [ ] 未決議題/風險是否列入 Action Items，並指定責任人與時程？
- [ ] 與 DevOps/Platform 設計是否一致（CI/CD、部署策略）？

---

## 4. 審查輸出
- 審查會議紀錄（含決議與 Action Items）
- 架構藍圖 v0.9（更新後）
- 確認版 Architecture Decision Records（ADR v0.9）
- 審查簽核完成後，更新專案計畫 (`reinsurance-system-project-plan.md`) 架構章節
- 若需後續 Proof of Concept 或 Spike，建立對應故事/任務

---

## 5. 後續追蹤
- 行動項目需在 Sprint 3 前完成或納入 Backlog。
- 每次 Steering Review 提供架構進度與風險更新。
- 重大變更須走 CCB 流程並更新 ADR。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 建立架構藍圖審查清單初稿 | Tao Yu 和他的 GPT 智能助手 |
