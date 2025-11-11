# RI-7-2 CI/CD 流程驗證計畫 / Pipeline Validation Plan

> 任務目的：為 `RI-7-2`（Sprint 2）建立驗證計畫，確保 CI/CD Pipeline 原型符合專案需求並可持續運作。

---

## 1. 驗證目標
- 確認 CI 流程能自動執行程式碼檢查與單元測試，並回報結果。
- 確認 CD 流程可於 Dev Sandbox 成功部署範例服務。
- 確保 Pipeline 具備異常通知與重試/回滾機制。
- 驗證 Pipeline 文檔及操作手冊是否完整，使用者能自行操作。

---

## 2. 驗證範圍與案例

### 2.1 CI 驗證案例
1. **成功案例**：提交合法程式碼 → Pipeline 通過，生成測試報告。
2. **失敗案例**：提交不符合 lint 規範 → Pipeline 失敗並通知責任人。
3. **單元測試失敗**：刻意讓測試失敗 → Pipeline 阻擋合併。

### 2.2 CD 驗證案例
1. **正常部署**：合併 PR → 自動部署至 Dev Sandbox，冒煙測試通過。
2. **部署失敗**：模擬缺少環境變數 → Pipeline 偵測並終止，觸發告警。
3. **回滾流程**：手動觸發 rollback job → 成功恢復上一版本。

---

## 3. 驗證步驟

| 步驟 | 負責人 | 說明 | 預計日期 |
|---|---|---|---|
| 設定測試 Repo 與分支策略 | DevOps Lead | 建立 `feature/ci-validation`、`feature/cd-validation` | 2025-10-26 |
| 執行 CI 成功案例 | DevOps Engineer | 提交合法程式碼並確認結果 | 2025-10-28 |
| 執行 CI 失敗案例 | DevOps + QA | 模擬 lint/test 失敗 | 2025-10-29 |
| 執行 CD 正常部署 | DevOps Engineer | 合併 PR → 部署 → 冒煙測試 | 2025-10-30 |
| 執行 CD 失敗與回滾案例 | DevOps + SRE | 模擬失敗情境、測試 rollback | 2025-10-31 |
| 撰寫驗證報告與分享 | DevOps Lead | 整理結果、更新文件、錄影 Demo | 2025-11-01 |

---

## 4. 成功標準
- Pipeline 成功率 ≥ 95%，如有失敗需提供解決方案。
- 通知流程（Teams/Email）於 5 分內送達責任人。
- 回滾流程在 10 分鐘內完成且不影響其他環境。
- 驗證報告提交給 Architecture Board & PMO 確認。

---

## 5. 文檔與報告
- Pipeline 操作手冊（含環境設定、Secrets 管理）。
- 驗證結果報告（成功/失敗案例記錄、建議）。
- Demo 影片或截圖（供培訓使用）。
- 將報告連結新增至 `OPS-PLAN-001-CICD原型計劃.md` 及 Task Tracker 備註。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 建立 CI/CD 驗證計畫初稿 | Tao Yu 和他的 GPT 智能助手 |
