# 國際化實作指南 / Internationalization Implementation Guide

本文檔說明再保系統的多語言支援實作，基於 [ADR-008 國際化策略](architecture/ADR-008-internationalization-strategy.md)。

> **實作狀態**：✅ 基礎架構已完成，使用 Next.js 16 原生方案（非 next-intl）
> **技術債務**：⚠️ 存在 35 個硬編碼位置需重構，詳見 [RI-9-8 重構計劃](RI-9-8-i18n-refactoring-plan.md)

## 🌐 支援的語言

- **繁體中文 (zh-TW)** - 預設語言
- **簡體中文 (zh-CN)**
- **英文 (en-US)**

## 📁 檔案結構

```
locales/
├── zh-TW/
│   ├── common.json      # 通用翻譯
│   ├── treaty.json      # 合約模組
│   └── reinsurer.json   # 再保人模組
├── zh-CN/
│   └── [同上結構]
└── en-US/
    └── [同上結構]

src/
├── lib/
│   ├── i18n.ts          # 國際化配置
│   ├── locale-utils.ts  # 語言工具函數
│   └── format-utils.ts  # 格式化工具
├── components/
│   ├── ui/
│   │   └── language-switcher.tsx  # 語言切換器
│   └── providers/
│       └── locale-provider.tsx    # 語言提供者
└── app/
    └── [locale]/        # 語言特定路由
        ├── layout.tsx
        ├── page.tsx
        ├── treaties/
        └── reinsurers/
```

## 🔧 使用方法

### 1. 在伺服器元件中使用翻譯

```typescript
import { loadTranslations, createTranslator } from '@/lib/locale-utils';
import { type Locale } from '@/lib/i18n';

export default async function MyPage({ params: { locale } }: { params: { locale: Locale } }) {
  // 載入翻譯（使用增強的翻譯載入器）
  const commonTranslations = await loadTranslations(locale, 'common');
  const moduleTranslations = await loadTranslations(locale, 'mymodule');
  const t = createTranslator({ ...commonTranslations, ...moduleTranslations });

  return (
    <div>
      <h1>{t('list.title')}</h1>
      <p>{t('list.subtitle', { count: 10 })}</p>
    </div>
  );
}
```

**實際範例**（基於現有實作）：
```typescript
// src/app/[locale]/treaties/page.tsx
import { loadTranslations, createTranslator } from '@/lib/locale-utils';

export default async function TreatiesPage({ params: { locale } }) {
  const translations = await loadTranslations(locale, 'treaty');
  const t = createTranslator(translations);

  return (
    <PageContainer>
      <PageHeader
        title={t('list.title')}
        subtitle={t('list.subtitle')}
      />
      {/* ... */}
    </PageContainer>
  );
}
```

### 2. 在客戶端元件中使用

```typescript
'use client';

import { useTranslations } from '@/hooks/use-translations';

export function MyClientComponent() {
  const { t, loading, error } = useTranslations('common');

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error loading translations</div>;

  return <button>{t('actions.save')}</button>;
}
```

**實際範例**（基於現有實作）：
```typescript
// src/components/ui/language-switcher.tsx
'use client';

import { useLocale } from '@/components/providers/locale-provider';
import { locales, localeConfig } from '@/lib/i18n';

export function LanguageSwitcher() {
  const locale = useLocale();
  
  return (
    <select value={locale} onChange={handleChange}>
      {locales.map((loc) => (
        <option key={loc} value={loc}>
          {localeConfig[loc].flag} {localeConfig[loc].name}
        </option>
      ))}
    </select>
  );
}
```

### 3. 格式化數字和日期

```typescript
import { formatCurrency, formatDate, formatPercentage } from '@/lib/format-utils';

// 格式化貨幣
const amount = formatCurrency(1000000, 'TWD', locale); // "NT$1,000,000"

// 格式化日期
const date = formatDate(new Date(), locale); // "2025-11-05" (zh-TW) 或 "11/05/2025" (en-US)

// 格式化百分比
const percent = formatPercentage(50, locale); // "50.00%"
```

### 4. 語言切換

```typescript
import { LanguageSwitcher } from '@/components/ui/language-switcher';

export function MyComponent() {
  return (
    <div>
      <LanguageSwitcher />
    </div>
  );
}
```

## 📝 翻譯鍵命名規範

採用階層式命名，格式：`<section>.<subsection>.<key>`

```json
{
  "list": {
    "title": "標題",
    "subtitle": "副標題",
    "noData": "無資料"
  },
  "form": {
    "fieldName": "欄位名稱",
    "placeholder": "提示文字"
  },
  "messages": {
    "success": "成功訊息",
    "error": "錯誤訊息"
  },
  "validation": {
    "required": "必填欄位",
    "invalid": "格式錯誤"
  }
}
```

## 🧪 測試

### 執行國際化測試

```bash
npm run test:i18n
```

### 驗證翻譯完整性

```bash
npm run i18n:validate
```

### 提取翻譯鍵

```bash
npm run i18n:extract
```

## 📋 開發檢查清單

### 新增翻譯時
- [ ] 在所有支援的語言中添加翻譯
- [ ] 使用一致的參數名稱（如 `{count}`, `{name}`）
- [ ] 確保翻譯長度適合UI版面
- [ ] 執行 `npm run i18n:validate` 檢查

### 新增頁面時
- [ ] 在 `app/[locale]/` 下建立頁面
- [ ] 使用 `loadTranslations` 載入翻譯
- [ ] 所有硬編碼文字都使用翻譯鍵
- [ ] 連結使用語言特定路徑 `/${locale}/path`

### 新增元件時
- [ ] 客戶端元件使用 `useLocale()` 獲取語言
- [ ] 伺服器元件接收 `locale` 參數
- [ ] 格式化使用 `format-utils.ts` 函數
- [ ] 預留30%文字伸展空間

## ⚠️ 注意事項

1. **路由結構**：所有頁面都必須在 `app/[locale]/` 下
2. **翻譯載入**：伺服器元件使用 `loadTranslations`，客戶端元件使用動態 import
3. **參數替換**：使用 `{paramName}` 格式，避免使用 `%s` 或其他格式
4. **版面適應**：英文通常比中文長30-50%，需要預留空間
5. **日期格式**：不同語言有不同的日期格式偏好

## 🔄 技術債務與改進計劃

### 當前問題
- **硬編碼語言判斷**：35 個位置存在 `locale === 'en-US' ? ... : ...` 模式
- **不可擴展**：每增加語言需修改所有組件
- **維護困難**：翻譯散佈在多個位置

### 重構計劃
詳見 [RI-9-8 國際化重構計劃](RI-9-8-i18n-refactoring-plan.md)：
1. **Phase 1**：創建完整翻譯檔案結構
2. **Phase 2**：重構所有硬編碼判斷
3. **Phase 3**：建立型別安全的翻譯系統

### 未來升級路徑
當 next-intl 支援 Next.js 16 後，可考慮遷移：
1. 保持現有翻譯檔案結構
2. 漸進式替換自建 Hook
3. 利用 next-intl 的進階功能

## 📚 參考資料

- [ADR-008 國際化策略](architecture/ADR-008-internationalization-strategy.md) - 架構決策記錄
- [RI-9-8 重構計劃](RI-9-8-i18n-refactoring-plan.md) - 硬編碼問題解決方案
- [RI-9-6 Next.js 16 兼容性分析](RI-9-6-nextjs16-i18n-compatibility-analysis.md) - 技術選型分析
- [開發手冊](RI-8-1-developer-handbook.md) - 國際化開發規範
- [Next.js 國際化文檔](https://nextjs.org/docs/app/building-your-application/routing/internationalization)

---

## 🔄 文檔維護

| 版本 | 日期 | 修訂內容 | 作者 |
|------|------|----------|------|
| v2.0 | 2025-11-06 | **重大更新**：移動到正確位置、更新實際實作內容、移除過時的 next-intl 引用 | Tao Yu 和他的 GPT 智能助手 |
| v1.0 | 2025-11-05 | 初版國際化實作指南 | Tao Yu 和他的 GPT 智能助手 |