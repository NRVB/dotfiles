#!/usr/bin/env bash

# Close any open System Preferences panes to prevent them from overriding settings
osascript -e 'tell application "System Preferences" to quit'

echo "Applying macOS settings..."
# Ask for the administrator password upfront
sudo -v
###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "Automatically quit the printer app once the print jobs complete..."
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "Increase sound quality for Bluetooth headphones/headsets..."
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo "Disable the “Are you sure you want to open this application?” dialog..."
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Expand save panel by default..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Disable automatic capitalization.."
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Set a blazingly fast keyboard repeat rate..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 10


# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2


###############################################################################
# Finder                                                                      #
###############################################################################

echo "Setting default path to Home"
defaults write com.apple.finder NewWindowTarget PfHm

echo "Allow quitting finder with cmd + Q"
defaults write com.apple.finder QuitMenuItem -bool true

echo "Showing hidden files by default..."
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "Showing all filename extensions..."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Showing status bar..."
defaults write com.apple.finder ShowStatusBar -bool true

echo "Using list view in all Finder windows..."
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo "Prevent Time Machine from prompting to use new hard drives as backup volume..."
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "Show the ~/Library folder..."
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library


echo "Restarting Finder..."
killall Finder

###############################################################################
# Dock                                                                        #
###############################################################################

echo "Enabling auto-hide for the Dock..."
defaults write com.apple.dock autohide -bool true

echo "Setting Dock position to the left side..."
defaults write com.apple.dock orientation -string left

echo "Removing the Dock auto-hiding delay..."
defaults write com.apple.dock autohide-delay -float 0

echo "Remove the animation when hiding/showing the Dock..."
defaults write com.apple.dock autohide-time-modifier -float 0

echo "remove show recents apps in dock..."
defaults write com.apple.dock show-recents -bool false


echo "Wipe all (default) app icons from the Dock..."
defaults write com.apple.dock persistent-apps -array

echo "Show only open applications in the Dock..."
defaults write com.apple.dock static-only -bool true

echo "Don't automatically rearrange Spaces based on most recent use..."
defaults write com.apple.dock mru-spaces -bool false

###############################################################################
# Photos                                                                      #
###############################################################################

echo "Prevent Photos from opening automatically when devices are plugged in..."
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true


#!/usr/bin/env bash

# Close any open System Preferences panes to prevent them from overriding settings
osascript -e 'tell application "System Preferences" to quit'

echo "Applying macOS settings..."

###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "Automatically quit the printer app once the print jobs complete..."
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "Increase sound quality for Bluetooth headphones/headsets..."
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo "Disable the “Are you sure you want to open this application?” dialog..."
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Expand save panel by default..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Disable automatic capitalization.."
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo "Set a blazingly fast keyboard repeat rate..."
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 10
###############################################################################
# Finder                                                                      #
###############################################################################


echo "Showing hidden files by default..."
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "Showing all filename extensions..."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Showing status bar..."
defaults write com.apple.finder ShowStatusBar -bool true

echo "Using list view in all Finder windows..."
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo "Prevent Time Machine from prompting to use new hard drives as backup volume..."
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "Show the ~/Library folder..."
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

echo "Restarting Finder..."
killall Finder

###############################################################################
# Dock                                                                        #
###############################################################################

echo "Enabling auto-hide for the Dock..."
defaults write com.apple.dock autohide -bool true

# Set the icon size of Dock items to 16 pixels (smallest size)
defaults write com.apple.dock tilesize -int 16

echo "Setting Dock position to the left side..."
defaults write com.apple.dock orientation -string left

echo "Removing the Dock auto-hiding delay..."
defaults write com.apple.dock autohide-delay -float 0

echo "Remove the animation when hiding/showing the Dock..."
defaults write com.apple.dock autohide-time-modifier -float 0

echo "remove show recents apps in dock..."
defaults write com.apple.dock show-recents -bool false


echo "Wipe all (default) app icons from the Dock..."
defaults write com.apple.dock persistent-apps -array

echo "Show only open applications in the Dock..."
defaults write com.apple.dock static-only -bool true

echo "Don't automatically rearrange Spaces based on most recent use..."
defaults write com.apple.dock mru-spaces -bool false

echo "Restarting Dock..."
killall Dock

###############################################################################
# Keyboard Layouts                                                             #
###############################################################################

echo "Adding Swedish and English (US) keyboard layouts..."

defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
    '{"InputSourceKind" = "Keyboard Layout"; "KeyboardLayout Name" = "U.S."; "KeyboardLayout ID" = 0;}' \
    '{"InputSourceKind" = "Keyboard Layout"; "KeyboardLayout Name" = "Swedish"; "KeyboardLayout ID" = 0;}'

echo "Setting Swedish and English (US) as enabled keyboard layouts."

echo "Restarting SystemUIServer to apply keyboard layout changes..."
killall SystemUIServer


###############################################################################
# Desktop Wallpaper                                                            #
###############################################################################

echo "Setting desktop wallpaper..."
WALLPAPER_PATH="$HOME/dotfiles/wallpapers/gruvbox-rainbow-nix.png"

# Check if the wallpaper file exists
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Error: Wallpaper file not found at $WALLPAPER_PATH"
    exit 1
fi

osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$WALLPAPER_PATH\""

echo "Desktop wallpaper set successfully."

echo "macOS settings applied successfully!"
echo "Some changes may require you to log out and log back in or restart your Mac to take full effect."
