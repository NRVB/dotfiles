#!/bin/bash
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed. Skipping installation."
else
echo "Installing Oh My Zsh..."
ZSH_INSTALL_SCRIPT=$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
echo "$ZSH_INSTALL_SCRIPT" | zsh -s -- --unattended
fi
