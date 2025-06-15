# 🚀 Flutter Environment Setup Scripts

Cross-platform Flutter development environment setup with AI-powered error recovery.

## 🚀 Quick Start - Choose Your Installation Method

### 🍎 macOS & Linux

#### 🔥 Option 1: Quick Install (Fastest)
**Perfect for: Fast setup without interactive prompts**
```bash
curl -fsSL https://raw.githubusercontent.com/Joynul-Abedin/Flutter-Pod/main/setup_flutter_env.sh | bash
```

#### 🤖 Option 2: Interactive Setup (With AI Features)
**Perfect for: Users who want AI-powered error recovery**
```bash
curl -O https://raw.githubusercontent.com/Joynul-Abedin/Flutter-Pod/main/setup_flutter_env.sh
chmod +x setup_flutter_env.sh
./setup_flutter_env.sh
```

#### ⚡ Option 3: Pre-configured AI (For Power Users)
**Perfect for: Automation and scripts with AI features**
```bash
export OPENROUTER_API_KEY="your-key-here"
curl -fsSL https://raw.githubusercontent.com/Joynul-Abedin/Flutter-Pod/main/setup_flutter_env.sh | bash
```

### 🪟 Windows PowerShell (Run as Administrator)

#### 🔥 Option 1: Quick Install (Fastest)
**Perfect for: Fast setup without interactive prompts**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Joynul-Abedin/Flutter-Pod/main/setup_flutter_env.ps1" -OutFile "setup.ps1"; .\setup.ps1; Remove-Item setup.ps1
```

#### 🤖 Option 2: Interactive Setup (With AI Features)
**Perfect for: Users who want AI-powered error recovery**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Joynul-Abedin/Flutter-Pod/main/setup_flutter_env.ps1" -OutFile "setup_flutter_env.ps1"
.\setup_flutter_env.ps1
```

#### ⚡ Option 3: Pre-configured AI (For Power Users)
**Perfect for: Automation and scripts with AI features**
```powershell
$env:OPENROUTER_API_KEY="your-key-here"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Joynul-Abedin/Flutter-Pod/main/setup_flutter_env.ps1" -OutFile "setup.ps1"; .\setup.ps1; Remove-Item setup.ps1
```

> **💡 Need an API key?** Get a free one at [openrouter.ai](https://openrouter.ai) for AI-powered error recovery!

## 🌟 Features

- **🔥 One-Click Setup**: Complete Flutter environment installation
- **🤖 AI Error Recovery**: Optional intelligent troubleshooting with DeepSeek AI
- **📊 Progress Tracking**: Professional progress bar with clean output
- **🌍 Cross-Platform**: Works on macOS, Linux, and Windows
- **⚡ Smart Detection**: Skips already installed components
- **🛡️ Self-Healing**: Automatic retry with AI-guided fixes

## 🛠️ What Gets Installed

### Core Components (All Platforms)
- ✅ Git version control
- ✅ Java JDK 11+
- ✅ Latest stable Flutter SDK
- ✅ Flutter PATH configuration
- ✅ Development dependencies

### Platform-Specific
- **macOS**: Homebrew, CocoaPods, Xcode tools
- **Linux**: APT packages, Flutter dependencies
- **Windows**: Chocolatey, development tools

## 🤖 AI-Powered Error Recovery

The scripts include optional intelligent error recovery that automatically:

1. **Detects Issues**: Identifies installation failures
2. **Consults AI**: Uses DeepSeek AI for problem analysis  
3. **Applies Fixes**: Automatically resolves dependency issues
4. **Continues Setup**: Seamlessly resumes installation

Choose **Option 2** or **Option 3** from the Quick Start section above to enable AI features.

### Visual Progress Experience
```
🚀     Intelligent Flutter Environment Setup Script             🚀
🚀     Powered by AI Error Recovery (DeepSeek)                  🚀

ℹ️  🖥️  System: macOS 15.3.2 (arm64)
✅ 🤖 AI Error Recovery: Enabled (with API key)
⚠️  🤖 AI Error Recovery: Disabled (no API key provided)

────────────────────────────────────────────────────────────────
📊 [███████████░░░░░░░░░░░░░░░░░░░] 37% - Installing Flutter SDK
```

## 📋 Requirements

- **macOS**: macOS 10.14+ 
- **Linux**: Ubuntu 18.04+ or Debian-based with sudo access
- **Windows**: Windows 10+ with PowerShell 5.1+

## 🔧 Usage Options

### Bash Script (macOS/Linux)
```bash
./setup_flutter_env.sh
```

### PowerShell Script (Windows)
```powershell
# Basic installation
.\setup_flutter_env.ps1

# Custom Flutter path
.\setup_flutter_env.ps1 -FlutterPath "C:\Dev\flutter"

# Disable AI assistance
.\setup_flutter_env.ps1 -NoAI
```

## 🚦 After Installation

1. **Restart your terminal** or reload shell:
   ```bash
   source ~/.zshrc  # macOS/Linux
   ```

2. **Verify installation**:
   ```bash
   flutter --version
   flutter doctor
   ```

3. **Create your first Flutter app**:
   ```bash
   flutter create my_app
   cd my_app
   flutter run
   ```

## 🔧 Troubleshooting

### Common Solutions

**macOS Issues:**
- Xcode license: `sudo xcodebuild -license accept`
- Homebrew permissions: `sudo chown -R $(whoami) /opt/homebrew`

**Linux Issues:**
- Ensure sudo access for package installation
- Script handles most dependency issues automatically

**Windows Issues:**
- Set execution policy: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Run PowerShell as Administrator

### Manual Flutter Installation

If automatic setup fails:
1. Download Flutter from https://flutter.dev/docs/get-started/install
2. Extract to preferred location
3. Add `flutter/bin` to PATH
4. Run `flutter doctor`

## 📁 Repository Contents

- `setup_flutter_env.sh` - macOS/Linux setup script
- `setup_flutter_env.ps1` - Windows PowerShell script
- `README.md` - This documentation

## 🤝 Contributing

Found an issue? Please open an issue or submit a pull request.

## 📄 License

MIT License - feel free to use and modify as needed.

---

**⚡ Get Flutter development ready in minutes, not hours!** 