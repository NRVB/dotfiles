#!/usr/bin/env bash
###############################################################################
# Iterm2 settup script                                                            #
###############################################################################
echo "Setting up iTerm2 preferences..."
echo "Setting settings directory to $HOME/dotfiles/iterm"
PREFS_DIR="$HOME/dotfiles/iterm"

echo "Set iTerm2 to use the custom preferences directory..."
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$PREFS_DIR"

echo "set iTerm2 to save changes to the custom folder..."
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 2

if pgrep "iTerm2" > /dev/null; then
    killall iTerm2
    echo "iTerm2 was running and has been restarted to apply changes."
else
    echo "iTerm2 is not running."
fi

echo "iTerm2 preferences configured to load from $PREFS_DIR"
