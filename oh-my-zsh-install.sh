#!/bin/bash

echo "Installing Oh My Zsh..."
ZSH_INSTALL_SCRIPT=$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
echo "$ZSH_INSTALL_SCRIPT" | zsh -s -- --unattended
