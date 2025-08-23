distro=$(grep '^ID=' /etc/os-release | cut -d= -f2)

case "$distro" in
    arch)
        echo "[*] Linking Arch configs..."
        ln -sf ~/dotfiles/distro/arch/config/hypr ~/.config/hypr
        ln -sf ~/dotfiles/distro/arch/config/waybar ~/.config/waybar
	ln -sf ~/dotfiles/distro/arch/config/alacritty ~/.config/alacritty
	ln -sf ~/dotfiles/distro/arch/config/Kvantum ~/.config/Kvantum
	ln -s ~/dotfiles/shells/.zshrc ~/.zshrc
	ln -s ~/dotfiles/distro/arch/config/kdeglobals ~/.config/

        ;;
    debian|ubuntu)
        echo "[*] Linking Debian configs..."
        # (future symlinks here)
        ;;
    *)
        echo "[!] Unknown distro: $distro"
        ;;
esac

