# =============================================================================
# 🚀 Intelligent Flutter Environment Setup Script (Windows PowerShell)
# =============================================================================
# Supports: Windows (x64, ARM64)
# Features: AI-powered error recovery via DeepSeek API
# =============================================================================

#Requires -Version 5.1
param(
    [switch]$NoAI,
    [string]$FlutterPath = "$env:USERPROFILE\flutter"
)

# Set error action preference
$ErrorActionPreference = "Stop"

# =============================================================================
# 🎨 COLORS AND STYLING
# =============================================================================
$script:Colors = @{
    Red = "Red"
    Green = "Green" 
    Yellow = "Yellow"
    Blue = "Blue"
    Magenta = "Magenta"
    Cyan = "Cyan"
    White = "White"
}

# =============================================================================
# 📝 LOGGING FUNCTIONS
# =============================================================================
function Write-LogInfo {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor $Colors.Blue
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor $Colors.Green
}

function Write-LogWarning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor $Colors.Yellow
}

function Write-LogError {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor $Colors.Red
}

function Write-LogStep {
    param([string]$Message)
    Write-Host "🔄 $Message" -ForegroundColor $Colors.Magenta
}

# =============================================================================
# 🤖 AI ERROR HANDLING
# =============================================================================
$script:OpenRouterApiKey = $env:OPENROUTER_API_KEY
$script:ErrorLogFile = "$env:TEMP\flutter_setup_errors.log"
$script:CurrentStep = "Unknown step"

function Invoke-AIErrorRecovery {
    param(
        [string]$ErrorMessage,
        [string]$CurrentStep,
        [string]$OSInfo
    )
    
    if ([string]::IsNullOrEmpty($script:OpenRouterApiKey) -or $NoAI) {
        Write-LogWarning "OPENROUTER_API_KEY not set or AI disabled. Skipping AI error recovery."
        return $false
    }
    
    Write-LogStep "🤖 Consulting AI for error resolution..."
    
    try {
        # Create JSON payload
        $payload = @{
            model = "deepseek/deepseek-chat"
            messages = @(
                @{
                    role = "system"
                    content = "You are a DevOps automation expert specializing in Flutter development environment setup on Windows. When given an error, analyze it and provide specific PowerShell commands or actions to resolve the issue. Be concise and practical. Return only executable commands or clear instructions."
                },
                @{
                    role = "user"
                    content = "I'm setting up Flutter environment on Windows and encountered an error:`n`nCurrent Step: $CurrentStep`nOS Info: $OSInfo`nError: $ErrorMessage`n`nPlease provide specific PowerShell commands or actions to fix this issue."
                }
            )
            max_tokens = 500
            temperature = 0.1
        } | ConvertTo-Json -Depth 10
        
        # Call OpenRouter API
        $headers = @{
            "Authorization" = "Bearer $script:OpenRouterApiKey"
            "Content-Type" = "application/json"
        }
        
        $response = Invoke-RestMethod -Uri "https://openrouter.ai/api/v1/chat/completions" -Method Post -Body $payload -Headers $headers
        
        if ($response.choices -and $response.choices[0].message.content) {
            $aiSuggestion = $response.choices[0].message.content
            Write-LogInfo "🤖 AI Suggestion:"
            Write-Host $aiSuggestion -ForegroundColor $Colors.Cyan
            Write-Host ""
            
            $userChoice = Read-Host "🤔 Do you want to try the AI suggestion? (y/n)"
            if ($userChoice -match "^[Yy]") {
                return $true
            }
        } else {
            Write-LogWarning "Could not get AI suggestion. Please check your API key and internet connection."
        }
    }
    catch {
        Write-LogWarning "Failed to get AI suggestion: $_"
    }
    
    return $false
}

function Write-ErrorToLog {
    param(
        [string]$ErrorMessage,
        [string]$Command,
        [string]$LineNumber = "Unknown"
    )
    
    $logEntry = @"
Error occurred at line $LineNumber
Command: $Command
Error: $ErrorMessage
Step: $script:CurrentStep
OS: $(Get-OSInfo)
Timestamp: $(Get-Date)
---
"@
    
    Add-Content -Path $script:ErrorLogFile -Value $logEntry
}

# =============================================================================
# 🔍 SYSTEM DETECTION
# =============================================================================
function Get-OSInfo {
    $os = Get-WmiObject -Class Win32_OperatingSystem
    $arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
    return "$($os.Caption) ($arch)"
}

function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# =============================================================================
# 🔧 UTILITY FUNCTIONS
# =============================================================================
function Add-ToPath {
    param(
        [string]$PathToAdd,
        [switch]$System
    )
    
    $target = if ($System -and (Test-IsAdmin)) { "Machine" } else { "User" }
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", $target)
    
    if ($currentPath -notlike "*$PathToAdd*") {
        $newPath = "$PathToAdd;$currentPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, $target)
        $env:PATH = "$PathToAdd;$env:PATH"  # Update current session
        Write-LogSuccess "Added $PathToAdd to $target PATH"
    } else {
        Write-LogInfo "$PathToAdd already in PATH"
    }
}

function Install-Chocolatey {
    if (Test-CommandExists "choco") {
        Write-LogSuccess "Chocolatey already installed"
        return
    }
    
    Write-LogInfo "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Refresh environment variables
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
}

# =============================================================================
# 📦 DEPENDENCY INSTALLATION
# =============================================================================
function Install-BasicDependencies {
    $script:CurrentStep = "Installing basic dependencies"
    Write-LogStep $script:CurrentStep
    
    try {
        # Install Chocolatey first
        Install-Chocolatey
        
        # List of packages to install
        $packages = @("git", "curl", "wget", "unzip", "7zip")
        
        foreach ($package in $packages) {
            if (Test-CommandExists $package) {
                Write-LogSuccess "$package already installed"
            } else {
                Write-LogInfo "Installing $package..."
                choco install $package -y
            }
        }
    }
    catch {
        Write-ErrorToLog -ErrorMessage $_.Exception.Message -Command "Install-BasicDependencies"
        if (Invoke-AIErrorRecovery -ErrorMessage $_.Exception.Message -CurrentStep $script:CurrentStep -OSInfo (Get-OSInfo)) {
            Write-LogInfo "Please apply the AI suggestion and retry."
        }
        throw
    }
}

function Install-Java {
    $script:CurrentStep = "Installing Java JDK"
    Write-LogStep $script:CurrentStep
    
    try {
        if (Test-CommandExists "java") {
            $javaVersion = java -version 2>&1 | Select-String "version" | Select-Object -First 1
            Write-LogSuccess "Java already installed: $javaVersion"
            return
        }
        
        Write-LogInfo "Installing OpenJDK 11..."
        choco install openjdk11 -y
        
        # Refresh environment variables
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
    }
    catch {
        Write-ErrorToLog -ErrorMessage $_.Exception.Message -Command "Install-Java"
        if (Invoke-AIErrorRecovery -ErrorMessage $_.Exception.Message -CurrentStep $script:CurrentStep -OSInfo (Get-OSInfo)) {
            Write-LogInfo "Please apply the AI suggestion and retry."
        }
        throw
    }
}

# =============================================================================
# 🎯 FLUTTER INSTALLATION
# =============================================================================
function Get-FlutterDownloadUrl {
    try {
        Write-LogInfo "Fetching Flutter release information..."
        $releaseInfo = Invoke-RestMethod -Uri "https://storage.googleapis.com/flutter_infra_release/releases/releases_windows.json"
        
        $stableReleases = $releaseInfo.releases | Where-Object { $_.channel -eq "stable" }
        if ($stableReleases) {
            $latestStable = $stableReleases[0]
            return "$($releaseInfo.base_url)/$($latestStable.archive)"
        } else {
            throw "No stable releases found"
        }
    }
    catch {
        Write-LogError "Failed to fetch Flutter version information: $_"
        throw
    }
}

function Install-Flutter {
    $script:CurrentStep = "Installing Flutter"
    Write-LogStep $script:CurrentStep
    
    try {
        # Check if Flutter is already installed
        if (Test-Path $FlutterPath) {
            Write-LogWarning "Flutter directory already exists. Checking installation..."
            $flutterExe = Join-Path $FlutterPath "bin\flutter.bat"
            if (Test-Path $flutterExe) {
                try {
                    $currentVersion = & $flutterExe --version 2>$null | Select-Object -First 1
                    Write-LogSuccess "Flutter already installed: $currentVersion"
                    Add-ToPath -PathToAdd (Join-Path $FlutterPath "bin")
                    return
                }
                catch {
                    Write-LogWarning "Flutter directory exists but seems corrupted. Removing..."
                    Remove-Item -Path $FlutterPath -Recurse -Force
                }
            } else {
                Write-LogWarning "Flutter directory exists but seems corrupted. Removing..."
                Remove-Item -Path $FlutterPath -Recurse -Force
            }
        }
        
        # Get download URL
        $downloadUrl = Get-FlutterDownloadUrl
        Write-LogInfo "Downloading Flutter from: $downloadUrl"
        
        # Download Flutter
        $tempFile = "$env:TEMP\flutter.zip"
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile
        
        # Extract Flutter
        Write-LogInfo "Extracting Flutter..."
        $parentDir = Split-Path $FlutterPath -Parent
        if (!(Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        
        Expand-Archive -Path $tempFile -DestinationPath $parentDir -Force
        
        # Clean up
        Remove-Item -Path $tempFile -Force
        
        # Add Flutter to PATH
        Add-ToPath -PathToAdd (Join-Path $FlutterPath "bin")
        
        Write-LogSuccess "Flutter installed successfully!"
    }
    catch {
        Write-ErrorToLog -ErrorMessage $_.Exception.Message -Command "Install-Flutter"
        if (Invoke-AIErrorRecovery -ErrorMessage $_.Exception.Message -CurrentStep $script:CurrentStep -OSInfo (Get-OSInfo)) {
            Write-LogInfo "Please apply the AI suggestion and retry."
        }
        throw
    }
}

# =============================================================================
# ⚙️  FLUTTER CONFIGURATION
# =============================================================================
function Initialize-Flutter {
    $script:CurrentStep = "Configuring Flutter"
    Write-LogStep $script:CurrentStep
    
    try {
        $flutterExe = Join-Path $FlutterPath "bin\flutter.bat"
        
        # Run flutter doctor to initialize
        Write-LogInfo "Running initial Flutter doctor check..."
        try {
            & $flutterExe doctor -v
        }
        catch {
            Write-LogWarning "Flutter doctor completed with warnings (this is normal for initial setup)"
        }
        
        # Run flutter precache for common targets
        Write-LogInfo "Running Flutter precache..."
        & $flutterExe precache --universal
        
        Write-LogSuccess "Flutter configuration completed!"
    }
    catch {
        Write-ErrorToLog -ErrorMessage $_.Exception.Message -Command "Initialize-Flutter"
        if (Invoke-AIErrorRecovery -ErrorMessage $_.Exception.Message -CurrentStep $script:CurrentStep -OSInfo (Get-OSInfo)) {
            Write-LogInfo "Please apply the AI suggestion and retry."
        }
        throw
    }
}

# =============================================================================
# 🏥 HEALTH CHECK
# =============================================================================
function Invoke-HealthCheck {
    $script:CurrentStep = "Running health check"
    Write-LogStep $script:CurrentStep
    
    try {
        $flutterExe = Join-Path $FlutterPath "bin\flutter.bat"
        
        Write-Host ""
        Write-LogInfo "🏥 Flutter Doctor Report:"
        Write-Host "================================" -ForegroundColor $Colors.White
        & $flutterExe doctor -v
        Write-Host "================================" -ForegroundColor $Colors.White
        Write-Host ""
        
        Write-LogSuccess "Setup completed! Please restart your PowerShell session to use Flutter."
        
        # Show next steps
        Write-Host ""
        Write-LogInfo "🎯 Next Steps:"
        Write-Host "1. Restart PowerShell or open a new session"
        Write-Host "2. Verify installation: flutter --version"
        Write-Host "3. Create your first app: flutter create my_app"
        Write-Host "4. For Android development:"
        Write-Host "   - Install Android Studio"
        Write-Host "   - Run: flutter doctor --android-licenses"
        Write-Host ""
        Write-Host "📱 For Windows desktop development:"
        Write-Host "1. Enable Windows desktop: flutter config --enable-windows-desktop"
        Write-Host "2. Install Visual Studio (not VS Code) with C++ tools"
        Write-Host ""
    }
    catch {
        Write-ErrorToLog -ErrorMessage $_.Exception.Message -Command "Invoke-HealthCheck"
        if (Invoke-AIErrorRecovery -ErrorMessage $_.Exception.Message -CurrentStep $script:CurrentStep -OSInfo (Get-OSInfo)) {
            Write-LogInfo "Please apply the AI suggestion and retry."
        }
        throw
    }
}

# =============================================================================
# 🚀 MAIN EXECUTION
# =============================================================================
function Main {
    try {
        Write-Host ""
        Write-Host "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀" -ForegroundColor $Colors.Cyan
        Write-Host "🚀                                                              🚀" -ForegroundColor $Colors.Cyan
        Write-Host "🚀     Intelligent Flutter Environment Setup Script             🚀" -ForegroundColor $Colors.Cyan
        Write-Host "🚀     Powered by AI Error Recovery (DeepSeek)                  🚀" -ForegroundColor $Colors.Cyan
        Write-Host "🚀                                                              🚀" -ForegroundColor $Colors.Cyan
        Write-Host "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀" -ForegroundColor $Colors.Cyan
        Write-Host ""
        
        Write-LogInfo "🖥️  System Information: $(Get-OSInfo)"
        
        if (Test-IsAdmin) {
            Write-LogSuccess "🔑 Running as Administrator"
        } else {
            Write-LogWarning "🔑 Not running as Administrator (some features may be limited)"
        }
        
        if ([string]::IsNullOrEmpty($script:OpenRouterApiKey) -or $NoAI) {
            Write-LogWarning "🤖 AI Error Recovery: Disabled"
        } else {
            Write-LogSuccess "🤖 AI Error Recovery: Enabled"
        }
        Write-Host ""
        
        # Initialize error log
        "Flutter Setup Error Log - $(Get-Date)" | Out-File -FilePath $script:ErrorLogFile -Encoding UTF8
        
        # Run installation steps
        Install-BasicDependencies
        Install-Java
        Install-Flutter
        Initialize-Flutter
        Invoke-HealthCheck
        
        Write-LogSuccess "🎉 Flutter environment setup completed successfully!"
    }
    catch {
        Write-LogError "Setup failed: $_"
        Write-LogInfo "Check the error log at: $script:ErrorLogFile"
        exit 1
    }
}

# Check PowerShell execution policy
if ((Get-ExecutionPolicy) -eq "Restricted") {
    Write-LogWarning "PowerShell execution policy is Restricted. You may need to run:"
    Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor $Colors.Yellow
    Write-Host ""
}

# Run main function
Main 