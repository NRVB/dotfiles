#!/usr/bin/env bash
# Exit the script immediately if any command fails
set -euo pipefail

# -------------------------------
# Master Setup Script for macOS
# -------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Array of script filenames in the desired execution order
SCRIPTS=(
"xcode-cli-setup.sh"
"oh-my-zsh-install.sh"
"brew.sh"
"iterm.sh"
"set-default-apps.sh"
"setup-xcode.sh"
"folders-setup.sh"
    "macos-settings.sh"
)

# Function to set executable permissions on a script
set_executable() {
    local script_path="$1"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        echo "Set executable permission for: $(basename "$script_path")"
    else
        echo "Error: Script not found -> $script_path"
        exit 1
    fi
}

execute_script() {
    local script_path="$1"
    echo "----------------------------------------"
    echo "Running $(basename "$script_path")..."
    echo "----------------------------------------"
    bash "$script_path"
    echo "Completed: $(basename "$script_path")"
    echo ""
}

echo "========================================"
echo "Starting Master Setup Script for macOS"
echo "========================================"

cd "$SCRIPT_DIR"

echo "Step 1: Setting executable permissions..."
for script in "${SCRIPTS[@]}"; do
    set_executable "$SCRIPT_DIR/$script"
done
echo "All scripts are set to executable."
echo ""

echo "Step 2: Executing setup scripts..."
for script in "${SCRIPTS[@]}"; do
    execute_script "$SCRIPT_DIR/$script"
done
echo "All setup scripts executed successfully."
echo ""

echo "========================================"
echo "Master Setup Completed Successfully!"
echo "========================================"
