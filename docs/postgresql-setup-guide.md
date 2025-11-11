# PostgreSQL Setup Guide for RI Management System

## Overview

This guide provides comprehensive instructions for setting up PostgreSQL with the RI Management application, including environment configuration, migration from SQLite, testing procedures, and troubleshooting tips.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [PostgreSQL Provider Options](#postgresql-provider-options)
3. [Environment Configuration](#environment-configuration)
4. [Database Schema Setup](#database-schema-setup)
5. [Migration from SQLite](#migration-from-sqlite)
6. [Application Configuration](#application-configuration)
7. [Testing Procedures](#testing-procedures)
8. [Common Issues and Troubleshooting](#common-issues-and-troubleshooting)
9. [Performance Considerations](#performance-considerations)
10. [Production Deployment](#production-deployment)

## Prerequisites

Before setting up PostgreSQL with the RI Management system, ensure you have:

- Node.js 18+ installed
- PostgreSQL database access (local or cloud provider)
- Administrative privileges for database operations
- Git repository access to the RI Management codebase
- Basic knowledge of database operations

## PostgreSQL Provider Options

### Option 1: Neon (Recommended for Development/Production)

Neon provides a serverless PostgreSQL platform with excellent performance and scalability.

**Setup Steps:**
1. Create an account at [https://neon.tech](https://neon.tech)
2. Create a new project/database
3. Copy the connection string from the Neon dashboard
4. Ensure SSL mode is enabled (default for Neon)

**Connection String Format:**
```
postgresql://[username]:[password]@[host]/[database]?sslmode=require
```

### Option 2: Local PostgreSQL Installation

For local development environments:

**macOS (using Homebrew):**
```bash
brew install postgresql
brew services start postgresql
createuser -s postgres
createdb ri_management
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo -u postgres createuser -s $USER
createdb ri_management
```

### Option 3: Docker PostgreSQL

For containerized environments:

```bash
docker run --name postgres-ri \
  -e POSTGRES_DB=ri_management \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=your_password \
  -p 5432:5432 \
  -d postgres:15
```

## Environment Configuration

### 1. Database Environment Variables

Create or update your `.env` file in the `code/ri-app` directory:

```env
# Database Configuration
DATABASE_PROVIDER=postgresql
DATABASE_URL="postgresql://[username]:[password]@[host]/[database]?sslmode=require"

# Example for Neon:
# DATABASE_URL="postgresql://neondb_owner:npg_HheOWji7sR2d@ep-gentle-hat-a1l79o09-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require"

# Application Environment
NODE_ENV=development
```

### 2. Prisma Configuration

The application uses a dynamic Prisma configuration that automatically selects the appropriate schema based on the `DATABASE_PROVIDER` environment variable.

**Configuration File:** `code/ri-app/prisma.config.mjs`

```javascript
import { loadEnvConfig } from "@next/env";
import { defineConfig } from "@prisma/config";

loadEnvConfig(process.cwd());

function getSchemaPath() {
  const provider = process.env.DATABASE_PROVIDER;
  
  // Default to PostgreSQL for Vercel or when explicitly set
  if (provider === "postgresql" || process.env.VERCEL_ENV) {
    return "./prisma/schema-postgresql.prisma";
  }
  
  // Default to SQLite for local development
  return "./prisma/schema-sqlite.prisma";
}

export default defineConfig({
  schema: getSchemaPath(),
  migrations: {
    seed: "node prisma/seed.js",
  },
});
```

## Database Schema Setup

### 1. PostgreSQL Schema File

The PostgreSQL-specific schema is located at `code/ri-app/prisma/schema-postgresql.prisma`.

**Key Differences from SQLite:**
- Uses `postgresql` provider
- PostgreSQL-specific data types and constraints
- Optimized indexes for PostgreSQL performance

### 2. Generate Prisma Client

After setting up the environment variables, generate the Prisma client:

```bash
cd code/ri-app
npm run prisma:generate:postgres
```

### 3. Database Migration

Run the database migrations to create the schema:

```bash
cd code/ri-app
npm run prisma:migrate:postgres
```

### 4. Seed Initial Data

Populate the database with initial data:

```bash
cd code/ri-app
npm run prisma:seed:postgres
```

## Migration from SQLite

If you have an existing SQLite database with data, follow these steps:

### 1. Export SQLite Data

Use the provided export script or manually export data:

```bash
cd code/ri-app
npm run db:export:sqlite
```

### 2. Set Up PostgreSQL

Follow the [Environment Configuration](#environment-configuration) and [Database Schema Setup](#database-schema-setup) steps above.

### 3. Import Data to PostgreSQL

```bash
cd code/ri-app
npm run db:import:postgres
```

### 4. Verify Migration

Run the test scripts to verify the migration:

```bash
cd code/ri-app
node test-postgresql-crud.js
node test-postgresql-audit-fixed.js
```

## Application Configuration

### 1. NPM Scripts

The application includes PostgreSQL-specific NPM scripts:

```json
{
  "dev:postgres": "DATABASE_PROVIDER=postgresql next dev",
  "build:postgres": "DATABASE_PROVIDER=postgresql npm run prisma:generate:env && next build",
  "prisma:generate:postgres": "DATABASE_PROVIDER=postgresql prisma generate --schema=./prisma/schema-postgresql.prisma",
  "prisma:migrate:postgres": "DATABASE_PROVIDER=postgresql node scripts/db-utils.js migrate",
  "prisma:seed:postgres": "DATABASE_PROVIDER=postgresql node scripts/db-utils.js seed",
  "test:integration:postgres": "DATABASE_PROVIDER=postgresql vitest run --pool=threads --poolOptions.threads.singleThread=true"
}
```

### 2. Development Server

Start the development server with PostgreSQL:

```bash
cd code/ri-app
npm run dev:postgres
```

### 3. Production Build

Build the application for production with PostgreSQL:

```bash
cd code/ri-app
npm run build:postgres
```

## Testing Procedures

### 1. Database Connection Test

Verify the database connection:

```bash
cd code/ri-app
node -e "
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
prisma.\$connect().then(() => {
  console.log('✅ Database connection successful');
  prisma.\$disconnect();
}).catch(err => {
  console.error('❌ Database connection failed:', err);
});
"
```

### 2. CRUD Operations Test

Run the comprehensive CRUD test script:

```bash
cd code/ri-app
node test-postgresql-crud.js
```

**Expected Output:**
```
🧪 Testing PostgreSQL CRUD Operations...

1️⃣ Testing READ operations...
   ✅ Found [X] reinsurers
   ✅ Found [Y] treaties

2️⃣ Testing CREATE operation...
   ✅ Created reinsurer: Test Reinsurer for PostgreSQL (RIN-TEST-001)

3️⃣ Testing UPDATE operation...
   ✅ Updated reinsurer status to: UNDER_REVIEW

4️⃣ Testing CREATE with relations...
   ✅ Created treaty: Test Treaty for PostgreSQL (TREATY-TEST-001)

5️⃣ Testing READ with relations...
   ✅ Treaty has 1 shares
   ✅ Share belongs to: Test Reinsurer for PostgreSQL

6️⃣ Testing DELETE operations...
   ✅ Deleted test treaty and reinsurer

7️⃣ Verifying deletion...
   ✅ Treaty deleted: true
   ✅ Reinsurer deleted: true

✅ All PostgreSQL CRUD operations completed successfully!
```

### 3. Audit Trail Test

Run the audit trail functionality test:

```bash
cd code/ri-app
node test-postgresql-audit-fixed.js
```

**Expected Output:**
```
🧪 Testing PostgreSQL Audit Trail Functionality...

1️⃣ Testing audit trail on CREATE operation...
   ✅ Created test reinsurer: Audit Test Reinsurer

2️⃣ Testing audit trail on UPDATE operation...
   ✅ Updated reinsurer status to: UNDER_REVIEW

3️⃣ Verifying audit events were created...
   ✅ Found [X] audit events for test reinsurer

4️⃣ Verifying audit changes were recorded...
   ✅ Found [Y] audit changes for test reinsurer

5️⃣ Verifying audit change details...
   ✅ CREATE change recorded: [field] = [old] → [new]
   ✅ UPDATE change recorded: [field] = [old] → [new]

✅ All PostgreSQL audit trail tests completed successfully!
```

### 4. Application UI Test

Verify the application works correctly with PostgreSQL:

1. Start the development server: `npm run dev:postgres`
2. Navigate to `http://localhost:3000`
3. Check the reinsurers page: `http://localhost:3000/reinsurers`
4. Check the treaties page: `http://localhost:3000/treaties`
5. Verify data is displayed correctly

### 5. Integration Tests

Run the integration test suite:

```bash
cd code/ri-app
npm run test:integration:postgres
```

## Common Issues and Troubleshooting

### 1. Connection Issues

**Problem:** Connection timeout or refused connection

**Solutions:**
- Verify the connection string is correct
- Check if the database server is running
- Ensure firewall allows connection to the database
- Verify SSL mode is correctly configured

**Debug Command:**
```bash
cd code/ri-app
node -e "
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
prisma.\$connect()
  .then(() => console.log('✅ Connected'))
  .catch(err => console.error('❌ Connection error:', err.message))
  .finally(() => prisma.\$disconnect());
"
```

### 2. Migration Issues

**Problem:** Migration fails with constraint errors

**Solutions:**
- Drop and recreate the database
- Check for existing tables with conflicting names
- Verify PostgreSQL version compatibility

**Reset Database:**
```bash
cd code/ri-app
npm run db:reset:postgres
```

### 3. Schema Mismatch

**Problem:** Prisma schema doesn't match database

**Solutions:**
- Regenerate Prisma client: `npm run prisma:generate:postgres`
- Reset database: `npm run db:reset:postgres`
- Check for manual database modifications

### 4. Performance Issues

**Problem:** Slow query performance

**Solutions:**
- Check database indexes
- Monitor connection pool usage
- Consider query optimization
- Enable PostgreSQL query logging

### 5. Audit Trail Not Working

**Problem:** Audit events not being created

**Solutions:**
- Verify audit triggers are properly set up
- Check if operations go through the service layer
- Ensure audit context is properly configured
- Test through application UI rather than direct database operations

## Performance Considerations

### 1. Connection Pooling

PostgreSQL connection pooling is automatically configured through Prisma. Monitor connection usage:

```sql
-- Check active connections
SELECT count(*) FROM pg_stat_activity;

-- Check connection details
SELECT datname, usename, count(*) 
FROM pg_stat_activity 
GROUP BY datname, usename;
```

### 2. Index Optimization

The schema includes optimized indexes for common queries. Monitor query performance:

```sql
-- Check slow queries
SELECT query, mean_time, calls 
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;
```

### 3. Neon-Specific Considerations

When using Neon:

- **Cold Starts**: First connection after inactivity may be slower
- **Connection Limits**: Monitor connection pool usage
- **Branching**: Use Neon branches for development/testing
- **Autoscaling**: Monitor compute usage during peak times

### 4. Memory Usage

Monitor PostgreSQL memory usage:

```sql
-- Check memory usage
SELECT datname, numbackends, xact_commit, xact_rollback, 
       blks_read, blks_hit, tup_returned, tup_fetched
FROM pg_stat_database;
```

## Production Deployment

### 1. Environment Variables

Set production environment variables:

```env
DATABASE_PROVIDER=postgresql
DATABASE_URL="postgresql://[user]:[pass]@[host]/[db]?sslmode=require"
NODE_ENV=production
```

### 2. Database Security

**Security Best Practices:**
- Use SSL connections (sslmode=require)
- Implement connection limits
- Use read replicas for reporting queries
- Regular database backups
- Monitor access logs

### 3. Backup Strategy

Implement regular backups:

```bash
# For Neon: Use the Neon console or API
# For self-hosted PostgreSQL:
pg_dump -h [host] -U [user] [database] > backup.sql
```

### 4. Monitoring

Set up monitoring for:
- Connection pool usage
- Query performance
- Database size growth
- Error rates

### 5. Scaling Considerations

**Vertical Scaling:**
- Increase compute resources
- Optimize memory allocation
- Adjust connection pool size

**Horizontal Scaling:**
- Implement read replicas
- Use connection pooling services (PgBouncer)
- Consider database sharding for large datasets

## Quick Reference Commands

### Development Setup
```bash
# Set environment variables
export DATABASE_PROVIDER=postgresql
export DATABASE_URL="postgresql://[user]:[pass]@[host]/[db]?sslmode=require"

# Generate Prisma client
npm run prisma:generate:postgres

# Run migrations
npm run prisma:migrate:postgres

# Seed database
npm run prisma:seed:postgres

# Start development server
npm run dev:postgres
```

### Testing
```bash
# Test database connection
node -e "const {PrismaClient}=require('@prisma/client');new PrismaClient().\$connect().then(()=>console.log('✅ Connected')).catch(e=>console.error('❌',e)).finally(()=>process.exit(0))"

# Test CRUD operations
node test-postgresql-crud.js

# Test audit trail
node test-postgresql-audit-fixed.js

# Run integration tests
npm run test:integration:postgres
```

### Maintenance
```bash
# Reset database
npm run db:reset:postgres

# Validate schema
npm run db:validate

# View database (Prisma Studio)
npm run db:studio:postgres
```

## Support and Resources

- **PostgreSQL Documentation**: [https://www.postgresql.org/docs/](https://www.postgresql.org/docs/)
- **Neon Documentation**: [https://neon.tech/docs](https://neon.tech/docs)
- **Prisma Documentation**: [https://www.prisma.io/docs](https://www.prisma.io/docs)
- **Next.js Documentation**: [https://nextjs.org/docs](https://nextjs.org/docs)

## Conclusion

This guide provides a comprehensive approach to setting up PostgreSQL with the RI Management system. Following these steps will ensure a robust, scalable database configuration suitable for both development and production environments.

For additional support or questions, refer to the project documentation or contact the development team.