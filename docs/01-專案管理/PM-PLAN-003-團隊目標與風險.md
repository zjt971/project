# RI-1-4 各 Squad 目標與初步風險彙整

> 任務來源：`PM-REPORT-001-任務追蹤.md`（Sprint 1）。目的：整理各主要 Squad 的交付目標、成功指標與初步風險，供專案章程及後續 Sprint 計畫引用。

---

## 1. Squad 概覽

| Squad / Team | 主要範疇 | Product Owner / Lead | 支援角色 |
|---|---|---|---|
| Treaty & Facultative Squad | 合約及臨分模組 | PO：Tao Yu；Tech Lead：Treaty Lead | UX、Actuary SME |
| Cession Engine Squad | 分保計算引擎與試算 API | Tech Lead：Cession Lead | Backend、QA、自動化測試 |
| Claims & SoA Squad | 理賠攤回、SoA、自動對帳 | Product Ops Manager | Finance SME、Reporting Lead |
| IFRS17 & Reporting Squad | IFRS17 資料模型與報表服務 | Finance SME | Data Lead、Reporting Dev |
| AI & Insights Squad | NLP 條款解析、異常偵測、Dashboard | AI/ML Lead | Data Scientist、MLOps |
| Platform & DevOps Squad | CI/CD、環境、監控、資安支援 | DevOps Lead | Security Lead、SRE |
| Data & Migration Squad | 資料導入、清洗、品質檢核 | Data Lead | ETL Engineer、DBA |
| QA & Compliance Guild | 測試策略、DoR/DoD、合規伙伴 | QA Lead | Compliance Officer、Security Lead |

---

## 2. Squad 目標與成功指標

| Squad | 2025-Q4 / 2026 上半年目標 | 成功指標 |
|---|---|---|
| Treaty & Facultative | 完成合約/臨分 CRUD、審批、版本控制，2026-Q1 達到 Beta | ● Sprint 10 前完成 E2E Demo<br>● 使用者測試滿意度 ≥ 4/5 |
| Cession Engine | 建置分保/佣金計算與試算 API，支援多種分保型態 | ● 試算響應時間 < 3s<br>● Calculation Regression 測試 100% 通過 |
| Claims & SoA | 自動化理賠攤回、SoA 生成、調整分錄流程 | ● SoA 自動化覆蓋率 ≥ 90%<br>● 攤回錯誤率降低 90% |
| IFRS17 & Reporting | 建立 IFRS17 Data Layer、報表 API 與可視化輸出 | ● 報表產出時間 < 4 小時<br>● 財務審核一次通過 |
| AI & Insights | 交付合約 NLP、異常偵測、Insights Dashboard Alpha | ● NLP 條款抽取 F1 ≥ 0.85<br>● Insights Dashboard 於 Sprint 13 Review 通過 |
| Platform & DevOps | CI/CD、監控、資安流程就緒，支援 Go-Live | ● 部署自動化成功率 100%<br>● 資安掃描無 Critical 漏洞 |
| Data & Migration | 完成資料需求、遷移工具、品質檢核、演練 | ● 遷移成功率 ≥ 95%<br>● 資料品質指標 ≥ 98% |
| QA & Compliance | 建立測試策略、品質門檻、合規檢核 | ● DoR/DoD Sprint 4 起全面使用<br>● SIT/UAT 缺陷關閉率 ≥ 95% |

---

## 3. 初步風險與對策

| Squad | 初步風險 | 可能影響 | 緩解策略 |
|---|---|---|---|
| Treaty & Facultative | 業務規則複雜度高 | 開發返工、審批延宕 | 與 Actuary SME 每週需求澄清；建立規則庫 |
| Cession Engine | 分保算式資料不足 | 試算不準、延期 | Sprint 5 前蒐集實務案例；建立單元測試範本 |
| Claims & SoA | 資料清潔度不一 | 對帳錯誤、延遲 | 導入資料檢核流程；Finance SME 早期參與 |
| IFRS17 & Reporting | 報表需求變動頻繁 | 重工、時程延宕 | 需求變更凍結日 2025-12-12；CCB 驗證 |
| AI & Insights | 資料隱私及標註量不足 | 模型延誤、合規風險 | 與 Legal 合作；預留標註資源（Action Item A05） |
| Platform & DevOps | 環境供應延遲 | Sprint 架設延誤 | 2025-10-31 前完成環境；設立沙箱 |
| Data & Migration | 歷史資料樣本晚提供 | 遷移演練延期 | 2026-03-16 前取得資料；先做樣本分析 |
| QA & Compliance | DoR/DoD 未落實 | 品質不一致 | 制定檢核清單；Sprint Review 提醒檢查 |

---

## 4. 後續工作建議
- Sprint 1 Review 前：各 Squad 更新目標與風險，若有調整同步 PMO。
- 與 `PM-CHARTER-001-專案章程.md`、`PM-PLAN-002-Sprint計劃.md` 連動，確保資訊一致。
- 若新增 Squad 或變動出現，請於此檔案版本紀錄更新並通知 Scrum Master。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 初版各 Squad 目標與風險彙整 | Tao Yu 和他的 GPT 智能助手 |
