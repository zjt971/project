# ADR-006：Git 分支與協作策略

- **狀態**：提案中（待 Architecture Review 核可）
- **日期**：2025-11-02
- **決策者**：Engineering Lead、Scrum Master、DevOps Lead

---

## 1. 背景

伴隨再保系統模組化開發與多團隊協作，現有的臨時分支流程易導致歷史混亂、回溯困難與生產事故。為此，我們需要一套明確的 Git 分支策略，確保：

- 產線分支永遠可部署。
- 功能分支有明確命名與生命週期。
- Pull Request（PR）流程標準化且可追蹤。

《git-branching-strategy.md》已定義完整流程，本 ADR 用於沉澱關鍵決策並納入架構準則。

---

## 2. 決策摘要

1. **主分支**
   - `master`：唯一的生產分支，嚴禁直接推送，所有變更必須經由 PR、審查與自動化測試。
   - `develop`（選用）：團隊若需要長期的整合測試環境，可維護 develop；規則與 master 相同。

2. **輔助分支類型**
   - `feature/<描述>` 或 `feature/<JIRA>-<描述>`：新功能。
   - `bugfix/<描述>`：非緊急缺陷修復，基於 master 或 develop。
   - `hotfix/<描述>`：緊急生產修補，從 master 切出並回流 master／develop。
   - `release/<版本號>`：發版前最後整合與驗證，用完即刪。

3. **PR 與審查**
   - 所有分支透過 PR 合併；禁止直接合入主分支。
   - PR 必須描述變更、引用對應文件或需求，並通過自動化測試。
   - 至少一位審查者（依模組責任人）核可後才能合併。

4. **提交訊息格式**
   - 採 `type(scope): summary`，type 包含 `feat`、`fix`、`docs`、`refactor`、`test`、`chore` 等。

5. **No Fast-Forward Merge Policy / 禁用快進合併政策**
   - **強制要求**：所有合併必須使用 `--no-ff` 選項，以保留分支歷史結構。
   - **配置要求**：`git config merge.ff false`
   - **目的**：確保 Git 歷史中可以清楚看到分支樹和合併點，便於追蹤功能開發時間線。
   - **合併命令**：`git merge --no-ff feature/branch-name`
   - 若對應任務／Issue，於腳註註明，例如 `Closes #123`。

5. **分支壽命**
   - 功能／修復分支在合併後立即刪除。
   - release/hotfix 分支完成後同步至 master 及 develop，並打上 tag。

---

## 3. 父子分支流程

```
master ───────┐
              │  hotfix        ┌───▶ master ─▶ tag
develop ──┐   └───────────────┤
          │                   │
          └─▶ feature ─▶ PR ──┴──▶ develop/master
                      (刪除)
```

> 若團隊未啟用 develop，feature 直接基於 master。各模組仍應採“切分支 → 開發 → 提 PR → 合併 → 刪分支”的閉環流程。

---

## 4. 與現有規範對齊

- 與 `RI-8-1-developer-handbook.md` 的開發流程、PR 自檢清單相容。
- 與 `reinsurance-system-task-tracker.md` 的任務追蹤欄位（分支／PR 連結）相互引用。
- 若模組有專用分支（如 `UC01-*`），須在 PR 描述對應本策略，避免孤立歷史。

---

## 5. 實施步驟

1. 更新 Git 設定：對 master（與選用的 develop）啟用保護規則（禁止直接 push、強制 PR 審查）。
2. 將本策略補入團隊入職教材與每日 standup 節奏，確保所有人使用一致命名。
3. CI/CD 加入檢查：確認 PR 來源分支符合命名規則、測試全數通過。
4. Sprint 回顧時定期檢查分支是否及時刪除，避免遺留。

---

## 6. 替代方案（未採用）

- **Trunk-based development**：研判目前模組拆分尚在演進，Trunk 模式需高度自動化（feature flag、灰度）與嚴格 CICD，暫不採納。
- **單分支模式**：缺乏隔離性，對多人協同風險過高。

---

## 7. 後續維護

- 規則若有更新，需同步修改 `docs/git-branching-strategy.md` 與本 ADR。
- 重大版本（例如新增持續整合環節）須提交新 ADR 或修訂版本紀錄。
