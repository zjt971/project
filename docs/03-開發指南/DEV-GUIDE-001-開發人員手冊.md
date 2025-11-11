# RI-8-1：Developer Handbook / 開發人員導覽

> 目的：協助新成員（或 AI 協作工具）在 30–60 分鐘內熟悉再保系統的開發流程、規範與常用指令。所有條目皆掛鉤對應的 ADR / UI / Markdown 規範，請務必閱讀並遵守。

---

## 1. 快速導覽

| 主題 | 位置 | 必讀章節 |
|------|------|----------|
| 架構分層 | `../02-架構設計/ARCH-ADR-001-分層架構.md` | §2–4（分層責任、檔案擺放規則） |
| 資料庫策略 | `../02-架構設計/ARCH-ADR-002-資料庫策略.md` | §3–6（ENV、migrate 流程、dev.db 禁令） |
| React Query & Server State | `../02-架構設計/ARCH-ADR-003-React查詢策略.md` | §2–3（查詢/Mutation 樣板） |
| 測試策略 | `../02-架構設計/ARCH-ADR-004-測試策略.md` | §2、§5（測試金字塔、範例指令） |
| 稽核軌跡 | `../02-架構設計/ARCH-ADR-005-稽核軌跡.md` | 若開發與稽核相關模組必讀 |
| Git 分支策略 | `../04-運維部署/OPS-PROCESS-001-Git分支流程.md`、`../02-架構設計/ARCH-ADR-006-Git分支策略.md` | §1–4（分支類型、PR 流程、命名規則） |
| 模組架構模式 | `../02-架構設計/ARCH-ADR-007-模組架構模式.md` | §2–4（模組分層、錯誤治理、型別規則） |
| UI/UX 導則 | `../08-用戶界面/UI-GUIDE-001-界面設計指南.md` | §1–4（Design Tokens、Page Layout、反例） |
| 國際化策略 | `../02-架構設計/ARCH-ADR-008-國際化策略.md` | 多語言支援、翻譯鍵管理、格式化工具 |
| Markdown 規範 | `../07-文檔管理/DOC-GUIDE-001-Markdown指南.md`、`../07-文檔管理/DOC-PROCESS-001-Markdown維運流程.md` | 新產出物命名、通知、Task Tracker 維護 |
| Vercel 部署 | `../04-運維部署/OPS-DEPLOY-002-Vercel部署配置.md`、`DEV-GUIDE-002-環境設置指南.md` | 雲端部署流程、環境配置、健康檢查 |

---

## 2. 環境設定

### 2.1 本地開發環境（SQLite）

```bash
# 1. 安裝依賴
npm install

# 2. 設定環境變數
cp .env.example .env.local
# 編輯 .env.local：
# DATABASE_PROVIDER=sqlite
# DATABASE_URL=file:./prisma/dev.db

# 3. 初始化資料庫
npm run setup:dev

# 4. 啟動開發伺服器
npm run dev
```

### 2.2 Vercel 部署環境（PostgreSQL）

```bash
# 1. 安裝 Vercel CLI
npm i -g vercel
vercel login

# 2. 連結專案
vercel link

# 3. 設定環境變數
vercel env add DATABASE_URL
vercel env add DATABASE_PROVIDER

# 4. 部署到預覽環境
npm run deploy:preview

# 5. 部署到生產環境
npm run deploy:prod
```

### 2.3 環境切換

```bash
# SQLite 開發（預設）
npm run dev:sqlite

# PostgreSQL 開發（如已配置）
npm run dev:postgres

# 資料庫管理工具
npm run db:studio:sqlite    # SQLite
npm run db:studio:postgres  # PostgreSQL
```

**重要提醒**：
- `prisma/dev.db` 已被 `.gitignore` 排除，**嚴禁提交**
- 本地開發使用 SQLite，Vercel 部署自動使用 PostgreSQL
- 環境變數透過 [`src/config/environment.ts`](code/ri-app/src/config/environment.ts:1) 自動檢測

---

## 3. 工程流程 Checklist

1. **需求理解**  
   - 研讀對應 PRD/FRD，並在 `reinsurance-system-task-tracker.md` 勾選任務狀態與交付物連結。
   - 檢視 UI 指南與 Figma 導出 PDF，確認版型與互動。

2. **資料模型 / Schema**
   - 修改 `prisma/schema.prisma`（PostgreSQL）或 `prisma/schema-sqlite.prisma`（SQLite）後，執行對應的 migration 指令。
   - SQLite：`npm run prisma:migrate:sqlite`；PostgreSQL：`npm run prisma:migrate:postgres`
   - 更新完成需於 PR 描述附上「Migration 摘要」與核對 `../02-架構設計/ARCH-ADR-002-資料庫策略.md` 是否需補文。
   - 同步更新 `prisma/seed.js` 以維護示範資料。

3. **程式分層**（參照 ADR-001）
   - Repository → Service → Action → UI，禁止跨層依賴。
   - 頁面放 `src/app/[locale]/<feature>/page.tsx`，注意國際化路由結構。
   - 共享元件放 `_components/` 或 `src/components/ui/`。
   - 所有模組需同步檢查《ADR-007 模組架構模式指南》，維護 `domain/`、`types/`、`constants/`、`errors/` 等資料夾一致性。

4. **UI 實作**
   - 使用 `PageContainer`、`PageHeader`、`SectionCard`、`FormGrid` 等共用元件。
   - **國際化要求**：避免硬編碼文字，使用 `useTranslations()` Hook 和翻譯鍵。
   - 若版型需求未涵蓋於導則，先與 UI/UX 角色確認並更新 `../08-用戶界面/UI-GUIDE-001-界面設計指南.md`。

5. **測試**
   - 新增或更新單元／整合測試；執行 `npm run test:unit`。
   - 雙環境測試：`npm run test:integration:sqlite` 和 `npm run test:integration:postgres`。
   - 國際化測試：`npm run test:i18n` 驗證翻譯完整性。
   - 回歸測試需記錄於 PR 描述，並附上與更新內容對應的 ADR / UI 章節。

6. **部署驗證**
   - 本地驗證：`npm run build:sqlite` 確認本地建置成功。
   - Vercel 驗證：`npm run deploy:preview` 部署到預覽環境測試。
   - 健康檢查：確認 `/api/health` 端點正常回應。

7. **文檔同步**
   - 若調整規範，於對應 Markdown（ADR/UI/TASK Tracker）更新內容與版本紀錄。
   - 在 Teams/Slack `#reinsurance-project` 發送通知，格式參考 `../07-文檔管理/DOC-PROCESS-001-Markdown維運流程.md` §2。

8. **PR 自檢**
   - PR 需列出：影響範圍、對應文件章節、測試指令、資料庫動作（如 migrate）。
   - 附上 UI 截圖或動態錄影（如有 UI 變更）。
   - 如涉及環境配置變更，需附上部署驗證結果。

---

## 4. 常見違規與處置

| 類型 | 典型症狀 | 處置 |
|------|----------|------|
| 層級違反 | 在頁面直接 import Service/Repository、直接 new PrismaClient | 退回 PR，需改用 Actions → Services → Repositories |
| 檔案擺放錯誤 | 新增 `src/components/<feature>/page.tsx`、隨意建立資料夾 | 退回並重構，遵守 ADR-001 檔案擺放守則 |
| UI 走樣 | 表單欄位寬度不一、內容縮在中間、未用共用元件 | 依 UI 導則 §2–4 調整並補充截圖佐證 |
| Schema 管理鬆散 | 未更新 seed/test、提交本機 `dev.db` | CI 將拒收；持續違規會列為 Retro 行動項目 |
| 國際化違規 | 硬編碼語言判斷、未使用翻譯鍵 | 依 ADR-008 重構為翻譯鍵驅動，避免 `locale === 'en-US' ? ... : ...` 模式 |
| 環境配置錯誤 | 混用 SQLite/PostgreSQL 配置、環境變數設定錯誤 | 檢查 [`src/config/environment.ts`](code/ri-app/src/config/environment.ts:1)，確認環境檢測邏輯 |
| 部署失敗 | Vercel 建置錯誤、資料庫連線失敗 | 檢查 `vercel logs`、驗證環境變數、執行 `npm run db:validate` |

---

## 5. Onboarding 建議行程（Day 0–3）

| 時間 | 行動 | 產出 |
|------|------|------|
| Day 0 | 安裝環境、執行 `npm run setup:dev`、`npm run test:unit` | 確認本地環境無誤 |
| Day 1 | 閱讀 ADR-001/002/008、UI 導則、Vercel 部署指南 | 撰寫 3–5 條心得/提問於 Slack |
| Day 2 | 完成小型任務（調整 seed、UI 小改、翻譯更新） | PR + 對應文檔更新 |
| Day 3 | 練習 Vercel 部署、參與 Code Review | 成功部署到預覽環境、在 PR 留下建設性意見 |

---

## 6. 常用指令速查

### 6.1 本地開發指令

```bash
# 環境設定
npm run setup:dev                    # 初始化本地開發環境
npm run dev                          # 啟動開發伺服器（SQLite）
npm run dev:sqlite                   # 明確使用 SQLite
npm run dev:postgres                 # 使用 PostgreSQL（如已配置）

# Prisma 與資料庫
npx prisma migrate dev --name <desc> # 建立新的 migration
npm run db:reset:sqlite              # 重置 SQLite 資料庫
npm run db:reset:postgres            # 重置 PostgreSQL 資料庫
npm run prisma:seed:sqlite           # 填入種子資料（SQLite）
npm run prisma:seed:postgres         # 填入種子資料（PostgreSQL）
npm run db:studio:sqlite             # 開啟 Prisma Studio（SQLite）
npm run db:studio:postgres           # 開啟 Prisma Studio（PostgreSQL）

# 測試
npm run test:unit                    # 單元測試
npm run test:integration:sqlite      # 整合測試（SQLite）
npm run test:integration:postgres    # 整合測試（PostgreSQL）
npm run test:i18n                    # 國際化測試

# 程式碼品質
npm run lint                         # ESLint 檢查
npm run i18n:validate               # 翻譯完整性檢查
```

### 6.2 Vercel 部署指令

```bash
# 快速部署
npm run deploy:preview               # 部署到預覽環境
npm run deploy:prod                  # 部署到生產環境

# 完整部署（含檢查）
npm run deploy:preview-full          # 完整預覽部署
npm run deploy:prod-full             # 完整生產部署

# 部署腳本（進階）
./scripts/deploy-vercel.sh preview  # 使用腳本部署到預覽
./scripts/deploy-vercel.sh production --skip-tests  # 跳過測試部署

# 資料庫管理
npm run vercel:migrate               # 執行 Vercel 資料庫遷移
npm run db:validate                  # 驗證資料庫配置

# Vercel CLI
vercel login                         # 登入 Vercel
vercel link                          # 連結專案
vercel env ls                        # 列出環境變數
vercel logs                          # 查看部署日誌
```

### 6.3 建置指令

```bash
# 本地建置
npm run build                        # 一般建置
npm run build:sqlite                 # SQLite 建置
npm run build:vercel                 # Vercel 建置（PostgreSQL）

# 驗證
npm run db:validate                  # 驗證資料庫配置
curl http://localhost:3000/api/health # 健康檢查
```

---

## 8. Treaty 模組專用備註（2025-02 更新）

- **多再保人份額**：建立 / 編輯合約時，必須透過 `ReinsurerShareEditor` 元件輸入多筆份額；Actions 會解析 `shares[<index>].*` 欄位並寫入 `TreatyShare`。請勿在其他模組自建相同行為。
- **版本與審批流程**：Server Actions 提供 `submitTreatyForApproval`、`approveTreaty`、`rejectTreaty`，並由 `TreatyVersion` 紀錄快照。UI 若需觸發流程，請引用 `TreatyApprovalControls`；禁止直接修改 `status` 欄位。
- **新欄位支援**：合約新增 `limitAmount`、`attachmentPoint`、`commissionMinRate`、`commissionMaxRate`、`notes`、`attachments`。若在其他模組引用這些欄位，需同步補齊驗證（Zod）、Service 處理與 UI 顯示。
- **再保人刪除檢查**：`ReinsurerService.deleteReinsurer` 已改由 `treatyShare` 檢查關聯，若新增再保人刪除相關功能（如批次清理）需沿用相同邏輯。

---

## 7. 維護與版本紀錄

| 版本 | 日期 | 更新內容 | 編撰人 |
|------|------|----------|--------|
| v0.4 | 2025-11-06 | **重大更新**：新增 Vercel 部署流程、雙環境架構指引、國際化開發規範、完整指令參考 | Tao Yu 和他的 GPT 智能助手 |
| v0.3 | 2025-11-02 | 導入文件編號（RI-8-1）並更新引用至 ADR-007 模組指南 | Tao Yu 和他的 GPT 智能助手 |
| v0.2 | 2025-11-02 | 新增 Git 分支策略與再保人模組架構參考、補充程式分層檢查清單 | Tao Yu 和他的 GPT 智能助手 |
| v0.1 | 2025-10-31 | 建立 Developer Handbook 初稿（整合 ADR/UI/Markdown 守則） | Tao Yu 和他的 GPT 智能助手 |

> 若 Handbook 有調整，請同步更新此表，並在 `reinsurance-system-task-tracker.md` 的「持續維運 / Continuous Items」註記已完成。
