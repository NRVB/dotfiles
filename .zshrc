# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"  # You can change this to your preferred theme

# Oh-My-Zsh plugins
plugins=(macos xcode)

# Initialize Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Zinit installation and setup
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Terminal settings
export TERM="xterm-256color"
export COLORTERM="truecolor"

# Initialize rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


# Zinit plugins
zinit light zsh-users/zsh-autosuggestions
zinit light MichaelAquilina/zsh-you-should-use
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# fzf-tab plugin (load after compinit)
zinit light Aloxaf/fzf-tab

# Keyboard shortcut for autosuggest accept
bindkey '^o' autosuggest-accept

# fzf setup
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf options
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Aliases
# Oh-My-Zsh
alias ohmyzsh="zed ~/.oh-my-zsh"

# Git aliases
alias gp='git push'
alias gf='git fetch'
alias gaa='git add --all'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gst='git status'
alias gcmsg='git commit --message'
alias gpl='git pull'
alias gsq='git rebase -i HEAD~'
alias glg='git log'
alias gcob='git checkout -b'

# Utility aliases
alias lc='eza --icons=always --color=always --color-scale-mode=gradient -a'
alias lcl='eza --icons=always --color=always --color-scale-mode=gradient --long -a'
alias lcd='eza --icons=always --color=always --color-scale-mode=gradient --only-dirs --long -a'
alias lcf='eza --icons=always --color=always --color-scale-mode=gradient --only-files --long -a'
alias lct='eza --icons=always --color=always --color-scale-mode=gradient --long --only-dirs --tree --hyperlink --header -a'
alias lctf='eza --icons=always --color=always --color-scale-mode=gradient --tree -a'
alias edzsh='sudo zed ~/.zshrc'
alias edp10k='sudo zed ~/.p10k.zsh'
alias ednvim='sudo zed ~/.config/nvim/init.lua'
alias cop='gh copilot'
alias stest='speedtest-cli --server 41039'

# Directory aliases
alias prog='cd ~/Programmera'
alias programmera='cd ~/Programmera'
alias dashboard='cd ~/AndroidStudioProjects/Dashboard/'
alias xcode='cd ~/Programmera/xcode'

# Custom command aliases
alias itchy='sshpass -f <(./get_ssh_password.sh) ssh dv24nbr@itchy.cs.umu.se'
alias nvimf='nvim $(fzf)'
alias znvim='zn'

# Zoxide
eval "$(zoxide init zsh)"

# Function to fuzzy find and change directory using zoxide and fzf
zf() {
  local dir
  dir=$(zoxide query -l | fzf --preview 'tree -C {} | head -200')
  if [[ -n $dir ]]; then
    cd "$dir"
  fi
}

# Function to fuzzy find, change directory, and open Neovim using zoxide and fzf
zn() {
  local dir
  dir=$(zoxide query -l | fzf --preview 'tree -C {} | head -200')
  if [[ -n $dir ]]; then
    cd "$dir" && nvim .
  fi
}

# Renamed from 'zi' to 'zoxide_interactive' to avoid conflicts
zoxide_interactive() {
  local dir
  dir=$(zoxide query -i -- "$@")
  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

# 1Password SSH agent
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Oh-My-Posh
eval "$(oh-my-posh init zsh --config '~/dotfiles/.mytheme2.omp.json')"

# Source zsh-syntax-highlighting (should be last)
zinit light zsh-users/zsh-syntax-highlighting