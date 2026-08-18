# ~/.zshrc

# ===============================
# Aliases
# ===============================
# General
alias ll='ls -lah'
alias binds='cat ~/.dotfiles/shells/zsh_binds'  # Show system binds
alias reload='source ~/.zshrc'
alias ep='export_packages'

# Git Shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gu='gitupdate_safe'


# Pacman shortcuts
alias p='sudo pacman'
alias pi='sudo pacman -S'      # install package
alias ps='sudo pacman -Ss'     # search package
alias pf='sudo pacman -Fy'     # search installed packages
alias pu='sudo pacman -Syu'    # update system
alias pr='sudo pacman -R'      # remove package
alias pss='pacman -Q'          # list installed packages
alias p!='sudo pacman -S --needed - < ~/.dotfiles/packages/pacman.txt'   # Universal package list

# Yay shortcuts
alias y='yay'
alias yi='yay -S'              # install package
alias ys='yay -Ss'             # search package
alias yu='yay -Syu'            # update all packages (AUR + official)
alias yr='yay -R'              # remove package
alias yq='yay -Qi'             # info about installed package
alias yout='yay -Yc'           # remove orphaned packages
alias y!='yay -S --needed - < ~/.dotfiles/packages/yay.txt'   # Universal package list

# Directory shortcute
alias hd='cd ~/'
alias df='cd ~/.dotfiles/'
alias la='ls -A'     # show hidden files
alias ll='ls -lah'   # already your long listing
alias lla='ls -lahA' # long listing with hidden files
alias cfg='cd ~/.config/'

# Extra
alias theme='vscodium ~/.config/quickshell/themes/Main.qml'

# ===============================
# System info on shell startup
# ===============================
fastfetch

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
# Prompt
# ===============================
setopt prompt_subst

autoload -U colors && colors

#PROMPT='%F{cyan}%n@%m%f %F{green}%1~%f$(git_branch) %# '
#PROMPT='%F{cyan}%n%f@%F{green}%m%f  %F{yellow}%~%f$(git_branch) %&
#%F{yellow}󱞩%f '
#PROMPT='%F{cyan}┌─[%f%F{cyan}%n%f@%F{green}%m%f%F{cyan}]%f %F{yellow}%~%f$(git_branch)
#%F{cyan}└─%f %F{yellow}󱞩%f '
#PROMPT='%F{cyan}┌─[%f%F{cyan}%n%f@%F{green}%m%f%F{cyan}]%f %F{cyan}::%f %F{yellow}%~%f$(git_branch)
#%F{cyan}└─[%f%F{yellow}󱞩%f%F{cyan}]%f '
PROMPT='%F{#ff6200}┌─[%f%F{#ff6200}%n%f@%F{green}%m%f%F{#ff6200}]%f %F{#ff6200}//%f %F{yellow}%~%f$(git_branch)
%F{#ff6200}└─[%f%F{yellow}❯%f%F{#ff6200}]%f '


#//------------Custom Functions------------\\#


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

        echo " %F{#ff6200}[%f%F{green}$branch%f%F{#ff6200}]%f$dirty"
    fi
}

# ===============================
# Safe Git auto-update with confirmation
# ===============================
gitupdate_safe() {
    local repo="${1:-$PWD}"
    local msg
    local confirm

    # Work in a subshell so the current directory is never changed
    (
        cd "$repo" || {
            echo "Directory not found: $repo"
            exit 1
        }

        # Make sure this is a Git repository
        if ! git rev-parse --is-inside-work-tree &>/dev/null; then
            echo "Not a Git repository: $repo"
            exit 1
        fi

        # Show git status first
        git status

        # Ask for confirmation
        read -q "confirm?Do you want to commit and push these changes? (y/n) "
        echo

        if [[ "$confirm" != "y" ]]; then
            echo "Aborted."
            exit 0
        fi

        # Generate timestamp commit message
        msg="update: $(date '+%Y-%m-%d %H:%M:%S')"

        # Stage everything
        git add -A

        # Commit changes
        if ! git commit -m "$msg"; then
            echo "Commit failed. Push aborted."
            exit 1
        fi

        # Pull remote changes and rebase our new commit
        echo "Pulling remote changes..."
        if ! git pull --rebase; then
            echo "Pull failed. Push aborted."
            exit 1
        fi

        # Push to GitHub
        echo "Pushing changes..."
        if ! git push; then
            echo "Push failed."
            exit 1
        fi

        echo "Git update complete."
    )
}

# ===============================
# Export packages to folder specified by host name
# ===============================
export_packages() {
    SYSTEM_NAME="$HOST"
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M:%S)
    PACKAGE_DIR="$HOME/.dotfiles/packages/$SYSTEM_NAME/$TIMESTAMP"
    PKG_DIR="$PACKAGE_DIR"

    mkdir -p "$PKG_DIR"

    pacman -Qqen | sort -u > "$PKG_DIR/pacman.txt"
    pacman -Qqem | sort -u > "$PKG_DIR/aur.txt"

    cat \
        "$PKG_DIR/pacman.txt" \
        "$PKG_DIR/aur.txt" |
        sort -u > "$PKG_DIR/all.txt"

    pacman -Q | sort > "$PKG_DIR/installed.txt"
    pacman -Qe | sort > "$PKG_DIR/explicit.txt"

    pacman -Qdtq 2>/dev/null | sort -u > "$PKG_DIR/orphans.txt"

    {
        echo "System Package Snapshot"
        echo "======================="
        echo
        echo "System Name : $SYSTEM_NAME"
        echo "Hostname    : $HOST"
        echo "Date        : $TIMESTAMP"
        echo "Kernel      : $(uname -r)"
        echo "Architecture: $(uname -m)"
        echo "Shell       : $SHELL"
        echo
        echo "Package Counts"
        echo "--------------"
        echo "Official    : $(wc -l < "$PKG_DIR/pacman.txt")"
        echo "Foreign/AUR : $(wc -l < "$PKG_DIR/aur.txt")"
        echo "Total       : $(wc -l < "$PKG_DIR/all.txt")"
        echo "Orphans     : $(wc -l < "$PKG_DIR/orphans.txt")"
        echo
        echo "Files"
        echo "-----"
        echo "pacman.txt    - Explicit official repository packages"
        echo "aur.txt       - Explicit foreign/AUR packages"
        echo "all.txt       - Combined package names"
        echo "installed.txt - Every installed package + version"
        echo "explicit.txt  - Explicit packages + version"
        echo "orphans.txt   - Unneeded dependency packages"
    } > "$PKG_DIR/info.txt"

    echo
    echo "Package snapshot complete"
    echo "────────────────────────────────────────"
    echo "System : $SYSTEM_NAME"
    echo "Date   : $TIMESTAMP"
    echo
    echo "Official packages : $(wc -l < "$PKG_DIR/pacman.txt")"
    echo "Foreign/AUR       : $(wc -l < "$PKG_DIR/aur.txt")"
    echo "Total             : $(wc -l < "$PKG_DIR/all.txt")"
    echo "Orphans           : $(wc -l < "$PKG_DIR/orphans.txt")"
    echo
    echo "Saved to:"
    echo "  $PKG_DIR"
}


#\\------------Custom Functions------------//#


# ===============================
# Export history of commands typed in shell
# ===============================
HISTFILE=~/.zsh_history

HISTSIZE=5000
SAVEHIST=5000

setopt APPEND_HISTORY        # append instead of overwrite
setopt SHARE_HISTORY         # share history across sessions
setopt HIST_IGNORE_DUPS      # ignore duplicates
setopt HIST_IGNORE_SPACE     # ignore commands starting with space

