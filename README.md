# 🚀 Intelligent Flutter Environment Setup

Cross-platform Flutter development environment setup scripts with AI-powered error recovery.

## 🌟 Features

- **Cross-Platform Support**: macOS (Intel & Apple Silicon), Linux (Ubuntu/Debian), Windows
- **Latest Flutter**: Automatically installs the latest stable Flutter version
- **Smart Dependencies**: Installs all required tools and SDKs
- **AI Error Recovery**: Uses DeepSeek AI to analyze and suggest fixes for setup errors
- **Intelligent Detection**: Skips already installed components
- **Beautiful UI**: Colorful terminal output with emojis and clear progress indicators

## 📋 Prerequisites

### For AI Error Recovery (Optional)
- OpenRouter API key for DeepSeek access
- Set environment variable: `export OPENROUTER_API_KEY="your-api-key"`

### System Requirements
- **macOS**: macOS 10.14+ (Homebrew will be installed automatically)
- **Linux**: Ubuntu 18.04+ or Debian-based distribution with `sudo` access
- **Windows**: Windows 10+ with PowerShell 5.1+

## 🚀 Quick Start

### macOS & Linux

```bash
# Download and run the script
curl -fsSL https://raw.githubusercontent.com/your-repo/flutter-setup/main/setup_flutter_env.sh | bash

# Or download first, then run
wget https://raw.githubusercontent.com/your-repo/flutter-setup/main/setup_flutter_env.sh
chmod +x setup_flutter_env.sh
./setup_flutter_env.sh
```

### Windows

```powershell
# Download and run the script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/your-repo/flutter-setup/main/setup_flutter_env.ps1" -OutFile "setup_flutter_env.ps1"
.\setup_flutter_env.ps1

# Or run with parameters
.\setup_flutter_env.ps1 -FlutterPath "C:\Dev\flutter" -NoAI
```

## 📖 Detailed Usage

### Bash Script (macOS/Linux) Options

The bash script automatically detects your system and runs the appropriate installation steps:

```bash
# Enable AI error recovery (recommended)
export OPENROUTER_API_KEY="your-api-key"
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

## 🤖 AI Error Recovery

When an error occurs during setup, the scripts can automatically:

1. **Capture Error Context**: Logs the error, current step, and system information
2. **Consult DeepSeek AI**: Sends error details to DeepSeek for analysis
3. **Suggest Solutions**: Provides specific commands or actions to resolve the issue
4. **Interactive Recovery**: Asks if you want to apply the AI suggestion

### Example AI Interaction

```
❌ Error occurred at line 245: brew install openjdk@11
🤖 Consulting AI for error resolution...
🤖 AI Suggestion:
The Homebrew installation might be incomplete. Try running:
1. brew doctor
2. brew update
3. brew install openjdk@11

🤔 Do you want to try the AI suggestion? (y/n): y
```

## 📁 File Structure

```
├── setup_flutter_env.sh     # macOS/Linux setup script
├── setup_flutter_env.ps1    # Windows PowerShell script
├── README.md                # This documentation
└── .cursorrules             # Development notes and lessons learned
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