# RI-9-4：測試與部署策略 / Testing & Deployment Strategy

- **文件編號**：RI-9-4
- **版本**：v1.0
- **狀態**：Draft for Architecture Review
- **作者**：Tao Yu 和他的 GPT 智能助手
- **建立日期**：2025-11-05
- **參考文件**：ADR-004測試策略、ADR-006 Git分支策略、RI-9-1實施路線圖

---

## 1. 測試策略概述 / Testing Strategy Overview

本文檔擴展ADR-004的測試策略，針對再保系統的複雜業務邏輯、多語言支援、外部系統整合等特殊需求，定義完整的測試金字塔和自動化測試流程。

### 1.1 測試目標
- 確保分保計算邏輯的準確性和可靠性
- 驗證多語言支援的完整性
- 保證外部系統整合的穩定性
- 維持高程式碼覆蓋率和品質標準
- 支援持續整合和快速部署

### 1.2 測試金字塔擴展

```mermaid
flowchart TD
    subgraph "E2E Tests (5%)"
        E2E1["業務流程測試<br/>Business Flow Tests"]
        E2E2["多語言UI測試<br/>Multi-language UI Tests"]
        E2E3["整合流程測試<br/>Integration Flow Tests"]
    end
    
    subgraph "Integration Tests (25%)"
        INT1["API整合測試<br/>API Integration Tests"]
        INT2["資料庫整合測試<br/>Database Integration Tests"]
        INT3["外部系統契約測試<br/>External System Contract Tests"]
        INT4["事件驅動測試<br/>Event-driven Tests"]
    end
    
    subgraph "Unit Tests (70%)"
        UNIT1["業務邏輯測試<br/>Business Logic Tests"]
        UNIT2["計算引擎測試<br/>Calculation Engine Tests"]
        UNIT3["驗證規則測試<br/>Validation Rules Tests"]
        UNIT4["工具函數測試<br/>Utility Function Tests"]
    end
    
    E2E1 --> INT1
    E2E2 --> INT2
    E2E3 --> INT3
    INT1 --> UNIT1
    INT2 --> UNIT2
    INT3 --> UNIT3
    INT4 --> UNIT4
```

---

## 2. 單元測試策略 / Unit Testing Strategy

### 2.1 業務邏輯測試

```typescript
// tests/unit/services/cession-engine.test.ts
import { describe, it, expect, beforeEach } from 'vitest';
import { CessionCalculationEngine } from '@/services/cession-engine/calculation-engine';
import { createTestTreaty, createTestPolicy } from '@/tests/factories';

describe('CessionCalculationEngine', () => {
  let engine: CessionCalculationEngine;
  
  beforeEach(() => {
    engine = new CessionCalculationEngine();
  });
  
  describe('Quota Share Calculation', () => {
    it('should calculate ceded premium correctly for single reinsurer', async () => {
      const treaty = createTestTreaty({
        treatyType: 'PROPORTIONAL',
        cessionMethod: 'QUOTA_SHARE',
        shares: [{
          reinsurerId: 'RIN-001',
          sharePercentage: 40,
          commissionRate: 10
        }]
      });
      
      const policy = createTestPolicy({
        premium: 100000,
        lineOfBusiness: 'FIRE'
      });
      
      const result = await engine.calculate({
        policyData: policy,
        treatyId: treaty.id,
        calculationType: 'PREMIUM'
      });
      
      expect(result.cededAmount.toNumber()).toBe(40000);
      expect(result.commissionAmount.toNumber()).toBe(4000);
      expect(result.retentionAmount.toNumber()).toBe(60000);
      expect(result.breakdown).toHaveLength(1);
    });
    
    it('should handle multiple reinsurers correctly', async () => {
      const treaty = createTestTreaty({
        shares: [
          { reinsurerId: 'RIN-001', sharePercentage: 30, commissionRate: 10 },
          { reinsurerId: 'RIN-002', sharePercentage: 20, commissionRate: 12 }
        ]
      });
      
      const result = await engine.calculate({
        policyData: createTestPolicy({ premium: 100000 }),
        treatyId: treaty.id,
        calculationType: 'PREMIUM'
      });
      
      expect(result.cededAmount.toNumber()).toBe(50000); // 30% + 20%
      expect(result.breakdown).toHaveLength(2);
      expect(result.breakdown[0].cededAmount.toNumber()).toBe(30000);
      expect(result.breakdown[1].cededAmount.toNumber()).toBe(20000);
    });
  });
  
  describe('Excess of Loss Calculation', () => {
    it('should not trigger XOL when claim below attachment', async () => {
      const treaty = createTestTreaty({
        treatyType: 'NON_PROPORTIONAL',
        cessionMethod: 'EXCESS_OF_LOSS',
        attachmentPoint: 500000,
        limitAmount: 1000000
      });
      
      const result = await engine.calculate({
        policyData: createTestPolicy(),
        treatyId: treaty.id,
        calculationType: 'CLAIM',
        claimAmount: new Decimal(300000) // 低於起賠點
      });
      
      expect(result.cededAmount.toNumber()).toBe(0);
      expect(result.retentionAmount.toNumber()).toBe(300000);
    });
    
    it('should calculate XOL correctly when claim exceeds attachment', async () => {
      const treaty = createTestTreaty({
        treatyType: 'NON_PROPORTIONAL',
        cessionMethod: 'EXCESS_OF_LOSS',
        attachmentPoint: 500000,
        limitAmount: 1000000,
        shares: [{ reinsurerId: 'RIN-001', sharePercentage: 100 }]
      });
      
      const result = await engine.calculate({
        policyData: createTestPolicy(),
        treatyId: treaty.id,
        calculationType: 'CLAIM',
        claimAmount: new Decimal(800000)
      });
      
      expect(result.cededAmount.toNumber()).toBe(300000); // 800000 - 500000
      expect(result.retentionAmount.toNumber()).toBe(500000);
    });
  });
  
  describe('Multi-currency Calculation', () => {
    it('should handle currency conversion correctly', async () => {
      const treaty = createTestTreaty({
        currency: 'USD',
        shares: [{ reinsurerId: 'RIN-001', sharePercentage: 50 }]
      });
      
      const policy = createTestPolicy({
        premium: 100000,
        currency: 'TWD'
      });
      
      // Mock匯率服務
      vi.mocked(exchangeRateService.getRate).mockResolvedValue(0.032); // TWD to USD
      
      const result = await engine.calculate({
        policyData: policy,
        treatyId: treaty.id,
        calculationType: 'PREMIUM'
      });
      
      expect(result.cededAmount.toNumber()).toBe(1600); // 50000 TWD * 0.032
      expect(result.currency).toBe('USD');
    });
  });
});
```

### 2.2 國際化測試

```typescript
// tests/unit/i18n/translation.test.ts
import { describe, it, expect } from 'vitest';
import { getTranslations } from 'next-intl/server';

describe('Internationalization', () => {
  describe('Translation Coverage', () => {
    it('should have complete translations for all supported locales', async () => {
      const locales = ['zh-TW', 'zh-CN', 'en-US'];
      const namespaces = ['common', 'treaty', 'reinsurer', 'errors'];
      
      for (const locale of locales) {
        for (const namespace of namespaces) {
          const t = await getTranslations({ locale, namespace });
          
          // 檢查關鍵翻譯鍵是否存在
          expect(t('actions.create')).toBeTruthy();
          expect(t('actions.edit')).toBeTruthy();
          expect(t('actions.delete')).toBeTruthy();
        }
      }
    });
  });
  
  describe('Date Formatting', () => {
    it('should format dates correctly for different locales', () => {
      const date = new Date('2025-12-31');
      
      expect(formatDate(date, 'zh-TW')).toBe('2025-12-31');
      expect(formatDate(date, 'en-US')).toBe('12/31/2025');
      expect(formatDate(date, 'zh-CN')).toBe('2025-12-31');
    });
  });
  
  describe('Currency Formatting', () => {
    it('should format currency correctly for different locales', () => {
      expect(formatCurrency(1000000, 'TWD', 'zh-TW')).toBe('NT$1,000,000');
      expect(formatCurrency(1000000, 'USD', 'en-US')).toBe('$1,000,000.00');
      expect(formatCurrency(1000000, 'CNY', 'zh-CN')).toBe('¥1,000,000.00');
    });
  });
});
```

---

## 3. 整合測試策略 / Integration Testing Strategy

### 3.1 API整合測試

```typescript
// tests/integration/api/treaty-actions.integration.test.ts
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { testDb } from '@/tests/helpers/test-db';
import { createTreaty, updateTreaty } from '@/actions/treaty-actions';

describe('Treaty Actions Integration', () => {
  beforeEach(async () => {
    await testDb.reset();
    await testDb.seed();
  });
  
  afterEach(async () => {
    await testDb.cleanup();
  });
  
  it('should create treaty with audit trail', async () => {
    const formData = new FormData();
    formData.append('treatyName', 'Test Treaty');
    formData.append('treatyType', 'PROPORTIONAL');
    formData.append('lineOfBusiness', 'FIRE');
    formData.append('effectiveDate', '2025-01-01');
    formData.append('expiryDate', '2025-12-31');
    formData.append('currency', 'TWD');
    
    const result = await createTreaty(undefined, formData);
    
    expect(result.success).toBe(true);
    expect(result.data?.treatyCode).toMatch(/^TR2025-\d{4}$/);
    
    // 驗證稽核記錄
    const auditEvents = await auditRepository.findByEntity('Treaty', result.data!.id);
    expect(auditEvents).toHaveLength(1);
    expect(auditEvents[0].action).toBe('treaty.create');
  });
  
  it('should validate business rules during creation', async () => {
    const formData = new FormData();
    formData.append('treatyName', 'Invalid Treaty');
    formData.append('treatyType', 'NON_PROPORTIONAL');
    formData.append('effectiveDate', '2025-01-01');
    formData.append('expiryDate', '2024-12-31'); // 錯誤：終止日早於生效日
    
    const result = await createTreaty(undefined, formData);
    
    expect(result.success).toBe(false);
    expect(result.errors?.expiryDate).toContain('終止日不可早於生效日');
  });
});
```

### 3.2 外部系統模擬測試

```typescript
// tests/integration/external-systems/policy-system.mock.test.ts
import { setupServer } from 'msw/node';
import { http, HttpResponse } from 'msw';
import { policySystemService } from '@/services/integration/policy-integration';

const server = setupServer(
  // 模擬保單系統API
  http.get('https://policy-system.example.com/api/policies/:policyId', ({ params }) => {
    return HttpResponse.json({
      policyNumber: params.policyId,
      productCode: 'FIRE-01',
      sumInsured: 1000000,
      premium: 50000,
      currency: 'TWD',
      effectiveDate: '2025-01-01T00:00:00Z',
      expiryDate: '2025-12-31T23:59:59Z',
      lineOfBusiness: 'FIRE'
    });
  }),
  
  // 模擬批次查詢API
  http.post('https://policy-system.example.com/api/policies/batch', async ({ request }) => {
    const { policyIds } = await request.json();
    
    return HttpResponse.json(
      policyIds.map((id: string) => ({
        policyNumber: id,
        productCode: 'FIRE-01',
        sumInsured: 1000000,
        premium: 50000,
        currency: 'TWD'
      }))
    );
  })
);

describe('Policy System Integration', () => {
  beforeAll(() => server.listen());
  afterEach(() => server.resetHandlers());
  afterAll(() => server.close());
  
  it('should sync policy data successfully', async () => {
    const result = await policySystemService.syncPolicyData(['POL-001', 'POL-002']);
    
    expect(result.successful).toHaveLength(2);
    expect(result.failed).toHaveLength(0);
    expect(result.totalCount).toBe(2);
  });
  
  it('should handle API errors gracefully', async () => {
    // 模擬API錯誤
    server.use(
      http.get('https://policy-system.example.com/api/policies/:policyId', () => {
        return new HttpResponse(null, { status: 500 });
      })
    );
    
    const result = await policySystemService.syncPolicyData(['POL-ERROR']);
    
    expect(result.successful).toHaveLength(0);
    expect(result.failed).toHaveLength(1);
    expect(result.failed[0].error).toContain('500');
  });
});
```

---

## 3. 端到端測試策略 / End-to-End Testing Strategy

### 3.1 Playwright測試配置

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html'],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    ['json', { outputFile: 'test-results/results.json' }]
  ],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure'
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    // 多語言測試
    {
      name: 'chromium-zh-tw',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'zh-TW',
        timezoneId: 'Asia/Taipei'
      },
    },
    {
      name: 'chromium-en-us',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'en-US',
        timezoneId: 'America/New_York'
      },
    }
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### 3.2 關鍵業務流程測試

```typescript
// tests/e2e/treaty-management.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Treaty Management E2E', () => {
  test.beforeEach(async ({ page }) => {
    // 設定測試資料
    await page.goto('/');
    await page.waitForLoadState('networkidle');
  });
  
  test('complete treaty creation flow', async ({ page }) => {
    // 1. 導航到合約列表
    await page.click('text=合約管理');
    await expect(page).toHaveURL('/zh-TW/treaties');
    
    // 2. 點擊建立合約
    await page.click('text=建立合約');
    await expect(page).toHaveURL('/zh-TW/treaties/new');
    
    // 3. 填寫基本資料
    await page.fill('[name="treatyName"]', '測試合約');
    await page.selectOption('[name="treatyType"]', 'PROPORTIONAL');
    await page.selectOption('[name="lineOfBusiness"]', 'FIRE');
    await page.fill('[name="effectiveDate"]', '2025-01-01');
    await page.fill('[name="expiryDate"]', '2025-12-31');
    await page.selectOption('[name="currency"]', 'TWD');
    
    // 4. 設定再保人份額
    await page.click('text=新增再保人');
    await page.fill('[name="shares[0].reinsurerName"]', '測試再保人');
    await page.fill('[name="shares[0].sharePercentage"]', '50');
    await page.fill('[name="shares[0].commissionRate"]', '10');
    
    // 5. 儲存合約
    await page.click('text=儲存');
    
    // 6. 驗證成功訊息
    await expect(page.locator('text=合約建立成功')).toBeVisible();
    
    // 7. 驗證重導向到詳情頁
    await expect(page).toHaveURL(/\/zh-TW\/treaties\/[a-f0-9-]+$/);
    
    // 8. 驗證合約資料顯示正確
    await expect(page.locator('text=測試合約')).toBeVisible();
    await expect(page.locator('text=比例合約')).toBeVisible();
    await expect(page.locator('text=草稿')).toBeVisible();
  });
  
  test('treaty approval workflow', async ({ page }) => {
    // 假設已有草稿合約
    const treatyId = await createTestTreatyInDatabase();
    
    // 1. 開啟合約詳情
    await page.goto(`/zh-TW/treaties/${treatyId}`);
    
    // 2. 提交審核
    await page.click('text=提交審核');
    await page.fill('[name="changeSummary"]', '提交初次審核');
    await page.click('text=確認提交');
    
    // 3. 驗證狀態變更
    await expect(page.locator('text=待審')).toBeVisible();
    
    // 4. 核准合約（模擬主管操作）
    await page.click('text=核准');
    await page.fill('[name="approvalSummary"]', '審核通過');
    await page.click('text=確認核准');
    
    // 5. 驗證最終狀態
    await expect(page.locator('text=生效')).toBeVisible();
    
    // 6. 檢查版本歷史
    await page.click('text=版本歷史');
    await expect(page.locator('text=v1.0')).toBeVisible();
    await expect(page.locator('text=v2.0')).toBeVisible();
  });
});
```

### 3.3 多語言UI測試

```typescript
// tests/e2e/multi-language.spec.ts
test.describe('Multi-language Support', () => {
  const locales = [
    { code: 'zh-TW', name: '繁體中文', url: '/zh-TW' },
    { code: 'zh-CN', name: '简体中文', url: '/zh-CN' },
    { code: 'en-US', name: 'English', url: '/en-US' }
  ];
  
  for (const locale of locales) {
    test(`should display correctly in ${locale.name}`, async ({ page }) => {
      await page.goto(locale.url);
      
      // 檢查導航選單
      if (locale.code === 'zh-TW') {
        await expect(page.locator('text=合約管理')).toBeVisible();
        await expect(page.locator('text=再保人管理')).toBeVisible();
      } else if (locale.code === 'en-US') {
        await expect(page.locator('text=Treaty Management')).toBeVisible();
        await expect(page.locator('text=Reinsurer Management')).toBeVisible();
      }
      
      // 檢查語言切換器
      await expect(page.locator('.language-switcher')).toBeVisible();
    });
  }
  
  test('should switch language correctly', async ({ page }) => {
    // 1. 開始於繁體中文
    await page.goto('/zh-TW/treaties');
    await expect(page.locator('text=合約管理')).toBeVisible();
    
    // 2. 切換到英文
    await page.selectOption('.language-switcher', 'en-US');
    await expect(page).toHaveURL('/en-US/treaties');
    await expect(page.locator('text=Treaty Management')).toBeVisible();
    
    // 3. 切換到簡體中文
    await page.selectOption('.language-switcher', 'zh-CN');
    await expect(page).toHaveURL('/zh-CN/treaties');
    await expect(page.locator('text=合约管理')).toBeVisible();
  });
  
  test('should handle text expansion correctly', async ({ page }) => {
    // 測試不同語言下的版面適應性
    const locales = ['zh-TW', 'en-US', 'zh-CN'];
    
    for (const locale of locales) {
      await page.goto(`/${locale}/treaties/new`);
      
      // 檢查表單欄位是否正確顯示
      const formFields = page.locator('.form-field');
      const count = await formFields.count();
      
      for (let i = 0; i < count; i++) {
        const field = formFields.nth(i);
        const boundingBox = await field.boundingBox();
        
        // 確保欄位有足夠寬度
        expect(boundingBox?.width).toBeGreaterThan(200);
        
        // 確保文字沒有被截斷
        const isOverflowing = await field.evaluate(el => 
          el.scrollWidth > el.clientWidth
        );
        expect(isOverflowing).toBe(false);
      }
    }
  });
});
```

---

## 4. 效能測試策略 / Performance Testing Strategy

### 4.1 負載測試

```typescript
// tests/performance/load-test.ts
import { check } from 'k6';
import http from 'k6/http';

export const options = {
  stages: [
    { duration: '2m', target: 10 }, // 暖身
    { duration: '5m', target: 50 }, // 正常負載
    { duration: '2m', target: 100 }, // 高負載
    { duration: '5m', target: 100 }, // 維持高負載
    { duration: '2m', target: 0 }, // 降載
  ],
  thresholds: {
    http_req_duration: ['p(95)<2000'], // 95%請求在2秒內完成
    http_req_failed: ['rate<0.1'], // 錯誤率低於10%
  },
};

export default function () {
  // 測試合約列表API
  const listResponse = http.get('http://localhost:3000/api/treaties');
  check(listResponse, {
    'treaty list status is 200': (r) => r.status === 200,
    'treaty list response time < 2s': (r) => r.timings.duration < 2000,
  });
  
  // 測試分保計算API
  const calculationPayload = {
    policyData: {
      policyNumber: 'POL-TEST-001',
      premium: 100000,
      lineOfBusiness: 'FIRE',
      effectiveDate: '2025-01-01'
    },
    treatyId: 'treaty-test-id',
    calculationType: 'PREMIUM'
  };
  
  const calcResponse = http.post(
    'http://localhost:3000/api/cession/calculate',
    JSON.stringify(calculationPayload),
    { headers: { 'Content-Type': 'application/json' } }
  );
  
  check(calcResponse, {
    'calculation status is 200': (r) => r.status === 200,
    'calculation response time < 3s': (r) => r.timings.duration < 3000,
  });
}
```

### 4.2 壓力測試

```typescript
// tests/performance/stress-test.ts
export const options = {
  stages: [
    { duration: '1m', target: 100 },
    { duration: '5m', target: 200 },
    { duration: '5m', target: 300 },
    { duration: '5m', target: 400 },
    { duration: '10m', target: 500 }, // 超出預期負載
  ],
  thresholds: {
    http_req_duration: ['p(99)<5000'], // 99%請求在5秒內完成
    http_req_failed: ['rate<0.2'], // 錯誤率低於20%
  },
};

export default function () {
  // 測試大量並發計算
  const batchCalculationPayload = {
    policies: Array.from({ length: 100 }, (_, i) => ({
      policyNumber: `POL-BATCH-${i}`,
      premium: Math.random() * 1000000,
      lineOfBusiness: 'FIRE'
    }))
  };
  
  const response = http.post(
    'http://localhost:3000/api/cession/batch-calculate',
    JSON.stringify(batchCalculationPayload),
    { headers: { 'Content-Type': 'application/json' } }
  );
  
  check(response, {
    'batch calculation accepted': (r) => r.status === 202,
    'response time acceptable': (r) => r.timings.duration < 10000,
  });
}
```

---

## 5. 部署策略 / Deployment Strategy

### 5.1 環境配置

```yaml
# environments/development.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: reinsurance-config-dev
data:
  NODE_ENV: "development"
  DATABASE_URL: "file:./dev.db"
  LOG_LEVEL: "debug"
  ENABLE_DEVTOOLS: "true"
  API_RATE_LIMIT: "1000"
  
---
# environments/production.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: reinsurance-config-prod
data:
  NODE_ENV: "production"
  LOG_LEVEL: "info"
  ENABLE_DEVTOOLS: "false"
  API_RATE_LIMIT: "100"
  
---
apiVersion: v1
kind: Secret
metadata:
  name: reinsurance-secrets-prod
type: Opaque
stringData:
  DATABASE_URL: "postgresql://user:password@host:5432/reinsurance_prod"
  JWT_SECRET: "super-secret-jwt-key"
  ENCRYPTION_KEY: "encryption-key-for-sensitive-data"
```

### 5.2 部署流程

```yaml
# .github/workflows/deploy.yml
name: Deploy Reinsurance System

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: reinsurance-system

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [20]
        database: [sqlite, postgresql]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Setup test database
        if: matrix.database == 'postgresql'
        run: |
          docker run -d \
            --name postgres-test \
            -e POSTGRES_PASSWORD=test \
            -e POSTGRES_DB=reinsurance_test \
            -p 5432:5432 \
            postgres:14
          
          export DATABASE_URL="postgresql://postgres:test@localhost:5432/reinsurance_test"
          npx prisma migrate deploy
      
      - name: Run linting
        run: npm run lint
      
      - name: Run unit tests
        run: npm run test:unit
      
      - name: Run integration tests
        run: npm run test:integration
      
      - name: Run i18n validation
        run: npm run i18n:validate
      
      - name: Build application
        run: npm run build
      
      - name: Run E2E tests
        run: npm run test:e2e
        env:
          CI: true

  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run security audit
        run: npm audit --audit-level=high
      
      - name: Run dependency check
        uses: securecodewarrior/github-action-add-sarif@v1
        with:
          sarif-file: 'security-scan-results.sarif'

  build-and-push:
    needs: [test, security-scan]
    runs-on: ubuntu-latest
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
      image-digest: ${{ steps.build.outputs.digest }}
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=sha,prefix={{branch}}-
      
      - name: Build and push
        id: build
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy-staging:
    needs: build-and-push
    runs-on: ubuntu-latest
    environment: staging
    if: github.ref == 'refs/heads/develop'
    
    steps:
      - name: Deploy to Staging
        run: |
          # 更新Kubernetes部署
          kubectl set image deployment/reinsurance-system \
            app=${{ needs.build-and-push.outputs.image-tag }}
          
          # 等待部署完成
          kubectl rollout status deployment/reinsurance-system --timeout=300s
          
          # 執行部署後測試
          kubectl run integration-test \
            --image=${{ needs.build-and-push.outputs.image-tag }} \
            --rm -i --restart=Never \
            -- npm run test:integration:staging

  deploy-production:
    needs: [build-and-push, deploy-staging]
    runs-on: ubuntu-latest
    environment: production
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: Create deployment
        run: |
          # 建立部署記錄
          kubectl create deployment-record \
            --image=${{ needs.build-and-push.outputs.image-tag }} \
            --environment=production \
            --deployer=${{ github.actor }}
      
      - name: Database migration
        run: |
          # 執行資料庫遷移
          kubectl run db-migration \
            --image=${{ needs.build-and-push.outputs.image-tag }} \
            --rm -i --restart=Never \
            -- npx prisma migrate deploy
      
      - name: Deploy application
        run: |
          # 藍綠部署
          kubectl set image deployment/reinsurance-system-green \
            app=${{ needs.build-and-push.outputs.image-tag }}
          
          kubectl rollout status deployment/reinsurance-system-green --timeout=600s
          
          # 切換流量
          kubectl patch service reinsurance-system \
            -p '{"spec":{"selector":{"version":"green"}}}'
      
      - name: Post-deployment validation
        run: |
          # 執行生產環境驗證
          kubectl run prod-validation \
            --image=${{ needs.build-and-push.outputs.image-tag }} \
            --rm -i --restart=Never \
            -- npm run test:production:validation
      
      - name: Notify stakeholders
        run: |
          # 通知相關人員部署完成
          curl -X POST ${{ secrets.SLACK_WEBHOOK_URL }} \
            -H 'Content-type: application/json' \
            --data '{"text":"再保系統已成功部署到生產環境"}'
```

---

## 6. 資料庫遷移策略 / Database Migration Strategy

### 6.1 遷移腳本管理

```typescript
// scripts/migration-manager.ts
export interface MigrationPlan {
  version: string;
  description: string;
  migrations: Migration[];
  rollbackPlan: RollbackStep[];
  validationQueries: ValidationQuery[];
  estimatedDuration: number; // 分鐘
}

export interface Migration {
  id: string;
  name: string;
  type: 'SCHEMA' | 'DATA' | 'INDEX' | 'CLEANUP';
  sql?: string;
  script?: string;
  dependencies: string[];
  rollbackSql?: string;
}

export class MigrationManager {
  async executeMigrationPlan(plan: MigrationPlan): Promise<MigrationResult> {
    const result: MigrationResult = {
      planVersion: plan.version,
      startTime: new Date(),
      migrations: [],
      overallStatus: 'PENDING'
    };
    
    try {
      // 1. 預檢查
      await this.preflightCheck(plan);
      
      // 2. 建立備份
      const backupId = await this.createBackup();
      result.backupId = backupId;
      
      // 3. 執行遷移
      for (const migration of plan.migrations) {
        const migrationResult = await this.executeMigration(migration);
        result.migrations.push(migrationResult);
        
        if (!migrationResult.success) {
          throw new MigrationError(`Migration ${migration.id} failed`, migrationResult.error);
        }
      }
      
      // 4. 驗證結果
      await this.validateMigrations(plan.validationQueries);
      
      result.endTime = new Date();
      result.overallStatus = 'SUCCESS';
      
    } catch (error) {
      // 5. 回滾處理
      await this.rollbackMigrations(plan.rollbackPlan);
      
      result.endTime = new Date();
      result.overallStatus = 'FAILED';
      result.error = error.message;
    }
    
    return result;
  }
  
  private async executeMigration(migration: Migration): Promise<MigrationStepResult> {
    const startTime = new Date();
    
    try {
      switch (migration.type) {
        case 'SCHEMA':
          await this.executeSchemaChange(migration.sql!);
          break;
        case 'DATA':
          await this.executeDataMigration(migration.script!);
          break;
        case 'INDEX':
          await this.createIndexes(migration.sql!);
          break;
        case 'CLEANUP':
          await this.performCleanup(migration.script!);
          break;
      }
      
      return {
        migrationId: migration.id,
        success: true,
        startTime,
        endTime: new Date(),
        duration: Date.now() - startTime.getTime()
      };
      
    } catch (error) {
      return {
        migrationId: migration.id,
        success: false,
        startTime,
        endTime: new Date(),
        error: error.message
      };
    }
  }
}
```

### 6.2 零停機部署

```bash
#!/bin/bash
# scripts/zero-downtime-deploy.sh

set -e

echo "Starting zero-downtime deployment..."

# 1. 預檢查
echo "Performing pre-deployment checks..."
./scripts/pre-deployment-check.sh

# 2. 建立新版本部署
echo "Creating new deployment version..."
kubectl apply -f k8s/deployment-green.yml

# 3. 等待新版本就緒
echo "Waiting for new version to be ready..."
kubectl rollout status deployment/reinsurance-system-green --timeout=600s

# 4. 執行資料庫遷移（如需要）
if [ -f "migrations/pending.sql" ]; then
  echo "Executing database migrations..."
  kubectl run db-migration \
    --image=$NEW_IMAGE \
    --rm -i --restart=Never \
    -- npx prisma migrate deploy
fi

# 5. 健康檢查
echo "Performing health check on new version..."
kubectl run health-check \
  --image=$NEW_IMAGE \
  --rm -i --restart=Never \
  -- npm run health-check

# 6. 切換流量（藍綠部署）
echo "Switching traffic to new version..."
kubectl patch service reinsurance-system \
  -p '{"spec":{"selector":{"version":"green"}}}'

# 7. 驗證新版本
echo "Validating new deployment..."
sleep 30
./scripts/post-deployment-validation.sh

# 8. 清理舊版本
echo "Cleaning up old version..."
kubectl delete deployment reinsurance-system-blue

echo "Zero-downtime deployment completed successfully!"
```

---

## 7. 監控與告警部署 / Monitoring & Alerting Deployment

### 7.1 監控配置

```yaml
# monitoring/prometheus-config.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s
    
    rule_files:
      - "reinsurance_rules.yml"
    
    scrape_configs:
      - job_name: 'reinsurance-system'
        static_configs:
          - targets: ['reinsurance-system:3000']
        metrics_path: '/api/metrics'
        scrape_interval: 30s
        
      - job_name: 'reinsurance-database'
        static_configs:
          - targets: ['postgres-exporter:9187']
        scrape_interval: 60s

---
# monitoring/alert-rules.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: reinsurance-alert-rules
data:
  reinsurance_rules.yml: |
    groups:
      - name: reinsurance.rules
        rules:
          - alert: HighErrorRate
            expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
            for: 2m
            labels:
              severity: critical
            annotations:
              summary: "High error rate detected"
              description: "Error rate is {{ $value }} for the last 5 minutes"
          
          - alert: SlowApiResponse
            expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2
            for: 5m
            labels:
              severity: warning
            annotations:
              summary: "API response time is slow"
              description: "95th percentile response time is {{ $value }}s"
          
          - alert: CalculationEngineFailure
            expr: rate(cession_calculation_errors_total[5m]) > 0.01
            for: 1m
            labels:
              severity: critical
            annotations:
              summary: "Cession calculation engine errors"
              description: "Calculation error rate is {{ $value }}"
```

### 7.2 日誌聚合

```yaml
# logging/fluentd-config.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
data:
  fluent.conf: |
    <source>
      @type tail
      path /var/log/containers/reinsurance-system-*.log
      pos_file /var/log/fluentd-containers.log.pos
      tag kubernetes.reinsurance.*
      format json
      time_key timestamp
      time_format %Y-%m-%dT%H:%M:%S.%NZ
    </source>
    
    <filter kubernetes.reinsurance.**>
      @type parser
      key_name log
      reserve_data true
      <parse>
        @type json
      </parse>
    </filter>
    
    <match kubernetes.reinsurance.**>
      @type elasticsearch
      host elasticsearch.logging.svc.cluster.local
      port 9200
      index_name reinsurance-logs
      type_name _doc
      include_tag_key true
      tag_key @log_name
      
      <buffer>
        @type file
        path /var/log/fluentd-buffers/kubernetes.system.buffer
        flush_mode interval
        retry_type exponential_backoff
        flush_thread_count 2
        flush_interval 5s
        retry_forever
        retry_max_interval 30
        chunk_limit_size 2M
        queue_limit_length 8
        overflow_action block
      </buffer>
    </match>
```

---

## 8. 災難恢復測試 / Disaster Recovery Testing

### 8.1 災難恢復演練

```typescript
// scripts/disaster-recovery-drill.ts
export interface DisasterRecoveryDrill {
  id: string;
  name: string;
  scenario: DisasterScenario;
  objectives: string[];
  participants: string[];
  scheduledAt: Date;
  duration: number; // 分鐘
  status: 'PLANNED' | 'IN_PROGRESS' | 'COMPLETED' | 'FAILED';
}

export interface DisasterScenario {
  type: 'DATABASE_FAILURE' | 'APPLICATION_FAILURE' | 'NETWORK_PARTITION' | 'DATA_CENTER_OUTAGE';
  description: string;
  simulationSteps: SimulationStep[];
  expectedImpact: string;
  recoverySteps: RecoveryStep[];
}

export class DisasterRecoveryDrillManager {
  async executeDrill(drill: DisasterRecoveryDrill): Promise<DrillResult> {
    const result: DrillResult = {
      drillId: drill.id,
      startTime: new Date(),
      scenario: drill.scenario,
      steps: [],
      overallStatus: 'IN_PROGRESS'
    };
    
    try {
      // 1. 準備階段
      await this.prepareDrillEnvironment(drill);
      
      // 2. 模擬災難
      await this.simulateDisaster(drill.scenario);
      
      // 3. 執行恢復程序
      for (const step of drill.scenario.recoverySteps) {
        const stepResult = await this.executeRecoveryStep(step);
        result.steps.push(stepResult);
        
        if (!stepResult.success) {
          throw new DrillError(`Recovery step failed: ${step.name}`);
        }
      }
      
      // 4. 驗證恢復結果
      const validation = await this.validateRecovery(drill.objectives);
      result.validation = validation;
      
      result.endTime = new Date();
      result.overallStatus = validation.allObjectivesMet ? 'COMPLETED' : 'PARTIAL_SUCCESS';
      
    } catch (error) {
      result.endTime = new Date();
      result.overallStatus = 'FAILED';
      result.error = error.message;
    } finally {
      // 5. 清理演練環境
      await this.cleanupDrillEnvironment(drill);
    }
    
    return result;
  }
  
  async scheduleRegularDrills(): Promise<void> {
    const drills: DisasterRecoveryDrill[] = [
      {
        id: 'DR-DRILL-001',
        name: 'Database Failure Recovery',
        scenario: {
          type: 'DATABASE_FAILURE',
          description: '主資料庫完全故障，需要從備份恢復',
          simulationSteps: [
            { action: 'STOP_DATABASE', target: 'primary-db' },
            { action: 'SIMULATE_DATA_CORRUPTION', target: 'primary-db' }
          ],
          expectedImpact: '系統完全不可用，所有交易停止',
          recoverySteps: [
            { name: 'Switch to backup database', estimatedTime: 5 },
            { name: 'Restore from latest backup', estimatedTime: 30 },
            { name: 'Validate data integrity', estimatedTime: 15 },
            { name: 'Resume application services', estimatedTime: 10 }
          ]
        },
        objectives: [
          'RTO < 60分鐘',
          'RPO < 15分鐘',
          '資料完整性100%',
          '所有核心功能恢復'
        ],
        participants: ['DevOps Team', 'DBA', 'Application Team'],
        scheduledAt: new Date('2025-12-01T02:00:00Z'),
        duration: 120
      }
    ];
    
    for (const drill of drills) {
      await this.scheduleDrill(drill);
    }
  }
}
```

---

## 9. 效能基準測試 / Performance Baseline Testing

### 9.1 基準測試套件

```typescript
// tests/performance/benchmark.test.ts
import { describe, it, expect } from 'vitest';
import { performance } from 'perf_hooks';

describe('Performance Benchmarks', () => {
  describe('Cession Calculation Performance', () => {
    it('should calculate 1000 policies within 30 seconds', async () => {
      const policies = Array.from({ length: 1000 }, (_, i) => 
        createTestPolicy({ policyNumber: `POL-${i}` })
      );
      
      const startTime = performance.now();
      
      const results = await Promise.all(
        policies.map(policy => 
          cessionEngine.calculate({
            policyData: policy,
            calculationType: 'PREMIUM'
          })
        )
      );
      
      const endTime = performance.now();
      const duration = endTime - startTime;
      
      expect(results).toHaveLength(1000);
      expect(duration).toBeLessThan(30000); // 30秒
      expect(results.every(r => r.cededAmount.gte(0))).toBe(true);
    });
  });
  
  describe('Database Query Performance', () => {
    it('should load treaty list within 2 seconds', async () => {
      // 建立大量測試資料
      await createTestTreaties(5000);
      
      const startTime = performance.now();
      const treaties = await treatyService.listTreaties();
      const endTime = performance.now();
      
      expect(endTime - startTime).toBeLessThan(2000);
      expect(treaties.length).toBeGreaterThan(0);
    });
    
    it('should handle complex audit queries efficiently', async () => {
      // 建立大量稽核資料
      await createTestAuditEvents(10000);
      
      const startTime = performance.now();
      const auditEvents = await auditRepository.findByFilters({
        entityType: 'Treaty',
        dateRange: {
          start: new Date('2025-01-01'),
          end: new Date('2025-12-31')
        },
        limit: 100
      });
      const endTime = performance.now();
      
      expect(endTime - startTime).toBeLessThan(3000);
      expect(auditEvents.length).toBeLessThanOrEqual(100);
    });
  });
});
```

### 9.2 記憶體洩漏測試

```typescript
// tests/performance/memory-leak.test.ts
describe('Memory Leak Detection', () => {
  it('should not leak memory during batch calculations', async () => {
    const initialMemory = process.memoryUsage().heapUsed;
    
    // 執行大量計算
    for (let i = 0; i < 1000; i++) {
      await cessionEngine.calculate({
        policyData: createTestPolicy(),
        calculationType: 'PREMIUM'
      });
      
      // 每100次檢查一次記憶體
      if (i % 100 === 0) {
        global.gc?.(); // 強制垃圾回收
        const currentMemory = process.memoryUsage().heapUsed;
        const memoryIncrease = currentMemory - initialMemory;
        
        // 記憶體增長不應超過100MB
        expect(memoryIncrease).toBeLessThan(100 * 1024 * 1024);
      }
    }
  });
});
```

---

## 10. 安全測試策略 / Security Testing Strategy

### 10.1 安全測試套件

```typescript
// tests/security/security.test.ts
describe('Security Tests', () => {
  describe('Authentication & Authorization', () => {
    it('should reject requests without valid API key', async () => {
      const response = await fetch('/api/treaties', {
        headers: { 'Authorization': 'Bearer invalid-token' }
      });
      
      expect(response.status).toBe(401);
    });
    
    it('should enforce role-based access control', async () => {
      const readOnlyToken = await getTestToken('READ_ONLY_USER');
      
      const response = await fetch('/api/treaties', {
        method: 'POST',
        headers: { 
          'Authorization': `Bearer ${readOnlyToken}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(createTestTreatyData())
      });
      
      expect(response.status).toBe(403);
    });
  });
  
  describe('Input Validation', () => {
    it('should prevent SQL injection attacks', async () => {
      const maliciousInput = "'; DROP TABLE Treaty; --";
      
      const formData = new FormData();
      formData.append('treatyName', maliciousInput);
      
      const result = await createTreaty(undefined, formData);
      
      expect(result.success).toBe(false);
      expect(result.errors?.treatyName).toContain('無效字符');
      
      // 驗證資料表仍然存在
      const treatyCount = await treatyRepository.count();
      expect(treatyCount).toBeGreaterThanOrEqual(0);
    });
    
    it('should sanitize XSS attempts', async () => {
      const xssPayload = '<script>alert("xss")</script>';
      
      const formData = new FormData();
      formData.append('notes', xssPayload);
      formData.append('treatyName', 'Test Treaty');
      
      const result = await createTreaty(undefined, formData);
      
      if (result.success) {
        expect(result.data?.notes).not.toContain('<script>');
        expect(result.data?.notes).toContain('&lt;script&gt;');
      }
    });
  });
  
  describe('Data Protection', () => {
    it('should encrypt sensitive data in audit logs', async () => {
      const sensitiveData = {
        taxId: '12345678-9',
        registrationNumber: 'FSC-2025-001'
      };
      
      await reinsurerService.createReinsurer({
        code: 'TEST-RIN',
        name: 'Test Reinsurer',
        ...sensitiveData
      });
      
      const auditEvents = await auditRepository.findByEntity('Reinsurer', 'TEST-RIN');
      const auditEvent = auditEvents[0];
      
      // 檢查敏感資料是否被遮罩
      const taxIdChange = auditEvent.changes.find(c => c.fieldPath === 'taxId');
      expect(taxIdChange?.newValue.display).toBe('***-***-*');
      expect(taxIdChange?.newValue.raw).not.toBe(sensitiveData.taxId);
    });
  });
});
```

### 10.2 滲透測試

```bash
#!/bin/bash
# scripts/penetration-test.sh

echo "Starting penetration testing..."

# 1. 網路掃描
echo "Performing network scan..."
nmap -sS -O target-host

# 2. 弱點掃描
echo "Running vulnerability scan..."
nikto -h http://target-host:3000

# 3. SQL注入測試
echo "Testing for SQL injection..."
sqlmap -u "http://target-host:3000/api/treaties?search=test" \
       --batch --level=3 --risk=2

# 4. XSS測試
echo "Testing for XSS vulnerabilities..."
xsser -u "http://target-host:3000/treaties/new" \
      --auto --cookie="session=test-session"

# 5. CSRF測試
echo "Testing for CSRF vulnerabilities..."
curl -X POST http://target-host:3000/api/treaties \
     -H "Content-Type: application/json" \
     -d '{"treatyName":"CSRF Test"}' \
     --referer "http://malicious-site.com"

echo "Penetration testing completed. Check results for vulnerabilities."
```

---

## 11. 部署自動化 / Deployment Automation

### 11.1 Kubernetes部署配置

```yaml
# k8s/deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reinsurance-system
  labels:
    app: reinsurance-system
    version: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: reinsurance-system
      version: blue
  template:
    metadata:
      labels:
        app: reinsurance-system
        version: blue
    spec:
      containers:
      - name: app
        image: ghcr.io/company/reinsurance-system:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: reinsurance-secrets
              key: database-url
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /api/health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /api/ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
        volumeMounts:
        - name: app-config
          mountPath: /app/config
          readOnly: true
      volumes:
      - name: app-config
        configMap:
          name: reinsurance-config

---
apiVersion: v1
kind: Service
metadata:
  name: reinsurance-system
spec:
  selector:
    app: reinsurance-system
  ports:
  - port: 80
    targetPort: 3000
  type: ClusterIP

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: reinsurance-system
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - reinsurance.company.com
    secretName: reinsurance-tls
  rules:
  - host: reinsurance.company.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: reinsurance-system
            port:
              number: 80
```

### 11.2 Helm Chart配置

```yaml
# helm/reinsurance-system/values.yml
replicaCount: 3

image:
  repository: ghcr.io/company/reinsurance-system
  pullPolicy: IfNotPresent
  tag: ""

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: reinsurance.company.com
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - secretName: reinsurance-tls
      hosts:
        - reinsurance.company.com

resources:
  limits:
    cpu: 500m
    memory: 1Gi
  requests:
    cpu: 250m
    memory: 512Mi

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80

database:
  host: postgres.database.svc.cluster.local
  port: 5432
  name: reinsurance_prod
  ssl: true

monitoring:
  enabled: true
  serviceMonitor:
    enabled: true
    interval: 30s
    path: /api/metrics

logging:
  level: info
  format: json
  destination: stdout

security:
  podSecurityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 2000
  securityContext:
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
    capabilities:
      drop:
      - ALL
```

---

## 12. 測試資料管理 / Test Data Management

### 12.1 測試資料工廠

```typescript
// tests/factories/treaty-factory.ts
import { faker } from '@faker-js/faker';
import type { CreateTreatyRequest } from '@/types/treaty';

export class TreatyFactory {
  static create(overrides: Partial<CreateTreatyRequest> = {}): CreateTreatyRequest {
    return {
      treatyName: faker.company.name() + ' 再保合約',
      treatyType: faker.helpers.arrayElement(['PROPORTIONAL', 'NON_PROPORTIONAL']),
      lineOfBusiness: faker.helpers.arrayElement(['FIRE', 'MOTOR', 'MARINE', 'LIFE']),
      effectiveDate: faker.date.future().toISOString().split('T')[0],
      expiryDate: faker.date.future({ years: 1 }).toISOString().split('T')[0],
      cessionMethod: faker.helpers.arrayElement(['QUOTA_SHARE', 'SURPLUS', 'EXCESS_OF_LOSS']),
      currency: faker.helpers.arrayElement(['TWD', 'USD', 'JPY']),
      shares: [
        {
          reinsurerId: faker.string.uuid(),
          reinsurerName: faker.company.name(),
          sharePercentage: faker.number.int({ min: 10, max: 50 }),
          commissionRate: faker.number.int({ min: 5, max: 15 })
        }
      ],
      ...overrides
    };
  }
  
  static createBatch(count: number, overrides: Partial<CreateTreatyRequest> = {}): CreateTreatyRequest[] {
    return Array.from({ length: count }, () => this.create(overrides));
  }
  
  static createQuotaShareTreaty(overrides: Partial<CreateTreatyRequest> = {}): CreateTreatyRequest {
    return this.create({
      treatyType: 'PROPORTIONAL',
      cessionMethod: 'QUOTA_SHARE',
      ...overrides
    });
  }
  
  static createExcessOfLossTreaty(overrides: Partial<CreateTreatyRequest> = {}): CreateTreatyRequest {
    return this.create({
      treatyType: 'NON_PROPORTIONAL',
      cessionMethod: 'EXCESS_OF_LOSS',
      attachmentPoint: 1000000,
      limitAmount: 5000000,
      ...overrides
    });
  }
}

// tests/factories/calculation-factory.ts
export class CalculationFactory {
  static createPolicyData(overrides: Partial<PolicyData> = {}): PolicyData {
    return {
      policyNumber: faker.string.alphanumeric(10).toUpperCase(),
      productCode: faker.helpers.arrayElement(['FIRE-01', 'MOTOR-01', 'MARINE-01']),
      sumInsured: faker.number.int({ min: 100000, max: 10000000 }),
      premium: faker.number.int({ min: 10000, max: 500000 }),
      currency: 'TWD',
      effectiveDate: faker.date.recent(),
      expiryDate: faker.date.future(),
      lineOfBusiness: faker.helpers.arrayElement(['FIRE', 'MOTOR', 'MARINE']),
      ...overrides
    };
  }
  
  static createClaimData(overrides: Partial<ClaimData> = {}): ClaimData {
    return {
      claimId: faker.string.alphanumeric(10).toUpperCase(),
      policyNumber: faker.string.alphanumeric(10).toUpperCase(),
      claimAmount: faker.number.int({ min: 50000, max: 2000000 }),
      lossDate: faker.date.recent(),
      reportedDate: faker.date.recent(),
      currency: 'TWD',
      status: 'REPORTED',
      ...overrides
    };
  }
}
```

### 12.2 測試環境管理

```typescript
// tests/helpers/test-environment.ts
export class TestEnvironmentManager {
  private static instance: TestEnvironmentManager;
  private testDatabases = new Map<string, TestDatabase>();
  
  static getInstance(): TestEnvironmentManager {
    if (!this.instance) {
      this.instance = new TestEnvironmentManager();
    }
    return this.instance;
  }
  
  async createIsolatedEnvironment(testSuite: string): Promise<TestEnvironment> {
    const envId = `test-${testSuite}-${Date.now()}`;
    
    // 建立獨立的測試資料庫
    const testDb = await this.createTestDatabase(envId);
    
    // 執行遷移
    await testDb.migrate();
    
    // 載入種子資料
    await testDb.seed();
    
    const environment: TestEnvironment = {
      id: envId,
      database: testDb,
      baseUrl: `http://localhost:${await this.getAvailablePort()}`,
      createdAt: new Date()
    };
    
    this.testDatabases.set(envId, testDb);
    
    return environment;
  }
  
  async cleanupEnvironment(envId: string): Promise<void> {
    const testDb = this.testDatabases.get(envId);
    if (testDb) {
      await testDb.cleanup();
      this.testDatabases.delete(envId);
    }
  }
  
  async resetEnvironment(envId: string): Promise<void> {
    const testDb = this.testDatabases.get(envId);
    if (testDb) {
      await testDb.reset();
      await testDb.seed();
    }
  }
}
```

---

## 13. CI/CD流水線優化 / CI/CD Pipeline Optimization

### 13.1 並行測試執行

```yaml
# .github/workflows/optimized-ci.yml
name: Optimized CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  # 並行執行不同類型的測試
  unit-tests:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        test-group: [services, repositories, utils, validations]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm run test:unit:${{ matrix.test-group }}
      - uses: actions/upload-artifact@v4
        with:
          name: coverage-${{ matrix.test-group }}
          path: coverage/

  integration-tests:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:14
        env:
          POSTGRES_PASSWORD: test
          POSTGRES_DB: reinsurance_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npx prisma migrate deploy
        env:
          DATABASE_URL: postgresql://postgres:test@localhost:5432/reinsurance_test
      - run: npm run test:integration

  e2e-tests:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        locale: [zh-TW, en-US, zh-CN]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run build
      - run: npx playwright install
      - run: npm run test:e2e:${{ matrix.locale }}
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-report-${{ matrix.locale }}
          path: playwright-report/

  security-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm audit --audit-level=high
      - run: npm run test:security
      - name: Run OWASP ZAP
        uses: zaproxy/action-baseline@v0.7.0
        with:
          target: 'http://localhost:3000'

  # 合併測試結果
  test-results:
    needs: [unit-tests, integration-tests, e2e-tests, security-tests]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
      - name: Merge coverage reports
        run: |
          npx nyc merge coverage/ coverage/merged.json
          npx nyc report --reporter=lcov --reporter=text-summary
      - name: Upload to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

### 13.2 部署驗證腳本

```bash
#!/bin/bash
# scripts/deployment-validation.sh

set -e

echo "Starting deployment validation..."

# 1. 健康檢查
echo "Checking application health..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/health)
if [ "$response" != "200" ]; then
  echo "Health check failed: HTTP $response"
  exit 1
fi

# 2. 資料庫連線測試
echo "Testing database connection..."
npm run db:test-connection

# 3. 外部系統整合測試
echo "Testing external system integrations..."
npm run test:integration:external

# 4. 關鍵功能煙霧測試
echo "Running smoke tests..."
npm run test:smoke

# 5. 效能基準測試
echo "Running performance baseline..."
npm run test:performance:baseline

# 6. 安全掃描
echo "Running security scan..."
npm run security:scan

# 7. 多語言功能測試
echo "Testing multi-language support..."
for locale in zh-TW en-US zh-CN; do
  response=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Accept-Language: $locale" \
    http://localhost:3000/$locale/treaties)
  
  if [ "$response" != "200" ]; then
    echo "Multi-language test failed for $locale: HTTP $response"
    exit 1
  fi
done

echo "All deployment validations passed!"
```

---

## 14. 測試報告與指標 / Test Reporting & Metrics

### 14.1 測試報告生成

```typescript
// scripts/generate-test-report.ts
export interface TestReport {
  summary: TestSummary;
  coverage: CoverageReport;
  performance: PerformanceReport;
  security: SecurityReport;
  i18n: I18nReport;
  generatedAt: Date;
}

export class TestReportGenerator {
  async generateComprehensiveReport(): Promise<TestReport> {
    const [
      unitResults,
      integrationResults,
      e2eResults,
      coverageData,
      performanceData,
      securityData,
      i18nData
    ] = await Promise.all([
      this.collectUnitTestResults(),
      this.collectIntegrationTestResults(),
      this.collectE2eTestResults(),
      this.collectCoverageData(),
      this.collectPerformanceData(),
      this.collectSecurityData(),
      this.collectI18nData()
    ]);
    
    return {
      summary: {
        totalTests: unitResults.total + integrationResults.total + e2eResults.total,
        passedTests: unitResults.passed + integrationResults.passed + e2eResults.passed,
        failedTests: unitResults.failed + integrationResults.failed + e2eResults.failed,
        overallStatus: this.calculateOverallStatus([unitResults, integrationResults, e2eResults]),
        testDuration: unitResults.duration + integrationResults.duration + e2eResults.duration
      },
      coverage: coverageData,
      performance: performanceData,
      security: securityData,
      i18n: i18nData,
      generatedAt: new Date()
    };
  }
  
  async publishReport(report: TestReport): Promise<void> {
    // 1. 生成HTML報告
    const htmlReport = await this.generateHtmlReport(report);
    await this.saveReport('test-report.html', htmlReport);
    
    // 2. 生成JSON報告
    await this.saveReport('test-report.json', JSON.stringify(report, null, 2));
    
    // 3. 發送到Slack
    await this.sendSlackNotification(report);
    
    // 4. 更新測試儀表板
    await this.updateTestDashboard(report);
  }
}
```

### 14.2 品質門檻檢查

```typescript
// scripts/quality-gate.ts
export interface QualityGate {
  name: string;
  criteria: QualityCriteria[];
  required: boolean;
}

export interface QualityCriteria {
  metric: string;
  operator: 'GT' | 'LT' | 'GTE' | 'LTE' | 'EQ';
  threshold: number;
  unit?: string;
}

export const qualityGates: QualityGate[] = [
  {
    name: 'Code Coverage',
    criteria: [
      { metric: 'line_coverage', operator: 'GTE', threshold: 85, unit: '%' },
      { metric: 'branch_coverage', operator: 'GTE', threshold: 80, unit: '%' },
      { metric: 'function_coverage', operator: 'GTE', threshold: 90, unit: '%' }
    ],
    required: true
  },
  {
    name: 'Performance',
    criteria: [
      { metric: 'api_response_p95', operator: 'LT', threshold: 2000, unit: 'ms' },
      { metric: 'calculation_time_avg', operator: 'LT', threshold: 3000, unit: 'ms' },
      { metric: 'memory_usage_max', operator: 'LT', threshold: 1024, unit: 'MB' }
    ],
    required: true
  },
  {
    name: 'Security',
    criteria: [
      { metric: 'critical_vulnerabilities', operator: 'EQ', threshold: 0 },
      { metric: 'high_vulnerabilities', operator: 'LTE', threshold: 2 },
      { metric: 'security_test_pass_rate', operator: 'GTE', threshold: 100, unit: '%' }
    ],
    required: true
  },
  {
    name: 'Internationalization',
    criteria: [
      { metric: 'translation_coverage', operator: 'GTE', threshold: 100, unit: '%' },
      { metric: 'ui_expansion_test_pass_rate', operator: 'GTE', threshold: 95, unit: '%' }
    ],
    required: true
  }
];

export class QualityGateChecker {
  async checkQualityGates(testReport: TestReport): Promise<QualityGateResult> {
    const results: QualityGateResult = {
      overallStatus: 'PASSED',
      gateResults: [],
      checkedAt: new Date()
    };
    
    for (const gate of qualityGates) {
      const gateResult = await this.checkGate(gate, testReport);
      results.gateResults.push(gateResult);
      
      if (!gateResult.passed && gate.required) {
        results.overallStatus = 'FAILED';
      }
    }
    
    return results;
  }
  
  private async checkGate(gate: QualityGate, report: TestReport): Promise<GateResult> {
    const criteriaResults: CriteriaResult[] = [];
    
    for (const criteria of gate.criteria) {
      const actualValue = this.extractMetricValue(report, criteria.metric);
      const passed = this.evaluateCriteria(actualValue, criteria);
      
      criteriaResults.push({
        metric: criteria.metric,
        threshold: criteria.threshold,
        actualValue,
        passed,
        operator: criteria.operator
      });
    }
    
    return {
      gateName: gate.name,
      passed: criteriaResults.every(c => c.passed),
      required: gate.required,
      criteria: criteriaResults
    };
  }
}
```

---

## 15. 修訂記錄 / Revision History

| 版本 | 日期 | 修訂內容 | 作者 |
|------|------|----------|------|
| v1.0 | 2025-11-05 | 初版測試與部署策略，涵蓋完整的測試金字塔、CI/CD流程、效能測試、安全測試和部署自動化 | Tao Yu 和他的 GPT 智能助手 |

---

> 本測試與部署策略需與QA Lead、DevOps Lead和Security Lead確認後實施。所有測試腳本和部署配置都應該在實際環境中驗證，並根據實際情況調整參數和閾值。