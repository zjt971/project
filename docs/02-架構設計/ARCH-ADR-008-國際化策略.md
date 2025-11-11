# ADR-008：國際化與多語系支援策略
# ADR-008: Internationalization & Multi-language Support Strategy

- **狀態**：已核可，需要重構（Critical Technical Debt Identified）
- **日期**：2025-11-05（更新：識別硬編碼問題）
- **決策者**：Architecture Board、Product Owner、UI/UX Lead
- **相關文件**：RI-9-8 國際化重構計劃

---

## 1. 背景與問題 / Background & Problem

根據 PRD 第3.4節要求，再保系統必須自第一版起支援多國語言（最少含繁體中文、簡體中文、英文），確保可於亞太與全球客戶部署。當前系統缺乏完整的國際化架構，需要建立統一的多語言支援機制。

### 1.1 核心需求
- 支援繁體中文（zh-TW）、簡體中文（zh-CN）、英文（en-US）三種語言
- 所有UI文案、錯誤訊息、郵件模板需以i18n Key管理
- 支援動態語言切換與用戶偏好設定
- 日期、金額、數字格式需依語系自動調整
- UI版面需預留30%以上文字伸展空間

---

## 2. 決策摘要 / Decision Summary

**⚠️ 重要更新**：經過實際實作發現嚴重的架構問題，需要立即重構。

### 2.1 當前實作狀態
- **核心框架**：Next.js 16 App Router（因next-intl兼容性問題改用原生方案）
- **翻譯管理**：JSON格式翻譯檔案，集中於 `locales/` 目錄
- **預設語言**：繁體中文（zh-TW）
- **Fallback策略**：未翻譯內容回退至繁體中文
- **格式化**：使用 Intl API 處理日期、數字、貨幣格式

### 2.2 識別的關鍵問題
**🔴 Critical Issue**：發現 **35個位置** 存在硬編碼語言判斷：
```tsx
// ❌ 不可擴展的實作方式
{locale === 'en-US' ? 'Operation Time' : locale === 'zh-CN' ? '操作时间' : '操作時間'}
```

**影響範圍**：
- 審計歷史表格：5個硬編碼
- 首頁：8個硬編碼
- 再保人相關頁面：17個硬編碼
- 合約相關頁面：11個硬編碼

### 2.3 緊急重構決策
基於可擴展性考量，決定立即重構為翻譯鍵驅動的架構：
- **翻譯鍵驅動**：所有文字通過 `t('key')` 獲取
- **組件語言無關**：組件不包含語言特定邏輯
- **型別安全**：編譯時翻譯鍵檢查
- **可擴展性**：支援任意數量語言而無需修改組件

---

## 3. 技術架構 / Technical Architecture

### 3.1 目錄結構
```
src/
├── app/
│   ├── [locale]/           # 語言路由層
│   │   ├── layout.tsx      # 語言特定佈局
│   │   ├── page.tsx        # 首頁
│   │   ├── treaties/       # 合約管理頁面
│   │   └── reinsurers/     # 再保人管理頁面
│   └── globals.css
├── lib/
│   ├── i18n.ts            # 國際化配置
│   ├── locale-utils.ts    # 語言工具函數
│   └── format-utils.ts    # 格式化工具
├── components/
│   ├── ui/
│   │   └── language-switcher.tsx  # 語言切換器
│   └── providers/
│       └── intl-provider.tsx      # 國際化提供者
└── middleware.ts          # 語言路由中間件

locales/
├── zh-TW/
│   ├── common.json        # 通用翻譯
│   ├── treaty.json        # 合約模組
│   ├── reinsurer.json     # 再保人模組
│   ├── errors.json        # 錯誤訊息
│   └── validation.json    # 驗證訊息
├── zh-CN/
│   └── [同上結構]
└── en-US/
    └── [同上結構]
```

### 3.2 配置檔案

**`src/lib/i18n.ts`**
```typescript
export const locales = ['zh-TW', 'zh-CN', 'en-US'] as const;
export type Locale = typeof locales[number];

export const defaultLocale: Locale = 'zh-TW';

export const localeConfig = {
  'zh-TW': {
    name: '繁體中文',
    flag: '🇹🇼',
    dateFormat: 'YYYY-MM-DD',
    numberFormat: 'zh-TW',
    currency: 'TWD',
    timezone: 'Asia/Taipei'
  },
  'zh-CN': {
    name: '简体中文', 
    flag: '🇨🇳',
    dateFormat: 'YYYY-MM-DD',
    numberFormat: 'zh-CN',
    currency: 'CNY',
    timezone: 'Asia/Shanghai'
  },
  'en-US': {
    name: 'English',
    flag: '🇺🇸', 
    dateFormat: 'MM/DD/YYYY',
    numberFormat: 'en-US',
    currency: 'USD',
    timezone: 'America/New_York'
  }
} as const;
```

### 3.3 中間件配置

**`middleware.ts`**
```typescript
import createMiddleware from 'next-intl/middleware';
import { locales, defaultLocale } from '@/lib/i18n';

export default createMiddleware({
  locales,
  defaultLocale,
  localePrefix: 'always'
});

export const config = {
  matcher: ['/((?!api|_next|_vercel|.*\\..*).*)']
};
```

---

## 4. 實作策略 / Implementation Strategy

### 4.1 翻譯鍵命名規範

採用階層式命名，格式：`<module>.<section>.<key>`

```json
{
  "common": {
    "actions": {
      "create": "建立",
      "edit": "編輯", 
      "delete": "刪除",
      "save": "儲存",
      "cancel": "取消"
    },
    "status": {
      "active": "生效",
      "draft": "草稿",
      "pending": "待審"
    }
  },
  "treaty": {
    "list": {
      "title": "合約管理",
      "subtitle": "管理再保合約與相關條款",
      "createButton": "建立合約"
    },
    "form": {
      "treatyCode": "合約代號",
      "treatyName": "合約名稱",
      "effectiveDate": "生效日期"
    },
    "validation": {
      "treatyCodeRequired": "合約代號為必填欄位",
      "dateRangeInvalid": "終止日不可早於生效日"
    }
  }
}
```

### 4.2 Server Actions 國際化

```typescript
// src/actions/treaty-actions.ts
import { getTranslations } from 'next-intl/server';

export async function createTreaty(
  _prevState: TreatyFormState | undefined,
  formData: FormData,
): Promise<TreatyFormState> {
  const t = await getTranslations('treaty.messages');
  
  try {
    // ... 業務邏輯
    return {
      success: true,
      message: t('createSuccess'), // "合約建立成功"
      data: created,
    };
  } catch (error) {
    return {
      success: false,
      message: t('createError'), // "建立合約時發生錯誤"
      errors: { global: error.message },
    };
  }
}
```

### 4.3 UI元件國際化

```typescript
// src/components/ui/page-header.tsx
import { useTranslations } from 'next-intl';

export function PageHeader({ titleKey, ...props }) {
  const t = useTranslations('common');
  
  return (
    <header>
      <h1>{t(titleKey)}</h1>
      {/* ... */}
    </header>
  );
}
```

### 4.4 格式化工具

```typescript
// src/lib/format-utils.ts
import { Locale, localeConfig } from '@/lib/i18n';

export function formatCurrency(
  amount: number,
  currency: string,
  locale: Locale
): string {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: currency || localeConfig[locale].currency,
  }).format(amount);
}

export function formatDate(
  date: Date | string,
  locale: Locale,
  options?: Intl.DateTimeFormatOptions
): string {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  return new Intl.DateTimeFormat(locale, {
    year: 'numeric',
    month: '2-digit', 
    day: '2-digit',
    ...options,
  }).format(dateObj);
}

export function formatPercentage(
  value: number,
  locale: Locale,
  decimals: number = 2
): string {
  return new Intl.NumberFormat(locale, {
    style: 'percent',
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  }).format(value / 100);
}
```

---

## 5. 資料庫國際化支援 / Database i18n Support

### 5.1 多語言內容儲存

對於需要多語言的資料庫內容，採用JSON欄位儲存：

```prisma
model SystemParameter {
  id          String   @id @default(uuid())
  key         String   @unique
  value       Json     // { "zh-TW": "值", "zh-CN": "值", "en-US": "value" }
  description Json?    // 多語言描述
  category    String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model ReinsurerType {
  code        String   @id
  label       Json     // { "zh-TW": "公司", "zh-CN": "公司", "en-US": "Company" }
  description Json?
  sortOrder   Int      @default(0)
  isActive    Boolean  @default(true)
}
```

### 5.2 稽核事件多語言

```typescript
// 稽核事件需記錄多語言顯示值
type AuditFieldValue = {
  raw: string | number | null;
  display: {
    'zh-TW': string | null;
    'zh-CN': string | null; 
    'en-US': string | null;
  };
};
```

---

## 6. UI/UX 多語言適配 / UI/UX Multi-language Adaptation

### 6.1 版面伸展性設計

遵循PRD要求，UI需預留30%以上文字伸展空間：

```css
/* globals.css - 多語言版面變數 */
:root {
  --text-expansion-factor: 1.3;
  --min-button-width: calc(80px * var(--text-expansion-factor));
  --min-field-width: calc(272px * var(--text-expansion-factor));
}

/* 按鈕最小寬度保護 */
.btn {
  min-width: var(--min-button-width);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 表單欄位寬度適配 */
.form-field {
  min-width: var(--min-field-width);
  flex: 1 1 auto;
}
```

### 6.2 語言切換器元件

```typescript
// src/components/ui/language-switcher.tsx
'use client';

import { useLocale } from 'next-intl';
import { useRouter, usePathname } from 'next/navigation';
import { locales, localeConfig } from '@/lib/i18n';

export function LanguageSwitcher() {
  const locale = useLocale();
  const router = useRouter();
  const pathname = usePathname();

  const switchLanguage = (newLocale: string) => {
    const newPath = pathname.replace(`/${locale}`, `/${newLocale}`);
    router.push(newPath);
  };

  return (
    <select 
      value={locale}
      onChange={(e) => switchLanguage(e.target.value)}
      className="language-switcher"
    >
      {locales.map((loc) => (
        <option key={loc} value={loc}>
          {localeConfig[loc].flag} {localeConfig[loc].name}
        </option>
      ))}
    </select>
  );
}
```

---

## 7. 服務層國際化 / Service Layer i18n

### 7.1 錯誤訊息國際化

```typescript
// src/errors/treaty.errors.ts
import { getTranslations } from 'next-intl/server';

export class TreatyValidationError extends TreatyError {
  constructor(
    messageKey: string,
    field: string,
    value?: string,
    locale?: string
  ) {
    super(messageKey, field, value);
    this.name = 'TreatyValidationError';
  }

  async getLocalizedMessage(locale: string = 'zh-TW'): Promise<string> {
    const t = await getTranslations({ locale, namespace: 'treaty.errors' });
    return t(this.message, { field: this.field, value: this.value });
  }
}
```

### 7.2 業務規則多語言

```typescript
// src/services/treaty-service.ts
import { getTranslations } from 'next-intl/server';

export class TreatyService {
  async validateTreatyOverlap(
    lineOfBusiness: string,
    effectiveDate: Date,
    expiryDate: Date,
    excludeId?: string,
    locale: string = 'zh-TW'
  ) {
    const overlap = await treatyRepository.findOverlap(/*...*/);
    if (overlap) {
      const t = await getTranslations({ locale, namespace: 'treaty.validation' });
      throw new TreatyValidationError(
        t('overlapError', { treatyCode: overlap.treatyCode }),
        'effectiveDate',
        overlap.treatyCode
      );
    }
  }
}
```

---

## 8. 翻譯資源管理 / Translation Resource Management

### 8.1 翻譯檔案結構

```json
// locales/zh-TW/common.json
{
  "navigation": {
    "home": "首頁",
    "treaties": "合約管理", 
    "reinsurers": "再保人管理",
    "facultative": "臨分管理",
    "reports": "報表中心"
  },
  "actions": {
    "create": "建立",
    "edit": "編輯",
    "delete": "刪除",
    "save": "儲存",
    "cancel": "取消",
    "submit": "提交",
    "approve": "核准",
    "reject": "退回"
  },
  "status": {
    "active": "生效",
    "draft": "草稿", 
    "pending": "待審",
    "closed": "結束",
    "archived": "封存"
  },
  "messages": {
    "loading": "載入中...",
    "noData": "暫無資料",
    "confirmDelete": "確定要刪除嗎？",
    "operationSuccess": "操作成功",
    "operationFailed": "操作失敗"
  }
}
```

```json
// locales/zh-TW/treaty.json
{
  "list": {
    "title": "合約管理",
    "subtitle": "管理再保合約與相關條款",
    "createButton": "建立合約",
    "filterTitle": "篩選條件"
  },
  "form": {
    "basicInfo": "基本資料",
    "treatyCode": "合約代號",
    "treatyName": "合約名稱",
    "treatyType": "合約類型",
    "lineOfBusiness": "險種別",
    "effectiveDate": "生效日期",
    "expiryDate": "終止日期",
    "currency": "幣別",
    "cessionMethod": "分保方式",
    "reinsurerConfig": "再保人配置",
    "sharePercentage": "分保比例",
    "commissionRate": "佣金比率"
  },
  "validation": {
    "treatyCodeRequired": "合約代號為必填欄位",
    "treatyNameRequired": "合約名稱為必填欄位",
    "dateRangeInvalid": "終止日不可早於生效日",
    "shareExceeds100": "再保人份額總和不可超過100%",
    "overlapError": "合約期間與既有合約 {treatyCode} 重疊"
  },
  "messages": {
    "createSuccess": "合約建立成功",
    "updateSuccess": "合約更新成功", 
    "deleteSuccess": "合約已刪除",
    "createError": "建立合約時發生錯誤",
    "updateError": "更新合約時發生錯誤",
    "deleteError": "刪除合約時發生錯誤"
  }
}
```

### 8.2 翻譯鍵提取工具

```typescript
// scripts/extract-i18n-keys.ts
import { glob } from 'glob';
import { readFileSync, writeFileSync } from 'fs';

// 自動掃描程式碼中的 t('key') 使用，產生翻譯鍵清單
export async function extractTranslationKeys() {
  const files = await glob('src/**/*.{ts,tsx}');
  const keys = new Set<string>();
  
  for (const file of files) {
    const content = readFileSync(file, 'utf-8');
    const matches = content.match(/t\(['"`]([^'"`]+)['"`]\)/g);
    if (matches) {
      matches.forEach(match => {
        const key = match.match(/t\(['"`]([^'"`]+)['"`]\)/)?.[1];
        if (key) keys.add(key);
      });
    }
  }
  
  return Array.from(keys).sort();
}
```

---

## 9. 格式化與本地化 / Formatting & Localization

### 9.1 日期格式化

```typescript
// src/lib/format-utils.ts
export function formatDate(
  date: Date | string,
  locale: Locale,
  options?: Intl.DateTimeFormatOptions
): string {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  const config = localeConfig[locale];
  
  return new Intl.DateTimeFormat(locale, {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    timeZone: config.timezone,
    ...options,
  }).format(dateObj);
}

export function formatDateRange(
  startDate: Date | string,
  endDate: Date | string, 
  locale: Locale
): string {
  const start = formatDate(startDate, locale);
  const end = formatDate(endDate, locale);
  
  switch (locale) {
    case 'en-US':
      return `${start} - ${end}`;
    default:
      return `${start} ~ ${end}`;
  }
}
```

### 9.2 貨幣與數字格式化

```typescript
export function formatCurrency(
  amount: number,
  currency: string,
  locale: Locale
): string {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: currency || localeConfig[locale].currency,
    minimumFractionDigits: 0,
    maximumFractionDigits: 2,
  }).format(amount);
}

export function formatPercentage(
  value: number,
  locale: Locale,
  decimals: number = 2
): string {
  return new Intl.NumberFormat(locale, {
    style: 'percent',
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  }).format(value / 100);
}
```

---

## 10. 稽核事件多語言支援 / Audit Event i18n Support

### 10.1 稽核訊息國際化

```typescript
// src/lib/audit-diff.ts
import { getTranslations } from 'next-intl/server';

export async function generateLocalizedAuditChanges<T>(
  before: T | null,
  after: T | null,
  options: {
    include?: string[];
    locale?: Locale;
  } = {}
): Promise<AuditChange[]> {
  const locale = options.locale || 'zh-TW';
  const t = await getTranslations({ locale, namespace: 'audit' });
  
  // 產生多語言的稽核變更記錄
  return changes.map(change => ({
    ...change,
    fieldDisplayName: t(`fields.${change.fieldPath}`),
    oldValueDisplay: formatAuditValue(change.oldValue, locale),
    newValueDisplay: formatAuditValue(change.newValue, locale),
  }));
}
```

### 10.2 稽核歷史表格

```typescript
// src/components/audit/audit-history-table.tsx
import { useTranslations } from 'next-intl';

export function AuditHistoryTable({ events, locale }: AuditHistoryTableProps) {
  const t = useTranslations('audit');
  
  return (
    <table>
      <thead>
        <tr>
          <th>{t('columns.timestamp')}</th>
          <th>{t('columns.actor')}</th>
          <th>{t('columns.action')}</th>
          <th>{t('columns.changes')}</th>
        </tr>
      </thead>
      <tbody>
        {events.map(event => (
          <tr key={event.id}>
            <td>{formatDate(event.createdAt, locale)}</td>
            <td>{event.actorName}</td>
            <td>{t(`actions.${event.action}`)}</td>
            <td>
              {event.changes.map(change => (
                <div key={change.id}>
                  {t(`fields.${change.fieldPath}`)}: 
                  {change.oldValueDisplay} → {change.newValueDisplay}
                </div>
              ))}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
```

---

## 11. 測試策略 / Testing Strategy

### 11.1 國際化測試

```typescript
// tests/i18n/translation-coverage.test.ts
import { describe, it, expect } from 'vitest';
import { extractTranslationKeys } from '@/scripts/extract-i18n-keys';
import zhTW from '@/locales/zh-TW/common.json';
import zhCN from '@/locales/zh-CN/common.json';
import enUS from '@/locales/en-US/common.json';

describe('Translation Coverage', () => {
  it('should have all required translations', async () => {
    const usedKeys = await extractTranslationKeys();
    const availableKeys = Object.keys(flattenObject(zhTW));
    
    const missingKeys = usedKeys.filter(key => !availableKeys.includes(key));
    expect(missingKeys).toEqual([]);
  });

  it('should have consistent keys across all locales', () => {
    const zhTWKeys = Object.keys(flattenObject(zhTW));
    const zhCNKeys = Object.keys(flattenObject(zhCN));
    const enUSKeys = Object.keys(flattenObject(enUS));
    
    expect(zhCNKeys).toEqual(zhTWKeys);
    expect(enUSKeys).toEqual(zhTWKeys);
  });
});
```

### 11.2 格式化測試

```typescript
// tests/i18n/formatting.test.ts
describe('Formatting Utils', () => {
  it('should format currency correctly for different locales', () => {
    expect(formatCurrency(1000000, 'TWD', 'zh-TW')).toBe('NT$1,000,000');
    expect(formatCurrency(1000000, 'USD', 'en-US')).toBe('$1,000,000.00');
  });

  it('should format dates correctly for different locales', () => {
    const date = new Date('2025-12-31');
    expect(formatDate(date, 'zh-TW')).toBe('2025-12-31');
    expect(formatDate(date, 'en-US')).toBe('12/31/2025');
  });
});
```

---

## 12. 部署與維護 / Deployment & Maintenance

### 12.1 翻譯工作流程

1. **開發階段**：開發者使用翻譯鍵，先以繁體中文建立基準翻譯
2. **翻譯階段**：產品/在地化人員補齊其他語言翻譯
3. **審核階段**：各語言母語者審核翻譯品質
4. **部署階段**：翻譯檔案與程式碼一同版本控制和部署

### 12.2 翻譯品質保證

```typescript
// scripts/validate-translations.ts
export function validateTranslations() {
  // 檢查翻譯完整性
  // 檢查參數一致性 (如 {treatyCode})
  // 檢查字符長度限制
  // 檢查特殊字符使用
}
```

### 12.3 CI/CD 整合

```yaml
# .github/workflows/i18n-validation.yml
name: i18n Validation
on: [push, pull_request]

jobs:
  validate-translations:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run i18n:extract
      - run: npm run i18n:validate
      - run: npm run test:i18n
```

---

## 13. 效能考量 / Performance Considerations

### 13.1 翻譯檔案分割

```typescript
// 按模組分割翻譯檔案，支援動態載入
const translations = {
  common: () => import(`@/locales/${locale}/common.json`),
  treaty: () => import(`@/locales/${locale}/treaty.json`),
  reinsurer: () => import(`@/locales/${locale}/reinsurer.json`),
  // ...
};
```

### 13.2 快取策略

```typescript
// src/lib/i18n-cache.ts
const translationCache = new Map<string, any>();

export async function getCachedTranslations(
  locale: Locale,
  namespace: string
) {
  const cacheKey = `${locale}:${namespace}`;
  
  if (!translationCache.has(cacheKey)) {
    const translations = await import(`@/locales/${locale}/${namespace}.json`);
    translationCache.set(cacheKey, translations.default);
  }
  
  return translationCache.get(cacheKey);
}
```

---

## 14. 實作階段規劃 / Implementation Phases

### Phase 1: 基礎架構（Sprint 3）
- [ ] 安裝和配置 next-intl
- [ ] 建立語言路由結構
- [ ] 創建基礎翻譯檔案
- [ ] 實作語言切換器
- [ ] 更新現有頁面支援國際化

### Phase 2: 核心模組國際化（Sprint 3-4）
- [ ] Treaty Management 模組完整國際化
- [ ] Reinsurer Management 模組完整國際化
- [ ] 錯誤訊息和驗證訊息國際化
- [ ] 稽核事件多語言支援

### Phase 3: 進階功能（Sprint 4-5）
- [ ] 格式化工具完善
- [ ] 用戶語言偏好設定
- [ ] 郵件模板國際化
- [ ] 報表輸出多語言支援

### Phase 4: 品質保證（Sprint 5）
- [ ] 翻譯覆蓋率測試
- [ ] UI伸展性測試
- [ ] 效能優化
- [ ] 文檔完善

---

## 15. 風險與緩解 / Risks & Mitigations

| 風險 | 影響 | 緩解策略 |
|------|------|----------|
| 翻譯品質不一致 | 用戶體驗差 | 建立翻譯審核流程，母語者校對 |
| UI版面在某些語言下破版 | 功能不可用 | 實作響應式測試，預留足夠空間 |
| 翻譯檔案過大影響載入 | 效能問題 | 按模組分割，實作動態載入 |
| 日期/貨幣格式錯誤 | 業務邏輯錯誤 | 建立格式化測試，使用標準Intl API |
| 翻譯鍵管理混亂 | 維護困難 | 建立命名規範，自動化檢查工具 |

---

## 16. 後續工作 / Next Steps

1. **立即行動**：
   - 安裝 next-intl 依賴
   - 建立基礎翻譯檔案結構
   - 更新 [`src/app/layout.tsx`](code/ri-app/src/app/layout.tsx) 支援語言路由

2. **Sprint 3 目標**：
   - 完成現有Treaty和Reinsurer模組的國際化
   - 建立翻譯工作流程
   - 實作語言切換功能

3. **長期規劃**：
   - 建立翻譯管理平台整合
   - 實作A/B測試支援不同語言版本
   - 考慮RTL語言支援（阿拉伯語等）

---

## 17. 參考資料 / References

- PRD 第3.4節：全球化與多語系支援
- Next.js 14 Internationalization Guide
- next-intl Documentation
- Unicode CLDR (Common Locale Data Repository)
- W3C Internationalization Best Practices

---

## 18. 附錄：翻譯檔案範本 / Appendix: Translation Templates

### 18.1 英文翻譯範本

```json
// locales/en-US/treaty.json
{
  "list": {
    "title": "Treaty Management",
    "subtitle": "Manage reinsurance treaties and related terms",
    "createButton": "Create Treaty",
    "filterTitle": "Filter Criteria"
  },
  "form": {
    "basicInfo": "Basic Information",
    "treatyCode": "Treaty Code",
    "treatyName": "Treaty Name",
    "treatyType": "Treaty Type",
    "lineOfBusiness": "Line of Business",
    "effectiveDate": "Effective Date",
    "expiryDate": "Expiry Date"
  },
  "validation": {
    "treatyCodeRequired": "Treaty code is required",
    "treatyNameRequired": "Treaty name is required",
    "dateRangeInvalid": "Expiry date cannot be earlier than effective date",
    "shareExceeds100": "Total reinsurer shares cannot exceed 100%"
  }
}
```

### 18.2 簡體中文翻譯範本

```json
// locales/zh-CN/treaty.json
{
  "list": {
    "title": "合约管理",
    "subtitle": "管理再保险合约与相关条款",
    "createButton": "创建合约",
    "filterTitle": "筛选条件"
  },
  "form": {
    "basicInfo": "基本资料",
    "treatyCode": "合约代号",
    "treatyName": "合约名称",
    "treatyType": "合约类型",
    "lineOfBusiness": "险种别",
    "effectiveDate": "生效日期",
    "expiryDate": "终止日期"
  }
}
```

---

## 19. 緊急重構計劃 / Emergency Refactoring Plan

### 19.1 立即行動（今天）
- [x] 識別所有硬編碼語言判斷（35個位置）
- [x] 創建 RI-9-8 重構計劃文檔
- [ ] 重構 P0 組件（審計歷史表格）

### 19.2 本週目標
- [ ] 創建完整的翻譯檔案結構
- [ ] 重構所有硬編碼判斷邏輯
- [ ] 建立型別安全的翻譯系統
- [ ] 完成測試驗證

### 19.3 技術債務追蹤
**債務等級**：🔴 Critical
**影響範圍**：整個國際化系統
**修復時程**：5-8天
**負責團隊**：前端開發團隊

---

## 20. 修訂記錄 / Revision History

| 版本 | 日期 | 修訂內容 | 作者 |
|------|------|----------|------|
| v1.0 | 2025-11-05 | 初始國際化策略設計 | Architecture Team |
| v1.1 | 2025-11-05 | **緊急更新**：識別硬編碼問題，制定重構計劃 | Tao Yu 和他的 GPT 智能助手 |

---

> **⚠️ 緊急通知**：本 ADR 識別出嚴重的技術債務問題。當前的硬編碼語言判斷方式完全不可擴展，必須立即重構。請參考 RI-9-8 重構計劃文檔執行修復工作。重構完成前，暫停新增任何包含硬編碼語言判斷的功能。