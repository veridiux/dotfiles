distro=$(grep '^ID=' /etc/os-release | cut -d= -f2)

case "$distro" in
    arch)
        echo "[*] Linking Arch configs..."
        ln -sf ~/dotfiles/distro/arch/config/auto-cpufreq ~/.config/auto-cpufreq
        ln -sf ~/dotfiles/distro/arch/config/hypr ~/.config/hypr
        ln -sf ~/dotfiles/distro/arch/config/waybar ~/.config/waybar
	ln -sf ~/dotfiles/distro/arch/config/alacritty ~/.config/alacritty
	ln -sf ~/dotfiles/distro/arch/config/Kvantum ~/.config/Kvantum
	ln -s ~/dotfiles/shells/.zshrc ~/.zshrc
	ln -s ~/dotfiles/distro/arch/config/kdeglobals ~/.config/kdeglobals

	ln -s /home/justin/dotfiles/systemd/fix_razer_sound.service /etc/systemd/system/fix_razer_sound.service
	ln -s ~/dotfiles/scripts/fix_razer_sound.sh /opt/binfix_razer_sound.sh
        ;;
    debian|ubuntu)
        echo "[*] Linking Debian configs..."
        # (future symlinks here)
        ;;
    *)
        echo "[!] Unknown distro: $distro"
        ;;
esac

