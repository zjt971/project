# 再保系統任務追蹤板 / Reinsurance System Task Tracker

> 依據最新專案計畫 (`PM-PLAN-001-專案計劃.md`) 與 Scrum 計畫 (`PM-PLAN-002-Sprint計劃.md`) 拆解之可執行任務清單。採狀態圖示 `✅` 完成、`🔄` 進行中、`⏳` 未開始；優先級以 `🔴` 高、`🟡` 中、`🟢` 低 表示。任務進度百分比依實際完成度估算，不再揭露固定日曆日期。

---

## 使用說明 / Usage Notes
- 任務命名：`RI-<模組縮寫>-<序號>`；若沿用歷史任務則保持原代號（如 `RI-1-1`）。
- 每項任務皆列出交付物（完成時提供實際連結；未開始則描述預期產出）。
- 完成度統計僅計入一次性任務；持續維運項目獨立紀錄且不列入百分比。

### 進度摘要 / Progress Snapshot
- 一次性任務總數：21
- ✅ 完成：13 ｜ 🔄 進行中：1 ｜ ⏳ 未開始：7
- 專案整體完成度：約 **62%** （13 / 21）
- 相關持續維運事項：4 項（另行追蹤）

---

## Sprint S0：啟動與治理基線（已完成）
- ✅ 🔴 `RI-1-1` 完成 Kickoff 議程與資料準備（進度：100%）  
  - 📦 交付物：[PM-PREP-001-啟動準備.md](PM-PREP-001-啟動準備.md)
- ✅ 🔴 `RI-1-2` 召集核心干係人並完成 Kickoff 會議（進度：100%）  
  - 📦 交付物：[PM-MEETING-001-啟動會議紀錄.md](PM-MEETING-001-啟動會議紀錄.md)
- ✅ 🟡 `RI-3-1` 建立 Markdown 任務/文件結構（進度：100%）  
  - 📦 交付物：[../07-文檔管理/DOC-GUIDE-001-Markdown指南.md](../07-文檔管理/DOC-GUIDE-001-Markdown指南.md)
- ✅ 🟡 `RI-3-2` 建立 Markdown 維運流程（進度：100%）  
  - 📦 交付物：[../07-文檔管理/DOC-PROCESS-001-Markdown維運流程.md](../07-文檔管理/DOC-PROCESS-001-Markdown維運流程.md)

---

## Sprint S1：規格與設計基線（已完成）
- ✅ 🔴 `RI-1-3` 草擬並發布專案章程（進度：100%）  
  - 📦 交付物：[PM-CHARTER-001-專案章程.md](PM-CHARTER-001-專案章程.md)
- ✅ 🔴 `RI-1-4` 蒐集 Squad 目標與風險（進度：100%）  
  - 📦 交付物：[PM-PLAN-003-團隊目標與風險.md](PM-PLAN-003-團隊目標與風險.md)
- ✅ 🟡 `RI-2-1` 建立干係人清單與溝通偏好（進度：100%）  
  - 📦 交付物：[PM-STAKEHOLDER-001-利益相關者清單.md](PM-STAKEHOLDER-001-利益相關者清單.md)
- ✅ 🟡 `RI-2-2` 完成溝通矩陣審核與公告（進度：100%）  
  - 📦 交付物：[PM-COMM-001-溝通矩陣.md](PM-COMM-001-溝通矩陣.md)

---

## Sprint S2：平台骨架與核心模組 POC（已完成）
- ✅ 🔴 `RI-PL-1` 完成平台 App Shell、導航與流體版面優化（進度：100%）
  - 📦 交付物：[code/ri-app/src/components/layout/app-shell.tsx](code/ri-app/src/components/layout/app-shell.tsx)、[code/ri-app/src/components/layout/page-container.tsx](code/ri-app/src/components/layout/page-container.tsx)
- ✅ 🔴 `RI-TR-1` 建立合約管理 CRUD POC（進度：100%）
  - 📦 交付物：[code/ri-app/src/app/treaties/](code/ri-app/src/app/treaties/)、[code/ri-app/src/actions/treaty-actions.ts](code/ri-app/src/actions/treaty-actions.ts)
- ✅ 🔴 `RI-RI-1` 建立再保人管理 CRUD POC（進度：100%）
  - 📦 交付物：[code/ri-app/src/app/reinsurers/](code/ri-app/src/app/reinsurers/)、[code/ri-app/src/actions/reinsurer-actions.ts](code/ri-app/src/actions/reinsurer-actions.ts)
- ✅ 🔴 `RI-VER-1` 實作 Vercel 部署功能（進度：100%）
  - 📦 交付物：[code/ri-app/vercel.json](code/ri-app/vercel.json)、[scripts/deploy-vercel.sh](code/ri-app/scripts/deploy-vercel.sh)、[src/app/api/health/route.ts](code/ri-app/src/app/api/health/route.ts)
- ✅ 🔴 `RI-ENV-1` 建立雙環境架構（SQLite + PostgreSQL）（進度：100%）
  - 📦 交付物：[src/config/environment.ts](code/ri-app/src/config/environment.ts)、[src/config/database.ts](code/ri-app/src/config/database.ts)、雙 Schema 檔案
- ✅ 🔴 `RI-I18N-1` 實作國際化基礎架構（進度：100%）
  - 📦 交付物：[locales/](code/ri-app/locales/) 翻譯檔案、語言路由、翻譯 Hook
- 🔄 🟡 `RI-PL-3` 釐清並記錄 Server Action 實作守則（進度：80%）
  - 📦 交付物（進行中）：已更新 [../03-開發指南/DEV-GUIDE-001-開發人員手冊.md](../03-開發指南/DEV-GUIDE-001-開發人員手冊.md)，待補齊範例說明
- ⏳ 🟡 `RI-PL-2` 建立 UI 視覺回歸測試策略（進度：0%）
  - 📦 預計交付：Playwright/Chromatic 測試計畫與腳本範例

---

## Backlog（S3 之後）
- ⏳ 🔴 `RI-FA-1` 臨分流程與資料模型設計（進度：0%）  
  - 📦 預計交付：臨分架構 ADR、資料字典草案
- ⏳ 🔴 `RI-FA-2` 臨分模組開發與測試（進度：0%）  
  - 📦 預計交付：[code/ri-app/src/app/facultative/](code/ri-app/src/app/facultative/)（新建）、對應整合測試
- ⏳ 🔴 `RI-CE-1` 分保計算引擎規則設計（進度：0%）  
  - 📦 預計交付：分保規則庫、試算介面契約
- ⏳ 🔴 `RI-CE-2` 實作分保計算引擎與試算 API（進度：0%）  
  - 📦 預計交付：[code/ri-app/src/services/cession-engine/](code/ri-app/src/services/cession-engine/)（新建）、自動化計算測試
- ⏳ 🟡 `RI-AS-1` 分入再保流程定義與資料展開（進度：0%）  
  - 📦 預計交付：分入再保流程圖、FRD 更新
- ⏳ 🟡 `RI-CL-1` 理賠攤回流程設計與原型（進度：0%）  
  - 📦 預計交付：理賠攤回 UX Flow、結算介面契約
- ⏳ 🟡 `RI-SOA-1` SoA/IFRS17 報表設計與資料映射（進度：0%）  
  - 📦 預計交付：報表需求文件、資料映射表

---

## 持續維運 / Continuous Items（不列入完成度計算）
- 🔄 🔴 `RI-CONT-1` Backlog Refinement 會議與紀錄維護（進度：持續）  
  - 📦 持續輸出：會議結論摘要（儲存於 `PM-COMM-001-溝通矩陣.md` 附錄）
- 🔄 🔴 `RI-CONT-2` PI Sync 依賴與風險盤點（進度：持續）  
  - 📦 持續輸出：風險/依賴更新（記錄於 `PM-RISK-001-風險登錄.md`）
- 🔄 🟡 `RI-CONT-3` 開發手冊與 ADR 維護（進度：持續）  
  - 📦 持續輸出：[../03-開發指南/DEV-GUIDE-001-開發人員手冊.md](../03-開發指南/DEV-GUIDE-001-開發人員手冊.md)、`../02-架構設計/ARCH-ADR-*.md`
- 🔄 🟡 `RI-CONT-4` 本檔案例行更新（進度：持續）  
  - 📦 持續輸出：`PM-REPORT-001-任務追蹤.md` 版本記錄（以 Git Log 為準）

---

> 文件維護人：Scrum Master 與 Tao Yu 和他的 GPT 智能助手；如需新增任務，請同時更新專案計畫與 Scrum 計畫兩份文件以維持一致性。
