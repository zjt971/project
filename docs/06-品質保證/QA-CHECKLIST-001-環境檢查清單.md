# Environment Setup Checklist

Use this checklist to verify that your development and deployment environments are properly configured.

## 📋 Local Development Checklist

### Prerequisites
- [ ] Node.js v18+ installed (`node --version`)
- [ ] npm v9+ installed (`npm --version`)
- [ ] Git installed (`git --version`)
- [ ] VS Code with recommended extensions (optional)

### Project Setup
- [ ] Repository cloned (`git clone <repository-url>`)
- [ ] Navigate to project directory (`cd ri-management/code/ri-app`)
- [ ] Dependencies installed (`npm install`)
- [ ] No installation errors or warnings

### Environment Configuration
- [ ] `.env.local` file created from `.env.example`
- [ ] `DATABASE_PROVIDER=sqlite` configured
- [ ] `DATABASE_URL=file:./prisma/dev.db` configured
- [ ] `NODE_ENV=development` configured
- [ ] `LOG_LEVEL=debug` configured

### Database Setup
- [ ] Database initialized (`npm run db:init:sqlite`)
- [ ] Prisma client generated (`npm run prisma:generate:sqlite`)
- [ ] Database seeded (`npm run prisma:seed:sqlite`)
- [ ] Database validation passes (`npm run db:validate`)
- [ ] `prisma/dev.db` file exists

### Development Server
- [ ] Development server starts (`npm run dev`)
- [ ] Server accessible at `http://localhost:3000`
- [ ] No startup errors in console
- [ ] Hot reload working
- [ ] Database operations working (test CRUD)

### Testing
- [ ] Unit tests pass (`npm run test:unit`)
- [ ] Integration tests pass (`npm run test:integration:sqlite`)
- [ ] All tests pass (`npm run test`)
- [ ] Test coverage acceptable

### Database Management
- [ ] Prisma Studio accessible (`npm run db:studio`)
- [ ] Can view and edit data
- [ ] Database schema matches expectations
- [ ] Seed data present and correct

---

## 🚀 Vercel Deployment Checklist

### Vercel Account Setup
- [ ] Vercel account created
- [ ] Vercel CLI installed (`npm i -g vercel`)
- [ ] Logged into Vercel (`vercel login`)
- [ ] Project linked to Vercel (`vercel link`)

### Database Configuration
- [ ] Vercel Postgres database created
- [ ] Database connected to project
- [ ] `DATABASE_URL` configured in Vercel dashboard
- [ ] `DATABASE_PROVIDER=postgresql` configured
- [ ] Connection pooling enabled
- [ ] SSL mode configured

### Environment Variables
- [ ] Preview environment variables configured
- [ ] Production environment variables configured
- [ ] `LOG_LEVEL` set appropriately (info/warn)
- [ ] `ENABLE_AUDIT_TRAIL=true` configured
- [ ] `ENABLE_ANALYTICS` configured as needed

### Build Configuration
- [ ] `vercel.json` configuration correct
- [ ] Build command set to `npm run vercel-build`
- [ ] Output directory set to `.next`
- [ ] Framework set to `nextjs`
- [ ] Regions configured (hkg1, sin1)

### Preview Deployment
- [ ] Preview deployment successful (`npm run deploy:preview`)
- [ ] Preview URL accessible
- [ ] Health check passes (`/api/health`)
- [ ] Database migrations applied
- [ ] Basic functionality working

### Production Deployment
- [ ] Production deployment successful (`npm run deploy:prod`)
- [ ] Production URL accessible
- [ ] HTTPS working
- [ ] Security headers present
- [ ] Analytics enabled (if configured)

### Monitoring and Health
- [ ] Health endpoint responding (`/api/health`)
- [ ] Automated health checks configured
- [ ] Error monitoring setup
- [ ] Performance monitoring enabled
- [ ] Log aggregation working

---

## 🔍 Verification Commands

### Local Development Verification

```bash
# Check Node.js version
node --version  # Should be v18+

# Check npm version
npm --version   # Should be v9+

# Verify dependencies
npm list --depth=0

# Check environment variables
cat .env.local

# Validate database configuration
npm run db:validate

# Test database connection
npm run db:studio

# Run tests
npm run test

# Check development server
curl http://localhost:3000/api/health
```

### Vercel Deployment Verification

```bash
# Check Vercel CLI
vercel --version

# List environment variables
vercel env ls

# Check deployment status
vercel ls

# View build logs
vercel logs

# Test health endpoint
curl https://your-app.vercel.app/api/health

# Check deployment URL
curl https://your-app.vercel.app
```

---

## 🚨 Common Issues to Check

### Local Development Issues

#### Database Issues
- [ ] No "database locked" errors
- [ ] No "missing table" errors
- [ ] Migration files present
- [ ] Seed data loaded correctly

#### Port Issues
- [ ] Port 3000 available
- [ ] No "address already in use" errors
- [ ] Server starts without conflicts

#### Dependency Issues
- [ ] No "module not found" errors
- [ ] All dependencies installed
- [ ] No peer dependency conflicts

### Vercel Deployment Issues

#### Build Issues
- [ ] No "out of memory" errors
- [ ] No "missing environment variable" errors
- [ ] Prisma client generates successfully
- [ ] Build completes within time limits

#### Runtime Issues
- [ ] No "database connection" errors
- [ ] No "SSL certificate" errors
- [ ] Functions don't timeout
- [ ] API routes respond correctly

#### Configuration Issues
- [ ] Environment variables accessible
- [ ] Database URL correct format
- [ ] SSL mode properly configured
- [ ] Regions properly set

---

## 📊 Performance Checks

### Local Development
- [ ] Development server starts within 10 seconds
- [ ] Hot reload updates within 2 seconds
- [ ] Database queries complete within 1 second
- [ ] Page loads within 3 seconds

### Vercel Deployment
- [ ] Build completes within 5 minutes
- [ ] Initial page load within 3 seconds
- [ ] API responses within 1 second
- [ ] Health check responds within 500ms

---

## 🔐 Security Checks

### Local Development
- [ ] No sensitive data in `.env.local`
- [ ] No secrets committed to git
- [ ] Development-only headers present

### Vercel Deployment
- [ ] HTTPS enforced
- [ ] Security headers present
- [ ] Environment variables encrypted
- [ ] No sensitive data in client-side code

---

## 📝 Documentation Checklist

### Setup Documentation
- [ ] Environment setup guide exists
- [ ] Quick start guide available
- [ ] Troubleshooting guide complete
- [ ] Configuration documented

### Project Documentation
- [ ] README.md up to date
- [ ] Architecture documentation current
- [ ] API documentation complete
- [ ] Deployment instructions clear

---

## ✅ Final Verification

### Before Starting Development
- [ ] All local development checks pass
- [ ] Development server running smoothly
- [ ] Tests passing
- [ ] Database operations working

### Before Deploying to Preview
- [ ] Code committed to feature branch
- [ ] Local tests passing
- [ ] Environment variables configured
- [ ] Preview deployment successful

### Before Deploying to Production
- [ ] Code reviewed and approved
- [ ] All tests passing
- [ ] Preview deployment tested
- [ ] Production deployment successful
- [ ] Post-deployment verification complete

---

## 🆘 Troubleshooting Resources

### Quick Fixes
- **Database issues**: `npm run db:reset:sqlite`
- **Port conflicts**: `lsof -ti:3000 | xargs kill -9`
- **Dependency issues**: `rm -rf node_modules && npm install`
- **Build issues**: `rm -rf .next && npm run build`

### Documentation
- [Environment Setup Guide](./environment-setup-guide.md)
- [Quick Start Guide](./environment-quick-start.md)
- [Vercel Deployment Guide](./vercel-deployment-guide.md)

### Support
- Check existing GitHub issues
- Create new issue with detailed description
- Contact development team for urgent issues

---

**Tip**: Save this checklist and run through it whenever setting up a new development machine or deploying to a new environment.