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
# Safe Git auto-update with confirmation
# ===============================
gitupdate_safe() {
    local repo="$1"
    local msg

    # default to current directory if none given
    if [[ -z "$repo" ]]; then
        repo="$PWD"
    fi

    cd "$repo" || { echo "Directory not found: $repo"; return; }

    # show git status first
    git status

    # ask for confirmation
    read -q "confirm?Do you want to commit and push these changes? (y/n) " 
    echo
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Aborted."
        cd - || return
        return
    fi

    # generate timestamp commit message
    msg="update: $(date '+%Y-%m-%d %H:%M:%S')"

    # stage and commit
    git add -A
    git commit -m "$msg"

    # pull remote changes first
    git pull --rebase

    # push to GitHub
    git push

    # return to original directory
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
alias gu='gitupdate_safe'

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


HISTFILE=~/.zsh_history

HISTSIZE=5000
SAVEHIST=5000

setopt APPEND_HISTORY        # append instead of overwrite
setopt SHARE_HISTORY         # share history across sessions
setopt HIST_IGNORE_DUPS      # ignore duplicates
setopt HIST_IGNORE_SPACE     # ignore commands starting with space




