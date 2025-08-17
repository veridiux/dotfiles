#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc


# Only start Hyprland on TTY1
if [[ $(tty) == /dev/tty1 ]]; then
	exec ~/Scripts/System/hyprland_launcher.sh
fi

