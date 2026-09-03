# ~/.zshrc

# ===============================
# Aliases
# ===============================
# General
alias ll='ls -lah'
alias cs='cs_viewer'                # show the cheat sheet
alias reload='source ~/.zshrc'
alias ep='export_packages'
alias il='is_link'
alias zshedit='vscodium ~/.zshrc'

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
alias sshm='sshmenu'

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

# =============================Export packages to folder specified by host name==
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
# Is the current path symlinked
# ===============================
is_link() {
	if [[ -L $PWD ]]; then
  	echo "✓ $PWD is a symlink → $(readlink $PWD)"
  	echo "  Resolved path: $(pwd -P)"
	else	
  	    echo "✗ $PWD is not a symlink"
	fi
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

# ===============================
# Cheat Sheet Viewer
# ===============================
cs_viewer() {
    local base_dir="$HOME/.dotfiles/cheat-sheet"
    local current_dir="$base_dir"
    local choice
    local file
    local i

    # Clear screen + scrollback
    cs_clear() {
        printf '\033[2J\033[3J\033[H'
    }

    # Get the relative path for display
    cs_relative_path() {
        local path="$1"
        printf '%s' "${path#$base_dir/}"
    }

    while true; do
        cs_clear

        printf '%s\n' \
            '// ┌─[ CHEAT SHEET ]─────────────────────────────────────────┐' \
            '// │                                                         │' \
            '// └─────────────────────────────────────────────────────────┘'

        printf '\n  Location: %s\n\n' "$(cs_relative_path "$current_dir")"

        # ---------------------------------
        # Build menu
        # ---------------------------------
        local -a entries=()
        local -a types=()

        # Add ".." if we're not at the root
        if [[ "$current_dir" != "$base_dir" ]]; then
            entries+=("..")
            types+=("dir")
        fi

        # Add directories first
        for file in "$current_dir"/*(/N); do
            entries+=("${file:t}")
            types+=("dir")
        done

        # Then add files
        for file in "$current_dir"/*(.N); do
            entries+=("${file:t}")
            types+=("file")
        done

        # ---------------------------------
        # Display menu
        # ---------------------------------
        i=1

        for (( i = 1; i <= ${#entries[@]}; i++ )); do
            if [[ "${types[i]}" == "dir" ]]; then
                printf '  %d) %s/\n' "$i" "${entries[i]}"
            else
                printf '  %d) %s\n' "$i" "${entries[i]}"
            fi
        done

        printf '\n  q) Quit\n\n'
        printf 'Select: '
        read -r choice

        # ---------------------------------
        # Quit
        # ---------------------------------
        if [[ "${choice:l}" == "q" ]]; then
            cs_clear
            return
        fi

        # ---------------------------------
        # Number selection
        # ---------------------------------
        if [[ "$choice" =~ '^[0-9]+$' ]]; then
            if (( choice < 1 || choice > ${#entries[@]} )); then
                printf '\nInvalid selection.'
                sleep 1
                continue
            fi

            local selected="${entries[choice]}"
            local selected_type="${types[choice]}"

        # ---------------------------------
        # Name selection
        # ---------------------------------
        else
            local selected=""
            local selected_type=""

            for (( i = 1; i <= ${#entries[@]}; i++ )); do
                if [[ "${entries[i]:l}" == "${choice:l}" ]]; then
                    selected="${entries[i]}"
                    selected_type="${types[i]}"
                    break
                fi
            done

            if [[ -z "$selected" ]]; then
                printf '\nInvalid selection.'
                sleep 1
                continue
            fi
        fi

        # ---------------------------------
        # Directory
        # ---------------------------------
        if [[ "$selected_type" == "dir" ]]; then

            if [[ "$selected" == ".." ]]; then
                current_dir="${current_dir:h}"
            else
                current_dir="$current_dir/$selected"
            fi

            continue
        fi

        # ---------------------------------
        # File
        # ---------------------------------
        file="$current_dir/$selected"

        # less gives us:
        #
        #   /word  = search
        #   n      = next match
        #   N      = previous match
        #   g      = top
        #   G      = bottom
        #   q      = quit
        #
        less -N "$file"
    done
}

# ===============================
# SSH Menu
# ===============================
sshmenu() {
    local dir="$HOME/.dotfiles/ssh-menu"
    local choice
    local file
    local device
    local name
    local target
    local description

    while true; do
        echo
        echo "SSH MENU"
        echo "────────────────────────────"

        local -a files
        files=("$dir"/*(N:t))

        local i=1

        for file in "${files[@]}"; do
            printf "%d) %s\n" "$i" "$file"
            ((i++))
        done

        echo "q) Quit"
        echo

        read "choice?Select group: "

        [[ "$choice" == [qQ] ]] && return

        if (( choice < 1 || choice > ${#files[@]} )); then
            echo "Invalid selection."
            continue
        fi

        file="$dir/${files[$choice]}"

        while true; do
            echo
            echo "${files[$choice]:u}"
            echo "────────────────────────────────────────────"

            local -a devices
            devices=("${(@f)$(grep -v '^[[:space:]]*$\|^[[:space:]]*#' "$file")}")

            i=1

            for device in "${devices[@]}"; do
                name="${device%%|*}"
                device="${device#*|}"
                target="${device%%|*}"
                description="${device#*|}"

                printf "%d) %-18s — %-22s %s\n" \
                    "$i" "$name" "$target" "$description"

                ((i++))
            done

            echo "b) Back"
            echo "q) Quit"
            echo

            read "choice?Select device: "

            [[ "$choice" == [qQ] ]] && return
            [[ "$choice" == [bB] ]] && break

            if (( choice >= 1 && choice <= ${#devices[@]} )); then
                device="${devices[$choice]}"

                name="${device%%|*}"
                device="${device#*|}"

                target="${device%%|*}"

                echo
                echo "Connecting to $name..."
                echo

                ssh "$target"

                break
            else
                echo "Invalid selection."
            fi
        done
    done
}

# ===============================
# Quick add pkg
# ===============================
padd() {
    local pkg="$1"
    local file="$HOME/.dotfiles/packages/pacman.txt"

    [[ -z "$pkg" ]] && { echo "Usage: padd <package>"; return 1; }

    grep -qxF "$pkg" "$file" || echo "$pkg" >> "$file"
}

pdel() {
    local pkg="$1"
    local file="$HOME/.dotfiles/packages/pacman.txt"

    [[ -z "$pkg" ]] && { echo "Usage: pdel <package>"; return 1; }

    sed -i "/^${pkg}$/d" "$file"
}

yadd() {
    local pkg="$1"
    local file="$HOME/.dotfiles/packages/yay.txt"

    [[ -z "$pkg" ]] && { echo "Usage: yadd <package>"; return 1; }

    grep -qxF "$pkg" "$file" || echo "$pkg" >> "$file"
}

ydel() {
    local pkg="$1"
    local file="$HOME/.dotfiles/packages/yay.txt"

    [[ -z "$pkg" ]] && { echo "Usage: ydel <package>"; return 1; }

    sed -i "/^${pkg}$/d" "$file"
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

