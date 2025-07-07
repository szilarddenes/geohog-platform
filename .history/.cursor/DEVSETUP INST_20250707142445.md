# GeoHog Deployment & CI/CD Setup Instructions

## **Project Goal**
Set up automated deployment workflow: Local Development → GitHub → Supabase Hosting → Live Updates

## **Hosting Strategy**
- **Platform**: Supabase (database + hosting)
- **Repository**: GitHub (version control + CI/CD triggers)
- **Workflow**: Push to GitHub → Automatic deployment to Supabase staging/production

## **Required Setup**

### **1. Repository Configuration**
```
1. Fork AppFlowy to new repository: szilarddenes/geohog-platform
2. Set up GitHub repository with main/staging branches
3. Configure repository secrets for deployment
4. Enable GitHub Actions for CI/CD
```

### **2. Supabase Project Setup**
```
1. Create Supabase project for GeoHog
2. Configure database (PostgreSQL + PostGIS)
3. Set up Edge Functions for backend processing
4. Configure environment variables and secrets
5. Enable GitHub integration for automatic deployments
```

### **3. Deployment Configuration**
```
1. Create Supabase CLI configuration files
2. Set up GitHub Actions workflow (.github/workflows/deploy.yml)
3. Configure staging and production environments
4. Test deployment pipeline
```

## **Implementation Steps**

### **Step 1: Supabase Project Creation**
```
Tasks for Cursor/Claude CLI:
1. Create new Supabase project named "geohog-staging"
2. Enable required extensions (PostGIS, UUID, etc.)
3. Set up database schema for geological data
4. Configure Row Level Security (RLS) policies
5. Set up file storage buckets for geological files
6. Generate and save API keys and connection strings
```

### **Step 2: GitHub Repository Setup**
```
Tasks for Cursor/Claude CLI:
1. Initialize repository with proper .gitignore
2. Create development, staging, and main branches
3. Set up GitHub repository secrets:
   - SUPABASE_ACCESS_TOKEN
   - SUPABASE_PROJECT_ID
   - SUPABASE_DB_PASSWORD
4. Create basic project structure following AppFlowy fork
```

### **Step 3: CI/CD Workflow Creation**
```
Create GitHub Actions workflow file (.github/workflows/deploy.yml):

Trigger: Push to staging/main branches
Actions:
1. Checkout code
2. Install dependencies
3. Build application
4. Run tests
5. Deploy to Supabase Edge Functions
6. Update database migrations
7. Deploy frontend to Supabase hosting
8. Run post-deployment tests
```

### **Step 4: Development Workflow Setup**
```
Local Development Process:
1. Clone repository locally
2. Install Supabase CLI
3. Link local project to Supabase project
4. Set up local development environment
5. Configure environment variables
6. Test local → Supabase connection
```

### **Step 5: Deployment Testing**
```
Test the complete workflow:
1. Make a simple code change locally
2. Commit and push to staging branch
3. Verify GitHub Actions triggers
4. Confirm deployment to Supabase staging
5. Test live changes on staging URL
6. Document any issues and fixes needed
```

## **Expected Workflow**
```
Developer makes change → 
git commit → 
git push origin staging → 
GitHub Actions triggered → 
Build and test → 
Deploy to Supabase → 
Live staging site updated → 
Test changes → 
Merge to main for production
```

## **Configuration Files Needed**

### **1. supabase/config.toml**
```
Supabase configuration file for local development and deployment
- Project settings
- Database configuration
- Edge Functions setup
- Storage buckets configuration
```

### **2. .github/workflows/deploy.yml**
```
GitHub Actions workflow for automated deployment
- Build steps
- Test execution
- Supabase deployment
- Environment-specific configurations
```

### **3. Environment Variables**
```
Local (.env.local):
- SUPABASE_URL
- SUPABASE_ANON_KEY
- SUPABASE_SERVICE_ROLE_KEY

GitHub Secrets:
- SUPABASE_ACCESS_TOKEN
- SUPABASE_PROJECT_ID
- Additional deployment secrets
```

## **Success Criteria**
- [ ] Repository connected to Supabase project
- [ ] GitHub Actions workflow functional
- [ ] Push to staging triggers automatic deployment
- [ ] Changes appear live on staging URL
- [ ] Local development environment working
- [ ] Database migrations deploy automatically
- [ ] Frontend updates deploy automatically
- [ ] Rollback capability working

## **Deliverables**
1. **Working CI/CD pipeline** (GitHub → Supabase)
2. **Staging environment URL** for testing
3. **Local development setup** instructions
4. **Deployment workflow** documentation
5. **Environment configuration** files
6. **Troubleshooting guide** for common issues

## **Testing Protocol**
```
1. Make simple frontend change (e.g., change title text)
2. Commit: git commit -m "test: update title"
3. Push: git push origin staging
4. Verify: GitHub Actions runs successfully
5. Check: Staging URL shows the change
6. Time: Document deployment time (should be < 5 minutes)
7. Rollback: Test reverting changes
```

## **Focus Areas for Cursor/Claude CLI**
- **Automate setup**: Create scripts for Supabase project configuration
- **Simplify workflow**: Ensure one-command deployment setup
- **Document everything**: Clear step-by-step instructions
- **Error handling**: Robust deployment pipeline with proper error messages
- **Testing**: Verify each step works before moving to next

---

**Primary Objective**: Establish reliable development → staging deployment workflow before adding any complex features or integrations.