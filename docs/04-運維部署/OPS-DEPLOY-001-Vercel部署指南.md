# Vercel Deployment Guide / Vercel 部署指南

This guide covers the complete setup and deployment process for the Reinsurance System on Vercel.

本指南涵蓋再保險系統在 Vercel 上的完整設置和部署流程。

## Quick Start / 快速開始

### Prerequisites / 先決條件

1. **Vercel Account / Vercel 帳戶**
   - Sign up at [vercel.com](https://vercel.com) / 在 [vercel.com](https://vercel.com) 註冊
   - Install Vercel CLI: `npm i -g vercel` / 安裝 Vercel CLI
   - Login: `vercel login` / 登錄

2. **Database Setup / 數據庫設置**
   - Create Vercel Postgres database / 創建 Vercel Postgres 數據庫
   - Note the connection string / 記錄連接字符串

3. **Project Setup / 項目設置**
   ```bash
   # Clone the repository / 克隆倉庫
   git clone <repository-url>
   cd ri-app/code/ri-app
   
   # Install dependencies / 安裝依賴
   npm install
   
   # Configure environment variables / 配置環境變量
   cp .env.example .env.local
   ```

### Initial Deployment / 初始部署

1. **Link Project to Vercel / 將項目鏈接到 Vercel**
   ```bash
   vercel link
   ```

2. **Configure Environment Variables / 配置環境變量**
   ```bash
   # Set database URL / 設置數據庫 URL
   vercel env add DATABASE_URL
   
   # Set database provider / 設置數據庫提供商
   vercel env add DATABASE_PROVIDER
   ```

3. **Deploy to Preview / 部署到預覽環境**
   ```bash
   npm run deploy:preview-full
   ```

4. **Deploy to Production / 部署到生產環境**
   ```bash
   npm run deploy:prod-full
   ```

## Environment Configuration / 環境配置

### Required Environment Variables / 必需的環境變量

| Variable / 變量 | Description / 描述 | Example / 示例 |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string / PostgreSQL 連接字符串 | `postgresql://user:pass@host:5432/db?sslmode=require` |
| `DATABASE_PROVIDER` | Database provider / 數據庫提供商 | `postgresql` |
| `NODE_ENV` | Environment type / 環境類型 | `production` (auto-set by Vercel / 由 Vercel 自動設置) |
| `VERCEL_ENV` | Vercel environment / Vercel 環境 | `preview` or `production` (auto-set / 自動設置) |

### Optional Environment Variables / 可選環境變量

| Variable / 變量 | Description / 描述 | Default / 默認值 |
|----------|-------------|---------|
| `LOG_LEVEL` | Logging level / 日誌級別 | `info` |
| `ENABLE_AUDIT_TRAIL` | Enable audit logging / 啟用審計日誌 | `true` |
| `ENABLE_ANALYTICS` | Enable analytics / 啟用分析 | `false` |

### Setting Environment Variables / 設置環境變量

#### Via Vercel CLI / 通過 Vercel CLI
```bash
# Add environment variable / 添加環境變量
vercel env add VARIABLE_NAME

# List all environment variables / 列出所有環境變量
vercel env ls

# Remove environment variable / 移除環境變量
vercel env remove VARIABLE_NAME
```

#### Via Vercel Dashboard / 通過 Vercel 儀表板
1. Go to project settings / 進入項目設置
2. Click "Environment Variables" / 點擊"環境變量"
3. Add variables for specific environments / 為特定環境添加變量

## Database Setup / 數據庫設置

### Creating Vercel Postgres Database / 創建 Vercel Postgres 數據庫

1. **In Vercel Dashboard / 在 Vercel 儀表板中**
   - Go to Storage tab / 進入存儲選項卡
   - Click "Create Database" / 點擊"創建數據庫"
   - Select PostgreSQL / 選擇 PostgreSQL
   - Choose region (recommended: Hong Kong or Singapore) / 選擇區域（推薦：香港或新加坡）

2. **Configure Database / 配置數據庫**
   - Enable connection pooling / 啟用連接池
   - Set backup retention / 設置備份保留
   - Configure read replicas if needed / 如需要配置讀取副本

3. **Connect to Project / 連接到項目**
   - Select your project / 選擇您的項目
   - Vercel automatically sets `DATABASE_URL` / Vercel 自動設置 `DATABASE_URL`

### Database Migrations / 數據庫遷移

Migrations are automatically deployed during the build process:

遷移在構建過程中自動部署：

```bash
# Manual migration deployment / 手動遷移部署
npm run vercel:migrate

# Migration with build / 構建時遷移
npm run vercel-build
```

### Database Seeding / 數據庫種子數據

Seeding is automatically performed for preview environments:

預覽環境會自動執行種子數據：

```bash
# Manual seeding / 手動種子數據
npm run prisma:seed:postgres
```

## Deployment Process / 部署流程

### Preview Deployments / 預覽部署

Preview deployments are created for: / 預覽部署適用於：
- Pull requests / 拉取請求
- Push to non-main branches / 推送到非主分支
- Manual preview deployments / 手動預覽部署

```bash
# Deploy to preview / 部署到預覽環境
npm run deploy:preview-full

# Deploy with options / 帶選項部署
./scripts/deploy-vercel.sh preview --skip-tests
```

### Production Deployments / 生產部署

Production deployments are triggered by: / 生產部署觸發條件：
- Merge to main branch / 合併到主分支
- Manual production deployment / 手動生產部署

```bash
# Deploy to production / 部署到生產環境
npm run deploy:prod-full

# Deploy with options / 帶選項部署
./scripts/deploy-vercel.sh production --skip-checks
```

### Build-Only Mode / 僅構建模式

For testing builds without deployment: / 用於測試構建而不部署：

```bash
# Build only / 僅構建
./scripts/deploy-vercel.sh --build-only

# Or use npm script / 或使用 npm 腳本
npm run build:vercel
```

## Deployment Scripts / 部署腳本

### Available Scripts / 可用腳本

| Script / 腳本 | Description / 描述 |
|--------|-------------|
| `npm run deploy:preview` | Quick preview deployment / 快速預覽部署 |
| `npm run deploy:prod` | Quick production deployment / 快速生產部署 |
| `npm run deploy:preview-full` | Full preview deployment with checks / 帶檢查的完整預覽部署 |
| `npm run deploy:prod-full` | Full production deployment with checks / 帶檢查的完整生產部署 |
| `npm run vercel:migrate` | Run database migrations / 運行數據庫遷移 |
| `npm run build:vercel` | Build for Vercel deployment / 為 Vercel 部署構建 |

### Deployment Script Options / 部署腳本選項

The deployment script (`scripts/deploy-vercel.sh`) supports several options:

部署腳本（`scripts/deploy-vercel.sh`）支持多個選項：

```bash
# Show help / 顯示幫助
./scripts/deploy-vercel.sh --help

# Skip tests / 跳過測試
./scripts/deploy-vercel.sh preview --skip-tests

# Skip post-deployment checks / 跳過部署後檢查
./scripts/deploy-vercel.sh production --skip-checks

# Build only / 僅構建
./scripts/deploy-vercel.sh --build-only
```

## Health Monitoring / 健康監控

### Health Check Endpoint / 健康檢查端點

The application includes a comprehensive health check endpoint:

應用程序包含全面的健康檢查端點：

- **URL**: `/api/health`
- **Methods**: GET, HEAD
- **Response**: JSON with system status / 系統狀態的 JSON 響應

### Health Check Response / 健康檢查響應

```json
{
  "status": "healthy",
  "timestamp": "2025-01-01T00:00:00.000Z",
  "environment": "production",
  "version": "1.0.0",
  "uptime": 3600,
  "checks": {
    "database": {
      "status": "healthy",
      "responseTime": 45
    },
    "memory": {
      "status": "healthy",
      "usage": 134217728,
      "total": 268435456,
      "percentage": 50
    },
    "disk": {
      "status": "healthy"
    }
  },
  "metadata": {
    "lastDeployment": "https://your-app.vercel.app",
    "region": "hkg1",
    "nodeId": "vercel-node-123"
  }
}
```

### Automated Health Checks / 自動健康檢查

Vercel automatically runs health checks every 6 hours:

Vercel 每 6 小時自動運行健康檢查：

```json
{
  "crons": [
    {
      "path": "/api/health",
      "schedule": "0 */6 * * *"
    }
  ]
}
```

## Performance Optimization / 性能優化

### Edge Functions / 邊緣函數

API routes are configured as Edge Functions for better performance:

API 路由配置為邊緣函數以獲得更好的性能：

- **Max Duration / 最大持續時間**: 30 seconds / 30 秒
- **Regions / 區域**: Hong Kong, Singapore / 香港、新加坡
- **Auto-scaling / 自動擴展**: Enabled / 已啟用

## Troubleshooting / 故障排除

### Common Issues / 常見問題

1. **Database Connection Issues / 數據庫連接問題**
   - Check `DATABASE_URL` format / 檢查 `DATABASE_URL` 格式
   - Verify database is accessible / 驗證數據庫可訪問
   - Check connection pooling settings / 檢查連接池設置

2. **Build Failures / 構建失敗**
   - Check TypeScript errors / 檢查 TypeScript 錯誤
   - Verify all dependencies are installed / 驗證所有依賴已安裝
   - Review build logs in Vercel dashboard / 在 Vercel 儀表板中查看構建日誌

3. **Environment Variable Issues / 環境變量問題**
   - Ensure all required variables are set / 確保設置了所有必需變量
   - Check variable names and values / 檢查變量名稱和值
   - Verify environment-specific settings / 驗證特定環境設置

### Debug Commands / 調試命令

```bash
# Check deployment status / 檢查部署狀態
vercel ls

# View deployment logs / 查看部署日誌
vercel logs <deployment-url>

# Test local build / 測試本地構建
npm run build:vercel

# Check environment variables / 檢查環境變量
vercel env ls
```

## Best Practices / 最佳實踐

1. **Use Preview Deployments / 使用預覽部署**: Always test changes in preview before production / 在生產前始終在預覽中測試更改
2. **Monitor Performance / 監控性能**: Use Vercel Analytics and health checks / 使用 Vercel Analytics 和健康檢查
3. **Database Backups / 數據庫備份**: Regular backups for production data / 定期備份生產數據
4. **Environment Separation / 環境分離**: Keep development, preview, and production separate / 保持開發、預覽和生產環境分離
5. **Security / 安全**: Use environment variables for sensitive data / 使用環境變量存儲敏感數據

---

For more information, refer to: / 更多信息請參考：
- [Vercel Documentation](https://vercel.com/docs)
- [Next.js Deployment Guide](https://nextjs.org/docs/deployment)
- [Environment Setup Guide](environment-setup-guide.md)