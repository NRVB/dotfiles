#!/bin/bash

# Function to check if Xcode Command Line Tools are installed
function check_xcode_cli() {
    xcode-select -p &>/dev/null
    return $?
}

if check_xcode_cli; then
    echo "Xcode Command Line Tools are already installed."
else
    echo "Xcode Command Line Tools are not installed."
    echo  "Installing Xcode Command Line Tools..."

    # Create a placeholder file to make the Command Line Tools appear as an available update
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

    # Find the software update label for the Command Line Tools
    PROD=$(softwareupdate -l | grep -E "\*.*Command Line Tools" | head -n 1 | awk -F"*" '{print $2}' | sed 's/^ *//')

    if [[ -n "$PROD" ]]; then
        # Install the Command Line Tools
        sudo softwareupdate -i "$PROD" --verbose
        echo "Xcode Command Line Tools installation complete."
    else
        echo "Failed to find the Command Line Tools in the software updates."
        echo "Please try installing them manually."
    fi

    # Remove the placeholder file
    rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
fi