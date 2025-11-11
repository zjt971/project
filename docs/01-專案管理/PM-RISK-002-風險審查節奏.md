# RI-4-2 風險審視節奏安排

> 任務來源：`PM-REPORT-001-任務追蹤.md`。建立定期風險審視節奏，確保風險登錄表（`PM-RISK-001-風險登錄.md`）持續更新。

---

## 1. 風險審視會議安排

| 會議名稱 | 主持人 | 參與者 | 頻率 | 時間 | 主要議程 | 輸出 |
|---|---|---|---|---|---|---|
| 週度風險檢視會議 | Scrum Master | PMO、Product Ops、各 Squad 代表、QA、DevOps | 每週三 16:00–16:30 | 線上 Teams | ● 更新風險狀態<br>● 新增/調整風險項目<br>● 檢視應對行動進度 | `PM-RISK-001-風險登錄.md` 更新記錄、會議簡記 |
| Sprint Review Risk Check | Scrum Master | 全體 Sprint Review 參與者 | 每 Sprint Review | Sprint Review 末段 10 分鐘 | ● 回顧 Sprint 內風險<br>● 確認未解決的行動項 | Sprint Review 紀錄中的風險摘要 |
| Steering Review Risk Update | PMO | Steering Committee | 每月 | Steering Review | ● 提交高風險清單<br>● 檢視 Risk Score & 趨勢 | Steering Review 報告風險章節 |

---

## 2. 風險管理工作流程
1. **收集**：團隊於每日站會與週度檢視會議提出新風險或更新。
2. **紀錄**：Scrum Master 更新 `RI-4-1-risk-register.md`，並在追蹤表勾選進度。
3. **執行**：責任人（Owner）依 Action Item 推進緩解措施。
4. **監控**：每週檢查 Risk Score 是否變動，必要時升級至 Sponsor。
5. **關閉**：風險解除時，保留關閉理由與日期，於會議紀錄中備註。

---

## 3. 通知與工具
- 風險登錄表採 Markdown + Git 版控，重大更新需在 Teams `#reinsurance-project` 頻道公告。
- 若 Risk Score ≥ 12，Scrum Master 需於 24 小時內通知 PMO 與 Sponsor。
- 與 Action Item 表 (`PM-ACTION-001-行動項目.md`) 互通，確保行動追蹤。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 建立風險審視節奏初稿 | Tao Yu 和他的 GPT 智能助手 |
