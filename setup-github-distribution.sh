#!/bin/bash

# =============================================================================
# 🚀 SETUP GITHUB DISTRIBUTION
# Configure GitHub Pages + Releases for Flutter setup distribution
# =============================================================================

set -e

REPO_NAME="Flutter-Pod"
GITHUB_USERNAME="Joynul-Abedin"
VERSION="v1.0.0"

echo "🚀 Setting up GitHub Distribution for Flutter Setup"
echo "================================================="
echo "📁 Repository: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo "🌐 GitHub Pages: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}"
echo ""

# =============================================================================
# 📦 PREPARE GITHUB PAGES
# =============================================================================
echo "📄 Setting up GitHub Pages files..."

# Create docs directory for GitHub Pages
mkdir -p docs

# Copy landing page to docs (GitHub Pages serves from docs/ folder)
cp index.html docs/
cp -r dist/ docs/dist/

# Update the landing page with correct GitHub URLs
sed -i.bak "s|https://your-cdn.com/executables/|https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/releases/download/${VERSION}/|g" docs/index.html
sed -i.bak "s|https://flutter-setup.com/mac|https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/install-mac|g" docs/index.html
sed -i.bak "s|https://flutter-setup.com/linux|https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/install-linux|g" docs/index.html
sed -i.bak "s|https://flutter-setup.com/win|https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/install-windows|g" docs/index.html

# Clean up backup files
rm -f docs/index.html.bak

echo "✅ GitHub Pages files prepared in docs/ directory"

# =============================================================================
# 🔗 CREATE INSTALLATION SCRIPTS
# =============================================================================
echo "📜 Creating platform-specific installation scripts..."

# macOS installation script
cat > docs/install-mac << 'EOF'
#!/bin/bash
set -e

REPO="Joynul-Abedin/Flutter-Pod"
VERSION="v1.0.0"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/flutter-setup-macos"
TEMP_FILE="/tmp/flutter-setup-macos"

echo "🍎 Downloading Flutter Setup for macOS..."
curl -fsSL "$DOWNLOAD_URL" -o "$TEMP_FILE"
chmod +x "$TEMP_FILE"

echo "🚀 Running Flutter Setup..."
"$TEMP_FILE"

echo "🧹 Cleaning up..."
rm -f "$TEMP_FILE"

echo "✅ Flutter setup completed!"
EOF

# Linux installation script  
cat > docs/install-linux << 'EOF'
#!/bin/bash
set -e

REPO="Joynul-Abedin/Flutter-Pod"
VERSION="v1.0.0"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/flutter-setup-linux"
TEMP_FILE="/tmp/flutter-setup-linux"

echo "🐧 Downloading Flutter Setup for Linux..."
curl -fsSL "$DOWNLOAD_URL" -o "$TEMP_FILE"
chmod +x "$TEMP_FILE"

echo "🚀 Running Flutter Setup..."
"$TEMP_FILE"

echo "🧹 Cleaning up..."
rm -f "$TEMP_FILE"

echo "✅ Flutter setup completed!"
EOF

# Windows installation script
cat > docs/install-windows << 'EOF'
# Flutter Setup for Windows
$repo = "Joynul-Abedin/Flutter-Pod"
$version = "v1.0.0"
$downloadUrl = "https://github.com/$repo/releases/download/$version/flutter-setup-windows.exe"
$tempFile = "$env:TEMP\flutter-setup-windows.exe"

Write-Host "🪟 Downloading Flutter Setup for Windows..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile

Write-Host "🚀 Running Flutter Setup..." -ForegroundColor Green
& $tempFile

Write-Host "🧹 Cleaning up..." -ForegroundColor Yellow
Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue

Write-Host "✅ Flutter setup completed!" -ForegroundColor Green
EOF

chmod +x docs/install-mac docs/install-linux

echo "✅ Installation scripts created"

# =============================================================================
# 📋 CREATE GITHUB ACTIONS WORKFLOW
# =============================================================================
echo "⚙️ Creating GitHub Actions workflow..."

mkdir -p .github/workflows

cat > .github/workflows/build-and-release.yml << 'EOF'
name: Build and Release Flutter Setup

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  build-and-release:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Set up environment
      run: |
        sudo apt-get update
        sudo apt-get install -y shc
        
    - name: Build executables
      run: |
        # Build macOS executable (cross-compile)
        shc -f setup_flutter_env.sh -o flutter-setup-macos
        
        # Build Linux executable
        shc -f setup_flutter_env.sh -o flutter-setup-linux
        
        # For Windows, we'll use the PowerShell script directly
        cp setup_flutter_env.ps1 flutter-setup-windows.ps1
        
    - name: Create Release
      id: create_release
      uses: actions/create-release@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        tag_name: ${{ github.ref }}
        release_name: Flutter Setup ${{ github.ref }}
        body: |
          🚀 Flutter Environment Setup - Professional Installation
          
          ## Download for your platform:
          - **macOS**: Download `flutter-setup-macos`
          - **Linux**: Download `flutter-setup-linux`  
          - **Windows**: Download `flutter-setup-windows.ps1`
          
          ## One-liner installation:
          ```bash
          # macOS/Linux
          curl -fsSL https://joynul-abedin.github.io/Flutter-Pod/install-mac | bash
          
          # Windows
          iwr https://joynul-abedin.github.io/Flutter-Pod/install-windows -useb | iex
          ```
          
          ## Features:
          - ✅ AI-powered error recovery
          - ✅ Unified progress bar
          - ✅ Cross-platform support
          - ✅ Zero configuration required
        draft: false
        prerelease: false
        
    - name: Upload macOS Binary
      uses: actions/upload-release-asset@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        upload_url: ${{ steps.create_release.outputs.upload_url }}
        asset_path: ./flutter-setup-macos
        asset_name: flutter-setup-macos
        asset_content_type: application/octet-stream
        
    - name: Upload Linux Binary
      uses: actions/upload-release-asset@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        upload_url: ${{ steps.create_release.outputs.upload_url }}
        asset_path: ./flutter-setup-linux
        asset_name: flutter-setup-linux
        asset_content_type: application/octet-stream
        
    - name: Upload Windows Script
      uses: actions/upload-release-asset@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        upload_url: ${{ steps.create_release.outputs.upload_url }}
        asset_path: ./flutter-setup-windows.ps1
        asset_name: flutter-setup-windows.ps1
        asset_content_type: text/plain
EOF

echo "✅ GitHub Actions workflow created"

# =============================================================================
# 📄 CREATE DISTRIBUTION README
# =============================================================================
cat > docs/README.md << EOF
# 🚀 Flutter Setup Distribution

## One-Click Installation

### macOS & Linux
\`\`\`bash
curl -fsSL https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/install-mac | bash
\`\`\`

### Windows PowerShell
\`\`\`powershell
iwr https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/install-windows -useb | iex
\`\`\`

## Direct Downloads

- **macOS**: [flutter-setup-macos](https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/releases/latest/download/flutter-setup-macos)
- **Linux**: [flutter-setup-linux](https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/releases/latest/download/flutter-setup-linux)
- **Windows**: [flutter-setup-windows.ps1](https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/releases/latest/download/flutter-setup-windows.ps1)

## Features

- 🤖 **AI Error Recovery**: Built-in DeepSeek AI troubleshooting
- 📊 **Unified Progress Bar**: Professional installation experience
- 🔧 **Complete Setup**: Flutter + dependencies + PATH configuration
- 🚀 **Cross-Platform**: macOS, Linux, Windows support
- ✨ **Zero Config**: No API keys or setup required

## Visit

🌐 **Landing Page**: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}

Generated: $(date)
EOF

echo "✅ Distribution README created"

# =============================================================================
# 📊 SUMMARY
# =============================================================================
echo ""
echo "🎉 GitHub Distribution Setup Complete!"
echo "======================================"
echo ""
echo "📁 Files created:"
echo "  - docs/index.html (GitHub Pages landing page)"
echo "  - docs/install-mac (macOS one-liner installer)"
echo "  - docs/install-linux (Linux one-liner installer)"  
echo "  - docs/install-windows (Windows one-liner installer)"
echo "  - .github/workflows/build-and-release.yml (Auto-build on release)"
echo "  - docs/README.md (Distribution documentation)"
echo ""
echo "🌐 Your distribution URLs:"
echo "  Landing Page: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}"
echo "  macOS Install: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/install-mac"
echo "  Linux Install: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/install-linux"
echo "  Windows Install: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/install-windows"
echo ""
echo "🚀 Next steps:"
echo "1. git add . && git commit -m \"Add GitHub distribution setup\""
echo "2. git push origin main"
echo "3. Enable GitHub Pages in repository settings (docs/ folder)"
echo "4. Create a release tag: git tag v1.0.0 && git push origin v1.0.0"
echo "5. Visit your landing page and test the installers!"
echo "" 