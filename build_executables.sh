#!/bin/bash

# =============================================================================
# 🔨 BUILD FLUTTER SETUP EXECUTABLES
# Compile scripts to binary executables for public distribution
# =============================================================================

set -e

BUILD_DIR="dist"
VERSION="1.0.0"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "🔨 Building Flutter Setup Executables v${VERSION}"
echo "=================================================="

# Create build directory
mkdir -p "${BUILD_DIR}"/{macos,linux,windows}

# =============================================================================
# 📦 COMPILE BASH SCRIPT (macOS/Linux)
# =============================================================================
echo "🍎 Compiling macOS executable..."

# Compile for macOS (current architecture)
shc -f setup_flutter_env.sh -o "${BUILD_DIR}/macos/flutter-setup-macos"

# Make executable
chmod +x "${BUILD_DIR}/macos/flutter-setup-macos"

echo "✅ macOS executable created: ${BUILD_DIR}/macos/flutter-setup-macos"

# =============================================================================
# 🐧 LINUX EXECUTABLE (Cross-compile simulation)
# =============================================================================
echo "🐧 Preparing Linux executable..."

# For actual Linux cross-compilation, you'd need a Linux environment
# For now, we'll create a placeholder script that downloads and compiles
cat > "${BUILD_DIR}/linux/install.sh" << 'EOF'
#!/bin/bash
echo "🐧 Flutter Setup for Linux - Downloading components..."
# This would download the actual compiled binary from your server
curl -fsSL "https://yourserver.com/flutter-setup-linux" -o flutter-setup-linux
chmod +x flutter-setup-linux
./flutter-setup-linux
EOF

chmod +x "${BUILD_DIR}/linux/install.sh"

echo "✅ Linux installer created: ${BUILD_DIR}/linux/install.sh"

# =============================================================================
# 🪟 WINDOWS EXECUTABLE
# =============================================================================
echo "🪟 Preparing Windows executable builder..."

# Create PowerShell script compiler
cat > "${BUILD_DIR}/windows/build-windows.ps1" << 'EOF'
# PowerShell Script to EXE Compiler
# Requires ps2exe module: Install-Module -Name ps2exe

# Convert PowerShell script to executable
ps2exe -inputFile "..\..\setup_flutter_env.ps1" -outputFile "flutter-setup-windows.exe" -requireAdmin -verbose

Write-Host "✅ Windows executable created: flutter-setup-windows.exe"
EOF

echo "✅ Windows build script created: ${BUILD_DIR}/windows/build-windows.ps1"

# =============================================================================
# 📋 CREATE DISTRIBUTION README
# =============================================================================
cat > "${BUILD_DIR}/README.md" << EOF
# 🚀 Flutter Setup Executables

## Download & Install

### macOS
\`\`\`bash
curl -fsSL https://yourserver.com/macos -o flutter-setup && chmod +x flutter-setup && ./flutter-setup
\`\`\`

### Linux  
\`\`\`bash
curl -fsSL https://yourserver.com/linux | bash
\`\`\`

### Windows
\`\`\`powershell
Invoke-WebRequest -Uri "https://yourserver.com/windows" -OutFile "flutter-setup.exe"
.\flutter-setup.exe
\`\`\`

## Features
- ✅ Zero-configuration setup
- ✅ AI-powered error recovery  
- ✅ Cross-platform support
- ✅ Professional progress tracking

## Support
For issues, visit: https://yourwebsite.com/support

Generated: ${TIMESTAMP}
Version: ${VERSION}
EOF

# =============================================================================
# 📊 SUMMARY
# =============================================================================
echo ""
echo "🎉 Build Complete!"
echo "=================="
echo "📁 Distribution files created in: ${BUILD_DIR}/"
echo ""
echo "📦 Files created:"
echo "  macOS:   ${BUILD_DIR}/macos/flutter-setup-macos"
echo "  Linux:   ${BUILD_DIR}/linux/install.sh"  
echo "  Windows: ${BUILD_DIR}/windows/build-windows.ps1"
echo "  README:  ${BUILD_DIR}/README.md"
echo ""
echo "🌐 Next steps:"
echo "1. Upload executables to your hosting server"
echo "2. Set up download endpoints"
echo "3. Create a landing page for easy access"
echo "4. Consider code signing for better security"
echo "" 