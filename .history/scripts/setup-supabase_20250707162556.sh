#!/bin/bash

# GeoHog Supabase Setup Script
# Run this script to set up Supabase hosting for your GeoHog app

set -e

echo "🏗️  Setting up Supabase hosting for GeoHog..."

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install supabase/tap/supabase
    else
        npm install -g supabase
    fi
fi

# Initialize Supabase project (if not already done)
if [ ! -f "supabase/config.toml" ]; then
    echo "📝 Initializing Supabase project..."
    supabase init
fi

# Create storage bucket for website hosting
echo "🗂️  Setting up storage bucket for web hosting..."

# Login to Supabase (user will need to provide access token)
echo "🔐 Please login to Supabase CLI..."
echo "You can get your access token from: https://supabase.com/dashboard/account/tokens"
supabase auth login

# Link to your Supabase project
echo "🔗 Linking to your Supabase project..."
echo "Please enter your Supabase project reference ID (from your project URL):"
read -p "Project Ref: " PROJECT_REF

supabase link --project-ref $PROJECT_REF

# Create storage bucket via SQL
echo "🗃️  Creating storage bucket for website..."
supabase db push

echo ""
echo "✅ Supabase setup complete!"
echo ""
echo "Next steps:"
echo "1. Go to your Supabase dashboard > Storage"
echo "2. Create a public bucket named 'website'"
echo "3. Set up GitHub secrets in your repository:"
echo "   - SUPABASE_URL: Your Supabase project URL"
echo "   - SUPABASE_ANON_KEY: Your anon public key"
echo "   - SUPABASE_ACCESS_TOKEN: Your access token"
echo "   - SUPABASE_PROJECT_REF: Your project reference ID"
echo ""
echo "4. Push to main branch to trigger deployment"
echo "" 