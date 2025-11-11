#!/bin/bash

# 批量修復文檔引用腳本
# Script to fix document references after reorganization

echo "開始修復文檔引用..."

# 定義替換規則
declare -A replacements=(
    # 專案管理文檔
    ["docs/reinsurance-system-task-tracker.md"]="../01-專案管理/PM-REPORT-001-任務追蹤.md"
    ["docs/reinsurance-system-project-plan.md"]="../01-專案管理/PM-PLAN-001-專案計劃.md"
    ["docs/reinsurance-system-scrum-plan.md"]="../01-專案管理/PM-PLAN-002-Sprint計劃.md"
    ["RI/docs/reinsurance-system-task-tracker.md"]="../PM-REPORT-001-任務追蹤.md"
    ["RI/docs/reinsurance-system-project-plan.md"]="../PM-PLAN-001-專案計劃.md"
    ["RI/docs/reinsurance-system-scrum-plan.md"]="../PM-PLAN-002-Sprint計劃.md"
    
    # RI 系列文檔
    ["docs/RI-1-1-kickoff-preparation.md"]="../01-專案管理/PM-PREP-001-啟動準備.md"
    ["docs/RI-1-1-kickoff-minutes.md"]="../01-專案管理/PM-MEETING-001-啟動會議紀錄.md"
    ["docs/RI-1-1-action-items.md"]="../01-專案管理/PM-ACTION-001-行動項目.md"
    ["docs/RI-1-3-project-charter.md"]="../01-專案管理/PM-CHARTER-001-專案章程.md"
    ["docs/RI-1-4-squad-goals-risks.md"]="../01-專案管理/PM-PLAN-003-團隊目標與風險.md"
    ["docs/RI-2-1-stakeholder-register.md"]="../01-專案管理/PM-STAKEHOLDER-001-利益相關者清單.md"
    ["docs/RI-2-2-communication-matrix.md"]="../01-專案管理/PM-COMM-001-溝通矩陣.md"
    ["docs/RI-4-1-risk-register.md"]="../01-專案管理/PM-RISK-001-風險登錄.md"
    ["docs/RI-4-2-risk-review-cadence.md"]="../01-專案管理/PM-RISK-002-風險審查節奏.md"
    ["docs/RI-8-1-developer-handbook.md"]="../03-開發指南/DEV-GUIDE-001-開發人員手冊.md"
    ["docs/RI-9-8-i18n-refactoring-plan.md"]="../03-開發指南/DEV-PLAN-001-國際化重構計劃.md"
    
    # 相對路徑的 RI 引用
    ["RI/docs/RI-1-1-kickoff-preparation.md"]="PM-PREP-001-啟動準備.md"
    ["RI/docs/RI-1-1-kickoff-minutes.md"]="PM-MEETING-001-啟動會議紀錄.md"
    ["RI/docs/RI-1-1-action-items.md"]="PM-ACTION-001-行動項目.md"
    ["RI/docs/RI-1-3-project-charter.md"]="PM-CHARTER-001-專案章程.md"
    ["RI/docs/RI-1-4-squad-goals-risks.md"]="PM-PLAN-003-團隊目標與風險.md"
    ["RI/docs/RI-2-1-stakeholder-register.md"]="PM-STAKEHOLDER-001-利益相關者清單.md"
    ["RI/docs/RI-2-2-communication-matrix.md"]="PM-COMM-001-溝通矩陣.md"
    ["RI/docs/RI-4-1-risk-register.md"]="PM-RISK-001-風險登錄.md"
    ["RI/docs/RI-4-2-risk-review-cadence.md"]="PM-RISK-002-風險審查節奏.md"
    ["RI/docs/RI-7-1-cicd-prototype-plan.md"]="../04-運維部署/OPS-PLAN-001-CICD原型計劃.md"
    ["RI/docs/RI-8-1-developer-handbook.md"]="../03-開發指南/DEV-GUIDE-001-開發人員手冊.md"
    
    # 架構文檔
    ["docs/architecture/ADR-001-layered-architecture.md"]="../02-架構設計/ARCH-ADR-001-分層架構.md"
    ["docs/architecture/ADR-002-database-strategy.md"]="../02-架構設計/ARCH-ADR-002-資料庫策略.md"
    ["docs/architecture/ADR-003-react-query-strategy.md"]="../02-架構設計/ARCH-ADR-003-React查詢策略.md"
    ["docs/architecture/ADR-004-testing-strategy.md"]="../02-架構設計/ARCH-ADR-004-測試策略.md"
    ["docs/architecture/ADR-005-audit-trail.md"]="../02-架構設計/ARCH-ADR-005-稽核軌跡.md"
    ["docs/architecture/ADR-006-git-branching-strategy.md"]="../02-架構設計/ARCH-ADR-006-Git分支策略.md"
    ["docs/architecture/ADR-007-module-architecture-pattern.md"]="../02-架構設計/ARCH-ADR-007-模組架構模式.md"
    ["docs/architecture/ADR-008-internationalization-strategy.md"]="../02-架構設計/ARCH-ADR-008-國際化策略.md"
    ["RI/docs/RI-5-2-architecture-review-checklist.md"]="../02-架構設計/ARCH-CHECKLIST-001-架構審查清單.md"
    
    # UI/UX 文檔
    ["docs/uiux/uiux-guidelines.md"]="../08-用戶界面/UI-GUIDE-001-界面設計指南.md"
    
    # 環境和部署文檔
    ["docs/environment-setup-guide.md"]="../03-開發指南/DEV-GUIDE-002-環境設置指南.md"
    ["docs/environment-quick-start.md"]="../03-開發指南/DEV-GUIDE-003-環境快速開始.md"
    ["docs/environment-checklist.md"]="../06-品質保證/QA-CHECKLIST-001-環境檢查清單.md"
    ["docs/vercel-deployment.md"]="../04-運維部署/OPS-DEPLOY-002-Vercel部署配置.md"
    ["docs/vercel-deployment-guide.md"]="../04-運維部署/OPS-DEPLOY-001-Vercel部署指南.md"
    ["docs/git-branching-strategy.md"]="../04-運維部署/OPS-PROCESS-001-Git分支流程.md"
    
    # Markdown 文檔
    ["docs/RI-3-1-markdown-structure.md"]="../07-文檔管理/DOC-GUIDE-001-Markdown指南.md"
    ["docs/RI-3-2-markdown-ops.md"]="../07-文檔管理/DOC-PROCESS-001-Markdown維運流程.md"
)

# 遍歷所有 markdown 文檔並進行替換
find . -name "*.md" -type f | while read file; do
    echo "處理文檔: $file"
    
    # 對每個替換規則進行處理
    for old_path in "${!replacements[@]}"; do
        new_path="${replacements[$old_path]}"
        
        # 使用 sed 進行替換
        if grep -q "$old_path" "$file" 2>/dev/null; then
            echo "  - 替換: $old_path -> $new_path"
            sed -i.bak "s|$old_path|$new_path|g" "$file"
        fi
    done
done

# 清理備份文件
find . -name "*.bak" -delete

echo "引用修復完成！"