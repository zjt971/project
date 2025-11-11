# PostgreSQL Setup Quick Reference Checklist

## Environment Setup Checklist

### Prerequisites
- [ ] Node.js 18+ installed
- [ ] PostgreSQL database access (local or cloud provider)
- [ ] Administrative privileges for database operations
- [ ] Git repository access to RI Management codebase

### Database Provider Setup
- [ ] Choose PostgreSQL provider (Neon recommended)
- [ ] Create database instance
- [ ] Obtain connection string
- [ ] Verify SSL mode is enabled

### Environment Configuration
- [ ] Create/update `.env` file in `code/ri-app` directory
- [ ] Set `DATABASE_PROVIDER=postgresql`
- [ ] Set `DATABASE_URL` with PostgreSQL connection string
- [ ] Set `NODE_ENV=development` (for development)

### Application Setup
- [ ] Navigate to `code/ri-app` directory
- [ ] Install dependencies: `npm install`
- [ ] Generate Prisma client: `npm run prisma:generate:postgres`
- [ ] Run database migrations: `npm run prisma:migrate:postgres`
- [ ] Seed initial data: `npm run prisma:seed:postgres`

### Testing and Verification
- [ ] Test database connection
- [ ] Run CRUD operations test: `node test-postgresql-crud.js`
- [ ] Run audit trail test: `node test-postgresql-audit-fixed.js`
- [ ] Start development server: `npm run dev:postgres`
- [ ] Verify application loads correctly
- [ ] Check data display in UI

### Production Deployment
- [ ] Set production environment variables
- [ ] Configure database security (SSL, connection limits)
- [ ] Set up backup strategy
- [ ] Configure monitoring and alerting
- [ ] Build production application: `npm run build:postgres`

## Quick Commands Reference

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

### Testing Commands
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

### Maintenance Commands
```bash
# Reset database
npm run db:reset:postgres

# Validate schema
npm run db:validate

# View database (Prisma Studio)
npm run db:studio:postgres
```

## Troubleshooting Checklist

### Connection Issues
- [ ] Verify connection string format
- [ ] Check database server status
- [ ] Ensure firewall allows connection
- [ ] Verify SSL mode configuration

### Migration Issues
- [ ] Check for existing conflicting tables
- [ ] Verify PostgreSQL version compatibility
- [ ] Consider database reset if needed

### Performance Issues
- [ ] Monitor connection pool usage
- [ ] Check database indexes
- [ ] Review query performance
- [ ] Consider connection optimization

## Environment Variables Template

```env
# Database Configuration
DATABASE_PROVIDER=postgresql
DATABASE_URL="postgresql://[username]:[password]@[host]/[database]?sslmode=require"

# Application Environment
NODE_ENV=development

# Example for Neon:
# DATABASE_URL="postgresql://neondb_owner:npg_HheOWji7sR2d@ep-gentle-hat-a1l79o09-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require"
```

## Verification Steps

### Database Connection Test
1. Run connection test command
2. Verify "✅ Connected" message appears
3. Check for any error messages

### CRUD Operations Test
1. Run `node test-postgresql-crud.js`
2. Verify all test steps pass
3. Check for "✅ All PostgreSQL CRUD operations completed successfully!" message

### Audit Trail Test
1. Run `node test-postgresql-audit-fixed.js`
2. Verify audit events are created
3. Check for "✅ All PostgreSQL audit trail tests completed successfully!" message

### Application UI Test
1. Start development server
2. Navigate to `http://localhost:3000`
3. Check reinsurers page displays data
4. Check treaties page displays data
5. Verify pagination and filtering work

## Production Readiness Checklist

### Security
- [ ] SSL connections enabled
- [ ] Connection limits configured
- [ ] Read replicas implemented (if needed)
- [ ] Regular backups scheduled
- [ ] Access logging enabled

### Performance
- [ ] Connection pooling optimized
- [ ] Database indexes reviewed
- [ ] Query performance monitored
- [ ] Compute resources allocated appropriately

### Monitoring
- [ ] Database performance monitoring
- [ ] Error rate tracking
- [ ] Connection pool usage monitoring
- [ ] Storage growth monitoring

### Backup and Recovery
- [ ] Automated backup schedule
- [ ] Backup verification process
- [ ] Recovery procedures documented
- [ ] Disaster recovery plan tested

## Support Resources

- **PostgreSQL Documentation**: https://www.postgresql.org/docs/
- **Neon Documentation**: https://neon.tech/docs
- **Prisma Documentation**: https://www.prisma.io/docs
- **Next.js Documentation**: https://nextjs.org/docs
- **Project Documentation**: See `docs/postgresql-setup-guide.md`

## Contact Information

For additional support or questions:
- Refer to project documentation
- Contact development team
- Check GitHub issues for known problems
- Review troubleshooting section in setup guide