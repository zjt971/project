# OPS-PROCESS-001: Git Branching Strategy and Workflow / Git 分支策略與工作流程

## Document Information / 文檔資訊
- **Document ID / 文檔編號**: OPS-PROCESS-001
- **Version / 版本**: v2.0
- **Status / 狀態**: Active
- **Author / 作者**: Tao Yu 和他的 GPT 智能助手
- **Created Date / 建立日期**: 2025-11-03
- **Last Updated / 最後更新**: 2025-11-06
- **Related Documents / 相關文檔**: [ARCH-ADR-006](../02-架構設計/ARCH-ADR-006-Git分支策略.md)

---

## 1. Executive Summary / 執行摘要

This document defines the Git branching management strategy for the RI Management project, aimed at standardizing team collaboration processes, improving code quality and development efficiency. **Critical Update**: All merges must use `--no-ff` to preserve branch history and maintain clear project timeline visibility.

本文檔定義了 RI Management 專案的 Git 分支管理策略，旨在規範團隊協作流程，提高代碼品質和開發效率。**重要更新**：所有合併必須使用 `--no-ff` 以保留分支歷史並維持清晰的專案時間線可見性。

---

## 2. Branch Types / 分支類型

### 2.1 Main Branches / 主分支

#### master 分支
- **Purpose / 用途**: Production environment code branch, always maintain stable deployable state / 生產環境代碼分支，始終保持穩定可部署狀態
- **Protection Rules / 保護規則**: 
  - Prohibit direct commits to master branch / 禁止直接提交到 master 分支
  - Only merge through Pull Request (PR) / 只能通過 Pull Request (PR) 合併
  - **MANDATORY: Use `--no-ff` for all merges / 強制要求：所有合併使用 `--no-ff`**
  - All PRs must pass code review and automated testing / 所有 PR 必須通過代碼審查和自動化測試
- **Update Frequency / 更新頻率**: Only updated when releasing versions / 僅在發布版本時更新

#### develop 分支 (Optional / 可選)
- **Purpose / 用途**: Development environment integration branch / 開發環境集成分支
- **Protection Rules / 保護規則**: 
  - Prohibit direct commits to develop branch / 禁止直接提交到 develop 分支
  - Only merge through PR / 只能通過 PR 合併
  - **MANDATORY: Use `--no-ff` for all merges / 強制要求：所有合併使用 `--no-ff`**
  - All PRs must pass code review and automated testing / 所有 PR 必須通過代碼審查和自動化測試
- **Update Frequency / 更新頻率**: Updated when feature branches are merged / 功能分支合併時更新

### 2.2 Supporting Branches / 輔助分支

#### feature 分支
- **Naming Convention / 命名規範**: `feature/功能描述` 或 `feature/TASK-編號-功能描述`
- **Purpose / 用途**: Develop new features / 開發新功能
- **Source Branch / 來源分支**: develop 或 master (如果沒有 develop 分支)
- **Target Branch / 目標分支**: develop 或 master
- **Lifecycle / 生命週期**: Delete after feature development is complete and merged / 功能開發完成並合併後刪除

#### bugfix 分支
- **Naming Convention / 命名規範**: `bugfix/問題描述` 或 `bugfix/TASK-編號-問題描述`
- **Purpose / 用途**: Fix bugs in production or development environment / 修復生產環境或開發環境的 bug
- **Source Branch / 來源分支**: master (生產 bug) 或 develop (開發環境 bug)
- **Target Branch / 目標分支**: Corresponding source branch / 對應的來源分支
- **Lifecycle / 生命週期**: Delete after fix is complete and merged / 修復完成並合併後刪除

#### hotfix 分支
- **Naming Convention / 命名規範**: `hotfix/緊急修復描述` 或 `hotfix/TASK-編號-緊急修復描述`
- **Purpose / 用途**: Emergency fix for serious production issues / 緊急修復生產環境的嚴重問題
- **Source Branch / 來源分支**: master
- **Target Branch / 目標分支**: master 和 develop (如果存在)
- **Lifecycle / 生命週期**: Delete after fix is complete and merged / 修復完成並合併後刪除

---

## 3. Development Workflow / 開發流程

### 3.1 Feature Development Workflow / 功能開發流程

1. **Create Feature Branch / 創建功能分支**
   ```bash
   git checkout master  # or develop
   git pull origin master  # or develop
   git checkout -b feature/新功能描述
   ```

2. **Develop Feature / 開發功能**
   - Develop on feature branch / 在功能分支上進行開發
   - Follow commit message conventions / 遵循提交信息規範
   - Regularly sync with main branch / 定期同步主分支的最新更改
   ```bash
   git checkout master  # or develop
   git pull origin master  # or develop
   git checkout feature/新功能描述
   git merge master  # or develop
   ```

3. **Submit Code Review / 提交代碼審查**
   - Push feature branch to remote repository / 推送功能分支到遠程倉庫
   - Create Pull Request to main branch / 創建 Pull Request 到主分支
   - Fill PR template describing feature changes / 填寫 PR 模板，描述功能變更
   ```bash
   git push origin feature/新功能描述
   ```

4. **Code Review and Merge / 代碼審查與合併**
   - At least one team member reviews code / 至少一名團隊成員進行代碼審查
   - Pass all automated tests / 通過所有自動化測試
   - **CRITICAL: Use `--no-ff` merge to preserve branch history / 關鍵：使用 `--no-ff` 合併以保留分支歷史**
   ```bash
   git checkout master
   git merge --no-ff feature/新功能描述
   git push origin master
   git branch -d feature/新功能描述
   git push origin --delete feature/新功能描述
   ```

### 3.2 Bug Fix Workflow / Bug 修復流程

1. **Create Bug Fix Branch / 創建 Bug 修復分支**
   ```bash
   git checkout master  # or develop
   git pull origin master  # or develop
   git checkout -b bugfix/問題描述
   ```

2. **Fix Bug / 修復 Bug**
   - Fix on bugfix branch / 在 bugfix 分支上進行修復
   - Add or update test cases / 添加或更新測試用例
   - Ensure tests pass / 確保測試通過

3. **Submit Code Review / 提交代碼審查**
   - Push bugfix branch to remote repository / 推送 bugfix 分支到遠程倉庫
   - Create Pull Request to corresponding main branch / 創建 Pull Request 到對應的主分支
   - Fill PR template describing problem and solution / 填寫 PR 模板，描述問題和修復方案

4. **Code Review and Merge / 代碼審查與合併**
   - Code review and testing / 代碼審查和測試
   - **MANDATORY: Use `--no-ff` merge / 強制要求：使用 `--no-ff` 合併**
   ```bash
   git checkout master
   git merge --no-ff bugfix/問題描述
   git push origin master
   git branch -d bugfix/問題描述
   git push origin --delete bugfix/問題描述
   ```

---

## 4. No Fast-Forward Merge Policy / 禁用快進合併政策

### 4.1 Problem Analysis / 問題分析

**Issue / 問題**: Fast-forward merges create linear history that hides branch structure, making it difficult to track feature development timeline and understand project evolution.

快進合併創建線性歷史，隱藏分支結構，使得難以追蹤功能開發時間線和理解專案演進。

**Impact / 影響**:
- Loss of branch context in Git history / Git 歷史中丟失分支上下文
- Difficulty tracking feature development lifecycle / 難以追蹤功能開發生命週期
- Reduced visibility of merge points / 合併點可見性降低
- Harder to identify related commits / 更難識別相關提交

### 4.2 Solution / 解決方案

**Mandatory Configuration / 強制配置**:
```bash
# Set repository-wide no-ff policy
git config merge.ff false

# For global user configuration (optional)
git config --global merge.ff false
```

**Merge Commands / 合併命令**:
```bash
# Feature branch merge (REQUIRED FORMAT)
git checkout master
git pull origin master
git merge --no-ff feature/branch-name
git push origin master

# Alternative with merge message
git merge --no-ff feature/branch-name -m "Merge feature: 功能描述"
```

### 4.3 Branch History Visualization / 分支歷史可視化

**Expected Git Graph / 預期的 Git 圖形**:
```
*   commit (merge commit)
|\  
| * commit (feature work)
| * commit (feature work)
|/  
* commit (master)
```

**Commands to View Branch History / 查看分支歷史的命令**:
```bash
# View branch graph
git log --oneline --graph --all

# View detailed branch history
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all

# View specific branch merges
git log --merges --oneline --graph
```

---

## 5. Merge Process Standards / 合併流程標準

### 5.1 Pre-Merge Checklist / 合併前檢查清單

**Before Any Merge / 任何合併前**:
- [ ] Feature/bugfix branch is up to date with target branch / 功能/修復分支與目標分支同步
- [ ] All tests pass locally / 所有測試在本地通過
- [ ] Code review completed and approved / 代碼審查完成並批准
- [ ] No merge conflicts / 無合併衝突
- [ ] Documentation updated if needed / 如需要已更新文檔

### 5.2 Merge Execution / 合併執行

**Standard Merge Process / 標準合併流程**:
```bash
# 1. Switch to target branch
git checkout master

# 2. Pull latest changes
git pull origin master

# 3. Merge with no-ff (MANDATORY)
git merge --no-ff feature/branch-name

# 4. Push to remote
git push origin master

# 5. Clean up feature branch
git branch -d feature/branch-name
git push origin --delete feature/branch-name
```

### 5.3 Merge Message Standards / 合併信息標準

**Format / 格式**:
```
Merge feature: [功能描述] / [Feature Description]

- [主要變更1] / [Major change 1]
- [主要變更2] / [Major change 2]
- [主要變更3] / [Major change 3]

Related: [相關任務編號] / [Related task ID]
Reviewed-by: [審查者] / [Reviewer]
```

**Example / 範例**:
```
Merge feature: 文檔重組與標準化 / Documentation Reorganization

- 實施統一編號規範 / Implement unified numbering standards
- 建立邏輯目錄結構 / Establish logical directory structure  
- 修復所有內部引用 / Fix all internal references
- 建立雙語文檔標準 / Establish bilingual documentation standards

Related: DOC-STD-001
Reviewed-by: Architecture Team
```

---

## 6. Git Configuration Setup / Git 配置設置

### 6.1 Repository Configuration / 倉庫配置

**Required Settings / 必需設置**:
```bash
# Disable fast-forward merges (MANDATORY)
git config merge.ff false

# Set default merge message format
git config merge.tool vimdiff

# Configure pull behavior
git config pull.rebase false
```

### 6.2 Team Configuration / 團隊配置

**For All Team Members / 所有團隊成員**:
```bash
# Global configuration (recommended)
git config --global merge.ff false
git config --global pull.rebase false

# Set user information
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"
```

### 6.3 Verification / 驗證

**Check Configuration / 檢查配置**:
```bash
# Verify merge.ff setting
git config --get merge.ff
# Should return: false

# View all merge-related settings
git config --list | grep merge
```

---

## 7. Branch History Best Practices / 分支歷史最佳實踐

### 7.1 Maintaining Clean History / 維護清潔歷史

**Do's / 應該做的**:
- Always use `--no-ff` for merges / 合併時始終使用 `--no-ff`
- Write descriptive merge messages / 編寫描述性合併信息
- Include related task/issue numbers / 包含相關任務/問題編號
- Delete feature branches after merge / 合併後刪除功能分支

**Don'ts / 不應該做的**:
- Never use fast-forward merge for feature branches / 永遠不要對功能分支使用快進合併
- Don't merge without code review / 不要在沒有代碼審查的情況下合併
- Don't leave stale branches / 不要留下過時的分支
- Don't force push to protected branches / 不要強制推送到受保護分支

### 7.2 Branch Naming Standards / 分支命名標準

**Format / 格式**: `<type>/<description>` or `<type>/<task-id>-<description>`

**Examples / 範例**:
- `feature/DOC-STD-001-documentation-standards`
- `bugfix/PM-REPORT-001-task-tracker-links`
- `hotfix/ARCH-ADR-001-critical-architecture-fix`

---

## 8. Merge Commands Reference / 合併命令參考

### 8.1 Feature Branch Merge / 功能分支合併

```bash
# Standard feature merge (REQUIRED PROCESS)
git checkout master
git pull origin master
git merge --no-ff feature/branch-name -m "Merge feature: 功能描述"
git push origin master

# Verify merge created merge commit
git log --oneline --graph -5
```

### 8.2 Bugfix Branch Merge / 修復分支合併

```bash
# Standard bugfix merge
git checkout master
git pull origin master
git merge --no-ff bugfix/branch-name -m "Merge bugfix: 修復描述"
git push origin master
```

### 8.3 Hotfix Branch Merge / 緊急修復分支合併

```bash
# Hotfix merge to master
git checkout master
git pull origin master
git merge --no-ff hotfix/branch-name -m "Merge hotfix: 緊急修復描述"
git tag -a v版本號 -m "版本描述"
git push origin master --tags

# Also merge to develop if exists
git checkout develop
git pull origin develop
git merge --no-ff hotfix/branch-name
git push origin develop
```

---

## 9. Troubleshooting / 故障排除

### 9.1 Common Issues / 常見問題

**Q: How to handle merge conflicts? / 如何處理合併衝突？**
A: 
1. Pull latest code / 拉取最新代碼
2. Resolve conflicts locally / 在本地解決衝突
3. Test to ensure functionality / 測試確保功能正常
4. Commit conflict resolution / 提交解決衝突的代碼
5. Continue merge process with `--no-ff` / 使用 `--no-ff` 繼續合併流程

**Q: When to use hotfix branch? / 何時使用 hotfix 分支？**
A: When production environment has serious issues requiring immediate fix / 當生產環境出現嚴重問題需要立即修復時

**Q: Feature branch development takes too long? / 功能分支開發時間過長怎麼辦？**
A: 
1. Regularly sync with main branch / 定期同步主分支最新更改
2. Consider splitting large features into smaller ones / 考慮將大功能拆分為多個小功能
3. Communicate progress and issues with team timely / 及時與團隊溝通進度和問題

### 9.2 Emergency Procedures / 緊急程序

**If Fast-Forward Merge Accidentally Used / 如果意外使用了快進合併**:
```bash
# Reset the merge (if not yet pushed)
git reset --hard HEAD~1

# Redo the merge with --no-ff
git merge --no-ff feature/branch-name

# If already pushed, create a new merge commit
git checkout master
git pull origin master
git merge --no-ff feature/branch-name --allow-unrelated-histories
```

---

## 10. Team Training and Compliance / 團隊培訓與合規

### 10.1 Onboarding Checklist / 入職檢查清單

**For New Team Members / 新團隊成員**:
- [ ] Configure Git with `merge.ff false` / 配置 Git 使用 `merge.ff false`
- [ ] Practice no-ff merge workflow / 練習 no-ff 合併工作流程
- [ ] Understand branch naming conventions / 理解分支命名約定
- [ ] Review merge message standards / 審查合併信息標準

### 10.2 Compliance Monitoring / 合規監控

**Regular Checks / 定期檢查**:
- Weekly review of merge history / 每週審查合併歷史
- Verify all merges use `--no-ff` / 驗證所有合併使用 `--no-ff`
- Check branch naming compliance / 檢查分支命名合規性
- Monitor for fast-forward merges / 監控快進合併

**Enforcement / 執行**:
- Code review must verify merge strategy / 代碼審查必須驗證合併策略
- Reject PRs that don't follow standards / 拒絕不遵循標準的 PR
- Regular team training on Git best practices / 定期進行 Git 最佳實踐團隊培訓

---

## 11. Integration with Project Tools / 與專案工具整合

### 11.1 Documentation Integration / 文檔整合

**Related Documents / 相關文檔**:
- [ARCH-ADR-006](../02-架構設計/ARCH-ADR-006-Git分支策略.md) - Architecture decision for Git strategy / Git 策略的架構決策
- [DEV-GUIDE-001](../03-開發指南/DEV-GUIDE-001-開發人員手冊.md) - Developer handbook with Git workflows / 包含 Git 工作流程的開發人員手冊
- [PM-REPORT-001](../01-專案管理/PM-REPORT-001-任務追蹤.md) - Task tracking with branch references / 包含分支引用的任務追蹤

### 11.2 CI/CD Integration / CI/CD 整合

**Automated Checks / 自動化檢查**:
- Verify merge commits exist for feature branches / 驗證功能分支存在合併提交
- Check branch naming conventions / 檢查分支命名約定
- Validate merge message format / 驗證合併信息格式
- Ensure no direct commits to protected branches / 確保受保護分支無直接提交

---

## 12. Current Branch Merge Instructions / 當前分支合併說明

### 12.1 For This Documentation Reorganization Branch / 本次文檔重組分支

**Current Branch / 當前分支**: `bugfix/nextjs-hydration-mismatch`

**Recommended Merge Process / 建議合併流程**:
```bash
# 1. Switch to master and update
git checkout master
git pull origin master

# 2. Merge with no-ff to preserve branch history
git merge --no-ff bugfix/nextjs-hydration-mismatch -m "Merge bugfix: 文檔重組與標準化

- 實施統一編號規範和邏輯目錄結構
- 建立完整文檔標準體系
- 修復所有內部引用，達成100%引用完整性
- 配置 Git no-ff merge 政策

Related: DOC-STD-001, DOC-TEMPLATE-001, DOC-REPORT-001
Reviewed-by: Documentation Team"

# 3. Push to remote
git push origin master

# 4. Clean up branch (optional, keep if needed for reference)
# git branch -d bugfix/nextjs-hydration-mismatch
# git push origin --delete bugfix/nextjs-hydration-mismatch
```

---

## Revision History / 修訂記錄

| Version / 版本 | Date / 日期 | Changes / 變更內容 | Author / 作者 |
|----------------|-------------|-------------------|---------------|
| v1.0 | 2025-11-03 | Initial Git branching strategy / 初版 Git 分支策略 | Tao Yu 和他的 GPT 智能助手 |
| v2.0 | 2025-11-06 | **Major Update**: Added no-fast-forward merge policy, standardized headers, bilingual content / **重大更新**：添加禁用快進合併政策，標準化標頭，雙語內容 | Tao Yu 和他的 GPT 智能助手 |

---

> **Maintenance / 維護**: DevOps Team / DevOps 團隊  
> **Review Cycle / 審查週期**: Quarterly / 每季度  
> **Next Review / 下次審查**: 2026-02-06  
> **Compliance / 合規**: All team members must follow no-ff merge policy / 所有團隊成員必須遵循 no-ff 合併政策