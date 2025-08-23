# ===============================
# Load Bash settings if you have them
# ===============================
[[ -f ~/.bashrc ]] && source ~/.bashrc

# ===============================
# Enable Zsh completion system
# ===============================
autoload -Uz compinit
compinit

# ===============================
# Zsh Autosuggestions & Syntax Highlighting
# ===============================
# Suggest commands from history first
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Auto-suggestions
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Make suggestions light gray for inline look
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Syntax highlighting (must be last)
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ===============================
# Colors
# ===============================
autoload -U colors && colors

# ===============================
# Git helper functions
# ===============================
git_branch() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null) || branch='?'
        local dirty=''
        if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
            dirty=' ✗'
        fi
        echo " (%F{yellow}$branch%f$dirty)"
    fi
}

# ===============================
# Custom functions
# ===============================
gitupdate() {
    local repo="$1"
    if [[ -z "$repo" ]]; then
        repo="$HOME/dotfiles"
    fi
    cd "$repo" || return
    git pull
    cd - || return
}


# ===============================
# Prompt
# ===============================
PROMPT='%F{cyan}%n@%m%f %F{green}%1~%f$(git_branch) %# '

# Interpret prompt variables correctly
setopt prompt_subst

# ===============================
# Aliases
# ===============================
# General
alias ll='ls -lah'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# Pacman shortcuts
alias p='sudo pacman'
alias pi='sudo pacman -S'      # install package
alias ps='sudo pacman -Ss'     # search package
alias pu='sudo pacman -Syu'    # update system
alias pr='sudo pacman -R'      # remove package
alias pss='pacman -Q'          # list installed packages

# Yay shortcuts
alias y='yay'
alias yi='yay -S'              # install package
alias ys='yay -Ss'             # search package
alias yu='yay -Syu'            # update all packages (AUR + official)
alias yr='yay -R'              # remove package
alias yq='yay -Qi'             # info about installed package
alias yout='yay -Yc'           # remove orphaned packages

# Directory shortcute
alias hd='cd ~/'
alias df='cd ~/dotfiles/'
alias la='ls -A'     # show hidden files
alias ll='ls -lah'   # already your long listing
alias lla='ls -lahA' # long listing with hidden files



