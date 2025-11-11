# Environment Setup Guide

This guide provides comprehensive documentation for setting up and managing coexistence between local development and Vercel deployment environments for the Reinsurance System.

> **更新狀態**：✅ 已實作 - 本指南反映實際的 Vercel 部署功能和雙環境架構

## Table of Contents

1. [Environment Setup Overview](#1-environment-setup-overview)
2. [Local Development Setup](#2-local-development-setup)
3. [Vercel Deployment Setup](#3-vercel-deployment-setup)
4. [Environment Configuration Details](#4-environment-configuration-details)
5. [Development Workflow](#5-development-workflow)
6. [Troubleshooting Guide](#6-troubleshooting-guide)
7. [Maintenance and Updates](#7-maintenance-and-updates)

---

## 1. Environment Setup Overview

### Purpose and Benefits

The Reinsurance System is designed to operate seamlessly across multiple environments with clear separation between local development and production deployments. This approach provides several key benefits:

- **Isolation**: Local development uses SQLite for simplicity, while production uses PostgreSQL for scalability
- **Consistency**: Shared business logic and UI components ensure consistent behavior across environments
- **Flexibility**: Easy switching between database providers and environments
- **Safety**: Environment-specific configurations prevent accidental data corruption
- **Efficiency**: Optimized workflows for different development stages

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Development Flow                          │
├─────────────────────────────────────────────────────────────┤
│  Local Development    │    Vercel Preview    │   Production │
│  ─────────────────    │    ───────────────    │   ────────── │
│  • SQLite Database    │    • PostgreSQL      │   • PostgreSQL│
│  • Hot Reload         │    • Auto-deploy      │   • CDN       │
│  • Debug Logging      │    • Isolated URL     │   • Analytics │
│  • Seed Data          │    • Shared DB*       │   • Monitoring│
│  • Prisma Studio      │    • Health Checks    │   • Backups   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Shared Components                         │
│  • Business Logic (Services)                               │
│  • UI Components                                           │
│  • API Routes (Server Actions)                             │
│  • Type Definitions                                        │
│  • Validation Schemas                                      │
└─────────────────────────────────────────────────────────────┘
```

*Preview environments can share the production database for testing or use a separate instance.

### Key Differences and Considerations

| Aspect | Local Development | Vercel Preview | Vercel Production |
|--------|-------------------|----------------|-------------------|
| **Database** | SQLite (file-based) | PostgreSQL (shared or isolated) | PostgreSQL (dedicated) |
| **Environment Variables** | `.env.local` file | Vercel Dashboard | Vercel Dashboard |
| **Logging Level** | Debug | Info | Warn |
| **Performance Monitoring** | Manual | Basic | Full Analytics |
| **Security** | Development headers | Production headers | Full security suite |
| **Data Persistence** | Persistent (local file) | Configurable | Persistent with backups |
| **Build Process** | On-demand | Automatic on push | Automatic on merge |

---

## 2. Local Development Setup

### Prerequisites

Before setting up local development, ensure you have the following installed:

- **Node.js** (v18 or higher) - 驗證：`node --version`
- **npm** (v9 or higher) - 驗證：`npm --version`
- **Git** (for version control) - 驗證：`git --version`
- **VS Code** (recommended IDE with extensions)
- **Vercel CLI** (for deployment) - 安裝：`npm i -g vercel`

### Step-by-Step Setup Instructions

#### 1. Clone and Install Dependencies

```bash
# Clone the repository
git clone <repository-url>
cd ri-management/code/ri-app

# Install dependencies
npm install

# Verify installation
npm run lint
```

#### 2. Environment Variable Configuration

Create a local environment file:

```bash
# Create environment file
cp .env.example .env.local
```

Configure your `.env.local` file:

```bash
# Database Configuration
DATABASE_PROVIDER=sqlite
DATABASE_URL=file:./prisma/dev.db

# Environment Settings
NODE_ENV=development
LOG_LEVEL=debug

# Feature Flags
ENABLE_AUDIT_TRAIL=true
ENABLE_ANALYTICS=false

# Optional: Override default ports
PORT=3000
```

#### 3. Database Setup (SQLite)

Initialize the local SQLite database:

```bash
# Initialize database with migrations and seed data
npm run setup:dev

# Verify database setup
npm run db:validate

# Open database management tool
npm run db:studio:sqlite
```

**驗證步驟**：
1. 確認 `prisma/dev.db` 檔案已建立
2. 訪問 `http://localhost:3000` 確認應用正常運行
3. 檢查 `/api/health` 端點回應正常

#### 4. Start Development Server

```bash
# Start with SQLite (default)
npm run dev

# Or explicitly specify SQLite
npm run dev:sqlite

# For PostgreSQL development (if configured)
npm run dev:postgres
```

The development server will start at `http://localhost:3000`.

#### 5. Database Management

Use Prisma Studio for database management:

```bash
# Open Prisma Studio
npm run db:studio:sqlite

# Or use the generic command (auto-detects provider)
npm run db:studio
```

### Common Troubleshooting Steps

#### Database Connection Issues

```bash
# Check database configuration
npm run db:validate

# Reset database if needed
npm run db:reset:sqlite

# Re-initialize from scratch
rm -f prisma/dev.db
npm run db:init:sqlite
npm run prisma:seed:sqlite
```

#### Port Conflicts

```bash
# Kill processes on port 3000
lsof -ti:3000 | xargs kill -9

# Or use a different port
PORT=3001 npm run dev
```

#### Dependency Issues

```bash
# Clean install
rm -rf node_modules package-lock.json
npm install

# Clear Next.js cache
rm -rf .next
npm run dev
```

---

## 3. Vercel Deployment Setup

### Prerequisites

- **Vercel Account**: Sign up at [vercel.com](https://vercel.com)
- **Vercel CLI**: Install with `npm i -g vercel`
- **GitHub Integration**: Connect your repository to Vercel

### Vercel Project Configuration Steps

#### 1. Initial Project Setup

```bash
# Login to Vercel
vercel login

# Link project to Vercel
cd code/ri-app
vercel link

# Follow the prompts to configure:
# - Project name (ri-app)
# - Framework (Next.js)
# - Build settings (auto-detected)
# - Deployment directory (.)
```

#### 2. Database Configuration

Create Vercel Postgres database:

1. **In Vercel Dashboard**:
   - Go to Storage tab
   - Click "Create Database"
   - Select PostgreSQL
   - Choose region (recommended: Hong Kong or Singapore)

2. **Connect Database to Project**:
   - Select your project
   - Choose the database
   - Vercel automatically sets `DATABASE_URL`

#### 3. Environment Variable Setup

Configure environment variables in Vercel dashboard:

##### Via Vercel CLI

```bash
# Add database URL (provided by Vercel Postgres)
vercel env add DATABASE_URL

# Set database provider
vercel env add DATABASE_PROVIDER

# Add optional variables
vercel env add LOG_LEVEL
vercel env add ENABLE_AUDIT_TRAIL
vercel env add ENABLE_ANALYTICS
```

##### Via Vercel Dashboard

1. Go to project settings
2. Click "Environment Variables"
3. Add variables for specific environments:

**Preview Environment**:
```
DATABASE_PROVIDER=postgresql
DATABASE_URL=postgresql://user:password@host:5432/db?sslmode=require
LOG_LEVEL=info
ENABLE_AUDIT_TRAIL=true
ENABLE_ANALYTICS=false
```

**Production Environment**:
```
DATABASE_PROVIDER=postgresql
DATABASE_URL=postgresql://user:password@host:5432/db?sslmode=require
LOG_LEVEL=warn
ENABLE_AUDIT_TRAIL=true
ENABLE_ANALYTICS=true
```

#### 4. Database Configuration (Vercel Postgres)

The application is configured to use PostgreSQL on Vercel with these settings:

```prisma
// prisma/schema.prisma
generator client {
  provider      = "prisma-client-js"
  binaryTargets = ["native", "rhel-openssl-3.0.x"]
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
```

Key configuration points:
- **SSL Mode**: Required for Vercel Postgres connections
- **Binary Targets**: Optimized for Vercel's runtime
- **Connection Pooling**: Automatically managed by Vercel

#### 5. Deployment Process and Verification

##### Automated Deployment

Deployments are automatically triggered by:
- **Preview**: Push to non-main branches, pull requests
- **Production**: Merge to main branch

##### Manual Deployment

```bash
# 快速部署
npm run deploy:preview               # 部署到預覽環境
npm run deploy:prod                  # 部署到生產環境

# 完整部署（推薦）
npm run deploy:preview-full          # 含測試和健康檢查
npm run deploy:prod-full             # 含完整驗證流程

# 進階部署腳本
./scripts/deploy-vercel.sh preview  # 使用腳本部署
./scripts/deploy-vercel.sh production --skip-tests  # 跳過測試
./scripts/deploy-vercel.sh --build-only  # 僅建置不部署
```

##### Deployment Verification

1. **自動驗證**（部署腳本內建）：
   - 環境變數檢查
   - 資料庫連線測試
   - 健康檢查端點驗證
   - 基本功能測試

2. **手動驗證**：
   ```bash
   # 檢查建置日誌
   vercel logs
   
   # 驗證健康檢查端點
   curl https://your-app.vercel.app/api/health
   
   # 檢查環境變數
   vercel env ls
   
   # 測試主要功能
   # 訪問部署 URL，測試合約和再保人管理功能
   ```

3. **監控指標**：
   - 回應時間 < 2 秒
   - 健康檢查狀態：`healthy`
   - 資料庫連線正常
   - 無 JavaScript 錯誤

---

## 4. Environment Configuration Details

### Environment-Specific Files

The application uses several configuration files to manage different environments:

#### 1. Environment Detection (`src/config/environment.ts`)

This file provides environment-aware configuration:

```typescript
export function getEnvironment(): Environment {
  // Vercel provides VERCEL_ENV for preview/production environments
  if (process.env.VERCEL_ENV) {
    return process.env.VERCEL_ENV as Environment;
  }
  
  // Fallback to NODE_ENV for local development
  return (process.env.NODE_ENV as Environment) || 'development';
}

export function getDatabaseProvider(): 'sqlite' | 'postgresql' {
  // In production/preview on Vercel, always use PostgreSQL
  if (isVercel()) {
    return 'postgresql';
  }
  
  // For local development, check environment variable or default to SQLite
  const provider = process.env.DATABASE_PROVIDER as 'sqlite' | 'postgresql';
  return provider || 'sqlite';
}
```

#### 2. Database Configuration (`src/config/database.ts`)

Handles database provider switching and validation:

```typescript
export function getDatabaseConfig(): DatabaseConfig {
  // Determine provider based on environment or explicit setting
  let provider: "sqlite" | "postgresql";
  
  if (process.env.DATABASE_PROVIDER) {
    provider = process.env.DATABASE_PROVIDER as "sqlite" | "postgresql";
  } else {
    provider = getDatabaseProvider();
  }

  const url = process.env.DATABASE_URL as string;
  const schemaPath = getSchemaPath(provider);

  return { provider, url, schemaPath };
}
```

#### 3. Schema Files

**PostgreSQL Schema** (`prisma/schema.prisma`):
- Uses `Json` type for flexible data storage
- `Decimal` type for financial calculations
- `uuid()` for primary keys
- Optimized for production scalability

**SQLite Schema** (`prisma/schema-sqlite.prisma`):
- Uses `String` type instead of `Json` (SQLite limitation)
- `Float` type instead of `Decimal` (SQLite limitation)
- `cuid()` for primary keys
- Optimized for local development

### Database Configuration Differences

| Feature | SQLite (Local) | PostgreSQL (Vercel) |
|--------|----------------|---------------------|
| **Data Types** | String, Float | Json, Decimal |
| **Primary Keys** | cuid() | uuid() |
| **Connection** | file:./path | postgresql://url |
| **SSL** | Not required | Required (sslmode=require) |
| **Connection Pooling** | Not applicable | Automatic |
| **Backups** | File-based | Automated by Vercel |

### Build Process Variations

#### Local Development Build

```bash
# SQLite build
npm run build:sqlite
# Equivalent to:
cross-env DATABASE_PROVIDER=sqlite npm run prisma:generate:env && next build
```

#### Vercel Build

```bash
# Vercel build (automatic)
npm run vercel-build
# Equivalent to:
cross-env DATABASE_PROVIDER=postgresql npm run prisma:generate:env && npm run prisma:migrate:deploy && next build
```

Key differences:
1. **Schema Selection**: Automatic based on `DATABASE_PROVIDER`
2. **Migration Deployment**: Only on Vercel
3. **Client Generation**: Environment-specific schema
4. **Build Optimization**: Production optimizations on Vercel

### Environment Detection Logic

The application uses a hierarchical approach to environment detection:

1. **Vercel Environment** (`VERCEL_ENV`):
   - `preview` for preview deployments
   - `production` for production deployments

2. **Node Environment** (`NODE_ENV`):
   - `development` for local development
   - `test` for testing environments

3. **Fallbacks**:
   - Default to `development` if not specified
   - Default to `sqlite` for local development

---

## 5. Development Workflow

### How to Switch Between Environments

#### Local Development Modes

```bash
# SQLite development (default)
npm run dev

# Explicit SQLite
npm run dev:sqlite

# PostgreSQL development (if configured)
npm run dev:postgres
```

#### Environment Variable Switching

Create multiple environment files for different setups:

```bash
# .env.local (default SQLite)
DATABASE_PROVIDER=sqlite
DATABASE_URL=file:./prisma/dev.db

# .env.local.postgres (PostgreSQL development)
DATABASE_PROVIDER=postgresql
DATABASE_URL=postgresql://localhost:5432/reins_dev
```

Switch between configurations:

```bash
# Use default SQLite
npm run dev

# Use PostgreSQL
cp .env.local.postgres .env.local
npm run dev
```

#### Database Provider Switching

The application automatically detects the database provider:

```typescript
// Automatic detection based on environment
const provider = isVercel() ? 'postgresql' : 
                 process.env.DATABASE_PROVIDER || 'sqlite';
```

### Testing Strategies for Each Environment

#### Local Development Testing

```bash
# Unit tests (SQLite)
npm run test:unit

# Integration tests (SQLite)
npm run test:integration:sqlite

# All tests
npm run test
```

#### Vercel Environment Testing

```bash
# Integration tests (PostgreSQL)
npm run test:integration:postgres

# Build testing
npm run build:vercel

# Deployment testing
npm run deploy:preview
```

#### Environment-Specific Test Configuration

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    environment: 'node',
    setupFiles: ['./src/tests/setup.ts'],
    // Use single thread for database tests
    pool: 'threads',
    poolOptions: {
      threads: {
        singleThread: true,
      },
    },
  },
});
```

### Deployment Workflow

#### Feature Development Workflow

1. **Create Feature Branch**:
   ```bash
   git checkout -b feature/new-feature
   ```

2. **Local Development**:
   ```bash
   npm run dev:sqlite
   # Develop and test locally
   ```

3. **Commit and Push**:
   ```bash
   git add .
   git commit -m "feat: add new feature"
   git push origin feature/new-feature
   ```

4. **Preview Deployment**:
   - Automatic preview deployment on push
   - Test in preview environment
   - Share URL for review

5. **Merge to Main**:
   ```bash
   # After approval
   git checkout main
   git merge feature/new-feature
   git push origin main
   ```

6. **Production Deployment**:
   - Automatic production deployment on merge
   - Monitor deployment health
   - Verify functionality

#### Hotfix Workflow

1. **Create Hotfix Branch**:
   ```bash
   git checkout -b hotfix/critical-bug
   ```

2. **Quick Fix and Test**:
   ```bash
   npm run dev:sqlite
   # Test fix locally
   ```

3. **Deploy to Preview**:
   ```bash
   npm run deploy:preview
   # Verify fix in preview
   ```

4. **Emergency Production Deploy**:
   ```bash
   npm run deploy:prod
   # Direct production deployment
   ```

### Best Practices and Common Pitfalls

#### Best Practices

1. **Environment Consistency**:
   - Keep business logic identical across environments
   - Use environment variables for configuration differences
   - Test in preview before production deployment

2. **Database Management**:
   - Use migrations for schema changes
   - Test migrations on local SQLite first
   - Verify PostgreSQL compatibility

3. **Security**:
   - Never commit secrets to version control
   - Use different secrets for preview/production
   - Regularly rotate environment variables

4. **Performance**:
   - Monitor build times and optimize
   - Use appropriate database indexes
   - Implement caching strategies

#### Common Pitfalls

1. **Schema Mismatches**:
   - SQLite and PostgreSQL schemas diverge
   - **Solution**: Keep schemas in sync, test both providers

2. **Environment Variable Conflicts**:
   - Local `.env` overrides Vercel settings
   - **Solution**: Use `.env.local` for local, Vercel dashboard for deployment

3. **Migration Failures**:
   - PostgreSQL-specific features in SQLite
   - **Solution**: Test migrations with both providers

4. **Build Errors**:
   - Missing environment variables during build
   - **Solution**: Set all required variables in Vercel dashboard

---

## 6. Troubleshooting Guide

### Common Issues and Solutions

#### Build and Deployment Issues

##### 1. Database Connection Error

**Symptoms**:
- Build fails with database connection error
- Runtime database connection timeout

**Solutions**:

```bash
# Check environment variables
vercel env ls

# Validate database configuration
npm run db:validate

# Test database connection
node -e "
const { getDatabaseConfig } = require('./src/config/database.js');
const config = getDatabaseConfig();
console.log('Database config:', config);
"
```

**Common Causes**:
- Missing `DATABASE_URL`
- Incorrect SSL configuration
- Firewall or network issues

##### 2. Prisma Generation Error

**Symptoms**:
- Build fails during Prisma client generation
- Type errors related to database schema

**Solutions**:

```bash
# Check schema path
echo "Schema path: $(node -e "console.log(require('./src/config/database.js').getDatabaseConfig().schemaPath)")"

# Manually generate client
npm run prisma:generate:postgres

# Validate schema
npx prisma validate --schema=./prisma/schema.prisma
```

**Common Causes**:
- Wrong schema file path
- Schema syntax errors
- Missing binary targets

##### 3. Migration Failures

**Symptoms**:
- Database migration fails during deployment
- Schema mismatch errors

**Solutions**:

```bash
# Check migration status
npx prisma migrate status --schema=./prisma/schema.prisma

# Reset and re-migrate (development only)
npm run db:reset:postgres

# Manual migration deployment
npm run prisma:migrate:deploy:postgres
```

**Common Causes**:
- Migration order issues
- Schema conflicts
- Database permission issues

### Environment-Specific Problems

#### Local Development Issues

##### 1. SQLite Database Lock

**Symptoms**:
- Database locked errors
- Cannot run migrations

**Solutions**:

```bash
# Check for running processes
lsof | grep dev.db

# Kill processes using the database
pkill -f "prisma"

# Remove lock file (if safe)
rm -f prisma/dev.db-journal
```

##### 2. Port Conflicts

**Symptoms**:
- Port 3000 already in use
- Development server fails to start

**Solutions**:

```bash
# Find process using port 3000
lsof -ti:3000

# Kill the process
lsof -ti:3000 | xargs kill -9

# Or use different port
PORT=3001 npm run dev
```

#### Vercel Deployment Issues

##### 1. Environment Variable Not Found

**Symptoms**:
- Build fails with missing environment variable
- Runtime errors accessing configuration

**Solutions**:

```bash
# List all environment variables
vercel env ls

# Add missing variable
vercel env add VARIABLE_NAME

# Redeploy to apply changes
vercel --prod
```

##### 2. Function Timeout

**Symptoms**:
- API routes timeout after 30 seconds
- Slow database queries

**Solutions**:

```bash
# Check function configuration in vercel.json
# Increase timeout if needed
{
  "functions": {
    "src/app/api/**/*.ts": {
      "maxDuration": 60  // Increase from 30
    }
  }
}

# Optimize database queries
# Add appropriate indexes
# Implement caching
```

### Database Connection Issues

#### PostgreSQL Connection Problems

##### 1. SSL Certificate Error

**Symptoms**:
- SSL verification failed
- Connection refused

**Solutions**:

```bash
# Update DATABASE_URL to include SSL
# Add ?sslmode=require to connection string
postgresql://user:password@host:5432/db?sslmode=require

# For development, you might need:
postgresql://user:password@host:5432/db?sslmode=prefer
```

##### 2. Connection Pool Exhaustion

**Symptoms**:
- Too many connections error
- Intermittent database failures

**Solutions**:

```typescript
// In database configuration
export function getDatabaseConnectionOptions() {
  const options = {
    // Connection pool settings
    connectionLimit: 10,
    // Enable connection pooling
    pool: {
      min: 2,
      max: 10,
    },
  };
  
  return options;
}
```

### Build and Deployment Problems

#### 1. Memory Limit Exceeded

**Symptoms**:
- Build fails with out of memory error
- Node.js heap memory limit exceeded

**Solutions**:

```bash
# Increase Node.js memory limit
export NODE_OPTIONS="--max-old-space-size=4096"

# Or in package.json scripts
{
  "scripts": {
    "vercel-build": "NODE_OPTIONS='--max-old-space-size=4096' npm run build"
  }
}
```

#### 2. Asset Size Too Large

**Symptoms**:
- Build fails with asset size limit
- Slow page load times

**Solutions**:

```bash
# Analyze bundle size
npm run build
npx @next/bundle-analyzer

# Optimize imports
# Use dynamic imports for large libraries
# Implement code splitting
```

---

## 7. Maintenance and Updates

### How to Update Configurations

#### Environment Variables

##### Adding New Variables

1. **Local Development**:
   ```bash
   # Add to .env.local
   NEW_VARIABLE=value
   
   # Update type definitions
   # src/config/environment.ts
   ```

2. **Vercel Deployment**:
   ```bash
   # Add to preview
   vercel env add NEW_VARIABLE
   
   # Add to production
   vercel env add NEW_VARIABLE --production
   ```

##### Updating Existing Variables

```bash
# Update in Vercel dashboard
# Or remove and re-add via CLI
vercel env remove VARIABLE_NAME
vercel env add VARIABLE_NAME
```

#### Database Schema Updates

##### Schema Migration Process

1. **Update Schema Files**:
   ```bash
   # Edit both schema files
   vim prisma/schema.prisma          # PostgreSQL
   vim prisma/schema-sqlite.prisma   # SQLite
   ```

2. **Generate Migration**:
   ```bash
   # Local testing (SQLite)
   npm run prisma:migrate:sqlite
   
   # Production testing (PostgreSQL)
   npm run prisma:migrate:postgres
   ```

3. **Test Migration**:
   ```bash
   # Test locally
   npm run test:integration:sqlite
   
   # Test in preview
   npm run deploy:preview
   ```

4. **Deploy to Production**:
   ```bash
   npm run deploy:prod
   ```

### Adding New Environment Variables

#### Step-by-Step Process

1. **Define Variable Purpose**:
   - Document the variable's purpose
   - Define default values
   - Specify required environments

2. **Update Configuration Files**:
   ```typescript
   // src/config/environment.ts
   export function getNewVariable(): string {
     return process.env.NEW_VARIABLE || 'default-value';
   }
   
   // Add validation if needed
   export function validateNewVariable(): boolean {
     const value = getNewVariable();
     return value !== undefined && value.length > 0;
   }
   ```

3. **Update Type Definitions**:
   ```typescript
   // types/environment.ts
   export interface EnvironmentConfig {
     // ... existing variables
     newVariable?: string;
   }
   ```

4. **Add to Environment Files**:
   ```bash
   # .env.example
   NEW_VARIABLE=example-value
   
   # .env.local
   NEW_VARIABLE=local-value
   ```

5. **Configure in Vercel**:
   ```bash
   # Preview environment
   vercel env add NEW_VARIABLE
   
   # Production environment
   vercel env add NEW_VARIABLE --production
   ```

6. **Update Documentation**:
   - Add to environment setup guide
   - Update deployment documentation
   - Document default values and requirements

### Database Migration Procedures

#### Migration Best Practices

1. **Backward Compatibility**:
   - Ensure migrations don't break existing functionality
   - Test with both database providers
   - Implement feature flags for new features

2. **Rollback Planning**:
   - Create rollback migrations
   - Test rollback procedures
   - Document rollback steps

3. **Testing Strategy**:
   ```bash
   # Test migration locally
   npm run db:reset:sqlite
   npm run prisma:migrate:sqlite
   npm run test:integration:sqlite
   
   # Test in preview
   npm run deploy:preview
   # Verify functionality
   ```

#### Migration Commands Reference

```bash
# SQLite migrations
npm run prisma:migrate:sqlite          # Create new migration
npm run prisma:migrate:deploy          # Deploy migrations
npm run db:reset:sqlite               # Reset database

# PostgreSQL migrations
npm run prisma:migrate:postgres        # Create new migration
npm run prisma:migrate:deploy:postgres # Deploy migrations
npm run db:reset:postgres             # Reset database

# Migration status
npx prisma migrate status --schema=./prisma/schema.prisma
npx prisma migrate status --schema=./prisma/schema-sqlite.prisma
```

### Keeping Environments in Sync

#### Configuration Synchronization

1. **Regular Audits**:
   ```bash
   # Compare environment variables
   vercel env ls
   # Compare with .env.example
   
   # Check schema consistency
   diff prisma/schema.prisma prisma/schema-sqlite.prisma
   ```

2. **Automated Checks**:
   ```bash
   # Add to CI/CD pipeline
   npm run db:validate
   npm run test:unit
   npm run test:integration
   ```

3. **Documentation Updates**:
   - Keep this guide updated
   - Document any environment-specific changes
   - Maintain changelog for configuration updates

#### Version Control Best Practices

1. **Commit Patterns**:
   ```bash
   # Feature development
   git commit -m "feat: add new feature with environment support"
   
   # Configuration changes
   git commit -m "config: update environment variables for production"
   
   # Database changes
   git commit -m "schema: add new field to user model"
   ```

2. **Branch Protection**:
   - Require PR reviews for main branch
   - Require status checks to pass
   - Prevent direct pushes to main

3. **Release Management**:
   - Use semantic versioning
   - Tag releases appropriately
   - Maintain release notes

---

## Quick Reference

### Essential Commands

```bash
# Local Development
npm run dev                    # Start development server
npm run dev:sqlite            # SQLite development
npm run dev:postgres          # PostgreSQL development
npm run db:studio             # Open Prisma Studio
npm run test                  # Run all tests

# Database Management
npm run db:init:sqlite        # Initialize SQLite database
npm run db:reset:sqlite       # Reset SQLite database
npm run prisma:migrate:sqlite # Create SQLite migration
npm run prisma:seed:sqlite    # Seed SQLite database

# Vercel Deployment
npm run deploy:preview        # Deploy to preview
npm run deploy:prod           # Deploy to production
npm run deploy:preview-full   # Full preview deployment
npm run deploy:prod-full      # Full production deployment

# Build and Validation
npm run build                 # Build for production
npm run build:sqlite          # Build with SQLite
npm run build:vercel          # Build for Vercel
npm run db:validate           # Validate database config
```

### Environment Variables Reference

| Variable | Local | Preview | Production | Description |
|----------|-------|---------|------------|-------------|
| `DATABASE_PROVIDER` | `sqlite` | `postgresql` | `postgresql` | Database provider |
| `DATABASE_URL` | `file:./prisma/dev.db` | Vercel Postgres URL | Vercel Postgres URL | Database connection |
| `NODE_ENV` | `development` | `production` | `production` | Node environment |
| `VERCEL_ENV` | Not set | `preview` | `production` | Vercel environment |
| `LOG_LEVEL` | `debug` | `info` | `warn` | Logging level |
| `ENABLE_AUDIT_TRAIL` | `true` | `true` | `true` | Enable audit logging |
| `ENABLE_ANALYTICS` | `false` | `false` | `true` | Enable analytics |

### File Structure Reference

```
code/ri-app/
├── .env.local                 # Local environment variables
├── .env.example              # Environment variable template
├── vercel.json               # Vercel configuration
├── prisma/
│   ├── schema.prisma         # PostgreSQL schema
│   ├── schema-sqlite.prisma  # SQLite schema
│   ├── migrations/           # Database migrations
│   └── seed.js              # Database seeding script
├── src/config/
│   ├── environment.ts        # Environment detection
│   └── database.ts          # Database configuration
├── scripts/
│   ├── deploy-vercel.sh      # Deployment script
│   └── vercel-migrate.js     # Migration script
└── docs/
    ├── environment-setup-guide.md  # This guide
    └── vercel-deployment.md        # Vercel-specific docs
```

---

This comprehensive guide should enable developers to effectively manage the coexistence between local development and Vercel deployment environments. For any specific issues or questions not covered here, please refer to the project's architecture documentation or contact the development team.