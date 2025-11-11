# DOC-STD-001: Documentation Standards and Structure / 文檔標準與結構規範

## Document Information / 文檔資訊
- **Document ID / 文檔編號**: DOC-STD-001
- **Version / 版本**: v1.0
- **Status / 狀態**: Draft for Review
- **Author / 作者**: Tao Yu 和他的 GPT 智能助手
- **Created Date / 建立日期**: 2025-11-06
- **Last Updated / 最後更新**: 2025-11-06

---

## 1. Executive Summary / 執行摘要

This document establishes unified documentation standards and structure for the reinsurance system project, addressing current issues with inconsistent numbering, scattered organization, and mixed language support.

本文檔為再保險系統專案建立統一的文檔標準和結構，解決當前編號不一致、組織分散和語言支援混合的問題。

---

## 2. Current Issues Analysis / 當前問題分析

### 2.1 Numbering Inconsistencies / 編號不一致

**Current Problems / 當前問題**:
- Mixed numbering formats: RI-X-Y, RI-XXX-Y, ADR-XXX / 混合編號格式
- No clear categorization system / 無明確分類系統
- Inconsistent with task tracker references / 與任務追蹤器引用不一致

**Examples / 範例**:
- `RI-1-1-kickoff-minutes.md` (project phase format / 專案階段格式)
- `RI-FAC-1-implementation-summary.md` (module format / 模組格式)
- `environment-setup-guide.md` (no numbering / 無編號)

### 2.2 Directory Structure Issues / 目錄結構問題

**Current Problems / 當前問題**:
- 40+ files in root docs directory / 根 docs 目錄中有 40+ 檔案
- No logical categorization / 無邏輯分類
- Difficult to navigate and maintain / 難以導航和維護

### 2.3 Content Duplication / 內容重複

**Overlapping Documents / 重疊文檔**:
- Project progress tracking in 4 different documents / 專案進度追蹤分散在 4 個不同文檔中
- Implementation details scattered across multiple files / 實施細節分散在多個檔案中

---

## 3. New Documentation Standards / 新文檔標準

### 3.1 Numbering Convention / 編號約定

**Format / 格式**: `[CATEGORY]-[TYPE]-[NUMBER]`

**Category Codes / 類別代碼**:

| Category / 類別 | Code / 代碼 | Description / 描述 | Examples / 範例 |
|-----------------|-------------|-------------------|-----------------|
| Project Management / 專案管理 | PM | Project plans, governance / 專案計劃、治理 | PM-PLAN-001, PM-CHARTER-001 |
| Architecture / 架構 | ARCH | Architecture decisions / 架構決策 | ARCH-ADR-001, ARCH-DESIGN-001 |
| Development / 開發 | DEV | Development guides / 開發指南 | DEV-GUIDE-001, DEV-STD-001 |
| Operations / 運維 | OPS | Deployment, monitoring / 部署、監控 | OPS-DEPLOY-001, OPS-MONITOR-001 |
| Business / 業務 | BIZ | Business processes / 業務流程 | BIZ-PROCESS-001, BIZ-GUIDE-001 |
| Quality / 品質 | QA | Testing, quality assurance / 測試、品質保證 | QA-TEST-001, QA-STRATEGY-001 |
| Documentation / 文檔 | DOC | Documentation standards / 文檔標準 | DOC-STD-001, DOC-TEMPLATE-001 |

**Type Codes / 類型代碼**:

| Type / 類型 | Code / 代碼 | Description / 描述 |
|-------------|-------------|-------------------|
| Architecture Decision Record | ADR | Technical decisions / 技術決策 |
| Standard / 標準 | STD | Standards and guidelines / 標準和指南 |
| Guide / 指南 | GUIDE | How-to guides / 操作指南 |
| Plan / 計劃 | PLAN | Project plans / 專案計劃 |
| Charter / 章程 | CHARTER | Project charters / 專案章程 |
| Process / 流程 | PROCESS | Business processes / 業務流程 |
| Template / 模板 | TEMPLATE | Document templates / 文檔模板 |
| Report / 報告 | REPORT | Status reports / 狀態報告 |

### 3.2 File Naming Convention / 檔案命名約定

**Format / 格式**: `[CATEGORY]-[TYPE]-[NUMBER]-[中文標題].md`

**Examples / 範例**:
- `PM-PLAN-001-專案計劃.md`
- `ARCH-ADR-001-分層架構.md`
- `DEV-GUIDE-001-開發人員手冊.md`
- `OPS-DEPLOY-001-Vercel部署指南.md`

---

## 4. Proposed Directory Structure / 建議目錄結構

```
docs/
├── README.md                                    # Main project documentation
├── 01-專案管理/                                 # Project Management
│   ├── PM-CHARTER-001-專案章程.md              # Project Charter
│   ├── PM-PLAN-001-專案計劃.md                 # Consolidated Project Plan
│   ├── PM-PLAN-002-Sprint計劃.md               # Sprint Plan
│   └── PM-REPORT-001-任務追蹤.md               # Task Tracker
├── 02-架構設計/                                 # Architecture
│   ├── ARCH-ADR-001-分層架構.md                # Layered Architecture
│   ├── ARCH-ADR-002-資料庫策略.md              # Database Strategy
│   ├── ARCH-ADR-003-React查詢策略.md           # React Query Strategy
│   ├── ARCH-ADR-004-測試策略.md                # Testing Strategy
│   ├── ARCH-ADR-005-稽核軌跡.md                # Audit Trail
│   ├── ARCH-ADR-006-Git分支策略.md             # Git Branching Strategy
│   ├── ARCH-ADR-007-模組架構模式.md            # Module Architecture Pattern
│   └── ARCH-ADR-008-國際化策略.md              # Internationalization Strategy
├── 03-開發指南/                                 # Development
│   ├── DEV-GUIDE-001-開發人員手冊.md           # Developer Handbook
│   ├── DEV-GUIDE-002-環境設置指南.md           # Environment Setup Guide
│   ├── DEV-GUIDE-003-環境快速開始.md           # Environment Quick Start
│   ├── DEV-GUIDE-004-應用開發指南.md           # App Development Guide
│   └── DEV-STD-001-編碼標準.md                 # Coding Standards
├── 04-運維部署/                                 # Operations
│   ├── OPS-DEPLOY-001-Vercel部署指南.md        # Vercel Deployment Guide
│   ├── OPS-MONITOR-001-健康監控.md             # Health Monitoring
│   └── OPS-GUIDE-001-維護指南.md               # Maintenance Guide
├── 05-業務流程/                                 # Business Processes
│   ├── BIZ-PROCESS-001-合約管理流程.md         # Treaty Management Process
│   ├── BIZ-PROCESS-002-臨分管理流程.md         # Facultative Management Process
│   └── BIZ-GUIDE-001-用戶手冊.md               # User Manual
├── 06-品質保證/                                 # Quality Assurance
│   ├── QA-STRATEGY-001-測試策略.md             # Testing Strategy
│   ├── QA-CHECKLIST-001-環境檢查清單.md        # Environment Checklist
│   └── QA-REPORT-001-實施總結.md               # Implementation Summary
├── 07-文檔管理/                                 # Documentation Management
│   ├── DOC-STD-001-文檔標準與結構規範.md       # Documentation Standards (this file)
│   ├── DOC-TEMPLATE-001-文檔模板標準.md        # Document Templates
│   └── DOC-GUIDE-001-Markdown指南.md           # Markdown Guidelines
├── 08-用戶界面/                                 # User Interface
│   └── UI-GUIDE-001-界面設計指南.md            # UI Design Guidelines
└── 99-歷史歸檔/                                 # Historical Archive
    ├── LEGACY-重組計劃.md                      # Reorganization Plan (archived)
    └── LEGACY-文檔重組總結.md                  # Documentation Summary (archived)
```

---

## 5. Document Consolidation Plan / 文檔整合計劃

### 5.1 Project Progress Documents / 專案進度文檔

**Problem / 問題**: Multiple overlapping documents tracking project progress
多個重疊的專案進度追蹤文檔

**Solution / 解決方案**: Consolidate into single source of truth
整合為單一真實來源

| Current Documents / 當前文檔 | New Document / 新文檔 | Action / 行動 |
|------------------------------|----------------------|---------------|
| `reinsurance-system-task-tracker.md` | `PM-REPORT-001-任務追蹤.md` | Rename and enhance / 重命名和增強 |
| `reinsurance-system-project-plan.md` | `PM-PLAN-001-專案計劃.md` | Consolidate with roadmap / 與路線圖整合 |
| `reinsurance-system-scrum-plan.md` | `PM-PLAN-002-Sprint計劃.md` | Simplify and focus / 簡化和聚焦 |
| `RI-9-1-implementation-roadmap.md` | **Merge into PM-PLAN-001** | Consolidate detailed roadmap / 整合詳細路線圖 |

### 5.2 Architecture Documents / 架構文檔

**Action / 行動**: Move to `02-架構設計/` with standardized naming
移動到 `02-架構設計/` 並標準化命名

### 5.3 Development Documents / 開發文檔

**Action / 行動**: Consolidate under `03-開發指南/`
整合到 `03-開發指南/` 下

---

## 6. Bilingual Content Standards / 雙語內容標準

### 6.1 Language Strategy / 語言策略

1. **Headers / 標頭**: Always bilingual format `English / 中文`
2. **Technical Content / 技術內容**: English primary, Chinese translation
3. **Business Content / 業務內容**: Chinese primary, English translation
4. **Code Examples / 代碼範例**: English comments with Chinese explanations
5. **Tables / 表格**: Bilingual headers, content in appropriate language

### 6.2 Translation Guidelines / 翻譯指南

- **Consistency / 一致性**: Use consistent terminology across documents / 在文檔間使用一致的術語
- **Clarity / 清晰度**: Prioritize clarity over literal translation / 優先考慮清晰度而非字面翻譯
- **Technical Terms / 技術術語**: Keep English terms with Chinese explanation / 保留英文術語並提供中文解釋
- **Cultural Adaptation / 文化適應**: Adapt examples to local context / 將範例適應本地語境

---

## 7. Reference Management / 引用管理

### 7.1 Internal References / 內部引用

**Format / 格式**: `[Document Title](./category/document-name.md)`

**Examples / 範例**:
- `[Project Plan](./01-專案管理/PM-PLAN-001-專案計劃.md)`
- `[Developer Handbook](./03-開發指南/DEV-GUIDE-001-開發人員手冊.md)`

### 7.2 External References / 外部引用

**To requirement directory / 對 requirement 目錄**:
- Format / 格式: `[Requirement Title](../requirement/document-name.md)`
- Example / 範例: `[Product Requirements](../requirement/EIS-REINS-PRD-001.md)`

### 7.3 Cross-References / 交叉引用

- Always use relative paths / 始終使用相對路徑
- Include document ID in link text when appropriate / 適當時在連結文字中包含文檔 ID
- Update all references when documents are moved / 移動文檔時更新所有引用

---

## 8. Implementation Priority / 實施優先級

### 8.1 Phase 1: Critical Structure (Week 1) / 階段1：關鍵結構（第1週）

**High Priority / 高優先級**:
1. Create directory structure / 創建目錄結構
2. Consolidate project progress documents / 整合專案進度文檔
3. Standardize architecture documents / 標準化架構文檔
4. Update main README / 更新主 README

### 8.2 Phase 2: Content Standardization (Week 2) / 階段2：內容標準化（第2週）

**Medium Priority / 中優先級**:
1. Apply standard headers to all documents / 為所有文檔應用標準標頭
2. Convert existing documents to bilingual format / 將現有文檔轉換為雙語格式
3. Update all internal references / 更新所有內部引用
4. Standardize development guides / 標準化開發指南

### 8.3 Phase 3: Quality Assurance (Week 3) / 階段3：品質保證（第3週）

**Lower Priority / 較低優先級**:
1. Validate all links and references / 驗證所有連結和引用
2. Review bilingual content consistency / 審查雙語內容一致性
3. Archive obsolete documents / 歸檔過時文檔
4. Create maintenance procedures / 創建維護程序

---

## 9. Document Migration Mapping / 文檔遷移映射

### 9.1 Project Management Documents / 專案管理文檔

| Current File / 當前檔案 | New File / 新檔案 | Action / 行動 |
|-------------------------|-------------------|---------------|
| `RI-1-3-project-charter.md` | `01-專案管理/PM-CHARTER-001-專案章程.md` | Move and standardize |
| `reinsurance-system-project-plan.md` | `01-專案管理/PM-PLAN-001-專案計劃.md` | Consolidate with roadmap |
| `reinsurance-system-scrum-plan.md` | `01-專案管理/PM-PLAN-002-Sprint計劃.md` | Move and simplify |
| `reinsurance-system-task-tracker.md` | `01-專案管理/PM-REPORT-001-任務追蹤.md` | Move and enhance |
| `RI-9-1-implementation-roadmap.md` | **Merge into PM-PLAN-001** | Consolidate content |

### 9.2 Architecture Documents / 架構文檔

| Current File / 當前檔案 | New File / 新檔案 | Action / 行動 |
|-------------------------|-------------------|---------------|
| `architecture/ADR-001-layered-architecture.md` | `02-架構設計/ARCH-ADR-001-分層架構.md` | Move and standardize |
| `architecture/ADR-002-database-strategy.md` | `02-架構設計/ARCH-ADR-002-資料庫策略.md` | Move and standardize |
| `architecture/ADR-003-react-query-strategy.md` | `02-架構設計/ARCH-ADR-003-React查詢策略.md` | Move and standardize |
| `architecture/ADR-004-testing-strategy.md` | `02-架構設計/ARCH-ADR-004-測試策略.md` | Move and standardize |
| `architecture/ADR-005-audit-trail.md` | `02-架構設計/ARCH-ADR-005-稽核軌跡.md` | Move and standardize |
| `architecture/ADR-006-git-branching-strategy.md` | `02-架構設計/ARCH-ADR-006-Git分支策略.md` | Move and standardize |
| `architecture/ADR-007-module-architecture-pattern.md` | `02-架構設計/ARCH-ADR-007-模組架構模式.md` | Move and standardize |
| `architecture/ADR-008-internationalization-strategy.md` | `02-架構設計/ARCH-ADR-008-國際化策略.md` | Move and standardize |

### 9.3 Development Documents / 開發文檔

| Current File / 當前檔案 | New File / 新檔案 | Action / 行動 |
|-------------------------|-------------------|---------------|
| `RI-8-1-developer-handbook.md` | `03-開發指南/DEV-GUIDE-001-開發人員手冊.md` | Move and enhance |
| `environment-setup-guide.md` | `03-開發指南/DEV-GUIDE-002-環境設置指南.md` | Move and standardize |
| `environment-quick-start.md` | `03-開發指南/DEV-GUIDE-003-環境快速開始.md` | Move and standardize |
| `ri-app-development-guide.md` | `03-開發指南/DEV-GUIDE-004-應用開發指南.md` | Move and standardize |
| `internationalization-implementation-guide.md` | `03-開發指南/DEV-GUIDE-005-國際化實施指南.md` | Move and standardize |

### 9.4 Operations Documents / 運維文檔

| Current File / 當前檔案 | New File / 新檔案 | Action / 行動 |
|-------------------------|-------------------|---------------|
| `vercel-deployment-guide.md` | `04-運維部署/OPS-DEPLOY-001-Vercel部署指南.md` | Move and enhance |
| `vercel-deployment.md` | `04-運維部署/OPS-DEPLOY-002-Vercel部署配置.md` | Move and standardize |
| `git-branching-strategy.md` | `04-運維部署/OPS-PROCESS-001-Git分支流程.md` | Move and standardize |

### 9.5 Quality Documents / 品質文檔

| Current File / 當前檔案 | New File / 新檔案 | Action / 行動 |
|-------------------------|-------------------|---------------|
| `environment-checklist.md` | `06-品質保證/QA-CHECKLIST-001-環境檢查清單.md` | Move and standardize |
| `RI-FAC-1-implementation-summary.md` | `06-品質保證/QA-REPORT-001-臨分實施總結.md` | Move and standardize |

### 9.6 UI/UX Documents / 用戶界面文檔

| Current File / 當前檔案 | New File / 新檔案 | Action / 行動 |
|-------------------------|-------------------|---------------|
| `uiux/uiux-guidelines.md` | `08-用戶界面/UI-GUIDE-001-界面設計指南.md` | Move and standardize |

---

## 10. Content Standardization Requirements / 內容標準化要求

### 10.1 Mandatory Elements / 必需元素

All documents must include / 所有文檔必須包含:
1. **Standard header with metadata / 標準標頭和元數據**
2. **Bilingual title and section headers / 雙語標題和章節標頭**
3. **Executive summary / 執行摘要**
4. **Revision history table / 修訂記錄表**
5. **Maintenance information / 維護資訊**

### 10.2 Content Quality Standards / 內容品質標準

- **Accuracy / 準確性**: All information must be current and correct / 所有資訊必須是最新和正確的
- **Completeness / 完整性**: Cover all necessary aspects of the topic / 涵蓋主題的所有必要方面
- **Clarity / 清晰度**: Use clear, concise language / 使用清晰、簡潔的語言
- **Consistency / 一致性**: Follow established terminology and style / 遵循既定的術語和風格

---

## 11. Reference Update Strategy / 引用更新策略

### 11.1 Internal Reference Updates / 內部引用更新

**Process / 流程**:
1. Identify all documents with internal references / 識別所有有內部引用的文檔
2. Map old paths to new paths / 將舊路徑映射到新路徑
3. Update references systematically / 系統性地更新引用
4. Validate all links work correctly / 驗證所有連結正常工作

### 11.2 External Reference Management / 外部引用管理

**To requirement directory / 對 requirement 目錄**:
- Maintain relative path format / 保持相對路徑格式
- Update path when docs structure changes / 當 docs 結構變更時更新路徑
- Example / 範例: `../requirement/EIS-REINS-PRD-001.md`

---

## 12. Success Metrics / 成功指標

### 12.1 Structural Metrics / 結構指標
- [ ] 100% of documents follow naming convention / 100% 文檔遵循命名約定
- [ ] All documents in appropriate categories / 所有文檔在適當類別中
- [ ] No duplicate content / 無重複內容
- [ ] Clear navigation structure / 清晰的導航結構

### 12.2 Content Metrics / 內容指標
- [ ] 100% bilingual content / 100% 雙語內容
- [ ] All documents have standard headers / 所有文檔有標準標頭
- [ ] All internal references functional / 所有內部引用有效
- [ ] Consistent terminology usage / 一致的術語使用

### 12.3 Maintenance Metrics / 維護指標
- [ ] Clear ownership assigned / 明確分配所有權
- [ ] Regular review schedule established / 建立定期審查計劃
- [ ] Update process documented / 更新流程已記錄

---

## Revision History / 修訂記錄

| Version / 版本 | Date / 日期 | Changes / 變更內容 | Author / 作者 |
|----------------|-------------|-------------------|---------------|
| v1.0 | 2025-11-06 | Initial documentation standards with Chinese filename convention and comprehensive migration plan / 初版文檔標準，採用中文檔案名約定和全面遷移計劃 | Tao Yu 和他的 GPT 智能助手 |

---

> **Maintenance / 維護**: Documentation Team / 文檔團隊  
> **Review Cycle / 審查週期**: Monthly / 每月  
> **Next Review / 下次審查**: 2025-12-06