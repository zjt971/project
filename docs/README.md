# Reinsurance Management System / 再保險管理系統

A comprehensive digital platform designed to modernize and streamline reinsurance operations for insurance companies.

一個全面的數位平台，旨在為保險公司現代化和簡化再保險業務。

## 🚀 Quick Start / 快速開始

### For New Developers / 新開發者指南

1. **Quick Setup (5 minutes) / 快速設置（5分鐘）**: [Environment Quick Start Guide](03-開發指南/DEV-GUIDE-003-環境快速開始.md)
2. **Complete Setup / 完整設置**: [Environment Setup Guide](03-開發指南/DEV-GUIDE-002-環境設置指南.md)
3. **Verification Checklist / 驗證清單**: [Environment Checklist](06-品質保證/QA-CHECKLIST-001-環境檢查清單.md)

### Local Development / 本地開發

```bash
# Clone and setup / 克隆並設置
git clone <repository-url>
cd ri-management/code/ri-app
npm install

# Initialize environment / 初始化環境
cp .env.example .env.local
npm run setup:dev

# Start development / 開始開發
npm run dev
```

### Vercel Deployment / Vercel 部署

```bash
# Setup Vercel / 設置 Vercel
npm i -g vercel
vercel login
vercel link

# Deploy to preview / 部署到預覽環境
npm run deploy:preview

# Deploy to production / 部署到生產環境
npm run deploy:prod
```

## 📋 Table of Contents / 目錄

- [Overview / 概述](#-overview--概述)
- [Features / 功能特性](#-features--功能特性)
- [Architecture / 架構](#-architecture--架構)
- [Development / 開發](#-development--開發)
- [Deployment / 部署](#-deployment--部署)
- [Documentation / 文檔](#-documentation--文檔)
- [Contributing / 貢獻](#-contributing--貢獻)

## 🎯 Overview / 概述

The Reinsurance Management System addresses critical inefficiencies in traditional reinsurance management processes by providing:

再保險管理系統通過提供以下功能來解決傳統再保險管理流程中的關鍵低效問題：

- **Centralized Data Management / 集中數據管理**: Single source of truth for all reinsurance data / 所有再保險數據的單一真實來源
- **Automated Workflows / 自動化工作流程**: Streamlined processes for treaty and facultative management / 合約和臨分管理的簡化流程
- **Real-time Visibility / 實時可見性**: Instant access to portfolio status and metrics / 即時訪問投資組合狀態和指標
- **Comprehensive Audit Trail / 全面審計跟蹤**: Complete tracking of all data changes / 完整跟蹤所有數據變更
- **Regulatory Compliance / 法規合規**: Built-in compliance with IFRS17 and other regulations / 內建 IFRS17 和其他法規合規性

## ✨ Features / 功能特性

### Core Modules / 核心模組

1. **Reinsurer Management / 再保險人管理**
   - Complete CRUD operations for reinsurer entities / 再保險人實體的完整 CRUD 操作
   - Contact information and relationship management / 聯絡資訊和關係管理
   - Financial and regulatory status tracking / 財務和監管狀態跟蹤
   - Document management and compliance verification / 文檔管理和合規驗證

2. **Treaty Management / 合約管理**
   - Creation and maintenance of reinsurance treaties / 再保險合約的創建和維護
   - Financial terms and conditions management / 財務條款和條件管理
   - Status tracking and lifecycle management / 狀態跟蹤和生命週期管理
   - Automated calculations and reporting / 自動計算和報告

3. **Facultative Management / 臨分管理**
   - Rapid case creation for special risks / 特殊風險的快速案例創建
   - Risk coverage verification against existing treaties / 針對現有合約的風險覆蓋驗證
   - Quotation and document management / 報價和文檔管理
   - Multi-currency support for international cases / 國際案例的多幣種支持

4. **Claims and Settlement / 理賠和結算**
   - Import and processing of reinsurance claims / 再保險理賠的導入和處理
   - Tracking of reinsurer responses / 再保險人回應跟蹤
   - Automatic SoA (Statement of Account) generation / 自動生成 SoA（對帳單）
   - Adjustment capabilities for discrepancies / 差異調整功能

### Technical Features / 技術特性

- **Modern Tech Stack / 現代技術棧**: Next.js 16, React 19, TypeScript, Prisma
- **Database Flexibility / 數據庫靈活性**: SQLite for development, PostgreSQL for production / 開發使用 SQLite，生產使用 PostgreSQL
- **Responsive Design / 響應式設計**: Mobile-first approach with Tailwind CSS / 使用 Tailwind CSS 的移動優先方法
- **Type Safety / 類型安全**: End-to-end TypeScript integration / 端到端 TypeScript 集成
- **Testing / 測試**: Comprehensive unit and integration tests / 全面的單元和集成測試
- **Audit Trail / 審計跟蹤**: Automatic tracking of all data changes / 自動跟蹤所有數據變更

## 🏗️ Architecture / 架構

### System Architecture / 系統架構

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer / 表現層              │
│  React Components │ Server Actions │ Next.js App Router    │
├─────────────────────────────────────────────────────────────┤
│                    Application Layer / 應用層               │
│  API Endpoints │ Input Validation │ Error Handling         │
├─────────────────────────────────────────────────────────────┤
│                   Business Logic Layer / 業務邏輯層         │
│  Reinsurer Service │ Treaty Service │ Audit Service        │
├─────────────────────────────────────────────────────────────┤
│                    Data Access Layer / 數據訪問層           │
│  Reinsurer Repo │ Treaty Repo │ Audit Repo │ Prisma ORM   │
├─────────────────────────────────────────────────────────────┤
│                  Infrastructure Layer / 基礎設施層          │
│  SQLite (Dev) │ PostgreSQL (Prod) │ Vercel │ Monitoring   │
└─────────────────────────────────────────────────────────────┘
```

### Technology Stack / 技術棧

- **Frontend / 前端**: Next.js 16, React 19, TypeScript, Tailwind CSS
- **Backend / 後端**: Next.js Server Actions, Prisma ORM
- **Database / 數據庫**: SQLite (development), PostgreSQL (production)
- **Deployment / 部署**: Vercel with automatic CI/CD
- **Testing / 測試**: Vitest, Testing Library, MSW
- **State Management / 狀態管理**: TanStack Query, React Context

## 💻 Development / 開發

### Prerequisites / 先決條件

- Node.js 18+ and npm 9+ / Node.js 18+ 和 npm 9+
- Git for version control / Git 版本控制
- VS Code (recommended) with extensions / VS Code（推薦）及擴展

### Environment Setup / 環境設置

1. **Local Development / 本地開發**: Follow the [Environment Quick Start Guide](03-開發指南/DEV-GUIDE-003-環境快速開始.md)
2. **Complete Setup / 完整設置**: See the [Environment Setup Guide](03-開發指南/DEV-GUIDE-002-環境設置指南.md)
3. **Verification / 驗證**: Use the [Environment Checklist](06-品質保證/QA-CHECKLIST-001-環境檢查清單.md)

### Development Workflow / 開發工作流程

```bash
# Feature development / 功能開發
git checkout -b feature/new-feature
npm run dev
# Develop and test locally / 本地開發和測試
git push origin feature/new-feature
# Auto-deploys to preview for review / 自動部署到預覽環境進行審查

# Production deployment / 生產部署
git checkout main
git merge feature/new-feature
git push origin main
# Auto-deploys to production / 自動部署到生產環境
```

### Available Scripts / 可用腳本

```bash
# Development / 開發
npm run dev              # Start development server / 啟動開發服務器
npm run dev:sqlite       # SQLite development / SQLite 開發
npm run dev:postgres     # PostgreSQL development / PostgreSQL 開發

# Database / 數據庫
npm run db:studio        # Open Prisma Studio / 打開 Prisma Studio
npm run db:init:sqlite   # Initialize SQLite database / 初始化 SQLite 數據庫
npm run db:reset:sqlite  # Reset SQLite database / 重置 SQLite 數據庫

# Testing / 測試
npm run test             # Run all tests / 運行所有測試
npm run test:unit        # Run unit tests / 運行單元測試
npm run test:integration # Run integration tests / 運行集成測試

# Building / 構建
npm run build            # Build for production / 生產構建
npm run build:sqlite     # Build with SQLite / 使用 SQLite 構建
npm run build:vercel     # Build for Vercel / 為 Vercel 構建

# Deployment / 部署
npm run deploy:preview   # Deploy to preview / 部署到預覽環境
npm run deploy:prod      # Deploy to production / 部署到生產環境
```

## 🚀 Deployment / 部署

### Environment Support / 環境支持

- **Local Development / 本地開發**: SQLite with hot reload / SQLite 熱重載
- **Vercel Preview / Vercel 預覽**: PostgreSQL with automatic deployment / PostgreSQL 自動部署
- **Vercel Production / Vercel 生產**: PostgreSQL with CDN and analytics / PostgreSQL 配 CDN 和分析

### Deployment Process / 部署流程

1. **Preview Deployments / 預覽部署**: Automatic on push to non-main branches / 推送到非主分支時自動部署
2. **Production Deployments / 生產部署**: Automatic on merge to main branch / 合併到主分支時自動部署
3. **Manual Deployments / 手動部署**: Using npm scripts or Vercel CLI / 使用 npm 腳本或 Vercel CLI

### Environment Variables / 環境變量

| Variable / 變量 | Local / 本地 | Preview / 預覽 | Production / 生產 | Description / 描述 |
|----------|-------|---------|------------|-------------|
| `DATABASE_PROVIDER` | `sqlite` | `postgresql` | `postgresql` | Database provider / 數據庫提供商 |
| `DATABASE_URL` | `file:./prisma/dev.db` | Vercel Postgres URL | Vercel Postgres URL | Database connection / 數據庫連接 |
| `NODE_ENV` | `development` | `production` | `production` | Node environment / Node 環境 |
| `LOG_LEVEL` | `debug` | `info` | `warn` | Logging level / 日誌級別 |

For detailed deployment instructions, see: / 詳細部署說明請參見：
- [Environment Setup Guide](03-開發指南/DEV-GUIDE-002-環境設置指南.md)
- [Vercel Deployment Guide](04-運維部署/OPS-DEPLOY-001-Vercel部署指南.md)

## 📚 Documentation / 文檔

### 📁 Documentation Structure / 文檔結構

#### 01-專案管理 / Project Management
- [Project Plan](01-專案管理/PM-PLAN-001-專案計劃.md) - Overall project plan / 整體項目計劃
- [Sprint Plan](01-專案管理/PM-PLAN-002-Sprint計劃.md) - Sprint planning / Sprint 規劃
- [Task Tracker](01-專案管理/PM-REPORT-001-任務追蹤.md) - Task tracking / 任務跟蹤
- [Project Charter](01-專案管理/PM-CHARTER-001-專案章程.md) - Project charter / 專案章程

#### 02-架構設計 / Architecture Design
- [Layered Architecture](02-架構設計/ARCH-ADR-001-分層架構.md) - System architecture / 系統架構
- [Database Strategy](02-架構設計/ARCH-ADR-002-資料庫策略.md) - Database design / 資料庫設計
- [Testing Strategy](02-架構設計/ARCH-ADR-004-測試策略.md) - Testing approach / 測試方法
- [Internationalization Strategy](02-架構設計/ARCH-ADR-008-國際化策略.md) - i18n strategy / 國際化策略

#### 03-開發指南 / Development Guides
- [Developer Handbook](03-開發指南/DEV-GUIDE-001-開發人員手冊.md) - Development guidelines / 開發指南
- [Environment Setup Guide](03-開發指南/DEV-GUIDE-002-環境設置指南.md) - Comprehensive setup / 全面設置
- [Environment Quick Start](03-開發指南/DEV-GUIDE-003-環境快速開始.md) - 5-minute setup / 5分鐘設置
- [App Development Guide](03-開發指南/DEV-GUIDE-004-應用開發指南.md) - Application development / 應用開發

#### 04-運維部署 / Operations & Deployment
- [Vercel Deployment Guide](04-運維部署/OPS-DEPLOY-001-Vercel部署指南.md) - Deployment specifics / 部署詳情
- [Git Branching Process](04-運維部署/OPS-PROCESS-001-Git分支流程.md) - Git workflow / Git 工作流程
- [CI/CD Strategy](04-運維部署/OPS-STRATEGY-001-測試部署策略.md) - CI/CD approach / CI/CD 方法

#### 06-品質保證 / Quality Assurance
- [Environment Checklist](06-品質保證/QA-CHECKLIST-001-環境檢查清單.md) - Verification checklist / 驗證清單
- [Implementation Summary](06-品質保證/QA-REPORT-001-臨分實施總結.md) - Implementation reports / 實施報告

#### 08-用戶界面 / User Interface
- [UI/UX Guidelines](08-用戶界面/UI-GUIDE-001-界面設計指南.md) - Design specifications / 設計規格

### Requirements and Specifications / 需求和規格

- [Product Requirements](../requirement/EIS-REINS-PRD-001.md) - Product requirements / 產品需求
- [Functional Requirements](../requirement/) - Use cases / 用例

## 🤝 Contributing / 貢獻

We welcome contributions! Please follow these steps: / 我們歡迎貢獻！請遵循以下步驟：

1. **Fork the Repository / 分叉倉庫**
   ```bash
   git clone https://github.com/your-username/ri-management.git
   ```

2. **Create a Feature Branch / 創建功能分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes / 進行更改**
   - Follow the coding standards / 遵循編碼標準
   - Add tests for new functionality / 為新功能添加測試
   - Update documentation / 更新文檔

4. **Test Your Changes / 測試您的更改**
   ```bash
   npm run test
   npm run lint
   ```

5. **Submit a Pull Request / 提交拉取請求**
   - Provide a clear description of changes / 提供清晰的更改描述
   - Include screenshots for UI changes / 為 UI 更改包含截圖
   - Link relevant issues / 鏈接相關問題

### Development Guidelines / 開發指南

- Follow the existing code style and patterns / 遵循現有的代碼風格和模式
- Write meaningful commit messages / 編寫有意義的提交消息
- Add tests for new features / 為新功能添加測試
- Update documentation as needed / 根據需要更新文檔
- Ensure all tests pass before submitting / 確保所有測試在提交前通過

### Code Review Process / 代碼審查流程

1. All changes require review / 所有更改都需要審查
2. Automated tests must pass / 自動化測試必須通過
3. Documentation should be updated / 應更新文檔
4. Follow the [Git Branching Strategy](02-架構設計/ARCH-ADR-006-Git分支策略.md)

## 📞 Support / 支持

### Getting Help / 獲取幫助

1. **Documentation / 文檔**: Check the [documentation](#-documentation--文檔) section
2. **Issues / 問題**: Search existing GitHub issues
3. **Discussions / 討論**: Join our GitHub discussions
4. **Team / 團隊**: Contact the development team for urgent matters / 緊急事項請聯繫開發團隊

### Reporting Issues / 報告問題

When reporting issues, please include: / 報告問題時，請包括：

- Clear description of the problem / 問題的清晰描述
- Steps to reproduce / 重現步驟
- Expected vs actual behavior / 預期與實際行為
- Environment details / 環境詳情
- Screenshots if applicable / 如適用，請提供截圖

### Feature Requests / 功能請求

We welcome feature requests! Please: / 我們歡迎功能請求！請：

- Check if it's already requested / 檢查是否已被請求
- Provide clear use case / 提供清晰的用例
- Explain the benefit / 解釋好處
- Consider implementation complexity / 考慮實現複雜性

## 📄 License / 許可證

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

本項目採用 MIT 許可證 - 詳情請參見 [LICENSE](LICENSE) 文件。

## 🙏 Acknowledgments / 致謝

- Development team for their dedication and expertise / 開發團隊的奉獻和專業知識
- Stakeholders for their valuable feedback and guidance / 利益相關者的寶貴反饋和指導
- Open source community for the tools and libraries that make this project possible / 開源社區提供的工具和庫使這個項目成為可能

---

**For the most up-to-date information, please refer to the documentation in the [docs](.) directory.**

**最新信息請參考 [docs](.) 目錄中的文檔。**