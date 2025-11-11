# RI-3-1 Markdown 任務與文件結構規劃

> 任務說明：取代 Jira/Confluence，建立專案使用之 Markdown 檔案架構與維運規則，支援 `../01-專案管理/PM-REPORT-001-任務追蹤.md` 的日常管理。

---

## 1. 檔案目錄規則

- **主目錄**：`RI/docs/`
  - `reinsurance-system-project-plan.md`：專案計畫與里程碑
  - `reinsurance-system-scrum-plan.md`：Sprint 規劃與故事清單
  - `reinsurance-system-task-tracker.md`：任務追蹤看板（主要入口）
  - `RI-<Story>-<序號>-*.md`：各任務/產出物專屬檔案
  - `meeting/`（選用）：會議紀錄，可依日期命名
  - `templates/`（選用）：常用模板（會議、報告、檢核清單）

---

## 2. 命名規範
- 任務/產出檔：`RI-<Story>-<子任務>-<短描述>.md`，例：`RI-1-1-kickoff-preparation.md`。
- 會議紀錄：`meeting/YYYYMMDD-<主題>.md`。
- 模板：`templates/<類型>-template.md`。
- 所有檔案以英文小寫與連字號（`-`）為主，避免空格與特殊字元。

---

## 3. 內容結構建議
- 需包含標題（任務編號 + 名稱）、任務說明或背景。
- 明確記錄輸入/輸出、步驟、決議、版本資訊。
- 若有表格、清單，使用 Markdown 標準語法；圖表可採 Mermaid。

---

## 4. 權責與維護流程
- **PO/PMO**：負責更新 Roadmap、Backlog 與決策紀錄。
- **Scrum Master**：維護任務追蹤表、會議紀錄與 Sprint Log。
- **各功能團隊（Data/DevOps/AI 等）**：提交各自產出檔案，並通知 Scrum Master 於追蹤表中更新連結。
- 變更/新增檔案後，於每日站會時報告並同步至任務追蹤。

---

## 5. 版本與通知策略
- Markdown 檔案透過 Git 版控；採 feature branch 或直接提交視團隊流程決定。
- 每次更新應附變更摘要（可於 README 或 Commit 訊息說明）。
- 重大更新（如 Roadmap 調整）需以 Slack / Teams 廣播，並在 `reinsurance-system-task-tracker.md` 的「持續維運」區塊標註已執行。

---

## 6. 後續建議
- 規劃 `README.md` 說明文件，協助新成員快速理解 Markdown 架構。
- 視需要在 `templates/` 內新增常用格式（例如會議紀錄、回顧摘要）。
- 若未來導入其他工具，可保持 Markdown 版本同步更新。
- 當程式規範／ADR／UI 導則更新時，請同步修改對應 Markdown（ADR-001/002/…、UIUX 指南），並於 `reinsurance-system-task-tracker.md` 的「持續維運」區註明更新日期與連結，確保團隊成員能追蹤到最新規則。

---

| 版本 | 日期 | 說明 | 編寫人 |
|---|---|---|---|
| v0.1 | 2025-09-12 | 建立 Markdown 結構規範初稿 | Tao Yu 和他的 GPT 智能助手 |
