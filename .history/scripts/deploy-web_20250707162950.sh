#!/bin/bash

# Manual deployment script for testing
# This builds and deploys the Flutter web app to Supabase

set -e

echo "🚀 Building and deploying GeoHog web app..."

# Change to Flutter app directory
cd frontend/appflowy_flutter

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Enable web platform
echo "🌐 Enabling web platform..."
flutter config --enable-web

# Build for web
echo "🏗️  Building Flutter web app..."
flutter build web --release

# Check if Supabase CLI is available and authenticated
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Please install it first."
    exit 1
fi

# Check if logged in
if ! supabase projects list &> /dev/null; then
    echo "❌ Not logged in to Supabase. Please run 'supabase auth login' first."
    exit 1
fi

# Deploy to Supabase storage
echo "☁️  Deploying to Supabase storage..."
supabase storage cp -r build/web/ supabase://website/

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Your app should be available at:"
echo "https://[your-project-ref].supabase.co/storage/v1/object/public/website/index.html"
echo ""
echo "Note: Replace [your-project-ref] with your actual Supabase project reference."
echo "" 