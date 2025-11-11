# ADR-003：React Query 與伺服器狀態管理策略

- **狀態**：提案中（待 Architecture Review 核可）
- **日期**：2025-09-12
- **決策者**：Product Engineering Lead、Frontend Lead、Architecture Board

---

## 1. 背景

再保系統前端需同時處理伺服器狀態（Server State）、多 API 整合、背景同步以及使用者體驗最佳化。純 Server Components 雖能處理首屏資料，但在互動頁面（合約維護、臨分試算、SoA 對帳等）仍需客戶端快取與錯誤處理能力。TanStack Query（React Query）可提供成熟的伺服器狀態管理配套，因此選擇與 Server Actions 搭配使用。

---

## 2. 決策

- 以 React Query 作為唯一的伺服器狀態管理工具，取代自建 hook 或 Redux。
- 所有資料請求仍以 Server Actions / Next.js Route Handler 為入口，React Query 負責客戶端 cache。
- 由 `src/app/providers.tsx` 注入 QueryClient 與 Devtools，遵循 `ADR-001` 的分層規則。

---

## 3. 整合模式

### 3.1 讀取資料（Queries）
```typescript
// src/hooks/use-treaty.ts
import { useQuery } from "@tanstack/react-query";
import { getTreatyDetail } from "@/actions/treaty-actions";
import { queryKeys } from "@/lib/query-keys";

export function useTreaty(treatyId: string) {
  return useQuery({
    queryKey: queryKeys.treaty(treatyId),
    queryFn: () => getTreatyDetail(treatyId),
    staleTime: 5 * 60 * 1000,
  });
}
```

### 3.2 寫入資料（Mutations）
```typescript
// src/hooks/use-update-treaty.ts
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { updateTreaty } from "@/actions/treaty-actions";
import { queryKeys } from "@/lib/query-keys";

export function useUpdateTreaty() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: updateTreaty,
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({
        queryKey: queryKeys.treaty(variables.id),
      });
    },
  });
}
```

### 3.3 查詢鍵集中管理
```typescript
// src/lib/query-keys.ts
export const queryKeys = {
  treaties: ["treaties"] as const,
  treaty: (id: string) => ["treaties", id] as const,
  facultatives: ["facultatives"] as const,
  soa: (period: string) => ["soa", period] as const,
};
```

### 3.4 提供器與設定
`Providers` 元件（`src/app/providers.tsx`）負責建立 QueryClient，設定重試策略、staleTime，以及掛載 React Query Devtools 以協助除錯。

---

## 4. 最佳實踐

1. **統一 Query Key**：所有查詢鍵必須在 `query-keys.ts` 定義，避免命名衝突。
2. **錯誤處理**：Mutation 須處理錯誤回傳並顯示 Toast，並回傳錯誤碼供 Actions 分流。
3. **樂觀更新**：針對 UI 重要操作（合約即時調整、臨分試算），使用 React Query 樂觀更新並提供回滾。
4. **背景同步**：啟用 `refetchOnWindowFocus` 或自定義 refetch 以確保資料新鮮。
5. **批次操作**：大體量資料（批次匯入、對帳）採用 infinite query；與 Server Actions 協作實作分頁。

---

## 5. 測試策略

- **Unit**：使用 Vitest + React Testing Library 測試 hook 的狀態與快取。
- **Integration**：使用 MSW 模擬 Server Action 回傳，驗證 invalidation / 樂觀更新。
- **E2E**：Playwright 覆蓋主要使用者流程，觀察快取行為與 UI 呈現。

---

## 6. 風險與緩解

| 風險 | 說明 | 緩解策略 |
|---|---|---|
| 重複快取鍵造成資料混淆 | Query Key 未統一管理 | 強制透過 `query-keys.ts` 匯出；PR Review 檢查 |
| Server Actions 的錯誤未正確冒泡 | Mutation 未處理錯誤格式 | 規範 Actions 回傳 `Result` 物件；hook 中實作錯誤轉換 |
| 大量並發更新導致資料過期 | Mutation 未適時失效 cache | 使用 `invalidateQueries`、`refetchQueries`，必要時搭配 Webhook 推送 |

---

## 7. 後續工作

- 建立共用 `useMutationWithToast`、`useInvalidateTreaty` 等輔助 hook。
- 在 `Providers` 中導入 React Query Devtools 時依環境決定是否顯示。
- 擴展 ADR-004 測試策略時，加入 React Query 專用測試樣板。
