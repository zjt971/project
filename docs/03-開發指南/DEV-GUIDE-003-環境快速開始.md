# Environment Quick Start Guide

This guide provides a condensed version of the full environment setup for developers who need to get started quickly.

## 🚀 Quick Start

### Local Development (5 minutes)

```bash
# 1. Clone and install
git clone <repository-url>
cd ri-management/code/ri-app
npm install

# 2. Setup environment
cp .env.example .env.local
# Edit .env.local with:
# DATABASE_PROVIDER=sqlite
# DATABASE_URL=file:./prisma/dev.db

# 3. Initialize database
npm run setup:dev

# 4. Start development
npm run dev
```

### Vercel Deployment (10 minutes)

```bash
# 1. Install Vercel CLI
npm i -g vercel
vercel login

# 2. Link project
cd code/ri-app
vercel link

# 3. Setup database
# In Vercel dashboard: Storage → Create Database → PostgreSQL
# Connect to your project

# 4. Configure environment
vercel env add DATABASE_URL
vercel env add DATABASE_PROVIDER

# 5. Deploy
npm run deploy:preview
```

## 📋 Essential Commands

### Local Development
```bash
npm run dev              # Start development server
npm run db:studio        # Open database GUI
npm run test             # Run tests
npm run db:reset:sqlite  # Reset database
```

### Vercel Deployment
```bash
npm run deploy:preview   # Deploy to preview
npm run deploy:prod      # Deploy to production
npm run vercel:migrate   # Run database migrations
```

## 🔧 Environment Variables

### Local (.env.local)
```bash
DATABASE_PROVIDER=sqlite
DATABASE_URL=file:./prisma/dev.db
NODE_ENV=development
LOG_LEVEL=debug
```

### Vercel (Dashboard)
```bash
DATABASE_PROVIDER=postgresql
DATABASE_URL=postgresql://...?sslmode=require
LOG_LEVEL=info  # preview / warn for production
```

## 🏗️ Architecture Overview

```
Local Development     →    Vercel Preview    →    Vercel Production
─────────────────────        ───────────────        ─────────────────
• SQLite Database           • PostgreSQL            • PostgreSQL
• Hot Reload                • Auto-deploy           • CDN + Analytics
• Debug Logging             • Isolated URL          • Monitoring
• Seed Data                 • Health Checks         • Backups
```

## 🐛 Common Issues & Solutions

### Database Connection Error
```bash
# Check configuration
npm run db:validate

# Reset local database
npm run db:reset:sqlite
```

### Port Already in Use
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Or use different port
PORT=3001 npm run dev
```

### Vercel Build Failure
```bash
# Check environment variables
vercel env ls

# Check build logs
vercel logs
```

## 📁 Key Files

| File | Purpose |
|------|---------|
| `.env.local` | Local environment variables |
| `vercel.json` | Vercel configuration |
| `src/config/environment.ts` | Environment detection |
| `src/config/database.ts` | Database configuration |
| `prisma/schema.prisma` | PostgreSQL schema |
| `prisma/schema-sqlite.prisma` | SQLite schema |

## 🔄 Development Workflow

1. **Feature Development**
   ```bash
   git checkout -b feature/new-feature
   npm run dev
   # Develop and test locally
   git push origin feature/new-feature
   # Auto-deploys to preview for review
   ```

2. **Production Deployment**
   ```bash
   git checkout main
   git merge feature/new-feature
   git push origin main
   # Auto-deploys to production
   ```

## 📚 Additional Resources

- **Full Documentation**: [Environment Setup Guide](./environment-setup-guide.md)
- **Vercel Deployment**: [Vercel Deployment Guide](./vercel-deployment-guide.md)
- **Architecture**: [Architecture Documentation](../architecture/)

## 🆘 Need Help?

1. Check the full [Environment Setup Guide](./environment-setup-guide.md)
2. Review [Vercel Deployment Guide](./vercel-deployment-guide.md)
3. Check existing issues or create new one
4. Contact the development team

---

**Tip**: This quick start guide covers the most common scenarios. For detailed configuration, troubleshooting, and advanced workflows, refer to the comprehensive [Environment Setup Guide](./environment-setup-guide.md).