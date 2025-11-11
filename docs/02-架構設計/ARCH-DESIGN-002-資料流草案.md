# RI-6-2 資料流與整合圖草稿 / Data Flow & Integration Draft

> 根據 `RI-6-1` 蒐集結果，整理 MVP 階段的資料流視圖與整合要點，供架構團隊在 Sprint 2 內完成初版圖稿及審查。

---

## 1. 視圖概述
- **應用層互動**：再保系統模組（Treaty、Facultative、Cession、Claims/SoA、IFRS17、AI Insights）之間的資料交換。
- **外部整合**：
  - EIS 核心系統（保單、理賠、財務資料）
  - 外部再保人/合作夥伴（SoA、回覆）
  - 財務/會計系統（GL、IFRS17）
  - 第三方服務（匯率、KYC/AML）
- **資料存放**：
  - Transactional DB（主檔資料）
  - Cession Calculation Engine（計算暫存/結果）
  - Reporting Warehouse（SoA、IFRS17）
  - Data Lake / Feature Store（AI 模型）

---

## 2. 資料流 (Level 0) 說明
1. **Treaty / Facultative → Cession Engine**
   - 輸入：合約條款、臨分設定、保單資料（由 EIS 匯入）
   - 輸出：分保保費、佣金、保額分配
   - 傳輸：同步 API（內部），支援批次試算

2. **Cession Engine → SoA / Reporting**
   - 輸入：分保結果、佣金、理賠攤回數據
   - 輸出：SoA 明細、調整分錄
   - 傳輸：事件驅動 + 批次匯出（每日/每月）

3. **Claims 模組 ↔ 外部再保人**
   - 輸入：理賠通報、再保回覆
   - 輸出：追償狀態、更新 SoA
   - 傳輸：API / 檔案交換（CSV/Excel）

4. **IFRS17 報表服務**
   - 輸入：交易明細、分保結果、財務調整
   - 輸出：IFRS17 報表、GL 匯入檔
   - 傳輸：批次（依月結節奏）

5. **AI Insights**
   - 輸入：合約文件、分保結果、歷史理賠資料
   - 輸出：條款抽取、異常警示、儀表板
   - 傳輸：ETL → Feature Store → 模型推論 API

---

## 3. 資料整合細節

| 整合對象 | 方向 | 技術 | 頻率 | 主要資料 |
|---|---|---|---|---|
| EIS Policy Admin | EIS → Reinsurance | REST API / 批次檔 | 每日 | 保單主檔、批單、保費 |
| EIS Claims | EIS ↔ Reinsurance | API / 事件 | 即時 / 每日 | 理賠申請、支付狀態 |
| Finance GL | Reinsurance → Finance | 匯入檔（CSV/XML） | 月結 | 分錄、SoA 調整 |
| 外部再保人 | Reinsurance ↔ Reinsurer | SFTP / API | 月結 / 需時 | SoA、回覆狀態 |
| 匯率服務 | 外部 → Reinsurance | REST API | 每日 | 匯率表 |
| Data Lake / AI | Reinsurance → Data Platform | ETL / Batch | 每日 | 合約文字、分保結果、理賠資料 |

---

## 4. 資料分類與敏感度
- **高敏感資料**：個資（被保人資料）、財務資訊、合約機密 → 需加密、遮罩、權限控管。
- **中敏感資料**：再保合約條款、再保人資料 → 權限限制、審計紀錄。
- **低敏感資料**：系統參數、匯率、統計報表 → 標準存取控制即可。

合規要求：
- 個資依 GDPR/TW PDPA 要求遮罩與存取審計。
- AI 模型訓練資料須匿名化，並經法遵審查（參考 Action Item A05）。

---

## 5. 下一步行動
- 製作 Mermaid 或 BPMN 資料流圖（Architecture/Data Lead，Due: 2025-11-02）。
- 完成資料交換契約（Integration Lead，Due: 2025-11-05）。
- 與 Security/Compliance 確認資料分類與保護措施（2025-11-06）。
- 提交審查成果於 `RI-5-2` 架構評審會議中核可。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 初版資料流與整合草稿 | Tao Yu 和他的 GPT 智能助手 |
