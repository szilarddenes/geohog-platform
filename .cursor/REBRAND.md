Based on my exploration of your AppFlowy codebase, I can provide you with a comprehensive guide on where to place your GeoHog branding assets. Here's where you need to replace the AppFlowy logos and branding:

## �� **Main Logo Assets**

### 1. **Primary Logo Files** (Replace these SVG files)
- `frontend/appflowy_flutter/assets/images/flowy_logo.svg` - Main app logo (40x40)
- `frontend/appflowy_flutter/assets/images/flowy_logo_with_text.svg` - Logo with "AppFlowy" text (92x17)
- `frontend/appflowy_flutter/assets/images/flowy_logo_dark_mode.svg` - Dark mode version

### 2. **App Icons for Different Platforms**

**iOS App Icons:**
- `frontend/appflowy_flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/` - Contains multiple PNG sizes (29x29 to 1024x1024)

**macOS App Icons:**
- `frontend/appflowy_flutter/macos/Runner/Assets.xcassets/AppIcon.appiconset/` - Contains multiple PNG sizes

**Android App Icons:**
- `frontend/appflowy_flutter/android/app/src/main/res/mipmap-*/` - Various density folders (mdpi, hdpi, xhdpi, etc.)
- `frontend/appflowy_flutter/android/app/src/main/res/mipmap-anydpi-v26/` - Adaptive icons

**Windows App Icon:**
- `frontend/appflowy_flutter/windows/runner/resources/app_icon.ico`

**Web Icons:**
- `frontend/appflowy_flutter/web/icons/` - Icon-192.png, Icon-512.png, etc.

### 3. **Splash Screen & Launch Images**
- `frontend/appflowy_flutter/assets/images/appflowy_launch_splash.jpg` - Launch splash screen
- `frontend/appflowy_flutter/assets/images/app_flowy_abstract_cover_1.jpg` - Abstract cover images
- `frontend/appflowy_flutter/assets/images/app_flowy_abstract_cover_2.jpg`

### 4. **Documentation Images**
- `doc/imgs/appflowy_title_and_logo.png` - Documentation header logo
- `doc/imgs/appflowy-logo-black.svg` - Black version for docs
- `doc/imgs/appflowy-logo-white.svg` - White version for docs

## 🔧 **Code References to Update**

### 5. **Generated SVG Constants** (After replacing assets, regenerate)
The app uses generated constants for SVG references. You'll need to:
1. Replace the SVG files mentioned above
2. Regenerate the `flowy_svgs.g.dart` file (this is auto-generated)

### 6. **Configuration Files to Update**

**App Metadata:**
- `frontend/appflowy_flutter/pubspec.yaml` - App name and description
- `frontend/appflowy_flutter/web/manifest.json` - Web app metadata
- `frontend/appflowy_flutter/android/app/src/main/AndroidManifest.xml` - Android app name
- `frontend/appflowy_flutter/ios/Runner/Info.plist` - iOS app name

**Distribution Files:**
- `frontend/scripts/flatpack-buildfiles/io.appflowy.AppFlowy.metainfo.xml` - Flatpak metadata
- `frontend/scripts/linux_distribution/packaging/io.appflowy.AppFlowy.metainfo.xml` - Linux distribution metadata

### 7. **README and Documentation**
- `README.md` - Main project README with AppFlowy branding
- `doc/CONTRIBUTING.md` - Contributing guidelines

## 📋 **Step-by-Step Rebranding Process**

1. **Create your GeoHog logo assets** in the same formats and sizes as the existing AppFlowy assets
2. **Replace the SVG files** in `assets/images/`
3. **Replace app icons** for all platforms (iOS, Android, macOS, Windows, Web)
4. **Update configuration files** with GeoHog branding
5. **Regenerate the SVG constants** by running the build process
6. **Update documentation** and README files
7. **Test the app** on all platforms to ensure branding appears correctly

## 🎯 **Key Files to Focus On First**

1. **`flowy_logo.svg`** - This is the main logo used throughout the app
2. **`flowy_logo_with_text.svg`** - Used in the sidebar header
3. **App icons** for your target platforms
4. **`pubspec.yaml`** - Update app name and description

The app uses a centralized SVG system, so once you replace the main logo files and regenerate the constants, the branding should update throughout the entire application.