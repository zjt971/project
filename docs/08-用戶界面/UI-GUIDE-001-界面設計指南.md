# 再保系統 UI/UX 導則 v0.4（Responsive First）

> 本指南以 Figma 產出的 PDF/JSON（`requirement/导出pdf json`）與 `requirement/uiux_規範_v_0_3_（以_figma_為準，next.md)` 為基礎，並調整為符合實際瀏覽器寬度的自適應做法。規則適用於所有開發與 AI 代碼生成，若 Figma 更新，請先同步 Token 與本文，再更新程式碼。

---

## 1. Design Tokens

| 類別 | Token | 值 | 說明 |
|------|-------|------|------|
| Page 背景 | `--color-page` | `#F6F8FB` | 全域底色 |
| Surface | `--color-surface` | `#FFFFFF` | 卡片 / 表單底色 |
| Surface Muted | `--color-surface-muted` | `#F3F9FF` | 區塊提示底色 |
| 分隔線 | `--color-border` | `#E3E3E3` | 邊界與表格線 |
| 輕量邊框 | `--color-border-soft` | `#D9D9D9` | 輸入框邊框 |
| 主要文字 | `--color-text-primary` | `#222222` | 主標題、列表內容 |
| 次要文字 | `--color-text-secondary` | `#595959` | 標籤、說明文字 |
| 第三級文字 | `--color-text-tertiary` | `#777474` | 麵包屑、meta |
| Disabled 文字 | `--color-text-disabled` | `#BFBEBE` | 非互動狀態 |
| 品牌色 | `--color-brand` | `#1677FF` | 主要按鈕、強調 |
| 品牌 Hover | `--color-brand-hover` | `#1458CC` | 互動狀態 |
| Danger | `--color-danger` | `#F03A3C` | 錯誤、必填標示 |
| On Brand | `--color-on-brand` | `#FFFFFF` | 品牌按鈕文字 |
| 陰影（卡片） | `--shadow-card` | `0 1px 2px rgba(15,23,42,0.08)` | 卡片陰影 |
| 陰影（浮層） | `--shadow-overlay` | `0 10px 24px rgba(15,23,42,0.18)` | Dialog/Toast |
| 欄位寬度基準 | `--field-width` | `272px` | 單欄表單最小寬度 |

字體：`"PingFang TC", "Inter", system-ui, -apple-system`。字級：頁面標題 `text-2xl`, 區塊標題 `text-sm font-semibold`, 標籤 `text-sm`, 麵包屑 `text-xs`。

> Tailwind 透過 `globals.css` 定義以上 CSS 變數，並在 `tailwind.config.ts` 的 `extend` 區塊映射到 `colors`、`boxShadow`、`spacing`、`borderRadius` 等，以便在元件中直接引用。

---

## 2. 版型與容器

- **AppShell**：固定 Header (`64px`) 與 Sidebar (`208px`)，內容區背景使用 `--color-page`。
- **PageContainer**：提供一致的 gutter 與縱向間距，類別為 `flex w-full flex-col gap-6 px-4 sm:px-6 lg:px-10`。不再限制最大寬度，確保內容能隨瀏覽器寬度自適應；若未來需限制超寬螢幕，可額外在頁面層加入 `max-w-screen-2xl`。此流體佈局規則已同步記錄於 `../02-架構設計/ARCH-ADR-001-分層架構.md`，PR 需同時引用兩份文件。
- **內容區塊**：所有卡片、表格、表單外層一律 `w-full`，與容器保持同樣寬度，避免出現「中間一塊」的視覺落差。
- **欄位排列**：表單預設使用 `FormGrid columns="three"`（`<640px` 單欄、`≥768px` 兩欄、`≥1280px` 三欄），配合 `md:col-span-*` 讓每列補滿欄位，避免出現單獨欄位；確實需要更多欄位時再調整為 `columns="four"` 或自訂配置。`FormField` 預設 `w-full min-w-[var(--field-width)]`，不再另設 `max-width` 以維持一致寬度。
- **反例參考**：以下情況視為違規（Review 時需退回修正）：
  - 表單欄位未補滿整行，造成上下錯列。
  - 內容區塊另設 `max-w-*` 導致縮成中間一塊。
  - 各欄位手動設定不同寬度或使用 Figma 中的固定像素寬度。

---

## 3. 共用元件

| 元件 | 檔案 | 對應規則 | 備註 |
|------|------|-----------|------|
| `FormGrid` | `src/components/ui/form-grid.tsx` | 統一表單欄位排版：`grid w-full gap-4`，預設值為 `columns="three"`（1 → 2 → 3 欄 RWD），遇到需要合併欄位時以 `md:col-span-*` 調整；篩選列或指標面板若有 4 個以上欄位，再改用 `columns="four"`。| 範例：「合約新增」篩選區 §4.2；違規：「欄位寬度不一致」 |
| `AppShell` | `src/components/layout/app-shell.tsx` | 包含 `SideNavigation` 與 `TopNavbar`，`main` 僅負責背景與垂直間距。| Sidebar 高度固定，內容區請勿自行加入 padding |
| `PageContainer` | `src/components/layout/page-container.tsx` | 提供統一的水平留白與縱向間距；頁面包覆內容即可自適應。| 不得在頁面額外套 `max-w` 破壞容器寬度 |
| `PageHeader` | `src/components/ui/page-header.tsx` | 麵包屑 + 標題 + 操作鈕。按鈕使用 `Button` variants（primary / secondary / outline）。| 需傳入 `breadcrumbs` 才可顯示麵包屑 |
| `ListCard` | `src/components/ui/list-card.tsx` | 通用卡片容器 `w-full rounded-md bg-surface shadow-card px-6 py-6`。| 表格、篩選區都使用此容器 |
| `SectionCard` | `src/components/ui/section-card.tsx` | 表單/段落專用卡片。若有標題/描述即自動產生 `header`，內容區以 `px-6 py-6` 呈現。| 請避免在頁面自行建立 Card 樣式 |
| `FormField` | `src/components/ui/form-field.tsx` | Label + Field + Hint 齊備，支援 `flex-1` 排版。必填星號採 `--color-danger`。| 錯誤訊息與提示統一顯示於欄位底部 |
| `Button` | `src/components/ui/button.tsx` | variant：`primary`（品牌底）、`secondary`（白底灰框）、`outline`（白底藍框）、`ghost`。高度一律 `py-[5px] px-4 rounded-sm`。| 同一區塊按鈕尺寸需一致，勿自訂 padding |
| `Alert` | `src/components/ui/alert.tsx` | 三種狀態（info/success/error），卡片式呈現。| 用於表單錯誤、成功訊息 |

所有頁面務必優先使用以上元件；如需新增模式，先擴充元件再回頭修改頁面。

---

## 4. Page Patterns

### 4.1 Page Header
- 麵包屑與標題置於 `PageHeader`，遵循 `bg-surface + shadow-card`。
- 右側操作鈕遵循「次要 → 主要」順序，並可視頁面加上 Outline variant。

### 4.2 篩選 / 列表頁
1. `PageHeader` → `ListCard` (篩選列) → `ListCard` (資料表) 依序排列。
2. 篩選卡片內依欄位數決定 `FormGrid columns`，原則是讓每列湊滿欄位（例如 3 個篩選條件使用 `columns="three"`）；按鈕區獨立放在底部靠右，避免打斷欄位對齊。
3. 表格使用 `ListCard` + `<table>`，表頭 `bg-[#F6F8FB] text-secondary`、資料列 `border-b border-[#E3E3E3]`。

### 4.3 表單 / 詳情頁
1. `PageHeader` 提供麵包屑與操作鈕。
2. 表單段落使用 `SectionCard` + `FormGrid columns="three"`；善用 `md:col-span-*` 讓每行補滿欄位並維持上下對齊，如需寬欄位再調整為跨欄或切換欄數設定。
3. 操作按鈕統一放在頁面底部，使用 `secondary + outline + primary` 三段式配置。

---

## 5. 互動、驗證與無障礙
- Focus ring：`focus-visible:outline outline-2 outline-offset-2 outline-[var(--color-brand)]`。
- 必填欄位顯示紅色星號；錯誤訊息 `text-[var(--color-danger)]`，並搭配 Toast。
- Toast / Dialog 皆使用 `shadow-overlay`，底色白、內容齊左。
- 鍵盤操作需完整（Tab、Enter、Esc）。頁面導航後自動聚焦主標題，確保螢幕閱讀器容易追蹤。

---

## 6. 實作流程
1. 取得最新 Figma PDF/JSON → 確認 Token、間距是否有變動。
2. 若有新 Token，先更新 `globals.css` 與 `tailwind.config.ts`，再更新本文。
3. 新頁面先組合 `PageContainer` + 既有元件，若現有元件不支援需要，再擴充元件。禁止於頁面直接硬寫樣式破壞一致性。
4. 變更完成後：`npm run test:unit` + 手動截圖對比 Figma。
5. PR 描述需引用本文章節，例如「依 UI 指南 §4.2 篩選列排版」。

---

## 7. 參考
- `requirement/导出pdf json/1-1-再保人管理.*`
- `requirement/导出pdf json/1-2-再保人管理-新增再保人.*`
- `requirement/导出pdf json/2-1-合約管理.*`
- `requirement/导出pdf json/2-2-合約管理-新增合約.*`
- `requirement/uiux_規範_v_0_3_（以_figma_為準，next.md)`
- `requirement/reinsurance_uiux_codepack_v0.3`

> 若 Figma 更新，請依「實作流程」同步 Token → 本文件 → 元件 → 頁面 → 測試。
