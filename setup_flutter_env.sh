#!/bin/bash

# =============================================================================
# 🚀 Intelligent Flutter Environment Setup Script
# =============================================================================
# Supports: macOS (Intel & Apple Silicon) and Linux (Ubuntu/Debian-based)
# Features: AI-powered error recovery via DeepSeek API
# =============================================================================

set -e  # Exit on any error (will be caught by our error handler)

# =============================================================================
# 🎨 COLORS AND STYLING
# =============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# =============================================================================
# 📝 LOGGING FUNCTIONS
# =============================================================================
log_info() {
    echo -e "${BLUE}ℹ️  ${WHITE}$1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ ${WHITE}$1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  ${WHITE}$1${NC}"
}

log_error() {
    echo -e "${RED}❌ ${WHITE}$1${NC}"
}

log_step() {
    echo -e "${PURPLE}🔄 ${WHITE}$1${NC}"
}

# =============================================================================
# 📊 PROGRESS TRACKING
# =============================================================================
TOTAL_STEPS=8
CURRENT_PROGRESS=0

update_progress() {
    local step_name="$1"
    CURRENT_PROGRESS=$((CURRENT_PROGRESS + 1))
    local percentage=$((CURRENT_PROGRESS * 100 / TOTAL_STEPS))
    
    # Create progress bar
    local bar_length=30
    local filled_length=$((percentage * bar_length / 100))
    local bar=""
    
    for ((i=0; i<filled_length; i++)); do
        bar+="█"
    done
    
    for ((i=filled_length; i<bar_length; i++)); do
        bar+="░"
    done
    
    echo -e "${CYAN}📊 Progress: [${bar}] ${percentage}% - ${step_name}${NC}"
}

# =============================================================================
# 🤖 AI ERROR HANDLING
# =============================================================================
OPENROUTER_API_KEY="${OPENROUTER_API_KEY:-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}"
ERROR_LOG_FILE="/tmp/flutter_setup_errors.log"

ask_ai_for_help() {
    local error_message="$1"
    local current_step="$2"
    local os_info="$3"
    local auto_apply="${4:-false}"
    
    if [[ -z "$OPENROUTER_API_KEY" ]]; then
        log_warning "AI API key not available. Skipping AI error recovery."
        return 1
    fi
    
    log_step "🤖 Consulting AI for error resolution..."
    
    # Create JSON payload
    local payload=$(cat <<EOF
{
    "model": "deepseek/deepseek-chat",
    "messages": [
        {
            "role": "system",
            "content": "You are a DevOps automation expert specializing in Flutter development environment setup. When given an error, analyze it and provide specific shell commands or actions to resolve the issue. Return ONLY executable shell commands, one per line, that can be run automatically. No explanations, no markdown formatting, just raw commands. If multiple steps are needed, list them in order."
        },
        {
            "role": "user",
            "content": "I'm setting up Flutter environment and encountered an error:\\n\\nCurrent Step: $current_step\\nOS Info: $os_info\\nError: $error_message\\n\\nProvide the exact shell commands needed to fix this issue:"
        }
    ],
    "max_tokens": 500,
    "temperature": 0.1
}
EOF
    )
    
    # Call OpenRouter API
    local response=$(curl -s -X POST "https://openrouter.ai/api/v1/chat/completions" \
        -H "Authorization: Bearer $OPENROUTER_API_KEY" \
        -H "Content-Type: application/json" \
        -d "$payload")
    
    # Extract the content from response
    local ai_suggestion=$(echo "$response" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data['choices'][0]['message']['content'].strip())
except:
    print('Failed to parse AI response')
    " 2>/dev/null)
    
    if [[ -n "$ai_suggestion" && "$ai_suggestion" != "Failed to parse AI response" ]]; then
        log_info "🤖 AI Suggested Fix:"
        echo -e "${CYAN}$ai_suggestion${NC}"
        echo
        
        if [[ "$auto_apply" == "true" ]]; then
            log_info "🔄 Auto-applying AI suggestion..."
            echo "$ai_suggestion" > /tmp/ai_fix_commands.sh
            chmod +x /tmp/ai_fix_commands.sh
            if /tmp/ai_fix_commands.sh; then
                rm -f /tmp/ai_fix_commands.sh
                return 0
            else
                rm -f /tmp/ai_fix_commands.sh
                return 1
            fi
        else
            read -p "🤔 Do you want to apply the AI suggestion? (y/n): " -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "$ai_suggestion" > /tmp/ai_fix_commands.sh
                chmod +x /tmp/ai_fix_commands.sh
                if /tmp/ai_fix_commands.sh; then
                    rm -f /tmp/ai_fix_commands.sh
                    return 0
                else
                    rm -f /tmp/ai_fix_commands.sh
                    return 1
                fi
            fi
        fi
    else
        log_warning "Could not get AI suggestion. Please check your API key and internet connection."
    fi
    
    return 1
}

# Enhanced command execution with AI retry
execute_with_ai_retry() {
    local command="$1"
    local description="$2"
    local max_retries="${3:-3}"
    local current_retry=0
    
    while [[ $current_retry -lt $max_retries ]]; do
        log_info "Executing: $description"
        
        if eval "$command"; then
            return 0
        else
            local exit_code=$?
            current_retry=$((current_retry + 1))
            
            if [[ $current_retry -lt $max_retries ]]; then
                log_warning "Command failed (attempt $current_retry/$max_retries). Consulting AI..."
                
                # Get the last few lines of error output
                local error_context=$(eval "$command" 2>&1 | tail -10)
                
                if ask_ai_for_help "$error_context" "$description" "$(get_os_info)" "true"; then
                    log_info "🔄 Retrying after AI fix..."
                    continue
                else
                    log_warning "AI couldn't resolve the issue. Retrying..."
                    sleep 2
                fi
            else
                log_error "Command failed after $max_retries attempts: $description"
                return $exit_code
            fi
        fi
    done
    
    return 1
}

# Error handler function
handle_error() {
    local exit_code=$?
    local line_number=$1
    local command="$2"
    local current_step="${CURRENT_STEP:-Unknown step}"
    
    log_error "Error occurred at line $line_number: $command"
    echo "Exit code: $exit_code" >> "$ERROR_LOG_FILE"
    echo "Line: $line_number" >> "$ERROR_LOG_FILE"
    echo "Command: $command" >> "$ERROR_LOG_FILE"
    echo "Step: $current_step" >> "$ERROR_LOG_FILE"
    echo "OS: $(get_os_info)" >> "$ERROR_LOG_FILE"
    echo "---" >> "$ERROR_LOG_FILE"
    
    # Try to get AI help
    if ask_ai_for_help "$command (exit code: $exit_code)" "$current_step" "$(get_os_info)"; then
        log_info "You can retry the script after applying the suggested fix."
    fi
    
    exit $exit_code
}

# Set up error handling
trap 'handle_error $LINENO "$BASH_COMMAND"' ERR

# =============================================================================
# 🔍 SYSTEM DETECTION
# =============================================================================
get_os_info() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        local os_version=$(sw_vers -productVersion)
        local arch=$(uname -m)
        echo "macOS $os_version ($arch)"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        local distro=$(lsb_release -d 2>/dev/null | cut -f2 || echo "Linux")
        local arch=$(uname -m)
        echo "$distro ($arch)"
    else
        echo "Unknown OS: $OSTYPE"
    fi
}

is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

is_linux() {
    [[ "$OSTYPE" == "linux-gnu"* ]]
}

is_apple_silicon() {
    [[ "$(uname -m)" == "arm64" ]] && is_macos
}

# =============================================================================
# 🔧 UTILITY FUNCTIONS
# =============================================================================
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

add_to_path() {
    local path_to_add="$1"
    local shell_rc=""
    
    if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == *"zsh"* ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ -n "$BASH_VERSION" ]] || [[ "$SHELL" == *"bash"* ]]; then
        shell_rc="$HOME/.bashrc"
        # On macOS, also check .bash_profile
        if is_macos && [[ -f "$HOME/.bash_profile" ]]; then
            shell_rc="$HOME/.bash_profile"
        fi
    else
        shell_rc="$HOME/.profile"
    fi
    
    if ! grep -q "$path_to_add" "$shell_rc" 2>/dev/null; then
        echo "export PATH=\"$path_to_add:\$PATH\"" >> "$shell_rc"
        log_success "Added $path_to_add to PATH in $shell_rc"
    else
        log_info "$path_to_add already in PATH"
    fi
}

# =============================================================================
# 📦 DEPENDENCY INSTALLATION
# =============================================================================
install_basic_dependencies() {
    CURRENT_STEP="Installing basic dependencies"
    update_progress "Installing basic dependencies"
    
    if is_macos; then
        # Install Homebrew if not present
        if ! command_exists brew; then
            log_info "Installing Homebrew..."
            execute_with_ai_retry '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' "Homebrew installation"
            
            # Add Homebrew to PATH
            if is_apple_silicon; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
                eval "$(/opt/homebrew/bin/brew shellenv)"
            else
                echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zshrc"
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
        
        # Install dependencies
        local deps=("git" "wget" "curl" "unzip")
        for dep in "${deps[@]}"; do
            if ! command_exists "$dep"; then
                log_info "Installing $dep..."
                execute_with_ai_retry "brew install $dep" "Installing $dep via Homebrew"
            else
                log_success "$dep already installed"
            fi
        done
        
    elif is_linux; then
        # Update package lists
        log_info "Updating package lists..."
        execute_with_ai_retry "sudo apt-get update" "Updating package lists"
        
        # Install dependencies
        local deps=("git" "wget" "curl" "unzip" "xz-utils" "zip" "libglu1-mesa")
        log_info "Installing dependencies: ${deps[*]}"
        execute_with_ai_retry "sudo apt-get install -y ${deps[*]}" "Installing basic dependencies via apt"
    fi
}

install_java() {
    CURRENT_STEP="Installing Java JDK"
    update_progress "Installing Java JDK"
    
    if command_exists java; then
        local java_version=$(java -version 2>&1 | head -n1 | cut -d'"' -f2)
        log_success "Java already installed: $java_version"
        return
    fi
    
    if is_macos; then
        log_info "Installing OpenJDK via Homebrew..."
        execute_with_ai_retry "brew install openjdk@11" "Installing OpenJDK 11 via Homebrew"
        
        # Link it
        execute_with_ai_retry "sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk" "Linking OpenJDK" || true
        
        # Add to PATH
        add_to_path "/opt/homebrew/opt/openjdk@11/bin"
        
    elif is_linux; then
        log_info "Installing OpenJDK 11..."
        execute_with_ai_retry "sudo apt-get install -y openjdk-11-jdk" "Installing OpenJDK 11 via apt"
    fi
}

install_cocoapods() {
    if ! is_macos; then
        return
    fi
    
    CURRENT_STEP="Installing CocoaPods"
    update_progress "Installing CocoaPods"
    
    if command_exists pod; then
        log_success "CocoaPods already installed"
        return
    fi
    
    # Check if we have Ruby
    if ! command_exists ruby; then
        log_info "Installing Ruby via Homebrew..."
        execute_with_ai_retry "brew install ruby" "Installing Ruby via Homebrew"
        add_to_path "/opt/homebrew/opt/ruby/bin"
        
        # Refresh PATH for current session
        export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    fi
    
    log_info "Installing CocoaPods..."
    execute_with_ai_retry "gem install cocoapods --user-install" "Installing CocoaPods via gem"
    
    # Add gem bin to PATH
    local gem_bin=$(ruby -e 'puts Gem.user_dir')/bin
    add_to_path "$gem_bin"
    
    # Refresh PATH for current session
    export PATH="$gem_bin:$PATH"
}

# =============================================================================
# 🎯 FLUTTER INSTALLATION
# =============================================================================
get_flutter_download_url() {
    local os="$1"
    local arch="$2"
    
    # Get the latest stable version info from Flutter API
    local version_info=$(curl -s "https://storage.googleapis.com/flutter_infra_release/releases/releases_${os}.json")
    
    if [[ -z "$version_info" ]]; then
        log_error "Failed to fetch Flutter version information"
        return 1
    fi
    
    # Extract the latest stable version URL
    local download_url=$(echo "$version_info" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    stable_releases = [r for r in data['releases'] if r['channel'] == 'stable']
    if stable_releases:
        print(data['base_url'] + '/' + stable_releases[0]['archive'])
    else:
        print('No stable releases found')
except Exception as e:
    print(f'Error: {e}')
")
    
    echo "$download_url"
}

install_flutter() {
    CURRENT_STEP="Installing Flutter"
    update_progress "Installing Flutter SDK"
    
    local flutter_dir="$HOME/flutter"
    
    # Check if Flutter is already installed
    if [[ -d "$flutter_dir" ]]; then
        log_warning "Flutter directory already exists. Checking installation..."
        if [[ -x "$flutter_dir/bin/flutter" ]]; then
            local current_version=$("$flutter_dir/bin/flutter" --version 2>/dev/null | head -n1 || echo "unknown")
            log_success "Flutter already installed: $current_version"
            
            # Still add to PATH if needed
            add_to_path "$flutter_dir/bin"
            return
        else
            log_warning "Flutter directory exists but seems corrupted. Removing..."
            execute_with_ai_retry "rm -rf $flutter_dir" "Removing corrupted Flutter directory"
        fi
    fi
    
    # Determine OS for download
    local os=""
    if is_macos; then
        os="macos"
    elif is_linux; then
        os="linux"
    else
        log_error "Unsupported operating system"
        return 1
    fi
    
    # Get download URL
    local download_url=$(get_flutter_download_url "$os" "$(uname -m)")
    
    if [[ -z "$download_url" || "$download_url" == "No stable releases found" ]]; then
        log_error "Could not determine Flutter download URL"
        return 1
    fi
    
    log_info "Downloading Flutter from: $download_url"
    
    # Download Flutter with AI retry
    local temp_file="/tmp/flutter.tar.xz"
    execute_with_ai_retry "curl -L -o $temp_file '$download_url'" "Downloading Flutter SDK"
    
    # Extract Flutter with AI retry
    log_info "Extracting Flutter..."
    execute_with_ai_retry "cd $HOME && tar -xf $temp_file" "Extracting Flutter SDK"
    
    # Clean up
    rm -f "$temp_file"
    
    # Add Flutter to PATH
    add_to_path "$flutter_dir/bin"
    
    # Make sure flutter is executable
    execute_with_ai_retry "chmod +x $flutter_dir/bin/flutter" "Setting Flutter executable permissions"
    
    # Refresh PATH for current session
    export PATH="$flutter_dir/bin:$PATH"
    
    log_success "Flutter installed successfully!"
}

# =============================================================================
# ⚙️  FLUTTER CONFIGURATION
# =============================================================================
configure_flutter() {
    CURRENT_STEP="Configuring Flutter"
    update_progress "Configuring Flutter"
    
    local flutter_bin="$HOME/flutter/bin/flutter"
    
    # Make sure Flutter is in PATH for this session
    export PATH="$HOME/flutter/bin:$PATH"
    
    # Run flutter doctor to initialize
    log_info "Running initial Flutter doctor check..."
    execute_with_ai_retry "$flutter_bin doctor -v" "Running Flutter doctor initialization" || true
    
    # Accept licenses if on macOS
    if is_macos; then
        log_info "Accepting Xcode license (if needed)..."
        execute_with_ai_retry "sudo xcodebuild -license accept" "Accepting Xcode license" || log_warning "Could not accept Xcode license. You may need to install Xcode first."
    fi
    
    # Run flutter precache for common targets
    log_info "Running Flutter precache..."
    execute_with_ai_retry "$flutter_bin precache --universal" "Running Flutter precache"
    
    log_success "Flutter configuration completed!"
}

# =============================================================================
# 🏥 HEALTH CHECK
# =============================================================================
run_health_check() {
    CURRENT_STEP="Running health check"
    update_progress "Running health check"
    
    export PATH="$HOME/flutter/bin:$PATH"
    
    echo
    log_info "🏥 Flutter Doctor Report:"
    echo "================================"
    execute_with_ai_retry "flutter doctor -v" "Running final Flutter doctor check" || true
    echo "================================"
    echo
    
    # Complete progress bar
    update_progress "Installation complete"
    echo
    
    log_success "🎉 Flutter environment setup completed successfully!"
    
    # Show next steps
    echo
    log_info "🎯 Next Steps:"
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. Verify installation: flutter --version"
    echo "3. Create your first app: flutter create my_app"
    echo "4. For Android development, install Android Studio and accept licenses"
    echo
    
    if is_macos; then
        echo "📱 For iOS development:"
        echo "1. Install Xcode from the App Store"
        echo "2. Run: sudo xcode-select --install"
        echo "3. Accept Xcode license: sudo xcodebuild -license accept"
        echo
    fi
}

# =============================================================================
# 🚀 MAIN EXECUTION
# =============================================================================
main() {
    echo
    echo "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
    echo "🚀                                                              🚀"
    echo "🚀     Intelligent Flutter Environment Setup Script             🚀"
    echo "🚀     Powered by AI Error Recovery (DeepSeek)                  🚀"
    echo "🚀                                                              🚀"
    echo "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
    echo
    
    log_info "🖥️  System Information: $(get_os_info)"
    echo
    
    log_success "🤖 AI Error Recovery: Enabled"
    echo
    
    # Initialize error log
    echo "Flutter Setup Error Log - $(date)" > "$ERROR_LOG_FILE"
    
    # Run installation steps
    install_basic_dependencies
    install_java
    install_cocoapods
    install_flutter
    configure_flutter
    run_health_check
    
    log_success "🎉 Flutter environment setup completed successfully!"
}

# Run main function
main "$@" 