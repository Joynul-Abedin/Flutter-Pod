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
# Logging functions that work with sticky progress bar
function Write-LogInfo {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor $Colors.Blue
    # Redraw progress bar if active
    if ($script:CurrentStepName) {
        $percentage = [math]::Round(($script:CurrentProgress * 100) / $script:TotalSteps)
        Draw-ProgressBar -StepName $script:CurrentStepName -Percentage $percentage
    }
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor $Colors.Green
    if ($script:CurrentStepName) {
        $percentage = [math]::Round(($script:CurrentProgress * 100) / $script:TotalSteps)
        Draw-ProgressBar -StepName $script:CurrentStepName -Percentage $percentage
    }
}

function Write-LogWarning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor $Colors.Yellow
    if ($script:CurrentStepName) {
        $percentage = [math]::Round(($script:CurrentProgress * 100) / $script:TotalSteps)
        Draw-ProgressBar -StepName $script:CurrentStepName -Percentage $percentage
    }
}

function Write-LogError {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor $Colors.Red
    if ($script:CurrentStepName) {
        $percentage = [math]::Round(($script:CurrentProgress * 100) / $script:TotalSteps)
        Draw-ProgressBar -StepName $script:CurrentStepName -Percentage $percentage
    }
}

function Write-LogStep {
    param([string]$Message)
    Write-Host "🔄 $Message" -ForegroundColor $Colors.Magenta
    if ($script:CurrentStepName) {
        $percentage = [math]::Round(($script:CurrentProgress * 100) / $script:TotalSteps)
        Draw-ProgressBar -StepName $script:CurrentStepName -Percentage $percentage
    }
}

# =============================================================================
# 📊 UNIFIED PROGRESS BAR SYSTEM
# =============================================================================
$script:TotalSteps = 6
$script:CurrentProgress = 0
$script:CurrentStepName = ""
$script:OriginalCursorPosition = @{ X = 0; Y = 0 }

function Initialize-ProgressBar {
    # Clear screen and initialize
    Clear-Host
    
    # Reserve space for progress bar at bottom
    try {
        $consoleHeight = [Console]::WindowHeight
        for ($i = 0; $i -lt ($consoleHeight - 2); $i++) {
            Write-Host ""
        }
    }
    catch {
        # Fallback: just clear and continue
    }
    
    # Set up initial progress bar
    Draw-ProgressBar -StepName "Initializing Flutter Setup..." -Percentage 0
}

function Cleanup-ProgressBar {
    # Move to a new line after progress bar and show cursor
    try {
        $consoleHeight = [Console]::WindowHeight
        [Console]::SetCursorPosition(0, $consoleHeight - 1)
        Write-Host ""
        [Console]::CursorVisible = $true
    }
    catch {
        Write-Host ""
    }
}

function Draw-ProgressBar {
    param(
        [string]$StepName,
        [int]$Percentage
    )
    
    try {
        # Save current cursor position and hide cursor
        $currentX = [Console]::CursorLeft
        $currentY = [Console]::CursorTop
        [Console]::CursorVisible = $false
        
        # Get console dimensions
        $consoleWidth = [Console]::WindowWidth
        $consoleHeight = [Console]::WindowHeight
        
        # Calculate bar width (leave space for text)
        $barWidth = [math]::Max(20, $consoleWidth - 25)
        $filledLength = [math]::Round($Percentage * $barWidth / 100)
        $bar = "█" * $filledLength + "░" * ($barWidth - $filledLength)
        
        # Move to bottom line and clear it
        [Console]::SetCursorPosition(0, $consoleHeight - 1)
        Write-Host (" " * $consoleWidth) -NoNewline
        [Console]::SetCursorPosition(0, $consoleHeight - 1)
        
        # Draw the progress bar
        $progressText = "📊 [$bar] $Percentage% - $StepName"
        if ($progressText.Length -gt $consoleWidth) {
            $progressText = $progressText.Substring(0, $consoleWidth - 1)
        }
        
        Write-Host $progressText -ForegroundColor $Colors.Cyan -NoNewline
        
        # Restore cursor position and show cursor
        [Console]::SetCursorPosition($currentX, $currentY)
        [Console]::CursorVisible = $true
    }
    catch {
        # Fallback to simple progress display
        Write-Host "📊 Progress: $Percentage% - $StepName" -ForegroundColor $Colors.Cyan
    }
}

function Update-Progress {
    param([string]$StepName)
    
    $script:CurrentProgress++
    $percentage = [math]::Round(($script:CurrentProgress * 100) / $script:TotalSteps)
    
    $script:CurrentStepName = $StepName
    Draw-ProgressBar -StepName $StepName -Percentage $percentage
}

function Update-ProgressText {
    param([string]$StepName)
    
    $percentage = [math]::Round(($script:CurrentProgress * 100) / $script:TotalSteps)
    $script:CurrentStepName = $StepName
    Draw-ProgressBar -StepName $StepName -Percentage $percentage
}

# =============================================================================
# 🤖 AI ERROR HANDLING
# =============================================================================
$script:OpenRouterApiKey = if ($env:OPENROUTER_API_KEY) { $env:OPENROUTER_API_KEY } else { "" }
$script:ErrorLogFile = "$env:TEMP\flutter_setup_errors.log"
$script:CurrentStep = "Unknown step"

# Function to prompt for API key
function Request-ApiKey {
    if ($script:OpenRouterApiKey) {
        return # Already have API key from environment
    }
    
    Write-Host ""
    Write-LogInfo "🤖 AI-Powered Error Recovery Setup"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor $Colors.White
    Write-Host ""
    Write-LogInfo "This script can use AI to automatically fix installation errors."
    Write-LogInfo "To enable this feature, you need a free API key from OpenRouter."
    Write-Host ""
    Write-LogInfo "💡 Benefits of AI Error Recovery:"
    Write-LogInfo "   • Automatic troubleshooting of installation issues"
    Write-LogInfo "   • Intelligent fixes for dependency problems"
    Write-LogInfo "   • Reduced manual intervention needed"
    Write-Host ""
    Write-LogInfo "🔗 Get your free API key: https://openrouter.ai"
    Write-LogInfo "   1. Sign up for free account"
    Write-LogInfo "   2. Go to Keys section"
    Write-LogInfo "   3. Create a new API key"
    Write-Host ""
    Write-LogWarning "⚠️  Note: AI features are optional - script works fine without them!"
    Write-Host ""
    
    $userInput = Read-Host "🔑 Enter your OpenRouter API key (or press Enter to skip)"
    $script:OpenRouterApiKey = $userInput.Trim()
    
    if ($script:OpenRouterApiKey) {
        # Test the API key
        Write-LogInfo "🧪 Testing API key..."
        try {
            $testPayload = @{
                model = "deepseek/deepseek-chat-v3-0324:free"
                messages = @(@{ role = "user"; content = "test" })
                max_tokens = 5
            } | ConvertTo-Json -Depth 10
            
            $testHeaders = @{
                "Authorization" = "Bearer $script:OpenRouterApiKey"
                "Content-Type" = "application/json"
                "HTTP-Referer" = "https://github.com/Joynul-Abedin/Flutter-Pod"
                "X-Title" = "Flutter Setup Script"
            }
            
            $testResponse = Invoke-RestMethod -Uri "https://openrouter.ai/api/v1/chat/completions" -Method Post -Body $testPayload -Headers $testHeaders -TimeoutSec 10
            
            if ($testResponse.choices) {
                Write-LogSuccess "✅ API key is valid! AI error recovery enabled."
            } else {
                Write-LogWarning "⚠️  API key test failed. Continuing without AI features."
                Write-LogInfo "💡 You can set `$env:OPENROUTER_API_KEY and re-run"
                $script:OpenRouterApiKey = ""
            }
        }
        catch {
            Write-LogWarning "⚠️  API key test failed: $_"
            Write-LogInfo "💡 Continuing without AI features"
            $script:OpenRouterApiKey = ""
        }
    } else {
        Write-LogInfo "ℹ️  Continuing without AI features. Basic error handling will be used."
    }
    Write-Host ""
}

function Invoke-AIErrorRecovery {
    param(
        [string]$ErrorMessage,
        [string]$CurrentStep,
        [string]$OSInfo,
        [bool]$AutoApply = $false
    )
    
    if ($NoAI) {
        Write-LogWarning "AI error recovery disabled by NoAI flag. Skipping AI error recovery."
        return $false
    }
    
    if ([string]::IsNullOrEmpty($script:OpenRouterApiKey)) {
        Write-LogWarning "🤖 AI Error Recovery: Not available (no API key provided)"
        Write-LogInfo "💡 To enable AI-powered error recovery:"
        Write-LogInfo "   1. Get a free API key from https://openrouter.ai"
        Write-LogInfo "   2. Set environment variable: `$env:OPENROUTER_API_KEY='your-key'"
        Write-LogInfo "   3. Re-run the script"
        return $false
    }
    
    Write-LogStep "🤖 Consulting AI for error resolution..."
    
    try {
        # Create JSON payload
        $payload = @{
            model = "deepseek/deepseek-chat-v3-0324:free"
            messages = @(
                @{
                    role = "system"
                    content = "You are a DevOps automation expert specializing in Flutter development environment setup on Windows. When given an error, analyze it and provide specific PowerShell commands or actions to resolve the issue. Return ONLY executable PowerShell commands, one per line, that can be run automatically. No explanations, no markdown formatting, just raw commands. If multiple steps are needed, list them in order."
                },
                @{
                    role = "user"
                    content = "I'm setting up Flutter environment on Windows and encountered an error:`n`nCurrent Step: $CurrentStep`nOS Info: $OSInfo`nError: $ErrorMessage`n`nProvide the exact PowerShell commands needed to fix this issue:"
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
            $aiSuggestion = $response.choices[0].message.content.Trim()
            Write-LogInfo "🤖 AI Suggested Fix:"
            Write-Host $aiSuggestion -ForegroundColor $Colors.Cyan
            Write-Host ""
            
            if ($AutoApply) {
                Write-LogInfo "🔄 Auto-applying AI suggestion..."
                try {
                    $aiSuggestion | Out-File -FilePath "$env:TEMP\ai_fix_commands.ps1" -Encoding UTF8
                    & "$env:TEMP\ai_fix_commands.ps1"
                    Remove-Item -Path "$env:TEMP\ai_fix_commands.ps1" -Force -ErrorAction SilentlyContinue
                    return $true
                }
                catch {
                    Remove-Item -Path "$env:TEMP\ai_fix_commands.ps1" -Force -ErrorAction SilentlyContinue
                    return $false
                }
            } else {
                $userChoice = Read-Host "🤔 Do you want to apply the AI suggestion? (y/n)"
                if ($userChoice -match "^[Yy]") {
                    try {
                        $aiSuggestion | Out-File -FilePath "$env:TEMP\ai_fix_commands.ps1" -Encoding UTF8
                        & "$env:TEMP\ai_fix_commands.ps1"
                        Remove-Item -Path "$env:TEMP\ai_fix_commands.ps1" -Force -ErrorAction SilentlyContinue
                        return $true
                    }
                    catch {
                        Remove-Item -Path "$env:TEMP\ai_fix_commands.ps1" -Force -ErrorAction SilentlyContinue
                        return $false
                    }
                }
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

# Enhanced command execution with AI retry
function Invoke-CommandWithAIRetry {
    param(
        [scriptblock]$Command,
        [string]$Description,
        [int]$MaxRetries = 6
    )
    
    $currentRetry = 0
    
    while ($currentRetry -lt $MaxRetries) {
        Update-ProgressText "Executing: $Description"
        Write-LogInfo "Executing: $Description"
        
        try {
            & $Command
            return $true
        }
        catch {
            $currentRetry++
            $errorMessage = $_.Exception.Message
            
            if ($currentRetry -lt $MaxRetries) {
                Update-ProgressText "🤖 Consulting AI... (attempt $currentRetry/$MaxRetries)"
                Write-LogWarning "Command failed (attempt $currentRetry/$MaxRetries). Consulting AI..."
                
                if (Invoke-AIErrorRecovery -ErrorMessage $errorMessage -CurrentStep $Description -OSInfo (Get-OSInfo) -AutoApply $true) {
                    Update-ProgressText "🔄 Retrying after AI fix..."
                    Write-LogInfo "🔄 Retrying after AI fix..."
                    continue
                } else {
                    Update-ProgressText "⚠️ AI couldn't resolve issue, retrying..."
                    Write-LogWarning "AI couldn't resolve the issue. Retrying..."
                    Start-Sleep -Seconds 2
                }
            } else {
                Update-ProgressText "❌ Failed after $MaxRetries attempts"
                Write-LogError "Command failed after $MaxRetries attempts: $Description"
                throw $_
            }
        }
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
    Update-Progress "Installing basic dependencies"
    
    # Install Chocolatey first
    Install-Chocolatey
    
    # List of packages to install
    $packages = @("git", "curl", "wget", "unzip", "7zip")
    
    foreach ($package in $packages) {
        if (Test-CommandExists $package) {
            Write-LogSuccess "$package already installed"
        } else {
            Write-LogInfo "Installing $package..."
            Invoke-CommandWithAIRetry -Command { choco install $package -y } -Description "Installing $package via Chocolatey"
        }
    }
}

function Install-Java {
    $script:CurrentStep = "Installing Java JDK"
    Update-Progress "Installing Java JDK"
    
    if (Test-CommandExists "java") {
        $javaVersion = java -version 2>&1 | Select-String "version" | Select-Object -First 1
        Write-LogSuccess "Java already installed: $javaVersion"
        return
    }
    
    Write-LogInfo "Installing OpenJDK 11..."
    Invoke-CommandWithAIRetry -Command { choco install openjdk11 -y } -Description "Installing OpenJDK 11 via Chocolatey"
    
    # Refresh environment variables
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
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
    Update-Progress "Installing Flutter SDK"
    
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
                Invoke-CommandWithAIRetry -Command { Remove-Item -Path $FlutterPath -Recurse -Force } -Description "Removing corrupted Flutter directory"
            }
        } else {
            Write-LogWarning "Flutter directory exists but seems corrupted. Removing..."
            Invoke-CommandWithAIRetry -Command { Remove-Item -Path $FlutterPath -Recurse -Force } -Description "Removing corrupted Flutter directory"
        }
    }
    
    # Get download URL
    $downloadUrl = Get-FlutterDownloadUrl
    Write-LogInfo "Downloading Flutter from: $downloadUrl"
    
    # Download Flutter with AI retry
    $tempFile = "$env:TEMP\flutter.zip"
    Invoke-CommandWithAIRetry -Command { Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile } -Description "Downloading Flutter SDK"
    
    # Extract Flutter with AI retry
    Write-LogInfo "Extracting Flutter..."
    $parentDir = Split-Path $FlutterPath -Parent
    Invoke-CommandWithAIRetry -Command { 
        if (!(Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        Expand-Archive -Path $tempFile -DestinationPath $parentDir -Force
    } -Description "Extracting Flutter SDK"
    
    # Clean up
    Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
    
    # Add Flutter to PATH
    Add-ToPath -PathToAdd (Join-Path $FlutterPath "bin")
    
    # Refresh PATH for current session
    $env:PATH = (Join-Path $FlutterPath "bin") + ";" + $env:PATH
    
    Write-LogSuccess "Flutter installed successfully!"
}

# =============================================================================
# ⚙️  FLUTTER CONFIGURATION
# =============================================================================
function Initialize-Flutter {
    $script:CurrentStep = "Configuring Flutter"
    Update-Progress "Configuring Flutter"
    
    $flutterExe = Join-Path $FlutterPath "bin\flutter.bat"
    
    # Run flutter doctor to initialize
    Write-LogInfo "Running initial Flutter doctor check..."
    Invoke-CommandWithAIRetry -Command { & $flutterExe doctor -v } -Description "Running Flutter doctor initialization" -MaxRetries 2
    
    # Run flutter precache for common targets
    Write-LogInfo "Running Flutter precache..."
    Invoke-CommandWithAIRetry -Command { & $flutterExe precache --universal } -Description "Running Flutter precache"
    
    Write-LogSuccess "Flutter configuration completed!"
}

# =============================================================================
# 🏥 HEALTH CHECK
# =============================================================================
function Invoke-HealthCheck {
    $script:CurrentStep = "Running health check"
    Update-Progress "Running health check"
    
    $flutterExe = Join-Path $FlutterPath "bin\flutter.bat"
    
    Write-Host ""
    Write-LogInfo "🏥 Flutter Doctor Report:"
    Write-Host "================================" -ForegroundColor $Colors.White
    Invoke-CommandWithAIRetry -Command { & $flutterExe doctor -v } -Description "Running final Flutter doctor check" -MaxRetries 2
    Write-Host "================================" -ForegroundColor $Colors.White
    Write-Host ""
    
    Write-LogSuccess "🎉 Flutter environment setup completed successfully!"
    
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

# =============================================================================
# 🚀 MAIN EXECUTION
# =============================================================================
function Main {
    try {
        # Initialize progress bar system
        Initialize-ProgressBar
        
        Write-Host "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀" -ForegroundColor $Colors.Cyan
        Write-Host "🚀                                                              🚀" -ForegroundColor $Colors.Cyan
        Write-Host "🚀     Intelligent Flutter Environment Setup Script             🚀" -ForegroundColor $Colors.Cyan
        Write-Host "🚀     Powered by AI Error Recovery (DeepSeek)                  🚀" -ForegroundColor $Colors.Cyan
        Write-Host "🚀                                                              🚀" -ForegroundColor $Colors.Cyan
        Write-Host "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀" -ForegroundColor $Colors.Cyan
        
        # Prompt for API key before starting
        if (!$NoAI) {
            Request-ApiKey
        }
        
        Write-LogInfo "🖥️  System Information: $(Get-OSInfo)"
        
        if (Test-IsAdmin) {
            Write-LogSuccess "🔑 Running as Administrator"
        } else {
            Write-LogWarning "🔑 Not running as Administrator (some features may be limited)"
        }
        
        if ($NoAI) {
            Write-LogWarning "🤖 AI Error Recovery: Disabled (NoAI flag set)"
        } elseif ([string]::IsNullOrEmpty($script:OpenRouterApiKey)) {
            Write-LogWarning "🤖 AI Error Recovery: Disabled"
            Write-LogInfo "💡 Basic error handling will be used"
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
        
        # Final completion
        Draw-ProgressBar -StepName "🎉 Installation completed successfully!" -Percentage 100
        Start-Sleep -Seconds 2
        
        # Cleanup progress bar
        Cleanup-ProgressBar
        
        Write-LogSuccess "🎉 Flutter environment setup completed successfully!"
    }
    catch {
        # Cleanup progress bar on error
        Cleanup-ProgressBar
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