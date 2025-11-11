# ADR-004：測試與 TDD 策略

- **狀態**：提案中（待 Architecture Review 核可）
- **日期**：2025-09-12
- **決策者**：QA Lead、Architecture Board、Product Owner

---

## 1. 背景

再保系統涵蓋精算規則、合規流程與跨系統整合，任何回歸都可能造成財務風險。為確保品質與可維護性，需採用測試驅動開發（TDD）與測試金字塔策略，並將其融入 CI/CD 流程。

---

## 2. 決策

- 採用 **紅-綠-重構** 的 TDD 週期，並配合測試金字塔（單元 > 整合 > E2E）。
- 使用 Vitest 作為單元/整合測試框架，Playwright 作為 E2E 工具。
- Testing Library + MSW 處理 React 組件與網路模擬。
- 在 CI Pipeline 中要求單元覆蓋率 ≥ 90%，整合 ≥ 80%，E2E 覆蓋主要旅程。

---

## 3. 測試金字塔

```
        E2E 測試（Playwright） ─ 覆蓋關鍵旅程，例如合約新增、分保計算、SoA 對帳
            ↑
    整合測試（Vitest + MSW） ─ 驗證 Actions/Services/Repositories 串接
            ↑
    單元測試（Vitest） ─ 驗證 Value Object、Service、Repository 規則
```

---

## 4. 測試框架與設定

`vitest.config.ts`：
```typescript
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    environment: "node",
    globals: true,
    setupFiles: ["./src/tests/setup.ts"],
    coverage: {
      provider: "v8",
      reporter: ["text", "json", "html"],
      thresholds: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80,
        },
      },
    },
  },
});
```

`src/tests/setup.ts` 負責設定 MSW、jest-dom 等輔助工具。

---

## 5. 層級測試範例

### 5.1 Repository
```typescript
import { describe, it, expect, beforeEach } from "vitest";
import { healthCheckRepository } from "@/repositories/health-check-repository";
import { prisma } from "@/lib/prisma";

describe("HealthCheckRepository", () => {
  beforeEach(async () => {
    await prisma.healthCheck.deleteMany();
  });

  it("persists a snapshot", async () => {
    const record = await healthCheckRepository.record({
      status: "healthy",
      checkedAt: new Date(),
    });
    expect(record.id).toBeTruthy();
  });
});
```

### 5.2 Service
```typescript
import { describe, it, expect, vi } from "vitest";
import { healthCheckService } from "@/services/health-check-service";

describe("HealthCheckService", () => {
  it("returns latest snapshot", async () => {
    const spy = vi
      .spyOn(healthCheckService, "latest")
      .mockResolvedValueOnce(null);

    const result = await healthCheckService.latest();
    expect(spy).toHaveBeenCalled();
    expect(result).toBeNull();
  });
});
```

---

## 6. CI/CD 整合

GitHub Actions 範例：
```yaml
name: Tests
on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm run lint
      - run: npm run test:unit
      # 預留整合與 E2E 流程
```

---

## 7. 測試資料與工廠

- `tests/helpers/db-setup.ts`：建立測試專用 Prisma Client，預設 SQLite 檔案 DB。
- `tests/factories/*.ts`：使用 `@faker-js/faker` 生成測試資料，保持一致性。
- 針對 PostgreSQL 的 migration，在 CI 中新增 job 驗證。

---

## 8. 後續工作

- 建立各模組的測試樣板（Treaty、Facultative、分保引擎）。
- 導入 Playwright 腳本覆蓋 MVP 核心流程。
- 與 ADR-002 的資料庫策略聯動，確保 SQLite / PostgreSQL 測試環境一致。
