# RI-7-1 CI/CD Pipeline 原型建置計畫 / CI/CD Prototype Plan

> 任務目的：支援 Sprint 2 `RI-7-1`，建立再保系統的 CI/CD Pipeline 原型，確保開發迭代具備自動化建置與部署能力。

---

## 1. 範圍與目標
- 設定 Git 儲存庫標準流程（branch 命名、PR 規範）。
- 建立基礎 CI 流程：程式碼檢查、單元測試、建置。
- 建立基礎 CD 流程：部署至開發環境（Dev Sandbox）。
- 整合品質門檻（DoR/DoD 對應的檢查項目）。

---

## 2. 技術堆疊假設
- **版本控管**：Git（GitHub / GitLab）
- **CI/CD 工具**：GitHub Actions 或 GitLab CI（視公司既有平台）
- **容器化**：Docker（應用服務）
- **Infra**：Kubernetes / AKS（待確認）、或雲端 VM
- **其他整合**：SonarQube（程式碼品質）、Snyk（安全掃描）、Vault（秘密管理）

---

## 3. Pipeline 流程設計

### 3.1 CI (每次 PR / Push 觸發)
1. 檢出程式碼 → 安裝依賴
2. 靜態程式碼檢查（linting、格式檢查）
3. 單元測試與覆蓋率報告
4. 結果發送至 Teams / Email 通知

### 3.2 CD (合併至 main / 手動觸發)
1. 建置容器映像檔並推送至 Registry
2. 部署至 Dev Sandbox（K8s YAML / Helm）
3. 執行冒煙測試與回報
4. 紀錄版本與變更摘要

---

## 4. 建置步驟與責任

| 項目 | 負責人 | 截止 | 輸出 |
|---|---|---|---|
| Pipeline 架構方案確定 | DevOps Lead | 2025-10-23 | Pipeline 設計文件 |
| 建置 CI 流程 (lint/test/build) | DevOps Engineer | 2025-10-27 | `.yml` 工作流程、測試報告 |
| 建置 CD 流程 (Dev 部署) | DevOps Engineer | 2025-10-30 | 部署腳本、環境變數設定 |
| 與 QA 對齊品質門檻 | QA Lead + DevOps | 2025-10-30 | 品質檢查項目清單 |
| Demo CI/CD 原型 | DevOps Lead | 2025-10-31 | Demo 錄影 / 紀要 |

---

## 5. 必要準備
- 取得雲端環境與 Registry 權限。
- 定義服務列表與建置指令（後端、前端、API）。
- 準備範例應用（Hello Service）作為 pipeline 驗證對象。
- 設定 Secrets / 環境參數（透過 Vault/Secret Manager）。

---

## 6. 測試與驗收
- CI Pipeline 成功率 ≥ 95%、每次執行時長 < 10 分鐘。
- CD Pipeline 能自動部署至 Dev Sandbox，且冒煙測試通過。
- Pipeline 文件與操作手冊完成，支援工程團隊使用。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | CI/CD 原型建置計畫初稿 | Tao Yu 和他的 GPT 智能助手 |
