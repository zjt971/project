# Vercel Deployment Guide

## Overview

This guide covers the deployment of the Reinsurance System to Vercel with proper environment configuration, database setup, and deployment strategies.

## Environment Variables

### Required Environment Variables

#### Database Configuration
- `DATABASE_URL` - PostgreSQL connection string (provided by Vercel Postgres)
- `DATABASE_PROVIDER` - Set to `postgresql` for all Vercel deployments

#### Application Configuration
- `NODE_ENV` - Automatically set by Vercel (development/preview/production)
- `VERCEL_ENV` - Automatically set by Vercel (preview/production)
- `LOG_LEVEL` - Logging level (debug/info/warn/error)

#### Security (Production)
- `NEXTAUTH_SECRET` - Secret key for authentication (if using NextAuth)
- `NEXTAUTH_URL` - Application URL for authentication callbacks

#### Optional Features
- `ENABLE_AUDIT_TRAIL` - Enable audit trail functionality (default: true)
- `ENABLE_ANALYTICS` - Enable analytics tracking (default: false)

### Environment-Specific Settings

#### Preview Environment
```bash
DATABASE_PROVIDER=postgresql
DATABASE_URL=postgresql://user:password@host:5432/db?sslmode=require
LOG_LEVEL=info
ENABLE_AUDIT_TRAIL=true
ENABLE_ANALYTICS=false
```

#### Production Environment
```bash
DATABASE_PROVIDER=postgresql
DATABASE_URL=postgresql://user:password@host:5432/db?sslmode=require
LOG_LEVEL=warn
ENABLE_AUDIT_TRAIL=true
ENABLE_ANALYTICS=true
NEXTAUTH_SECRET=your-production-secret
NEXTAUTH_URL=https://your-app.vercel.app
```

## Vercel Postgres Integration

### Setup Instructions

1. **Create Vercel Postgres Database**
   - In Vercel dashboard, go to Storage tab
   - Click "Create Database"
   - Select PostgreSQL
   - Choose region (recommended: Hong Kong or Singapore)

2. **Connect Database to Project**
   - Select your project
   - Choose the database
   - Vercel will automatically set `DATABASE_URL`

3. **Configure Database Settings**
   - Enable connection pooling
   - Set backup retention period
   - Configure read replicas if needed

### Database Migration Strategy

#### Automatic Migrations
Vercel automatically runs database migrations during deployment using the `prisma migrate deploy` command:

```json
{
  "buildCommand": "npm run vercel-build"
}
```

The `vercel-build` script includes:
1. Generate Prisma client with PostgreSQL schema
2. Run pending migrations
3. Build the Next.js application

#### Manual Migrations
For manual migration management:

```bash
# Generate migration locally
npm run prisma:migrate:postgres

# Deploy to Vercel
vercel --prod
```

## Deployment Process

### Preview Deployments
Preview deployments are automatically created for:
- Pull requests
- Push to non-main branches
- Manual preview deployments

Features:
- Isolated database (can share production for testing)
- Unique URL for each preview
- Automatic cleanup after 7 days

### Production Deployments
Production deployments are triggered by:
- Merge to main branch
- Manual production deployment
- Scheduled deployments

Features:
- Zero-downtime deployments
- Automatic rollback on failure
- CDN caching and optimization

## Build Configuration

### Next.js Configuration
The application is optimized for Vercel with:

```typescript
// next.config.ts
const nextConfig = {
  outputFileTracingIncludes: {
    "/api/**/*": ["./node_modules/.prisma/client/**/*"],
    "/**/*": ["./node_modules/.prisma/client/**/*"],
  },
};
```

### Prisma Configuration
Prisma is configured for Vercel with:

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

## Performance Optimization

### Edge Functions
API routes are configured as Edge Functions for better performance:

```json
{
  "functions": {
    "src/app/api/**/*.ts": {
      "maxDuration": 30
    }
  }
}
```

### Caching Strategy
- API routes: `no-store, must-revalidate`
- Static assets: Long-term caching
- Database queries: Connection pooling

### Regional Deployment
Deploy to multiple regions for better performance:

```json
{
  "regions": ["hkg1", "sin1"]
}
```

## Monitoring and Health Checks

### Health Check Endpoint
Automatic health checks every 6 hours:

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

### Monitoring Setup
1. **Vercel Analytics**
   - Enable in project settings
   - Track performance metrics
   - Monitor error rates

2. **Database Monitoring**
   - Vercel Postgres dashboard
   - Connection pool metrics
   - Query performance

3. **Application Monitoring**
   - Log aggregation
   - Error tracking
   - Performance metrics

## Security Configuration

### Headers
Security headers are automatically added:

```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        },
        {
          "key": "Referrer-Policy",
          "value": "strict-origin-when-cross-origin"
        }
      ]
    }
  ]
}
```

### Environment Variable Security
- Use Vercel's encrypted environment variables
- Never commit secrets to git
- Use different secrets for preview/production

## Troubleshooting

### Common Issues

#### Build Failures
1. **Database Connection Error**
   - Verify `DATABASE_URL` is correctly set
   - Check SSL configuration
   - Ensure database is accessible

2. **Prisma Generation Error**
   - Verify schema path is correct
   - Check binary targets
   - Ensure PostgreSQL provider is set

#### Runtime Errors
1. **Database Connection Timeout**
   - Check connection pool settings
   - Verify regional database access
   - Monitor database performance

2. **Migration Failures**
   - Check migration order
   - Verify schema compatibility
   - Review migration SQL

### Debugging Steps

1. **Check Build Logs**
   ```bash
   vercel logs
   ```

2. **Verify Environment Variables**
   ```bash
   vercel env ls
   ```

3. **Test Database Connection**
   ```bash
   npm run db:validate
   ```

4. **Check Health Endpoint**
   ```bash
   curl https://your-app.vercel.app/api/health
   ```

## Deployment Commands

### Local Development
```bash
# Setup local environment
npm run setup:dev

# Start development server
npm run dev:sqlite
```

### Preview Deployment
```bash
# Deploy to preview
npm run deploy:preview

# Deploy with specific environment
vercel --env DATABASE_PROVIDER=postgresql
```

### Production Deployment
```bash
# Deploy to production
npm run deploy:prod

# Deploy with manual confirmation
vercel --prod --confirm
```

## Best Practices

1. **Environment Management**
   - Use separate databases for preview/production
   - Regularly rotate secrets
   - Monitor environment variable usage

2. **Database Management**
   - Regular backups
   - Migration testing
   - Performance monitoring

3. **Deployment Strategy**
   - Use preview deployments for testing
   - Implement gradual rollouts
   - Monitor post-deployment metrics

4. **Security**
   - Regular security audits
   - Keep dependencies updated
   - Monitor for vulnerabilities

## Rollback Strategy

### Automatic Rollback
Vercel automatically rolls back if:
- Build fails
- Health checks fail
- Error rate exceeds threshold

### Manual Rollback
```bash
# List recent deployments
vercel deployments

# Rollback to specific deployment
vercel rollback [deployment-url]
```

### Database Rollback
```bash
# Reset database to previous migration
npm run db:reset:postgres

# Re-deploy previous application version
vercel --prod [previous-commit]