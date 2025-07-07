# GeoHog Supabase Hosting Guide

This guide will help you host your GeoHog app on Supabase using their storage and hosting capabilities.

## Prerequisites

- [Supabase Account](https://supabase.com) (free tier available)
- [Supabase CLI](https://supabase.com/docs/guides/cli) installed
- Flutter SDK installed and configured
- Git and GitHub account for automated deployments

## Quick Start

### 1. Create Supabase Project

1. Go to [https://supabase.com/dashboard](https://supabase.com/dashboard)
2. Click **"New Project"**
3. Fill in project details:
   - **Name**: `geohog-platform` (or your preferred name)
   - **Database Password**: Generate a strong password and save it
   - **Region**: Choose the closest to your users
4. Click **"Create new project"**
5. Wait for the project to be ready (usually 1-2 minutes)

### 2. Get Your Project Credentials

From your Supabase dashboard, go to **Settings > API** and note:
- **Project URL**: `https://your-project-ref.supabase.co`
- **Project Reference**: The part before `.supabase.co`
- **Anon public key**: `eyJ...` (starts with eyJ)

### 3. Set Up Local Development

Run the setup script:

```bash
./scripts/setup-supabase.sh
```

This will:
- Install Supabase CLI (if needed)
- Initialize Supabase in your project
- Prompt you to login and link your project
- Set up the storage bucket for hosting

### 4. Manual Deployment (Testing)

To test deployment locally:

```bash
./scripts/deploy-web.sh
```

This will build your Flutter web app and deploy it to Supabase storage.

### 5. Automated Deployment (Recommended)

For automated deployments via GitHub Actions:

1. Go to your GitHub repository settings
2. Navigate to **Settings > Secrets and variables > Actions**
3. Add these repository secrets:

   ```
   SUPABASE_URL=https://your-project-ref.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   SUPABASE_ACCESS_TOKEN=your-access-token
   SUPABASE_PROJECT_REF=your-project-ref
   ```

4. Get your access token from [Supabase Account Tokens](https://supabase.com/dashboard/account/tokens)

5. Push to `main` or `staging` branch to trigger deployment

## Project Structure

```
├── supabase/
│   ├── config.toml              # Supabase configuration
│   └── migrations/
│       └── 001_create_website_bucket.sql  # Storage setup
├── scripts/
│   ├── setup-supabase.sh        # Initial setup script
│   └── deploy-web.sh             # Manual deployment script
└── .github/workflows/
    └── deploy-web.yml            # Automated deployment
```

## How It Works

### Storage-Based Hosting

GeoHog uses Supabase Storage for static web hosting:

1. **Build**: Flutter web app is built using `flutter build web`
2. **Upload**: Built files are uploaded to a public storage bucket named `website`
3. **Access**: Your app is available at:
   ```
   https://your-project-ref.supabase.co/storage/v1/object/public/website/index.html
   ```

### Deployment Pipeline

The GitHub Actions workflow:
1. Triggers on pushes to `main` or `staging` branches
2. Sets up Flutter and builds the web app
3. Installs Supabase CLI and authenticates
4. Uploads the built files to Supabase storage
5. Provides the deployment URL

## Custom Domain (Optional)

To use a custom domain:

1. Set up a CNAME record pointing to your Supabase storage URL
2. Configure your domain in Supabase dashboard
3. Update your deployment scripts to use the custom domain

## Monitoring and Logs

- **Build Logs**: Check GitHub Actions for build and deployment logs
- **Storage Usage**: Monitor in Supabase dashboard > Storage
- **Performance**: Use browser dev tools to monitor web app performance

## Troubleshooting

### Common Issues

**1. "Bucket not found" error**
- Ensure the `website` bucket exists in your Supabase storage
- Run the migration: `supabase db push`

**2. "Permission denied" error**
- Check your Supabase access token is valid
- Ensure you're authenticated: `supabase auth login`

**3. "Flutter command not found"**
- Install Flutter SDK: [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
- Ensure Flutter is in your PATH

**4. Build failures**
- Check Flutter dependencies: `flutter pub get`
- Verify Flutter version compatibility
- Check GitHub Actions logs for detailed errors

### Debug Commands

```bash
# Check Supabase CLI status
supabase --version
supabase auth status

# Check Flutter installation
flutter doctor

# Test local build
cd frontend/appflowy_flutter
flutter build web --release

# List Supabase projects
supabase projects list

# Check storage buckets
supabase storage ls
```

## Performance Optimization

### Web App Optimization

1. **Bundle Size**: Use `--web-renderer canvaskit` for better performance
2. **Caching**: Configure appropriate cache headers
3. **Compression**: Enable gzip compression in your web server

### Storage Configuration

1. **CDN**: Supabase automatically provides CDN for storage
2. **Caching**: Files are cached by default
3. **Bandwidth**: Monitor usage in Supabase dashboard

## Costs

### Supabase Free Tier Includes:
- 500MB storage
- 1GB bandwidth per month
- Unlimited API requests

### Paid Plans:
- Pro Plan: $25/month (10GB storage, 100GB bandwidth)
- Team Plan: $599/month (100GB storage, 300GB bandwidth)

## Security

### Storage Policies

The setup includes policies for:
- Public read access to website files
- Authenticated upload access for CI/CD

### Environment Variables

Never commit sensitive information:
- Use GitHub Secrets for API keys
- Use environment files for local development
- Follow the `.env.example` pattern

## Support

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Web Documentation](https://docs.flutter.dev/platform-integration/web)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Next Steps

1. ✅ Basic hosting setup
2. 🔄 Custom domain configuration
3. 📊 Analytics integration
4. 🔐 Authentication setup (if needed)
5. 🗄️ Database integration (future)

---

**Note**: This setup provides static web hosting. For dynamic features requiring a backend, you'll need to set up Supabase Edge Functions or integrate with your preferred backend service. 