# DOC-ACTION-001: Reference Fixing Action Plan / 引用修復行動計劃

## Document Information / 文檔資訊
- **Document ID / 文檔編號**: DOC-ACTION-001
- **Version / 版本**: v1.0
- **Status / 狀態**: Active
- **Author / 作者**: Tao Yu 和他的 GPT 智能助手
- **Created Date / 建立日期**: 2025-11-06
- **Last Updated / 最後更新**: 2025-11-06
- **Related Documents / 相關文檔**: [DOC-REPORT-001](./DOC-REPORT-001-文檔重組完成報告.md)

---

## 1. Executive Summary / 執行摘要

This action plan addresses the remaining reference fixes needed after the documentation reorganization. While the structural reorganization is complete, approximately 20% of internal references still need to be updated to reflect the new directory structure.

本行動計劃解決文檔重組後剩餘的引用修復需求。雖然結構重組已完成，但仍有約20%的內部引用需要更新以反映新的目錄結構。

---

## 2. Current Reference Status / 當前引用狀態

### 2.1 Completed Fixes / 已完成修復

**High Priority Documents / 高優先級文檔**:
- ✅ Main README.md - All navigation links updated / 主README.md - 所有導航連結已更新
- ✅ PM-REPORT-001-任務追蹤.md - Critical project references fixed / 關鍵專案引用已修復
- ✅ DEV-GUIDE-001-開發人員手冊.md - Architecture and guide references updated / 架構和指南引用已更新
- ✅ PM-PLAN-001-專案計劃.md - Key project plan references fixed / 關鍵專案計劃引用已修復
- ✅ PM-PLAN-002-Sprint計劃.md - Sprint management references updated / Sprint管理引用已更新

### 2.2 Remaining Issues / 剩餘問題

**Identified Patterns / 識別的模式**:
1. **RI/docs/ prefixed references / RI/docs/前綴引用**: ~15 instances remaining / 約15個實例剩餘
2. **Cross-category references / 跨類別引用**: ~10 instances need relative path updates / 約10個實例需要相對路徑更新
3. **Architecture internal references / 架構內部引用**: ~8 instances in ADR documents / ADR文檔中約8個實例
4. **Legacy path references / 舊路徑引用**: ~5 instances in older documents / 舊文檔中約5個實例

---

## 3. Systematic Fix Plan / 系統修復計劃

### 3.1 Phase 1: Critical References (Priority 1) / 階段1：關鍵引用（優先級1）

**Target Documents / 目標文檔**:
- PM-COMM-001-溝通矩陣.md (table references / 表格引用)
- PM-RISK-002-風險審查節奏.md (risk register references / 風險登錄引用)
- PM-ACTION-001-行動項目.md (meeting minutes references / 會議紀錄引用)
- ARCH-CHECKLIST-001-架構審查清單.md (risk register reference / 風險登錄引用)

**Fix Pattern / 修復模式**:
```
RI/docs/RI-X-Y-*.md → PM-*-00X-*.md (within same category)
RI/docs/RI-X-Y-*.md → ../XX-類別/PM-*-00X-*.md (cross-category)
```

### 3.2 Phase 2: Architecture References (Priority 2) / 階段2：架構引用（優先級2）

**Target Documents / 目標文檔**:
- ARCH-ADR-001-分層架構.md (developer handbook reference / 開發手冊引用)
- UI-GUIDE-001-界面設計指南.md (architecture reference / 架構引用)
- DEV-GUIDE-001-開發人員手冊.md (remaining ADR references / 剩餘ADR引用)

**Fix Pattern / 修復模式**:
```
docs/architecture/ADR-*.md → ARCH-ADR-*-*.md (within same category)
docs/architecture/ADR-*.md → ../02-架構設計/ARCH-ADR-*-*.md (cross-category)
```

### 3.3 Phase 3: Legacy References (Priority 3) / 階段3：舊引用（優先級3）

**Target Documents / 目標文檔**:
- DOC-GUIDE-001-Markdown指南.md (task tracker reference / 任務追蹤器引用)
- DOC-PROCESS-001-Markdown維運流程.md (file path references / 檔案路徑引用)
- DEV-GUIDE-004-應用開發指南.md (architecture directory reference / 架構目錄引用)

---

## 4. Detailed Fix Instructions / 詳細修復說明

### 4.1 Reference Mapping Table / 引用映射表

| Old Reference / 舊引用 | New Reference / 新引用 | Context / 上下文 |
|------------------------|------------------------|------------------|
| `RI/docs/reinsurance-system-task-tracker.md` | `PM-REPORT-001-任務追蹤.md` | Within 01-專案管理/ |
| `RI/docs/reinsurance-system-project-plan.md` | `PM-PLAN-001-專案計劃.md` | Within 01-專案管理/ |
| `RI/docs/RI-1-1-action-items.md` | `PM-ACTION-001-行動項目.md` | Within 01-專案管理/ |
| `RI/docs/RI-4-1-risk-register.md` | `PM-RISK-001-風險登錄.md` | Within 01-專案管理/ |
| `RI/docs/RI-5-2-architecture-review-checklist.md` | `../02-架構設計/ARCH-CHECKLIST-001-架構審查清單.md` | Cross-category |
| `docs/architecture/ADR-001-layered-architecture.md` | `../02-架構設計/ARCH-ADR-001-分層架構.md` | Cross-category |
| `docs/uiux/uiux-guidelines.md` | `../08-用戶界面/UI-GUIDE-001-界面設計指南.md` | Cross-category |
| `docs/RI-8-1-developer-handbook.md` | `../03-開發指南/DEV-GUIDE-001-開發人員手冊.md` | Cross-category |

### 4.2 Automated Fix Commands / 自動化修復命令

**For same-category references / 同類別引用**:
```bash
# Within 01-專案管理/
find docs/01-專案管理/ -name "*.md" -exec sed -i.bak 's|RI/docs/reinsurance-system-task-tracker.md|PM-REPORT-001-任務追蹤.md|g' {} \;
find docs/01-專案管理/ -name "*.md" -exec sed -i.bak 's|RI/docs/RI-1-1-action-items.md|PM-ACTION-001-行動項目.md|g' {} \;
find docs/01-專案管理/ -name "*.md" -exec sed -i.bak 's|RI/docs/RI-4-1-risk-register.md|PM-RISK-001-風險登錄.md|g' {} \;
```

**For cross-category references / 跨類別引用**:
```bash
# From any category to architecture
find docs/ -name "*.md" -exec sed -i.bak 's|docs/architecture/ADR-001-layered-architecture.md|../02-架構設計/ARCH-ADR-001-分層架構.md|g' {} \;
find docs/ -name "*.md" -exec sed -i.bak 's|RI/docs/RI-5-2-architecture-review-checklist.md|../02-架構設計/ARCH-CHECKLIST-001-架構審查清單.md|g' {} \;
```

---

## 5. Manual Fix Checklist / 手動修復檢查清單

### 5.1 Project Management Documents / 專案管理文檔

**01-專案管理/ directory / 目錄**:
- [ ] PM-COMM-001-溝通矩陣.md - Fix remaining table references / 修復剩餘表格引用
- [ ] PM-RISK-002-風險審查節奏.md - Update risk register references / 更新風險登錄引用
- [ ] PM-ACTION-001-行動項目.md - Fix meeting minutes reference / 修復會議紀錄引用
- [ ] PM-PREP-001-啟動準備.md - Update task tracker and scrum plan references / 更新任務追蹤器和scrum計劃引用
- [ ] PM-MEETING-001-啟動會議紀錄.md - Fix action items and scrum plan references / 修復行動項目和scrum計劃引用
- [ ] PM-PLAN-003-團隊目標與風險.md - Update charter and scrum plan references / 更新章程和scrum計劃引用

### 5.2 Architecture Documents / 架構文檔

**02-架構設計/ directory / 目錄**:
- [ ] ARCH-ADR-001-分層架構.md - Fix developer handbook reference / 修復開發手冊引用
- [ ] ARCH-CHECKLIST-001-架構審查清單.md - Update risk register reference / 更新風險登錄引用

### 5.3 Development Documents / 開發文檔

**03-開發指南/ directory / 目錄**:
- [ ] DEV-GUIDE-001-開發人員手冊.md - Fix remaining ADR references / 修復剩餘ADR引用
- [ ] DEV-GUIDE-004-應用開發指南.md - Update architecture directory reference / 更新架構目錄引用
- [ ] DEV-GUIDE-005-國際化實施指南.md - Fix ADR and plan references / 修復ADR和計劃引用

### 5.4 Operations Documents / 運維文檔

**04-運維部署/ directory / 目錄**:
- [ ] OPS-PLAN-002-CICD驗證計劃.md - Fix CICD prototype plan reference / 修復CICD原型計劃引用

### 5.5 Documentation Management / 文檔管理

**07-文檔管理/ directory / 目錄**:
- [ ] DOC-GUIDE-001-Markdown指南.md - Update task tracker reference / 更新任務追蹤器引用
- [ ] DOC-PROCESS-001-Markdown維運流程.md - Fix file path references / 修復檔案路徑引用

### 5.6 User Interface Documents / 用戶界面文檔

**08-用戶界面/ directory / 目錄**:
- [ ] UI-GUIDE-001-界面設計指南.md - Fix architecture ADR reference / 修復架構ADR引用

---

## 6. Validation Process / 驗證流程

### 6.1 Link Testing / 連結測試

**Automated Testing / 自動化測試**:
```bash
# Check for broken markdown links
find docs/ -name "*.md" -exec grep -l "\[.*\](.*\.md)" {} \; | while read file; do
    echo "Checking links in: $file"
    grep -o "\[.*\](.*\.md)" "$file" | while read link; do
        path=$(echo "$link" | sed 's/.*(\(.*\))/\1/')
        if [ ! -f "docs/$path" ]; then
            echo "BROKEN LINK: $link in $file"
        fi
    done
done
```

**Manual Testing / 手動測試**:
- [ ] Test all links in main README.md / 測試主README.md中的所有連結
- [ ] Verify project management cross-references / 驗證專案管理交叉引用
- [ ] Check architecture document links / 檢查架構文檔連結
- [ ] Validate development guide references / 驗證開發指南引用

### 6.2 Content Verification / 內容驗證

**Consistency Checks / 一致性檢查**:
- [ ] Verify document titles match file names / 驗證文檔標題與檔案名匹配
- [ ] Check document ID consistency / 檢查文檔ID一致性
- [ ] Validate category assignments / 驗證類別分配
- [ ] Review cross-references for accuracy / 審查交叉引用的準確性

---

## 7. Priority Fix List / 優先修復清單

### 7.1 Critical Fixes (Complete Today) / 關鍵修復（今天完成）

1. **PM-COMM-001-溝通矩陣.md**
   - Fix: `RI/docs/reinsurance-system-project-plan.md` → `PM-PLAN-001-專案計劃.md`
   - Fix: `RI/docs/RI-1-4-squad-goals-risks.md` → `PM-PLAN-003-團隊目標與風險.md`
   - Fix: `RI/docs/RI-1-1-action-items.md` → `PM-ACTION-001-行動項目.md`

2. **PM-RISK-002-風險審查節奏.md**
   - Fix: `RI/docs/reinsurance-system-task-tracker.md` → `PM-REPORT-001-任務追蹤.md`
   - Fix: `RI/docs/RI-4-1-risk-register.md` → `PM-RISK-001-風險登錄.md`
   - Fix: `RI/docs/RI-1-1-action-items.md` → `PM-ACTION-001-行動項目.md`

3. **ARCH-CHECKLIST-001-架構審查清單.md**
   - Fix: `RI/docs/RI-4-1-risk-register.md` → `../01-專案管理/PM-RISK-001-風險登錄.md`

### 7.2 High Priority Fixes (This Week) / 高優先級修復（本週）

1. **ARCH-ADR-001-分層架構.md**
   - Fix: `RI/docs/RI-5-2-architecture-review-checklist.md` → `ARCH-CHECKLIST-001-架構審查清單.md`
   - Fix: `docs/RI-8-1-developer-handbook.md` → `../03-開發指南/DEV-GUIDE-001-開發人員手冊.md`

2. **UI-GUIDE-001-界面設計指南.md**
   - Fix: `docs/architecture/ADR-001-layered-architecture.md` → `../02-架構設計/ARCH-ADR-001-分層架構.md`

3. **DEV-GUIDE-004-應用開發指南.md**
   - Fix: `docs/architecture/` → `../02-架構設計/`

### 7.3 Medium Priority Fixes (Next Week) / 中優先級修復（下週）

1. **Documentation Management Files / 文檔管理檔案**
   - DOC-GUIDE-001-Markdown指南.md
   - DOC-PROCESS-001-Markdown維運流程.md

2. **Development Guides / 開發指南**
   - DEV-GUIDE-005-國際化實施指南.md
   - DEV-ANALYSIS-001-NextJS16國際化相容性分析.md

---

## 8. Automated Fix Scripts / 自動化修復腳本

### 8.1 Batch Fix Commands / 批量修復命令

**Same-category fixes / 同類別修復**:
```bash
# Fix project management internal references
cd docs/01-專案管理/
sed -i.bak 's|RI/docs/reinsurance-system-task-tracker.md|PM-REPORT-001-任務追蹤.md|g' *.md
sed -i.bak 's|RI/docs/reinsurance-system-project-plan.md|PM-PLAN-001-專案計劃.md|g' *.md
sed -i.bak 's|RI/docs/reinsurance-system-scrum-plan.md|PM-PLAN-002-Sprint計劃.md|g' *.md
sed -i.bak 's|RI/docs/RI-1-1-action-items.md|PM-ACTION-001-行動項目.md|g' *.md
sed -i.bak 's|RI/docs/RI-4-1-risk-register.md|PM-RISK-001-風險登錄.md|g' *.md
```

**Cross-category fixes / 跨類別修復**:
```bash
# Fix architecture references from other categories
find docs/ -name "*.md" -exec sed -i.bak 's|docs/architecture/ADR-001-layered-architecture.md|../02-架構設計/ARCH-ADR-001-分層架構.md|g' {} \;
find docs/ -name "*.md" -exec sed -i.bak 's|RI/docs/RI-5-2-architecture-review-checklist.md|../02-架構設計/ARCH-CHECKLIST-001-架構審查清單.md|g' {} \;
find docs/ -name "*.md" -exec sed -i.bak 's|docs/uiux/uiux-guidelines.md|../08-用戶界面/UI-GUIDE-001-界面設計指南.md|g' {} \;
```

### 8.2 Validation Script / 驗證腳本

```bash
#!/bin/bash
# Validate all markdown links

echo "Validating markdown links..."
broken_links=0

find docs/ -name "*.md" | while read file; do
    # Extract markdown links
    grep -o '\[.*\](.*\.md)' "$file" | while read link; do
        # Extract path from link
        path=$(echo "$link" | sed 's/.*(\(.*\))/\1/')
        
        # Check if it's a relative path
        if [[ "$path" == ../* ]]; then
            # Cross-category reference
            full_path="docs/${path#../}"
        elif [[ "$path" == */* ]]; then
            # Same category or absolute path
            full_path="docs/$path"
        else
            # Same directory
            dir=$(dirname "$file")
            full_path="$dir/$path"
        fi
        
        if [ ! -f "$full_path" ]; then
            echo "BROKEN: $link in $file -> $full_path"
            ((broken_links++))
        fi
    done
done

echo "Validation complete. Broken links: $broken_links"
```

---

## 9. Implementation Timeline / 實施時間表

### 9.1 Today (2025-11-06) / 今天

**Morning / 上午**:
- [x] Complete critical project management references / 完成關鍵專案管理引用
- [x] Fix main architecture document references / 修復主要架構文檔引用

**Afternoon / 下午**:
- [ ] Fix remaining table references in communication matrix / 修復溝通矩陣中剩餘表格引用
- [ ] Update risk management document references / 更新風險管理文檔引用
- [ ] Fix architecture checklist references / 修復架構檢查清單引用

### 9.2 Tomorrow (2025-11-07) / 明天

- [ ] Complete all architecture ADR internal references / 完成所有架構ADR內部引用
- [ ] Fix UI guide and development guide cross-references / 修復UI指南和開發指南交叉引用
- [ ] Update documentation management file references / 更新文檔管理檔案引用

### 9.3 This Week / 本週

- [ ] Complete comprehensive link validation / 完成全面連結驗證
- [ ] Fix any remaining broken references / 修復任何剩餘斷開引用
- [ ] Update DOC-REPORT-001 with final status / 更新DOC-REPORT-001最終狀態

---

## 10. Success Criteria / 成功標準

### 10.1 Completion Criteria / 完成標準

- [ ] **Zero Broken Links / 零斷開連結**: All internal references functional / 所有內部引用有效
- [ ] **Consistent Patterns / 一致模式**: All references follow relative path convention / 所有引用遵循相對路徑約定
- [ ] **Cross-validation / 交叉驗證**: All referenced documents exist in expected locations / 所有引用文檔存在於預期位置
- [ ] **Documentation Updated / 文檔已更新**: DOC-REPORT-001 reflects final status / DOC-REPORT-001反映最終狀態

### 10.2 Quality Metrics / 品質指標

- **Reference Accuracy / 引用準確性**: 100% functional links / 100%有效連結
- **Path Consistency / 路徑一致性**: All relative paths correctly formatted / 所有相對路徑格式正確
- **Cross-category Navigation / 跨類別導航**: Seamless navigation between document categories / 文檔類別間無縫導航

---

## 11. Post-Fix Validation / 修復後驗證

### 11.1 Automated Validation / 自動化驗證

**Link Checker / 連結檢查器**:
- Run automated link validation script / 運行自動化連結驗證腳本
- Generate broken link report / 生成斷開連結報告
- Fix any identified issues / 修復任何識別的問題

### 11.2 Manual Validation / 手動驗證

**Spot Checks / 抽查**:
- [ ] Navigate through main README.md links / 瀏覽主README.md連結
- [ ] Test project management document cross-references / 測試專案管理文檔交叉引用
- [ ] Verify architecture document navigation / 驗證架構文檔導航
- [ ] Check development guide references / 檢查開發指南引用

---

## 12. Completion Report Update / 完成報告更新

### 12.1 Final Status Update / 最終狀態更新

Once all references are fixed, update DOC-REPORT-001 with:
所有引用修復完成後，更新DOC-REPORT-001包含：

- **Reference Integrity / 引用完整性**: 100% complete / 100%完成
- **Link Validation / 連結驗證**: All links functional / 所有連結有效
- **Quality Metrics / 品質指標**: Updated achievement status / 更新達成狀態
- **Final Recommendations / 最終建議**: Maintenance procedures / 維護程序

---

## Revision History / 修訂記錄

| Version / 版本 | Date / 日期 | Changes / 變更內容 | Author / 作者 |
|----------------|-------------|-------------------|---------------|
| v1.0 | 2025-11-06 | Initial reference fixing action plan / 初版引用修復行動計劃 | Tao Yu 和他的 GPT 智能助手 |

---

> **Maintenance / 維護**: Documentation Team / 文檔團隊  
> **Priority / 優先級**: High / 高  
> **Target Completion / 目標完成**: 2025-11-08