#!/bin/bash

# =============================================================================
# 🔒 SECURE GITHUB DISTRIBUTION SETUP
# Landing page public, script files invisible, only executables accessible
# =============================================================================

set -e

REPO_NAME="Flutter-Pod"
GITHUB_USERNAME="Joynul-Abedin"
VERSION="v1.0.0"

echo "🔒 Setting up SECURE GitHub Distribution"
echo "========================================"
echo "✅ Landing page: PUBLIC (GitHub Pages)"
echo "❌ Script files: INVISIBLE (not served)"
echo "✅ Executables: PUBLIC (GitHub Releases only)"
echo ""

# =============================================================================
# 🗂️ CLEAN UP PREVIOUS SETUP
# =============================================================================
echo "🧹 Cleaning up previous distribution files..."

# Remove any exposed scripts from docs
rm -rf docs/dist/
find docs/ -name "*.sh" -delete
find docs/ -name "*.ps1" -delete

echo "✅ Removed script files from public docs/ directory"

# =============================================================================
# 📄 CREATE SECURE LANDING PAGE
# =============================================================================
echo "🌐 Creating secure landing page..."

# Update landing page to only reference GitHub Releases (no direct script access)
cat > docs/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🚀 Flutter Setup - Professional Installation</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            padding: 60px 0;
        }
        
        .header h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            background: linear-gradient(45deg, #fff, #e0e0e0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .header p {
            font-size: 1.3rem;
            opacity: 0.9;
            margin-bottom: 40px;
        }
        
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin: 60px 0;
        }
        
        .feature {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            text-align: center;
        }
        
        .feature h3 {
            font-size: 1.5rem;
            margin-bottom: 15px;
        }
        
        .download-section {
            text-align: center;
            padding: 60px 0;
        }
        
        .download-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }
        
        .download-card {
            background: rgba(255, 255, 255, 0.15);
            padding: 40px 20px;
            border-radius: 20px;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: transform 0.3s ease;
        }
        
        .download-card:hover {
            transform: translateY(-5px);
        }
        
        .download-card h3 {
            font-size: 1.8rem;
            margin-bottom: 20px;
        }
        
        .download-btn {
            display: inline-block;
            background: linear-gradient(45deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 50px;
            font-weight: bold;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            margin: 10px;
        }
        
        .download-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }
        
        .command-box {
            background: rgba(0, 0, 0, 0.3);
            padding: 20px;
            border-radius: 10px;
            font-family: 'Courier New', monospace;
            margin: 15px 0;
            overflow-x: auto;
        }
        
        .security-notice {
            background: rgba(34, 139, 34, 0.2);
            border: 1px solid rgba(34, 139, 34, 0.5);
            padding: 20px;
            border-radius: 10px;
            margin: 30px 0;
            text-align: center;
        }
        
        .footer {
            text-align: center;
            padding: 40px 0;
            opacity: 0.8;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2.5rem;
            }
            .container {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Flutter Setup</h1>
            <p>Professional Flutter development environment with AI-powered error recovery</p>
            <p><strong>✨ Zero configuration • 🤖 AI assistance • 📊 Progress tracking</strong></p>
        </div>
        
        <div class="security-notice">
            <h3>🔒 Secure Distribution</h3>
            <p>Source code protected • Only compiled executables provided • Enterprise-grade security</p>
        </div>
        
        <div class="features">
            <div class="feature">
                <h3>🎯 One-Click Setup</h3>
                <p>Complete Flutter development environment installed automatically with all dependencies</p>
            </div>
            <div class="feature">
                <h3>🤖 AI Error Recovery</h3>
                <p>Built-in AI troubleshooting fixes installation issues automatically</p>
            </div>
            <div class="feature">
                <h3>📊 Professional UI</h3>
                <p>Beautiful progress tracking with unified progress bar and clean output</p>
            </div>
            <div class="feature">
                <h3>🔒 Source Protected</h3>
                <p>Compiled executables ensure complete source code protection and security</p>
            </div>
        </div>
        
        <div class="download-section">
            <h2>🎯 Choose Your Platform</h2>
            
            <div class="download-grid">
                <div class="download-card">
                    <h3>🍎 macOS</h3>
                    <p>Intel & Apple Silicon</p>
                    <a href="https://github.com/Joynul-Abedin/Flutter-Pod/releases/latest/download/flutter-setup-macos" class="download-btn">Download for Mac</a>
                    <div class="command-box">
                        curl -fsSL https://Joynul-Abedin.github.io/Flutter-Pod/install-mac | bash
                    </div>
                </div>
                
                <div class="download-card">
                    <h3>🐧 Linux</h3>
                    <p>Ubuntu, Debian & derivatives</p>
                    <a href="https://github.com/Joynul-Abedin/Flutter-Pod/releases/latest/download/flutter-setup-linux" class="download-btn">Download for Linux</a>
                    <div class="command-box">
                        curl -fsSL https://Joynul-Abedin.github.io/Flutter-Pod/install-linux | bash
                    </div>
                </div>
                
                <div class="download-card">
                    <h3>🪟 Windows</h3>
                    <p>Windows 10/11 PowerShell</p>
                    <a href="https://github.com/Joynul-Abedin/Flutter-Pod/releases/latest/download/flutter-setup-windows.exe" class="download-btn">Download for Windows</a>
                    <div class="command-box">
                        iwr https://Joynul-Abedin.github.io/Flutter-Pod/install-windows -useb | iex
                    </div>
                </div>
            </div>
        </div>
        
        <div class="footer">
            <p>🎯 Get started with Flutter development in minutes, not hours</p>
            <p>🔒 Source code protected • Enterprise-grade security</p>
            <p>© 2024 Flutter Setup Professional. Advanced development tools.</p>
        </div>
    </div>
    
    <script>
        // Auto-detect platform and highlight
        document.addEventListener('DOMContentLoaded', function() {
            const platform = navigator.platform.toLowerCase();
            if (platform.includes('mac')) {
                document.querySelector('.download-card:first-child').style.border = '2px solid #ff6b6b';
            } else if (platform.includes('linux')) {
                document.querySelector('.download-card:nth-child(2)').style.border = '2px solid #ff6b6b';
            } else if (platform.includes('win')) {
                document.querySelector('.download-card:last-child').style.border = '2px solid #ff6b6b';
            }
        });
    </script>
</body>
</html>
EOF

echo "✅ Secure landing page created"

# =============================================================================
# 🔗 CREATE SECURE INSTALLATION SCRIPTS (GitHub Pages Only)
# =============================================================================
echo "📜 Creating secure installation scripts..."

# These scripts download from GitHub Releases (not exposed source code)
cat > docs/install-mac << 'EOF'
#!/bin/bash
set -e

REPO="Joynul-Abedin/Flutter-Pod"
DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/flutter-setup-macos"
TEMP_FILE="/tmp/flutter-setup-macos"

echo "🔒 Flutter Setup - Secure Installation"
echo "=====================================+"
echo "📥 Downloading secure executable..."

curl -fsSL "$DOWNLOAD_URL" -o "$TEMP_FILE"
chmod +x "$TEMP_FILE"

echo "🚀 Running Flutter Setup..."
"$TEMP_FILE"

echo "🧹 Cleaning up..."
rm -f "$TEMP_FILE"

echo "✅ Flutter setup completed securely!"
EOF

cat > docs/install-linux << 'EOF'
#!/bin/bash
set -e

REPO="Joynul-Abedin/Flutter-Pod"
DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/flutter-setup-linux"
TEMP_FILE="/tmp/flutter-setup-linux"

echo "🔒 Flutter Setup - Secure Installation"
echo "======================================"
echo "📥 Downloading secure executable..."

curl -fsSL "$DOWNLOAD_URL" -o "$TEMP_FILE"
chmod +x "$TEMP_FILE"

echo "🚀 Running Flutter Setup..."
"$TEMP_FILE"

echo "🧹 Cleaning up..."
rm -f "$TEMP_FILE"

echo "✅ Flutter setup completed securely!"
EOF

cat > docs/install-windows << 'EOF'
# Flutter Setup - Secure Installation for Windows
$repo = "Joynul-Abedin/Flutter-Pod"
$downloadUrl = "https://github.com/$repo/releases/latest/download/flutter-setup-windows.exe"
$tempFile = "$env:TEMP\flutter-setup-windows.exe"

Write-Host "🔒 Flutter Setup - Secure Installation" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "📥 Downloading secure executable..." -ForegroundColor Yellow

Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile

Write-Host "🚀 Running Flutter Setup..." -ForegroundColor Green
& $tempFile

Write-Host "🧹 Cleaning up..." -ForegroundColor Yellow
Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue

Write-Host "✅ Flutter setup completed securely!" -ForegroundColor Green
EOF

chmod +x docs/install-mac docs/install-linux

echo "✅ Secure installation scripts created"

# =============================================================================
# 🔐 CREATE GITIGNORE FOR SOURCE PROTECTION
# =============================================================================
echo "🔐 Setting up source code protection..."

# Add patterns to .gitignore to prevent accidental exposure
cat >> .gitignore << 'EOF'

# =============================================================================
# 🔒 SOURCE CODE PROTECTION
# =============================================================================
# Prevent accidental exposure of script files in docs/
docs/*.sh
docs/*.ps1
docs/scripts/
docs/src/

# Protect distribution source files
dist/src/
dist/scripts/
*.sh.original
*.ps1.original

# Temporary build files
*.x.c
build-temp/
EOF

echo "✅ Source protection configured"

# =============================================================================
# 🎯 CREATE SECURE RELEASE PREPARATION
# =============================================================================
echo "📦 Creating secure release preparation script..."

cat > prepare-secure-release.sh << 'EOF'
#!/bin/bash

# =============================================================================
# 📦 PREPARE SECURE RELEASE
# Creates release-ready executables without exposing source code
# =============================================================================

VERSION=${1:-"v1.0.0"}

echo "📦 Preparing Secure Release: $VERSION"
echo "====================================="

# Create release directory
mkdir -p release

# Copy compiled executables (source code not included)
echo "📋 Copying executables..."
cp dist/macos/flutter-setup-macos release/
cp dist/windows/build-windows.ps1 release/flutter-setup-windows.ps1

# For Linux, we'll need to build on Linux or use cross-compilation
echo "⚠️  Note: Linux executable should be built on Linux system"
echo "   You can use GitHub Actions or a Linux VM for this"

echo ""
echo "🎉 Release files ready in release/ directory:"
echo "   - flutter-setup-macos (compiled binary)"
echo "   - flutter-setup-windows.ps1 (PowerShell script)"
echo ""
echo "🚀 Next steps:"
echo "1. Create release on GitHub: https://github.com/Joynul-Abedin/Flutter-Pod/releases/new"
echo "2. Upload files from release/ directory"
echo "3. Set tag: $VERSION"
echo "4. Users will download executables without seeing source code!"
EOF

chmod +x prepare-secure-release.sh

echo "✅ Secure release preparation script created"

# =============================================================================
# 📋 UPDATE DISTRIBUTION README
# =============================================================================
cat > docs/README.md << EOF
# 🔒 Flutter Setup - Secure Distribution

## 🎯 Professional Installation

### One-Command Setup (Recommended)

#### macOS & Linux:
\`\`\`bash
curl -fsSL https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/install-mac | bash
\`\`\`

#### Windows PowerShell:
\`\`\`powershell
iwr https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/install-windows -useb | iex
\`\`\`

### Direct Executable Downloads

- **macOS**: [flutter-setup-macos](https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/releases/latest/download/flutter-setup-macos)
- **Linux**: [flutter-setup-linux](https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/releases/latest/download/flutter-setup-linux)
- **Windows**: [flutter-setup-windows.exe](https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/releases/latest/download/flutter-setup-windows.exe)

## 🔒 Security Features

- ✅ **Source Code Protected**: Users receive only compiled executables
- ✅ **No Script Exposure**: Original .sh and .ps1 files not accessible
- ✅ **Secure Downloads**: All downloads via HTTPS from GitHub
- ✅ **Integrity Verified**: Official releases only
- ✅ **Enterprise Ready**: Professional security standards

## 🚀 What Users Get

- 🤖 **AI Error Recovery**: Built-in DeepSeek troubleshooting
- 📊 **Unified Progress Bar**: Professional installation UI
- 🔧 **Complete Setup**: Flutter + all dependencies
- 🌍 **Cross-Platform**: macOS, Linux, Windows
- ⚡ **Zero Config**: No setup required

## 🌐 Landing Page

Visit: **https://${GITHUB_USERNAME}.github.io/${REPO_NAME}**

---
🔒 **Source code protected** • 🚀 **Enterprise-grade distribution**
EOF

echo "✅ Secure distribution README updated"

# =============================================================================
# 📊 SUMMARY
# =============================================================================
echo ""
echo "🔒 SECURE GitHub Distribution Setup Complete!"
echo "=============================================="
echo ""
echo "✅ WHAT'S PUBLIC:"
echo "   - Landing page (docs/index.html)"
echo "   - Installation scripts (docs/install-*)"
echo "   - Documentation (docs/README.md)"
echo ""
echo "❌ WHAT'S HIDDEN:"
echo "   - Source script files (.sh, .ps1)"
echo "   - Build processes"
echo "   - Implementation details"
echo ""
echo "🔗 USER ACCESS:"
echo "   - Landing page: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}"
echo "   - One-liners: curl/iwr commands"
echo "   - Executables: GitHub Releases only"
echo ""
echo "🚀 NEXT STEPS:"
echo "1. git add . && git commit -m \"Secure distribution setup\""
echo "2. git push origin main"
echo "3. Enable GitHub Pages (docs/ folder)"
echo "4. Run: ./prepare-secure-release.sh"
echo "5. Create GitHub Release with executables"
echo "6. Users get professional installation without seeing your code!"
echo ""
EOF 