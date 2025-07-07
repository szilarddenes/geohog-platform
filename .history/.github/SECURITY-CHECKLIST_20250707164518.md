# 🛡️ Security Checklist for GeoHog Platform

## ✅ Pre-Deployment Security Checklist

**COMPLETE ALL ITEMS BEFORE ADDING API KEYS:**

### 1. Repository Security
- [ ] Repository is set to **Private** (see `.github/MAKE-REPO-PRIVATE.md`)
- [ ] Verified lock icon 🔒 appears next to repository name
- [ ] Only authorized users have access

### 2. Environment Files Protection
- [ ] `.env` files added to `.gitignore` ✅
- [ ] No `.env` files committed to repository
- [ ] No API keys in any committed files
- [ ] Verified with: `git log --all -p | grep -i "supabase\|api\|key\|secret"`

### 3. GitHub Secrets Configuration
- [ ] Read `.github/SECRETS-TEMPLATE.md` completely
- [ ] Added all 4 required secrets to GitHub repository
- [ ] No secrets committed to code files
- [ ] Secrets page: `Settings > Secrets and variables > Actions`

### 4. Code Security
- [ ] No hardcoded API keys in source code
- [ ] No Supabase URLs in public files
- [ ] No database passwords in configuration
- [ ] All sensitive data uses GitHub secrets or environment variables

### 5. Deployment Security
- [ ] GitHub Actions workflow only triggers on authorized branches
- [ ] Deployment only happens from private repository
- [ ] Supabase project has proper access controls
- [ ] Storage bucket permissions are correctly configured

## 🔍 Security Verification Commands

Run these to check for accidentally committed secrets:

```bash
# Check for potential API keys in git history
git log --all -p | grep -E "(key|secret|token|password)" -i

# Check current files for secrets
find . -name "*.dart" -o -name "*.yaml" -o -name "*.yml" -o -name "*.toml" | xargs grep -E "(key|secret|token|password)" -i

# Verify .env files are ignored
git check-ignore .env
git check-ignore **/.env
```

## 🚨 If You Find Exposed Secrets

**If you accidentally committed API keys:**

1. **Immediately revoke** the exposed keys in Supabase dashboard
2. **Generate new keys** 
3. **Remove from git history**:
   ```bash
   git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch path/to/file' --prune-empty --tag-name-filter cat -- --all
   ```
4. **Force push** (⚠️ dangerous - coordinate with team)
5. **Update GitHub secrets** with new keys

## ✅ Final Security Confirmation

**Before going live, confirm:**
- [ ] Repository is private with lock icon 🔒
- [ ] All API keys are in GitHub secrets only
- [ ] No secrets in any committed files
- [ ] `.gitignore` prevents future secret commits
- [ ] Team members understand security practices

---

**🔐 Security is not optional - it's essential!** 