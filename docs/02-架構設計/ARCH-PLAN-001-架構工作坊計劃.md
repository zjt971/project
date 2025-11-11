# RI-5-1 系統架構工作坊計畫 / Architecture Workshop Plan

> 任務目的：支援 `RI-5-1`（Sprint 2），召集架構團隊與關鍵干係人，共同定義再保系統的整體架構藍圖、整合策略與技術決策基準。

---

## 1. 工作坊資訊
- **會議名稱**：Reinsurance System Architecture Blueprint Workshop
- **日期**：2025-10-22（建議於 Sprint 2 第 1 週舉行）
- **時間**：10:00 – 12:00（UTC+08）
- **形式**：混合（台北 HQ 15F Strategy Room + Microsoft Teams）
- **主持人**：Architecture Lead
- **記錄人**：Scrum Master
- **參與角色**：
  - Architecture Team（應用、資料、整合）
  - DevOps Lead、Security Lead
  - Product Owner / PMO
  - Data Lead、AI/ML Lead
  - Integration Lead（含外部 EIS 代表）

---

## 2. 目標與輸出
1. 確立系統分層架構、模組邊界與核心組件。
2. 定義資料流向、整合風格（API/Event）、安全性與合規要求。
3. 確認關鍵技術決策（雲端基礎、服務框架、資料庫選型等）。
4. 產出草稿架構圖、整合架構圖與決策清單，作為 `RI-5-2` 評審基礎。

**預期產出**：
- 架構藍圖草稿（應用/資料/整合視圖）
- 技術決策紀錄（ADR 清單）
- 待辦議題與後續行動項目

---

## 3. 議程安排

| 時段 | 主題 | 負責人 | 重點內容 |
|---|---|---|---|
| 10:00 – 10:10 | 開場與目標對齊 | Architecture Lead | 會議目的、預期成果、議程介紹 |
| 10:10 – 10:30 | 需求與限制確認 | PO、PMO | MVP 範圍、非功能需求、整合假設 |
| 10:30 – 11:00 | 架構候選方案 | Architecture Team | 系統分層、微服務/模組邊界、資料策略 |
| 11:00 – 11:20 | 整合與安全設計 | Integration Lead、Security Lead | API Gateway、Event Bus、資安需求、授權模型 |
| 11:20 – 11:40 | 平台與 DevOps 支援 | DevOps Lead | CI/CD、環境、監控、災難復原計畫概覽 |
| 11:40 – 11:55 | 決策彙整與開放議題 | Architecture Lead | 確認共識、列出需後續研究項目 |
| 11:55 – 12:00 | 行動項目與下一步 | Scrum Master | 收斂行動項、責任人與時程 |

---

## 4. 會前準備
- **Architecture Lead**：整理初版架構草圖（應用/資料/整合）。
- **DevOps Lead**：提供環境現況、CI/CD 需求摘要。
- **Security Lead**：整理資安基線、合規要求（含資料隱私）。
- **Data Lead**：準備主要資料來源、資料量與品質現況。
- **PO/PMO**：更新最新範疇與非功能需求摘要。
- **Scrum Master**：安排會議、準備協作白板（Miro/Teams Whiteboard）、建立會議筆記模板。

---

## 5. 會後行動與追蹤
- 整理會議紀錄與架構草圖（Scrum Master，Due: 2025-10-23）。
- 形成 Architecture Decision Record（ADR）初稿（Architecture Lead，Due: 2025-10-25）。
- 確認需進一步研究的技術議題，建立對應 Action Items 或 Spike Story。
- 將輸出提交至 `RI-5-2` 架構評審會議審核。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 建立架構工作坊計畫初稿 | Tao Yu 和他的 GPT 智能助手 |
