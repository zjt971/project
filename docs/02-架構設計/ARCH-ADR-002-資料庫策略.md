# ADR-002：資料庫策略與環境配置

- **狀態**：已核可並實作
- **日期**：2025-09-12（更新：2025-11-06）
- **決策者**：Architecture Board、Data Lead、DevOps Lead
- **實作狀態**：✅ 完成 - Vercel 部署功能已實現

---

## 1. 背景

再保系統需要快速迭代的開發體驗，以及在 SIT / UAT / 產線階段維持高可靠度與合規要求。必須針對不同環境選擇合適的資料庫與設定，確保：

- 開發者可零安裝啟動專案。
- 測試環境具備與產線一致的行為。
- 產線具備企業級穩定性、交易保證與擴充性。

---

## 2. 決策

- **開發環境（DEV）**：採用 SQLite3，存放於專案目錄的 `prisma/dev.db`。
- **Vercel 部署環境（PREVIEW、PROD）**：採用 Vercel Postgres（PostgreSQL 14+）。
- **環境自動檢測**：透過 [`src/config/environment.ts`](code/ri-app/src/config/environment.ts:1) 自動判斷環境並選擇對應資料庫。
- 使用 Prisma 作為 ORM，支援雙 Schema 檔案架構。

---

## 3. 雙 Schema 架構與環境設定

### 3.1 Schema 檔案結構

系統採用雙 Schema 檔案架構：

- **[`prisma/schema.prisma`](code/ri-app/prisma/schema.prisma:1)**：PostgreSQL Schema（Vercel 部署）
- **[`prisma/schema-sqlite.prisma`](code/ri-app/prisma/schema-sqlite.prisma:1)**：SQLite Schema（本地開發）

```prisma
// prisma/schema.prisma (PostgreSQL)
generator client {
  provider      = "prisma-client-js"
  binaryTargets = ["native", "rhel-openssl-3.0.x"]
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
```

```prisma
// prisma/schema-sqlite.prisma (SQLite)
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = env("DATABASE_URL")
}
```

### 3.2 環境配置

**本地開發 (`.env.local`)**：
```bash
DATABASE_PROVIDER=sqlite
DATABASE_URL=file:./prisma/dev.db
NODE_ENV=development
LOG_LEVEL=debug
```

**Vercel 部署**：
```bash
DATABASE_PROVIDER=postgresql
DATABASE_URL=postgresql://user:password@host:5432/db?sslmode=require
VERCEL_ENV=preview|production
LOG_LEVEL=info|warn
```

### 3.3 自動環境檢測

透過 [`src/config/environment.ts`](code/ri-app/src/config/environment.ts:1) 實現：

```typescript
export function getDatabaseProvider(): 'sqlite' | 'postgresql' {
  // Vercel 環境自動使用 PostgreSQL
  if (isVercel()) {
    return 'postgresql';
  }
  
  // 本地開發預設使用 SQLite
  return process.env.DATABASE_PROVIDER || 'sqlite';
}
```

> **重要**：`prisma/dev.db` 已加入 `.gitignore`，嚴禁提交。示範資料透過 [`prisma/seed.js`](code/ri-app/prisma/seed.js:1) 提供。

---

## 4. 優勢與注意事項

### 4.1 SQLite（DEV）
**優勢**
- 零安裝、快速啟動、適合本機開發。
- 檔案型資料庫，便於 reset 與版本控制。

**注意事項**
- 不支援高併發；僅用於本機開發。
- 需避免使用 PostgreSQL 專屬語法。

### 4.2 PostgreSQL（TEST/PROD）
**優勢**
- 企業級交易一致性與查詢能力。
- 支援 JSONB、全文檢索、複雜索引。
- 與雲端服務（RDS、Cloud SQL）整合便利。

**注意事項**
- 必須配置備援、備份策略。
- 需設定連線池（pgBouncer 或 Prisma 加值功能）。

---

## 5. Schema 兼容策略

- 在 CI Pipeline 中針對 SQLite 與 PostgreSQL 分別執行 `prisma migrate deploy`，確保兼容。
- 禁用資料庫專屬語法（例如 PostgreSQL `jsonb_path_query`）除非備妥替代方案。
- 使用 Prisma 提供的 `previewFeatures` 時，需確認兩種 provider 均支援。

---

## 6. 運維流程

### 6.1 開發流程

1. **本地開發**：
   ```bash
   # 修改 SQLite Schema
   vim prisma/schema-sqlite.prisma
   npm run prisma:migrate:sqlite
   npm run prisma:seed:sqlite
   ```

2. **PostgreSQL 同步**：
   ```bash
   # 同步修改 PostgreSQL Schema
   vim prisma/schema.prisma
   npm run prisma:migrate:postgres
   ```

### 6.2 Vercel 部署流程

1. **預覽部署**：
   ```bash
   npm run deploy:preview-full
   # 自動執行：環境檢測 → 資料庫遷移 → 建置 → 部署 → 健康檢查
   ```

2. **生產部署**：
   ```bash
   npm run deploy:prod-full
   # 包含完整的驗證和監控
   ```

3. **手動資料庫管理**：
   ```bash
   npm run vercel:migrate          # 執行遷移
   npm run db:validate            # 驗證配置
   vercel logs                    # 查看部署日誌
   ```

### 6.3 自動化腳本

- **[`scripts/deploy-vercel.sh`](code/ri-app/scripts/deploy-vercel.sh:1)**：完整部署腳本
- **[`scripts/vercel-migrate.js`](code/ri-app/scripts/vercel-migrate.js:1)**：資料庫遷移腳本
- **[`scripts/db-utils.js`](code/ri-app/scripts/db-utils.js:1)**：資料庫工具腳本

### 6.4 監控與健康檢查

- **健康檢查端點**：[`/api/health`](code/ri-app/src/app/api/health/route.ts:1)
- **自動監控**：每 6 小時執行健康檢查
- **Vercel 整合**：自動備份、連線池管理、效能監控

---

## 7. 風險與緩解

| 風險 | 說明 | 緩解策略 |
|---|---|---|
| Schema 差異導致測試失真 | SQLite 與 PostgreSQL 功能差異 | 建立雙資料庫自動測試、避免使用非通用語法 |
| Migration 衝突 | 多人同時調整模型 | 採用 feature branch，合併前執行 `prisma migrate diff` 並於 PR 附上摘要 |
| 連線資源不足 | 測試/產線同時運行大量 Job | 使用連線池與資源監控，設定警報 |
| 資料遺失或快照外洩 | 誤將本機 `dev.db` 納入版本控制 | `.gitignore` 固定排除 `prisma/dev.db`，CI 拒絕該檔案；示範資料透過 `prisma/seed.js` 提供 |
| Vercel 部署失敗 | 環境變數配置錯誤、資料庫連線問題 | 使用 [`scripts/deploy-vercel.sh`](code/ri-app/scripts/deploy-vercel.sh:1) 進行完整驗證，監控健康檢查端點 |

---

## 8. 實作成果與後續工作

### 8.1 已完成項目

- ✅ 雙環境架構實作完成
- ✅ Vercel Postgres 整合
- ✅ 自動化部署腳本
- ✅ 健康檢查系統
- ✅ 環境自動檢測機制

### 8.2 後續工作

- 定義資料庫命名規則與 Schema 模組劃分（合約、分保、IFRS17 等）。
- 建立資料脫敏與匿名化流程，供測試環境使用。
- 完善監控告警機制，整合 Vercel Analytics。
- 建立災難恢復演練流程。
- 於 ADR-003、ADR-004 對應測試策略與狀態管理時引用本決策。

---

## 9. 修訂記錄

| 版本 | 日期 | 修訂內容 | 作者 |
|------|------|----------|------|
| v2.0 | 2025-11-06 | **重大更新**：反映 Vercel 部署實作、雙 Schema 架構、自動化腳本 | Tao Yu 和他的 GPT 智能助手 |
| v1.0 | 2025-09-12 | 初版資料庫策略與環境配置 | Architecture Board |
