# Documentation Standards and Structure / 文檔標準與結構規範

## Document Information / 文檔資訊
- **Document ID / 文檔編號**: DOC-STD-001
- **Version / 版本**: v1.0
- **Status / 狀態**: Draft for Review
- **Author / 作者**: Tao Yu 和他的 GPT 智能助手
- **Created Date / 建立日期**: 2025-11-06
- **Last Updated / 最後更新**: 2025-11-06

---

## 1. Documentation Numbering Standards / 文檔編號標準

### 1.1 Numbering Convention / 編號約定

All documentation follows a hierarchical numbering system: / 所有文檔遵循階層編號系統：

```
<CATEGORY>-<TYPE>-<NUMBER>
```

### 1.2 Category Codes / 類別代碼

| Category / 類別 | Code / 代碼 | Description / 描述 | Examples / 範例 |
|-----------------|-------------|-------------------|-----------------|
| Project Management / 專案管理 | PM | Project plans, charters, governance / 專案計劃、章程、治理 | PM-PLAN-001, PM-CHARTER-001 |
| Architecture / 架構 | ARCH | Architecture decisions, technical design / 架構決策、技術設計 | ARCH-ADR-001, ARCH-DESIGN-001 |
| Development / 開發 | DEV | Development guides, standards / 開發指南、標準 | DEV-GUIDE-001, DEV-STD-001 |
| Operations / 運維 | OPS | Deployment, monitoring, maintenance / 部署、監控、維護 | OPS-DEPLOY-001, OPS-MONITOR-001 |
| Business / 業務 | BIZ | Business processes, user guides / 業務流程、用戶指南 | BIZ-PROCESS-001, BIZ-GUIDE-001 |
| Quality / 品質 | QA | Testing, quality assurance / 測試、品質保證 | QA-TEST-001, QA-STRATEGY-001 |
| Documentation / 文檔 | DOC | Documentation standards, templates / 文檔標準、模板 | DOC-STD-001, DOC-TEMPLATE-001 |

### 1.3 Type Codes / 類型代碼

| Type / 類型 | Code / 代碼 | Description / 描述 |
|-------------|-------------|-------------------|
| Architecture Decision Record | ADR | Technical architecture decisions / 技術架構決策 |
| Standard / 標準 | STD | Standards and guidelines / 標準和指南 |
| Guide / 指南 | GUIDE | How-to guides and tutorials / 操作指南和教程 |
| Plan / 計劃 | PLAN | Project and implementation plans / 專案和實施計劃 |
| Charter / 章程 | CHARTER | Project charters and governance / 專案章程和治理 |
| Process / 流程 | PROCESS | Business and technical processes / 業務和技術流程 |
| Template / 模板 | TEMPLATE | Document templates / 文檔模板 |
| Report / 報告 | REPORT | Status reports and summaries / 狀態報告和總結 |
| Strategy / 策略 | STRATEGY | Strategic documents / 策略文檔 |

---

## 2. Directory Structure / 目錄結構

### 2.1 Proposed Structure / 建議結構

```
docs/
├── README.md                                    # Main project documentation
├── 01-project-management/                      # 專案管理
│   ├── PM-CHARTER-001-project-charter.md      # 專案章程
│   ├── PM-PLAN-001-project-plan.md            # 專案計劃
│   ├── PM-PLAN-002-sprint-plan.md             # Sprint 計劃
│   ├── PM-REPORT-001-task-tracker.md          # 任務追蹤
│   └── PM-STRATEGY-001-implementation-roadmap.md # 實施路線圖
├── 02-architecture/                            # 架構設計
│   ├── ARCH-ADR-001-layered-architecture.md   # 分層架構
│   ├── ARCH-ADR-002-database-strategy.md      # 資料庫策略
│   ├── ARCH-ADR-003-react-query-strategy.md   # React Query 策略
│   ├── ARCH-ADR-004-testing-strategy.md       # 測試策略
│   ├── ARCH-ADR-005-audit-trail.md            # 稽核軌跡
│   ├── ARCH-ADR-006-git-branching-strategy.md # Git 分支策略
│   ├── ARCH-ADR-007-module-architecture-pattern.md # 模組架構模式
│   └── ARCH-ADR-008-internationalization-strategy.md # 國際化策略
├── 03-development/                             # 開發指南
│   ├── DEV-GUIDE-001-developer-handbook.md    # 開發人員手冊
│   ├── DEV-GUIDE-002-environment-setup.md     # 環境設置指南
│   ├── DEV-GUIDE-003-environment-quickstart.md # 環境快速開始
│   ├── DEV-STD-001-coding-standards.md        # 編碼標準
│   └── DEV-TEMPLATE-001-module-template.md    # 模組開發模板
├── 04-operations/                              # 運維部署
│   ├── OPS-DEPLOY-001-vercel-deployment.md    # Vercel 部署指南
│   ├── OPS-MONITOR-001-health-monitoring.md   # 健康監控
│   └── OPS-GUIDE-001-maintenance.md           # 維護指南
├── 05-business/                                # 業務文檔
│   ├── BIZ-PROCESS-001-treaty-management.md   # 合約管理流程
│   ├── BIZ-PROCESS-002-facultative-management.md # 臨分管理流程
│   └── BIZ-GUIDE-001-user-manual.md           # 用戶手冊
├── 06-quality/                                 # 品質保證
│   ├── QA-STRATEGY-001-testing-strategy.md    # 測試策略
│   ├── QA-CHECKLIST-001-environment-checklist.md # 環境檢查清單
│   └── QA-REPORT-001-implementation-summary.md # 實施總結
├── 07-documentation/                           # 文檔管理
│   ├── DOC-STD-001-documentation-standards.md # 文檔標準（本檔案）
│   ├── DOC-TEMPLATE-001-document-template.md  # 文檔模板
│   └── DOC-GUIDE-001-markdown-guidelines.md   # Markdown 指南
└── 99-archive/                                 # 歸檔文檔
    ├── legacy-reorganization-plan.md          # 重組計劃（歸檔）
    └── legacy-documentation-summary.md        # 文檔總結（歸檔）
```

### 2.2 Directory Naming Rules / 目錄命名規則

- Use numbered prefixes for logical ordering / 使用數字前綴進行邏輯排序
- Use kebab-case for directory names / 目錄名稱使用 kebab-case
- Keep directory names concise but descriptive / 保持目錄名稱簡潔但具描述性

---

## 3. Document Template Standards / 文檔模板標準

### 3.1 Standard Document Header / 標準文檔標頭

```markdown
# [Document Title] / [文檔標題]

## Document Information / 文檔資訊
- **Document ID / 文檔編號**: [CATEGORY]-[TYPE]-[NUMBER]
- **Version / 版本**: v[X.Y]
- **Status / 狀態**: [Draft/Review/Approved/Archived]
- **Author / 作者**: [Author Name]
- **Created Date / 建立日期**: YYYY-MM-DD
- **Last Updated / 最後更新**: YYYY-MM-DD
- **Related Documents / 相關文檔**: [Links to related docs]

---

## 1. Executive Summary / 執行摘要
[Brief overview in both languages]

## 2. [Main Content Sections]
[Content organized in logical sections]

---

## Revision History / 修訂記錄

| Version / 版本 | Date / 日期 | Changes / 變更內容 | Author / 作者 |
|----------------|-------------|-------------------|---------------|
| v1.0 | YYYY-MM-DD | Initial version / 初版 | [Author] |

---

> **Maintenance / 維護**: [Responsible person/team]
```

### 3.2 Bilingual Content Guidelines / 雙語內容指南

1. **Title Format / 標題格式**: `English Title / 中文標題`
2. **Section Headers / 章節標頭**: Use bilingual format for all major sections / 所有主要章節使用雙語格式
3. **Content Strategy / 內容策略**:
   - Technical content: English first, Chinese translation / 技術內容：英文優先，中文翻譯
   - Business content: Chinese first, English translation / 業務內容：中文優先，英文翻譯
   - Tables: Bilingual headers, content in primary language / 表格：雙語標頭，內容使用主要語言

---

## 4. Document Categories and Consolidation / 文檔分類與整合

### 4.1 Project Progress Documents Consolidation / 專案進度文檔整合

**Current Issues / 當前問題**:
- Multiple overlapping documents tracking project progress / 多個重疊的專案進度追蹤文檔
- Inconsistent information across documents / 文檔間資訊不一致
- Difficult to maintain synchronization / 難以維持同步

**Proposed Solution / 建議解決方案**:

| Current Documents / 當前文檔 | New Document / 新文檔 | Action / 行動 |
|------------------------------|----------------------|---------------|
| `reinsurance-system-task-tracker.md` | `PM-REPORT-001-task-tracker.md` | Rename and restructure / 重命名和重構 |
| `reinsurance-system-project-plan.md` | `PM-PLAN-001-project-plan.md` | Rename and consolidate / 重命名和整合 |
| `reinsurance-system-scrum-plan.md` | `PM-PLAN-002-sprint-plan.md` | Rename and simplify / 重命名和簡化 |
| `RI-9-1-implementation-roadmap.md` | **Merge into PM-PLAN-001** | Consolidate detailed roadmap / 整合詳細路線圖 |

### 4.2 Architecture Documents / 架構文檔

**Action**: Move to `02-architecture/` with new naming / 移動到 `02-architecture/` 並重新命名

### 4.3 Development Documents / 開發文檔

**Action**: Consolidate under `03-development/` / 整合到 `03-development/` 下

---

## 5. Reference Management / 引用管理

### 5.1 Internal References / 內部引用

- Use relative paths from docs root / 使用從 docs 根目錄的相對路徑
- Format: `[Document Title](./category/document-name.md)` / 格式
- Update all references when documents are moved / 移動文檔時更新所有引用

### 5.2 External References / 外部引用

- References to `requirement/` directory should use relative paths / 對 `requirement/` 目錄的引用應使用相對路徑
- Format: `[Requirement Title](../requirement/document-name.md)` / 格式
- Maintain clear separation between docs and requirements / 保持文檔和需求的清晰分離

---

## 6. Document Lifecycle / 文檔生命週期

### 6.1 Document States / 文檔狀態

| Status / 狀態 | Description / 描述 | Next Action / 下一步行動 |
|---------------|-------------------|-------------------------|
| Draft / 草稿 | Initial creation, work in progress / 初始創建，進行中 | Review / 審查 |
| Review / 審查中 | Under review by stakeholders / 利益相關者審查中 | Approval or revision / 批准或修訂 |
| Approved / 已批准 | Approved and active / 已批准並生效 | Maintenance / 維護 |
| Archived / 已歸檔 | No longer active, kept for reference / 不再活躍，保留供參考 | None / 無 |

### 6.2 Version Control / 版本控制

- Use semantic versioning: v[Major].[Minor] / 使用語義版本控制
- Major version for significant restructuring / 重大重構使用主版本號
- Minor version for content updates / 內容更新使用次版本號

---

## 7. Implementation Plan / 實施計劃

### 7.1 Phase 1: Structure Reorganization / 階段1：結構重組
1. Create new directory structure / 創建新目錄結構
2. Move and rename existing documents / 移動和重命名現有文檔
3. Update internal references / 更新內部引用

### 7.2 Phase 2: Content Standardization / 階段2：內容標準化
1. Apply standard headers to all documents / 為所有文檔應用標準標頭
2. Convert to bilingual format / 轉換為雙語格式
3. Consolidate overlapping documents / 整合重疊文檔

### 7.3 Phase 3: Quality Assurance / 階段3：品質保證
1. Validate all references / 驗證所有引用
2. Check bilingual consistency / 檢查雙語一致性
3. Verify document completeness / 驗證文檔完整性

---

## 8. Document Templates / 文檔模板

### 8.1 Standard Document Template / 標準文檔模板

```markdown
# [Document Title] / [文檔標題]

## Document Information / 文檔資訊
- **Document ID / 文檔編號**: [ID]
- **Version / 版本**: v[X.Y]
- **Status / 狀態**: [Status]
- **Author / 作者**: [Author]
- **Created Date / 建立日期**: YYYY-MM-DD
- **Last Updated / 最後更新**: YYYY-MM-DD
- **Related Documents / 相關文檔**: [Links]

---

## 1. Executive Summary / 執行摘要
[Brief overview in both languages]

## 2. [Content Sections]
[Main content organized logically]

---

## Revision History / 修訂記錄
| Version | Date | Changes | Author |
|---------|------|---------|--------|
| v1.0 | YYYY-MM-DD | Initial version | [Author] |

---

> **Maintenance / 維護**: [Responsible person/team]
```

### 8.2 ADR Template / ADR 模板

```markdown
# ARCH-ADR-[NUMBER]: [Decision Title] / [決策標題]

## Document Information / 文檔資訊
- **Document ID / 文檔編號**: ARCH-ADR-[NUMBER]
- **Status / 狀態**: [Proposed/Accepted/Deprecated]
- **Date / 日期**: YYYY-MM-DD
- **Decision Makers / 決策者**: [Names]

---

## Context / 背景
[Describe the situation and problem]

## Decision / 決策
[Describe the decision made]

## Rationale / 理由
[Explain why this decision was made]

## Consequences / 後果
[Describe the positive and negative consequences]

## Alternatives Considered / 考慮的替代方案
[List other options that were considered]

---

## Implementation / 實施
[How to implement this decision]

## Compliance / 合規性
[How to ensure compliance with this decision]
```

---

## 9. Quality Standards / 品質標準

### 9.1 Content Quality / 內容品質
- All documents must be bilingual / 所有文檔必須是雙語的
- Use clear, concise language / 使用清晰、簡潔的語言
- Include relevant examples and diagrams / 包含相關範例和圖表
- Maintain consistent terminology / 保持術語一致性

### 9.2 Technical Quality / 技術品質
- All links must be functional / 所有連結必須有效
- Use proper Markdown syntax / 使用正確的 Markdown 語法
- Include proper metadata / 包含適當的元數據
- Follow naming conventions / 遵循命名約定

---

## 10. Maintenance Guidelines / 維護指南

### 10.1 Regular Reviews / 定期審查
- Monthly review of document accuracy / 每月審查文檔準確性
- Quarterly review of structure and organization / 每季審查結構和組織
- Annual review of standards and templates / 年度審查標準和模板

### 10.2 Update Process / 更新流程
1. Identify need for update / 識別更新需求
2. Create draft revision / 創建草稿修訂
3. Review with stakeholders / 與利益相關者審查
4. Approve and publish / 批准並發布
5. Update related documents / 更新相關文檔

---

## 11. Migration Plan / 遷移計劃

### 11.1 Document Mapping / 文檔映射

| Current Document / 當前文檔 | New Document / 新文檔 | Action / 行動 |
|------------------------------|----------------------|---------------|
| `RI-1-3-project-charter.md` | `01-project-management/PM-CHARTER-001-project-charter.md` | Move and standardize |
| `reinsurance-system-project-plan.md` | `01-project-management/PM-PLAN-001-project-plan.md` | Move and consolidate |
| `reinsurance-system-scrum-plan.md` | `01-project-management/PM-PLAN-002-sprint-plan.md` | Move and simplify |
| `reinsurance-system-task-tracker.md` | `01-project-management/PM-REPORT-001-task-tracker.md` | Move and restructure |
| `RI-9-1-implementation-roadmap.md` | **Merge into PM-PLAN-001** | Consolidate |
| `RI-8-1-developer-handbook.md` | `03-development/DEV-GUIDE-001-developer-handbook.md` | Move and enhance |
| `environment-setup-guide.md` | `03-development/DEV-GUIDE-002-environment-setup.md` | Move and standardize |
| `vercel-deployment-guide.md` | `04-operations/OPS-DEPLOY-001-vercel-deployment.md` | Move and enhance |

### 11.2 Implementation Steps / 實施步驟

1. **Create directory structure / 創建目錄結構**
2. **Move and rename documents / 移動和重命名文檔**
3. **Apply standard headers / 應用標準標頭**
4. **Update all references / 更新所有引用**
5. **Consolidate overlapping content / 整合重疊內容**
6. **Convert to bilingual format / 轉換為雙語格式**
7. **Validate and test / 驗證和測試**

---

## 12. Success Criteria / 成功標準

### 12.1 Structural Goals / 結構目標
- [x] Consistent numbering across all documents / 所有文檔編號一致
- [x] Logical directory organization / 邏輯目錄組織
- [x] No duplicate or overlapping content / 無重複或重疊內容
- [x] Clear document hierarchy / 清晰的文檔層次結構

### 12.2 Content Goals / 內容目標
- [x] All documents bilingual / 所有文檔雙語
- [x] Standard headers and metadata / 標準標頭和元數據
- [x] Functional internal references / 有效的內部引用
- [x] Consistent terminology / 一致的術語

### 12.3 Maintenance Goals / 維護目標
- [x] Clear ownership and responsibility / 清晰的所有權和責任
- [x] Regular review process / 定期審查流程
- [x] Version control integration / 版本控制整合

---

## Revision History / 修訂記錄

| Version / 版本 | Date / 日期 | Changes / 變更內容 | Author / 作者 |
|----------------|-------------|-------------------|---------------|
| v1.0 | 2025-11-06 | Initial documentation standards and structure specification / 初版文檔標準和結構規範 | Tao Yu 和他的 GPT 智能助手 |

---

> **Maintenance / 維護**: Documentation Team / 文檔團隊  
> **Review Cycle / 審查週期**: Quarterly / 每季度  
> **Next Review / 下次審查**: 2026-02-06