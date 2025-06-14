# 🚀 Intelligent Flutter Environment Setup

Cross-platform Flutter development environment setup scripts with AI-powered error recovery.

## 🌟 Features

- **Cross-Platform Support**: macOS (Intel & Apple Silicon), Linux (Ubuntu/Debian), Windows
- **Latest Flutter**: Automatically installs the latest stable Flutter version
- **Smart Dependencies**: Installs all required tools and SDKs
- **Zero-Config AI Recovery**: Built-in DeepSeek AI integration (no API key setup required)
- **Unified Progress Bar**: Fixed bottom progress bar with clean output separation
- **Intelligent Detection**: Skips already installed components
- **Self-healing Installation**: Automatic retry with AI-guided fixes for failed components
- **Professional UI**: Clean terminal interface with persistent progress tracking

## 📋 Prerequisites

### System Requirements
- **macOS**: macOS 10.14+ (Homebrew will be installed automatically)
- **Linux**: Ubuntu 18.04+ or Debian-based distribution with `sudo` access
- **Windows**: Windows 10+ with PowerShell 5.1+

## 🚀 Quick Start

### macOS & Linux

```bash
# Download and run the script
curl -fsSL https://raw.githubusercontent.com/Joynul-Abedin/Flutter-Pod/main/setup_flutter_env.sh | bash

# Or download first, then run
wget https://raw.githubusercontent.com/Joynul-Abedin/Flutter-Pod/main/setup_flutter_env.sh
chmod +x setup_flutter_env.sh
./setup_flutter_env.sh
```

### Windows

```powershell
# Download and run the script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Joynul-Abedin/Flutter-Pod/main/setup_flutter_env.ps1" -OutFile "setup_flutter_env.ps1"
.\setup_flutter_env.ps1

# Or run with parameters
.\setup_flutter_env.ps1 -FlutterPath "C:\Dev\flutter" -NoAI
```

## 📖 Detailed Usage

### Bash Script (macOS/Linux) Options

The bash script automatically detects your system and runs the appropriate installation steps:

```bash
# Basic installation with built-in AI error recovery
./setup_flutter_env.sh
```

### PowerShell Script (Windows) Options

```powershell
# Basic installation
.\setup_flutter_env.ps1

# Custom Flutter installation path
.\setup_flutter_env.ps1 -FlutterPath "C:\Dev\flutter"

# Disable AI error recovery
.\setup_flutter_env.ps1 -NoAI

# Run as Administrator (recommended)
# Right-click PowerShell -> "Run as Administrator"
.\setup_flutter_env.ps1
```

## 🛠️ What Gets Installed

### All Platforms
- ✅ Git
- ✅ curl/wget
- ✅ unzip utilities
- ✅ Java JDK 11
- ✅ Latest stable Flutter SDK
- ✅ Flutter PATH configuration
- ✅ Flutter precache (web, mobile targets)

### macOS Specific
- ✅ Homebrew (if not installed)
- ✅ CocoaPods
- ✅ Ruby (if needed for CocoaPods)
- ✅ Xcode license acceptance (if Xcode installed)

### Linux Specific
- ✅ APT package updates
- ✅ Linux-specific Flutter dependencies (libglu1-mesa, etc.)

### Windows Specific
- ✅ Chocolatey package manager
- ✅ 7-Zip for archives
- ✅ Windows-specific PATH handling

## 🎯 Unified Progress Bar System

Experience professional installation feedback with our innovative progress tracking:

- **🔒 Fixed Position**: Progress bar always remains at the bottom of your terminal
- **📊 Real-time Updates**: Live percentage completion with current step description
- **📝 Clean Logs**: All installation output appears above the progress bar
- **📏 Dynamic Width**: Automatically adjusts to your terminal size
- **🎨 Visual Clarity**: Clear separation between logs and progress tracking

This creates a clean, professional installation experience where you can easily follow both the detailed logs and overall progress simultaneously.

## 🤖 Smart AI-Powered Installation

The scripts provide intelligent, self-healing installation with automatic dependency resolution:

### **Unified Progress Bar System**
- 📊 **Fixed Bottom Bar**: Progress bar stays permanently at the bottom of terminal
- 📈 **Clean Output**: All installation logs and output appear above the progress bar
- 🎯 **Real-time Updates**: Live completion percentage with current step details
- 🔄 **Dynamic Resizing**: Automatically adapts to terminal width for optimal display
- ⚡ **Professional Experience**: No more scattered progress messages throughout output

### **Automatic AI Error Recovery**
1. **Detect Issues**: Automatically detects package installation failures
2. **AI Analysis**: Consults DeepSeek AI with specific error context and system info
3. **Smart Fixes**: Receives and auto-executes dependency resolution commands
4. **Seamless Retry**: Continues installation after fixing dependencies
5. **Fallback Support**: Interactive mode if auto-fixes need confirmation

### **Visual Progress Experience**
```
🚀     Intelligent Flutter Environment Setup Script             🚀
🚀     Powered by AI Error Recovery (DeepSeek)                  🚀

ℹ️  🖥️  System Information: macOS 15.3.2 (arm64)
✅ 🤖 AI Error Recovery: Enabled

ℹ️  Installing basic dependencies
✅ git already installed
✅ wget already installed
ℹ️  Installing Java JDK
✅ Java already installed: 21.0.7

────────────────────────────────────────────────────────────────────────────────
📊 [███████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 37% - Installing CocoaPods
```

### **Example Smart Recovery**
```
ℹ️  Installing Ruby dependencies...
❌ Ruby installation failed: missing development tools
🤖 Consulting AI... (attempt 1/3)
🔄 Retrying after AI fix...
✅ Dependencies resolved, continuing installation...

────────────────────────────────────────────────────────────────────────────────
📊 [██████████████████░░░░░░░░░░░░░░░░░░░░░░░░] 62% - Configuring Flutter
```

### **Smart Dependency Resolution**
The system automatically handles complex dependency chains:

- **Ruby Installation**: Auto-installs development tools and build dependencies
- **Java Setup**: Handles JDK linking and PATH configuration issues
- **CocoaPods**: Resolves gem conflicts and Ruby version compatibility
- **Flutter SDK**: Manages extraction, permissions, and PATH setup issues
- **Package Managers**: Fixes Homebrew, Chocolatey, and APT repository issues

## 📁 File Structure

```
├── setup_flutter_env.sh     # macOS/Linux setup script
├── setup_flutter_env.ps1    # Windows PowerShell script
├── README.md                # This documentation
├── .gitignore              # Git ignore rules
└── .cursorrules            # Development notes and lessons learned
```

## 🔧 Troubleshooting

### Common Issues

#### macOS
- **Xcode License**: Run `sudo xcodebuild -license accept`
- **Homebrew Permissions**: Fix with `sudo chown -R $(whoami) /opt/homebrew`
- **CocoaPods**: Run `gem install cocoapods --user-install`

#### Linux
- **Permissions**: Ensure your user has `sudo` access
- **Missing Dependencies**: The script handles most cases automatically
- **Android Studio**: Install manually for Android development

#### Windows
- **Execution Policy**: Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **Admin Rights**: Run PowerShell as Administrator for system-wide PATH
- **Antivirus**: Temporarily disable if blocking downloads

### Manual Flutter Installation

If the automatic installation fails, you can install Flutter manually:

1. Download Flutter from https://flutter.dev/docs/get-started/install
2. Extract to your preferred location
3. Add `flutter/bin` to your PATH
4. Run `flutter doctor` to verify

## 🚦 Post-Installation

After running the setup script:

1. **Restart your terminal** or source your shell configuration:
   ```bash
   # macOS/Linux
   source ~/.zshrc  # or ~/.bashrc
   ```

2. **Verify installation**:
   ```bash
   flutter --version
   flutter doctor -v
   ```

3. **Create your first app**:
   ```bash
   flutter create my_awesome_app
   cd my_awesome_app
   flutter run
   ```

## 🧪 Testing the Scripts

To test the scripts in different environments:

### Using Docker (Linux simulation)
```bash
# Test Ubuntu setup
docker run -it --rm ubuntu:22.04 bash
# ... install curl, then run the script

# Test Debian setup  
docker run -it --rm debian:bullseye bash
# ... install curl, then run the script
```

### Using Virtual Machines
- **macOS**: Test on different macOS versions
- **Windows**: Test on Windows 10/11 with different PowerShell versions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes on multiple platforms
4. Submit a pull request

### Development Notes

- Error handling improvements are tracked in `.cursorrules`
- AI prompts can be refined for better error recovery
- Platform-specific edge cases should be documented

## 📝 License

MIT License - feel free to use and modify these scripts for your projects.

## 🙏 Acknowledgments

- Flutter team for the excellent framework
- OpenRouter for AI API access
- DeepSeek for intelligent error analysis
- Homebrew, Chocolatey, and APT maintainers

---

**Happy Flutter Development! 🎯✨** 