#!/usr/bin/env bash

# Log file to store failed installations
LOG_FILE="$HOME/install_errors.log"

# Initialize the log file
> "$LOG_FILE"

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Determine the brew installation prefix
    if [ -d "/opt/homebrew/bin" ]; then
        # Apple Silicon Macs
        BREW_PREFIX="/opt/homebrew"
    elif [ -d "/usr/local/bin" ]; then
        # Intel Macs
        BREW_PREFIX="/usr/local"
    else
        echo "Homebrew installation failed or installed in an unexpected location."
        exit 1
    fi

    echo "Adding Homebrew to PATH..."

    # Add brew to the PATH for the current session
    eval "$($BREW_PREFIX/bin/brew shellenv)"

    # Add brew to the PATH for future sessions
    echo "eval \"\$($BREW_PREFIX/bin/brew shellenv)\"" >> "$HOME/.zprofile"
else
    echo "Homebrew is already installed."
fi

# Verify brew is now accessible
if ! command -v brew &>/dev/null; then
    echo "Failed to configure Homebrew in PATH. Please add Homebrew to your PATH manually."
    exit 1
fi

# Update Homebrew and upgrade any already-installed formulae
echo "Updating Homebrew..."
brew update

echo "Upgrading existing packages..."
brew upgrade

# Cleanup outdated packages
echo "Cleaning up..."
brew cleanup

# Define an array of packages to install using Homebrew
packages=(
    "alacritty"
    "bat"
    "cocoapods"
    "curl"
    "duti"
    "eza"
    "fd"
    "fzf"
    "gcc"
    "gh"
    "git"
    "go@1.22"
    "imagemagick"
    "jq"
    "lazygit"
    "mas"
    "neofetch"
    "neovim"
    "node"
    "oh-my-posh"
    "oh-my-zsh"
    "prettierd"
    "python"
    "rbenv"
    "redis"
    "ripgrep"
    "ruby-build"
    "sshpass"
    "tmux"
    "topgrade"
    "tree"
    "tree-sitter"
    "wget"
    "zoxide"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
)

# Install packages
for package in "${packages[@]}"; do
    if brew list "$package" &>/dev/null; then
        echo "$package is already installed. Skipping..."
    else
        echo "Installing $package..."
        if brew install "$package"; then
            echo "$package installed successfully."
        else
            echo "Failed to install $package. Logging to $LOG_FILE."
            echo "$package" >> "$LOG_FILE"
        fi
    fi
done

# Install cask applications (GUI apps)
casks=(
    "1password"
    "aldente"
    "alfred"
    "arc"
    "balenaetcher"
    "bartender"
    "command-x"
    "dash"
    "flux"
    "garmin-express"
    "github-copilot-for-xcode"
    "hyperkey"
    "insomnia"
    "iina"
    "istat-menus"
    "jetbrains-toolbox"
    "iterm2"
    "karabiner-elements"
    "keyboardcleantool"
    "keyclu"
    "linearmouse"
    "macupdater"
    "obsidian"
    "onyx"
    "pearcleaner"
    "pichon"
    "postman"
    "shottr"
    "sketch"
    rectangle-pro
    "spotify"
    "sf-symbols"
    "visual-studio-code"
    "zed"
    "zen-browser"
)

for cask in "${casks[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
        echo "$cask is already installed. Skipping..."
    else
        echo "Installing $cask..."
        if brew install --cask "$cask"; then
            echo "$cask installed successfully."
        else
            echo "Failed to install $cask. Logging to $LOG_FILE."
            echo "$cask" >> "$LOG_FILE"
        fi
    fi
done

# Install Mac App Store applications using mas
mas_apps=(
    "904280696"    # Things
    "6476452351"   # DevHub
    "6448461551"   # Command X
    "462058435"    # Microsoft Excel
    "6476924627"   # Create Custom Symbols
    "497799835"    # Xcode
    "462054704"    # Microsoft Word
    "6503706164"   # StyleGuide
    "1569813296"   # 1Password for Safari
    "1611378436"   # Pure Paste
    "1388020431"   # DevCleaner
    "1593408455"   # Anybox
    "937984704"    # Amphetamine
    "1615595104"   # SF Menu Bar
    "697942581"    # Disk Graph
    "6469021132"   # PDFgear
    "1552536109"   # PasteNow
    "1504940162"   # RocketSim
    "899247664"    # TestFlight
    "1460684638"   # Core Data Lab
    "470158793"    # Keka
    "6504801865"   # JuxtaText
    "1659984546"   # EditKit Pro
    "1518425043"   # Boop
    "6447125648"   # Gestimer
    "1480068668"   # Messenger
    "935235287"    # Encrypto
    "1355679052"   # Dropover
    "1287239339"   # ColorSlurp
    "897118787"    # Shazam
)

for app_id in "${mas_apps[@]}"; do
    # Extract the app name from the comment
    app_name=$(echo "$app_id" | sed 's/^[^#]*# *//')
    # If app_name is empty, attempt to fetch it using mas info
    if [ -z "$app_name" ]; then
        app_name=$(mas info "$app_id" 2>/dev/null | head -n1)
    fi
    if mas list | grep -q "$app_id"; then
        echo "$app_name (App Store ID: $app_id) is already installed. Skipping..."
    else
        echo "Installing $app_name (App Store ID: $app_id)..."
        if mas install "$app_id"; then
            echo "$app_name installed successfully."
        else
            echo "Failed to install $app_name (App Store ID: $app_id). Logging to $LOG_FILE."
            echo "$app_name (App Store ID: $app_id)" >> "$LOG_FILE"
        fi
    fi
done

# Configure rbenv and install Ruby version
if brew list rbenv &>/dev/null; then
    echo "Configuring rbenv..."
    if ! command -v rbenv &>/dev/null; then
        # Add rbenv to PATH
        export PATH="$HOME/.rbenv/bin:$PATH"
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
    fi
    # Initialize rbenv
    if ! grep -q 'eval "$(rbenv init -)"' ~/.zshrc; then
        echo 'eval "$(rbenv init -)"' >> ~/.zshrc
    fi
    eval "$(rbenv init -)"

    # Install Ruby version if not already installed
    RUBY_VERSION="3.2.2"
    if ! rbenv versions | grep -q "$RUBY_VERSION"; then
        echo "Installing Ruby $RUBY_VERSION via rbenv..."
        if rbenv install "$RUBY_VERSION"; then
            echo "Ruby $RUBY_VERSION installed successfully."
        else
            echo "Failed to install Ruby $RUBY_VERSION. Logging to $LOG_FILE."
            echo "Ruby $RUBY_VERSION" >> "$LOG_FILE"
        fi
    else
        echo "Ruby $RUBY_VERSION is already installed."
    fi
    rbenv global "$RUBY_VERSION"
else
    echo "rbenv is not installed."
    echo "rbenv failed to install or is missing. Logging to $LOG_FILE."
    echo "rbenv" >> "$LOG_FILE"
fi

# install commit mono nerd font
echo "Installing Commit Mono Nerd Font..."
brew install --cask font-commit-mono-nerd-font



echo "Script execution completed."

# Check if any installations failed
if [ -s "$LOG_FILE" ]; then
    echo "Some installations failed. See the log file for details: $LOG_FILE"
    echo "Failed installations:"
    cat "$LOG_FILE"
else
    echo "All installations completed successfully."
    rm "$LOG_FILE"
fi
