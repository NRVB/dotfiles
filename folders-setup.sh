#!/usr/bin/env zsh

###############################################################################
# Script for creating necessary default folders                               #
###############################################################################

# List of default folders to create
default_folders=(
    "$HOME/Projects"
    "$HOME/Printscreens"
    # For stuff like Flutter SDK
    "$HOME/Development assets"

)

create_folders() {
    for folder in "${default_folders[@]}"; do
        if [ -d "$folder" ]; then
            echo "Directory already exists: $folder. Skipping..."
        else
            mkdir -p "$folder" && \
                echo "Created directory: $folder" || \
                echo "Failed to create directory: $folder"
        fi
    done
}

echo "Starting to create default folders..."
create_folders
echo "Default folders creation process completed."

###############################################################################
# Script for setting up symlinks for dotfiles/.config and .zshrc to home directory
###############################################################################

# Set the URL of your dotfiles repository
DOTFILES_REPO_URL="https://github.com/yourusername/dotfiles.git"  # Replace with your actual repo URL

DOTFILES_DIR="$HOME/dotfiles"
TARGET_CONFIG="$HOME/.config"
SOURCE_CONFIG="$DOTFILES_DIR/.config"

TARGET_ZSHRC="$HOME/.zshrc"
SOURCE_ZSHRC="$DOTFILES_DIR/.zshrc"

# Function to create symlink
create_symlink() {
    local target=$1
    local source=$2

    if [ -L "$target" ]; then
        echo "Symlink already exists: $target -> $(readlink $target)"
    elif [ -e "$target" ]; then
        echo "Existing file or directory found at $target. Backing up to ${target}.backup"
        mv "$target" "${target}.backup"
        ln -s "$source" "$target"
        echo "Symlink created: $target -> $source"
    else
        ln -s "$source" "$target"
        echo "Symlink created: $target -> $source"
    fi
}

# Check if Git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "Git is not installed. Please install Git before running this script."
    exit 1
fi

# Clone dotfiles repository if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles directory does not exist: $DOTFILES_DIR"
    echo "Cloning dotfiles repository from $DOTFILES_REPO_URL into $DOTFILES_DIR..."
    git clone "$DOTFILES_REPO_URL" "$DOTFILES_DIR" || {
        echo "Error cloning dotfiles repository. Exiting."
        exit 1
    }
else
    # If the directory exists, update it
    echo "Dotfiles directory exists. Pulling latest changes..."
    cd "$DOTFILES_DIR"
    git pull --rebase
    cd -
fi

# Ensure source .config directory exists
if [ ! -d "$SOURCE_CONFIG" ]; then
    echo "Source .config directory does not exist: $SOURCE_CONFIG"
    mkdir -p "$SOURCE_CONFIG"
    echo "Created source .config directory."
fi

echo "Setting up dotfiles..."
echo "Creating symlink for .config directory..."
create_symlink "$TARGET_CONFIG" "$SOURCE_CONFIG"

echo "Creating symlink for .zshrc..."
create_symlink "$TARGET_ZSHRC" "$SOURCE_ZSHRC"

echo "Dotfiles setup completed."