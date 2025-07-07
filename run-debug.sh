#!/bin/bash

# GeoHog AppFlowy Debug Runner
# This script navigates to the correct directory and runs the Flutter app in debug mode

echo "🚀 Starting GeoHog AppFlowy in debug mode..."
echo "📂 Navigating to frontend directory..."

# Navigate to the Flutter app directory
cd frontend/appflowy_flutter

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Make sure you're running this from the geohog-platform directory."
    exit 1
fi

echo "✅ Found Flutter project"
echo "🔧 Running Flutter app in debug mode for macOS..."

# Run the Flutter app in debug mode
flutter run -d macos --debug

echo "🏁 App finished running" 