# RI-4-1 風險登錄表 / Risk Register

> 任務來源：`PM-REPORT-001-任務追蹤.md`。建立風險管理機制，並填入初始風險項目，供 Sprint 1 及後續迭代追蹤。

---

## 1. 風險管理流程摘要
- **識別**：每週風險檢視會議、Scrum 儀式與 PMO 日常監控。
- **評估**：使用 Likelihood（發生機率）與 Impact（影響程度） 1~5 分制，計算 Risk Score = L × I。
- **應對策略**：避免 (Avoid)、減輕 (Mitigate)、轉移 (Transfer)、接受 (Accept)。
- **追蹤**：Scrum Master 與 PMO 保持更新，里程碑前重新評估。
- **通報**：重大風險需在 24 小時內通知 Sponsor 與 Steering Committee。

---

## 2. 初始風險列表

| Risk ID | 類型 | 描述 | L (1-5) | I (1-5) | Score | 應對策略 | 行動項目 / Owner | 狀態 |
|---|---|---|---|---|---|---|---|---|
| R-001 | 整合 | 外部核心系統 API 規格與時程不明確，可能延誤整合開發 | 3 | 5 | 15 | Mitigate | A06：Integration Lead 與 EIS 代表確認交付時程 | 開啟 |
| R-002 | 資料 | 歷史資料樣本品質不一，影響分保計算與遷移測試 | 3 | 4 | 12 | Mitigate | A04：Data Lead 建立資料需求與清洗規範 | 開啟 |
| R-003 | 合規 | AI 模型可能涉及個資，導致合法性與稽核疑慮 | 2 | 5 | 10 | Mitigate | A05：Legal/Compliance 進行資料隱私審核 | 開啟 |
| R-004 | 人力 | Scrum Master 尚未正式到位，敏捷節奏可能受影響 | 3 | 3 | 9 | Mitigate | A07：PMO/HR 完成指派並交接 | 開啟 |
| R-005 | 報表需求 | IFRS17 報表需求若頻繁變動，將導致重工 | 2 | 4 | 8 | Avoid/Mitigate | 需求凍結日 2025-12-12，透過 CCB 控制 | 開啟 |
| R-006 | 技術 | DevOps 環境若未如期完成，Sprint 開發節奏受阻 | 3 | 4 | 12 | Mitigate | DevOps Lead 於 2025-10-31 前確認環境 | 開啟 |
| R-007 | 使用者採納 | 核心使用者若缺席 UAT/培訓，降低系統採用度 | 2 | 4 | 8 | Mitigate | Product Ops 安排 UAT Briefing 與培訓計畫 | 開啟 |

---

## 3. 後續維護
- 每週風險檢視（`RI-4-2` 任務）更新狀態，新增或關閉風險需保留紀錄。
- 重大風險變動需更新行動項目 `PM-ACTION-001-行動項目.md`。
- 於每次 Steering Review 前提出最新風險評估報告。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 初版風險登錄表 | Tao Yu 和他的 GPT 智能助手 |
