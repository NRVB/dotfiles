#!/usr/bin/env bash

################################################################################
# Script Name: setup-xcode.sh
# Description: Copies Xcode themes, settings, key bindings, code snippets, and
#              templates from the dotfiles repository to the correct locations.
# Usage: Run this script on a fresh install to set up your Xcode environment.
################################################################################

set -e  # Exit immediately if a command exits with a non-zero status

# Define the paths
# Set this to the actual path of your dotfiles Xcode directory
DOTFILES_XCODE_DIR="$HOME/dotfiles/xcode"

# Xcode directories
XCODE_USER_DATA_DIR="$HOME/Library/Developer/Xcode/UserData"
XCODE_TEMPLATES_DIR="$HOME/Library/Developer/Xcode/Templates"

echo "Starting Xcode configuration restoration..."

# Ensure destination directories exist
mkdir -p "$XCODE_USER_DATA_DIR"
mkdir -p "$XCODE_TEMPLATES_DIR"

###############################################################################
# Restore Key Bindings
###############################################################################
echo "Restoring Xcode key bindings..."
if [ -d "$DOTFILES_XCODE_DIR/UserData/KeyBindings" ]; then
    echo "Restoring Key Bindings..."
    cp -R "$DOTFILES_XCODE_DIR/UserData/KeyBindings" "$XCODE_USER_DATA_DIR/"
else
    echo "No Key Bindings found in dotfiles."
fi

###############################################################################
# Restore Font and Color Themes
###############################################################################
echo "Restoring Xcode Font and Color Themes..."
if [ -d "$DOTFILES_XCODE_DIR/UserData/FontAndColorThemes" ]; then
    echo "Restoring Font and Color Themes..."
    cp -R "$DOTFILES_XCODE_DIR/UserData/FontAndColorThemes" "$XCODE_USER_DATA_DIR/"
else
    echo "No Font and Color Themes found in dotfiles."
fi

###############################################################################
# Restore Code Snippets
###############################################################################
echo "Restoring Xcode Code Snippets..."
if [ -d "$DOTFILES_XCODE_DIR/UserData/CodeSnippets" ]; then
    echo "Restoring Code Snippets..."
    cp -R "$DOTFILES_XCODE_DIR/UserData/CodeSnippets" "$XCODE_USER_DATA_DIR/"
else
    echo "No Code Snippets found in dotfiles."
fi

###############################################################################
# Restore IDETemplateMacros.plist
###############################################################################
echo "Restoring IDETemplateMacros.plist..."
if [ -f "$DOTFILES_XCODE_DIR/UserData/IDETemplateMacros.plist" ]; then
    echo "Restoring IDETemplateMacros.plist..."
    cp "$DOTFILES_XCODE_DIR/UserData/IDETemplateMacros.plist" "$XCODE_USER_DATA_DIR/"
else
    echo "No IDETemplateMacros.plist found in dotfiles."
fi

###############################################################################
# Restore Templates
###############################################################################
echo "Restoring Xcode Templates..."
if [ -d "$DOTFILES_XCODE_DIR/Templates" ]; then
    echo "Restoring Templates..."
    cp -R "$DOTFILES_XCODE_DIR/Templates" "$XCODE_TEMPLATES_DIR/"
else
    echo "No Templates found in dotfiles."
fi

echo "Xcode configurations restored successfully."
