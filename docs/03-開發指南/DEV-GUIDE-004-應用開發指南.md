# Reinsurance System App Development Guide / 再保險系統應用開發指南

## Quick Start / 快速開始

```bash
npm run dev
```

This Next.js 16 application follows project ADRs: / 此 Next.js 16 應用遵循項目 ADR：

- ADR-001: Layered Architecture (App → Actions → Services → Repositories) / 分層架構
- ADR-002: Database Strategy (DEV uses SQLite, TEST/PROD uses PostgreSQL) / 資料庫策略
- ADR-003: React Query server state management / React Query 伺服器狀態管理
- ADR-004: TDD and Testing Pyramid / TDD 與測試金字塔

## Project Structure / 專案結構

```
src/
  app/            # Next.js App Router, UI only gets data through Actions
                  # Next.js App Router，UI 僅透過 Actions 取資料
  actions/        # 'use server' Server Actions, responsible for validation and orchestration
                  # 'use server' Server Actions，負責驗證與流程編排
  services/       # Business logic layer, implements reinsurance rules
                  # 業務邏輯層，實作再保規則
  repositories/   # Prisma CRUD and data access
                  # Prisma CRUD 與資料存取
  domain/         # Value Objects / Domain Model
                  # 值物件 / 領域模型
  validations/    # Zod schemas / Zod 模式
  lib/            # Prisma client, React Query keys, utilities
                  # Prisma client、React Query keys、工具
  config/         # Environment and feature flag settings
                  # 環境與特徵旗標設定
  tests/          # Vitest test templates / Vitest 測試樣板
prisma/
  schema.prisma   # SQLite / PostgreSQL shared Schema
                  # SQLite / PostgreSQL 共用 Schema
```

## Development Workflow / 開發流程

- `npm run dev`: Start development server (uses `.env.development`, SQLite by default)
  啟動開發伺服器（預設使用 `.env.development`、SQLite）
- `npm run prisma:generate`: Generate Prisma client / 產生 Prisma client
- `npm run prisma:migrate`: Create/update migration / 建立/更新 migration
- `npm run test:unit`: Run Vitest unit tests / 執行 Vitest 單元測試

## Treaty Creation POC / Treaty 建立 POC

- Path: `/treaties/new` allows filling PRD core fields, saves and redirects to `/treaties` list
  路徑：`/treaties/new` 可填寫 PRD 核心欄位，儲存後會導向 `/treaties` 列表
- Form submission goes through Next.js Server Action → Service → Repository → Prisma to database
  送出表單會透過 Next.js Server Action → Service → Repository → Prisma 落地到資料庫
- First run requires `npm run prisma:migrate` (or `npx prisma migrate dev --name init_treaty`) to create `Treaty` and `Reinsurer` tables
  初次執行請先跑 `npm run prisma:migrate` 以建立 `Treaty` 與 `Reinsurer` 資料表
- `prisma/schema.prisma` uses SQLite by default; to switch to PostgreSQL, manually change `provider` to `"postgresql"` and adjust `DATABASE_URL`
  `prisma/schema.prisma` 預設使用 SQLite；若要切換 PostgreSQL，需手動將 `provider` 改為 `"postgresql"` 並調整 `DATABASE_URL`
- Defaults to `Draft` status; subsequent approval workflow can be expanded in future sprints
  預設會儲存為 `Draft` 狀態；後續審核流程可在後續 Sprint 擴充

## Main Dependencies / 主要依賴

- Next.js 16 App Router, React 19
- Prisma ORM + SQLite / PostgreSQL
- @tanstack/react-query
- Tailwind CSS 4, shadcn/ui (imported as needed) / shadcn/ui（依需求引入）
- Vitest, Testing Library, MSW

For more details, refer to ADR documents in `../02-架構設計/`.

更多細節請參考 `../02-架構設計/` 內的 ADR 文件。