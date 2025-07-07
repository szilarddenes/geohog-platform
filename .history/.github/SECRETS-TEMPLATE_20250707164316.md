# GitHub Repository Secrets Setup

## ⚠️ IMPORTANT SECURITY NOTICE
**NEVER commit actual API keys to this repository!**
This file only shows the secret names you need to configure.

## Required Secrets for Supabase Deployment

Go to your GitHub repository: **Settings > Secrets and variables > Actions**

Add these **Repository secrets**:

### 1. SUPABASE_URL
- **Name**: `SUPABASE_URL`
- **Value**: `https://your-project-ref.supabase.co`
- **Where to find**: Supabase Dashboard > Settings > API > Project URL

### 2. SUPABASE_ANON_KEY
- **Name**: `SUPABASE_ANON_KEY`
- **Value**: `eyJ...` (starts with eyJ)
- **Where to find**: Supabase Dashboard > Settings > API > Project API keys > anon public

### 3. SUPABASE_ACCESS_TOKEN
- **Name**: `SUPABASE_ACCESS_TOKEN`
- **Value**: Your personal access token
- **Where to find**: https://supabase.com/dashboard/account/tokens

### 4. SUPABASE_PROJECT_REF
- **Name**: `SUPABASE_PROJECT_REF`
- **Value**: `oqjjyjwyzddwzqlezfjm` (your project reference ID)
- **Where to find**: From your project URL or `supabase projects list`

## How to Add Secrets

1. Go to: `https://github.com/szilarddenes/geohog-platform/settings/secrets/actions`
2. Click **"New repository secret"**
3. Add each secret listed above
4. **Never share these values publicly**

## Security Checklist

- [ ] Repository is set to **Private**
- [ ] All secrets added to GitHub (not committed to code)
- [ ] No API keys in any files
- [ ] `.env` files are in `.gitignore`
- [ ] Access tokens have minimal required permissions

## Testing

After adding secrets, push to `main` branch to trigger deployment workflow.

---

**🔒 This file contains NO actual secrets - only instructions for setup.** 