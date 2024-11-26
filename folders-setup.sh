#!/usr/bin/env bash

###############################################################################
# Script for creating necessary default folders                               #
###############################################################################

# List of default folders to create
default_folders=(
    "$HOME/Projects"
    "$HOME/Printscreens"
    # For stuff litke flutter sdk
    "$HOME/Development assets"

)

create_folders() {
    for folder in "${default_folders[@]}"; do
        if [ -d "$folder" ]; then
            echo "Directory already exists: $folder. Skipping..." | tee -a "$FOLDER_LOG_FILE"
        else
            mkdir -p "$folder" && \
                echo "Created directory: $folder" | tee -a "$FOLDER_LOG_FILE" || \
                echo "Failed to create directory: $folder" | tee -a "$FOLDER_LOG_FILE"
        fi
    done
}

decho "Starting to create default folders..." | tee -a "$FOLDER_LOG_FILE"
create_folders
echo "Default folders creation process completed." | tee -a "$FOLDER_LOG_FILE"

###############################################################################
# Script for setup symlink for dotfiles/.config and zshrc to home directory   #
###############################################################################

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
        echo "Existing file or directory found at $target. Backing up to $target.backup"
        mv "$target" "$target.backup"
        ln -s "$source" "$target"
        echo "Symlink created: $target -> $source"
    else
        ln -s "$source" "$target"
        echo "Symlink created: $target -> $source"
    fi
}

# Ensure dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles directory does not exist: $DOTFILES_DIR"
    exit 1
fi

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
