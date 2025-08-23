distro=$(grep '^ID=' /etc/os-release | cut -d= -f2)

case "$distro" in
    arch)
        echo "[*] Linking Arch configs..."
        ln -sf ~/dotfiles/distro/arch/config/hypr ~/.config/hypr
        ln -sf ~/dotfiles/distro/arch/config/waybar ~/.config/waybar
	ls -sf ~/dotfiles/distro/arch/config/alacritty ~/.config/alacritty
	ln -s ~/dotfiles/shells/.zshrc ~/.zshrc

        ;;
    debian|ubuntu)
        echo "[*] Linking Debian configs..."
        # (future symlinks here)
        ;;
    *)
        echo "[!] Unknown distro: $distro"
        ;;
esac

