#!/usr/bin/env python3

import os
import subprocess
import sys
from pathlib import Path

def run_command(cmd):
    """Run a shell command and return success status"""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"Error running: {cmd}")
            print(f"Error: {result.stderr}")
            return False
        return True
    except Exception as e:
        print(f"Exception running {cmd}: {e}")
        return False

def convert_svg_to_png(svg_path, output_path, size):
    """Convert SVG to PNG at specified size using rsvg-convert or inkscape"""
    
    # Try rsvg-convert first (more common on macOS via Homebrew)
    cmd = f"rsvg-convert -w {size} -h {size} '{svg_path}' -o '{output_path}'"
    if run_command(cmd):
        return True
    
    # Try inkscape as fallback
    cmd = f"inkscape --export-width={size} --export-height={size} --export-filename='{output_path}' '{svg_path}'"
    if run_command(cmd):
        return True
    
    # Try ImageMagick as last resort
    cmd = f"convert -background transparent -size {size}x{size} '{svg_path}' '{output_path}'"
    if run_command(cmd):
        return True
    
    print(f"Failed to convert {svg_path} to {output_path} at size {size}x{size}")
    return False

def generate_app_icons():
    """Generate all app icons from the GeoHog logo"""
    
    # Base directories
    flutter_dir = Path("frontend/appflowy_flutter")
    logo_svg = flutter_dir / "assets/images/flowy_logo.svg"
    
    if not logo_svg.exists():
        print(f"Error: Logo file not found at {logo_svg}")
        return False
    
    print(f"Using logo: {logo_svg}")
    
    # iOS App Icons
    ios_dir = flutter_dir / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    ios_sizes = [29, 40, 57, 58, 60, 80, 87, 114, 120, 180, 1024]
    
    print("Generating iOS app icons...")
    for size in ios_sizes:
        output = ios_dir / f"{size}.png"
        print(f"  Creating {size}x{size} icon...")
        if not convert_svg_to_png(logo_svg, output, size):
            return False
    
    # macOS App Icons
    macos_dir = flutter_dir / "macos/Runner/Assets.xcassets/AppIcon.appiconset"
    macos_sizes = [16, 20, 29, 32, 40, 50, 57, 58, 60, 64, 72, 76, 80, 87, 100, 114, 120, 128, 144, 152, 167, 180, 256, 512, 1024]
    
    print("Generating macOS app icons...")
    for size in macos_sizes:
        output = macos_dir / f"{size}.png"
        print(f"  Creating {size}x{size} icon...")
        if not convert_svg_to_png(logo_svg, output, size):
            return False
    
    # Android App Icons
    android_dirs = [
        ("mipmap-mdpi", 48),
        ("mipmap-hdpi", 72),
        ("mipmap-xhdpi", 96),
        ("mipmap-xxhdpi", 144),
        ("mipmap-xxxhdpi", 192)
    ]
    
    print("Generating Android app icons...")
    for dir_name, size in android_dirs:
        android_dir = flutter_dir / f"android/app/src/main/res/{dir_name}"
        
        # Create main launcher icons
        for icon_name in ["ic_launcher.png", "ic_launcher_round.png"]:
            output = android_dir / icon_name
            print(f"  Creating {dir_name}/{icon_name} ({size}x{size})...")
            if not convert_svg_to_png(logo_svg, output, size):
                return False
        
        # Create foreground and monochrome variants (slightly larger for adaptive icons)
        foreground_size = int(size * 1.5)  # Foreground should be larger for adaptive icons
        for icon_name in ["ic_launcher_foreground.png", "ic_launcher_monochrome.png"]:
            output = android_dir / icon_name
            print(f"  Creating {dir_name}/{icon_name} ({foreground_size}x{foreground_size})...")
            if not convert_svg_to_png(logo_svg, output, foreground_size):
                return False
    
    # Web App Icons
    web_dir = flutter_dir / "web"
    web_icons_dir = web_dir / "icons"
    
    print("Generating Web app icons...")
    
    # Favicon
    favicon_output = web_dir / "favicon.png"
    print(f"  Creating favicon.png (32x32)...")
    if not convert_svg_to_png(logo_svg, favicon_output, 32):
        return False
    
    # Web manifest icons
    web_sizes = [(192, "Icon-192.png"), (512, "Icon-512.png"), (192, "Icon-maskable-192.png"), (512, "Icon-maskable-512.png")]
    for size, filename in web_sizes:
        output = web_icons_dir / filename
        print(f"  Creating {filename} ({size}x{size})...")
        if not convert_svg_to_png(logo_svg, output, size):
            return False
    
    print("✅ All app icons generated successfully!")
    return True

if __name__ == "__main__":
    print("🎨 GeoHog App Icon Generator")
    print("=" * 40)
    
    # Check if we're in the right directory
    if not Path("frontend/appflowy_flutter").exists():
        print("Error: Please run this script from the project root directory")
        sys.exit(1)
    
    success = generate_app_icons()
    if not success:
        print("❌ Failed to generate some app icons")
        print("\n💡 Make sure you have one of these tools installed:")
        print("  - rsvg-convert: brew install librsvg")
        print("  - inkscape: brew install inkscape") 
        print("  - ImageMagick: brew install imagemagick")
        sys.exit(1)
    
    print("\n🎉 App icon generation complete!") 