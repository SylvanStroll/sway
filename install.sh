#!/usr/bin/env bash
#
# Personal Arch Linux post-install setup script
#
# Usage:
#   chmod +x install.sh
#   ./install.sh
#

set -euo pipefail

log() { echo -e "\n\033[1;32m==> $*\033[0m"; }
warn() { echo -e "\033[1;33m[warn] $*\033[0m"; }

# ---------------------------------------------------------------------------
# 0. Sanity checks
# ---------------------------------------------------------------------------
if [[ $EUID -eq 0 ]]; then
    echo "Don't run this as root. Run as your normal user (it will sudo when needed)."
    exit 1
fi

# ---------------------------------------------------------------------------
# 1. Base system update + build tools
# ---------------------------------------------------------------------------
log "Updating system"
sudo pacman -Syyu --noconfirm

log "Installing base-devel and git (needed to build yay)"
sudo pacman -S --needed --noconfirm base-devel git

# ---------------------------------------------------------------------------
# 2. Install yay (AUR helper)
# ---------------------------------------------------------------------------
if ! command -v yay &>/dev/null; then
    log "Installing yay from AUR"
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
else
    log "yay already installed, skipping"
fi

# ---------------------------------------------------------------------------
# 3. Shell setup (fish + starship)
# ---------------------------------------------------------------------------
log "Installing fish shell + starship prompt"
sudo pacman -S --needed --noconfirm fish starship

mkdir -p ~/.config/fish

log "Setting fish as default shell"
if [[ "$SHELL" != */fish ]]; then
    chsh -s /usr/bin/fish
fi

# ---------------------------------------------------------------------------
# 4. Sway (Wayland WM) + core desktop stack
# ---------------------------------------------------------------------------
log "Installing sway and core WM tools"
sudo pacman -S --needed --noconfirm \
    sway foot fuzzel waybar neovim yazi \
    wl-clipboard cliphist mako \
    swaybg swaylock swayidle brightnessctl

# ---------------------------------------------------------------------------
# 5. CLI / system utilities
# ---------------------------------------------------------------------------
log "Installing CLI utilities"
sudo pacman -S --needed --noconfirm \
    bat btop fastfetch \
    imagemagick libheif poppler \
    dosfstools android-tools \
    thermald tlp intel-ucode \
    mesa vulkan-intel intel-media-driver

log "Installing archive tools"
sudo pacman -S --needed --noconfirm 7zip

# ---------------------------------------------------------------------------
# 6. GUI apps
# ---------------------------------------------------------------------------
log "Installing GUI apps"
sudo pacman -S --needed --noconfirm \
    grim slurp mpv imv keepassxc qt5-wayland udisks2 

log "Installing AUR GUI apps"
yay -S --needed --noconfirm swaylock-effects librewolf-bin aria2 localsend-bin

# ---------------------------------------------------------------------------
# 7. Networking / sync
# ---------------------------------------------------------------------------
log "Installing syncthing + enabling service"
sudo pacman -S --needed --noconfirm syncthing
systemctl --user enable --now syncthing

log "Configuring ufw"
sudo pacman -S --needed --noconfirm ufw
sudo ufw allow syncthing
sudo systemctl enable --now ufw

# ---------------------------------------------------------------------------
# 8. Enable power/thermal services
# ---------------------------------------------------------------------------
log "Enabling thermald and tlp"
sudo systemctl enable --now thermald
sudo systemctl enable --now tlp

# ---------------------------------------------------------------------------
# 9. Copy dotfiles into ~/.config
# ---------------------------------------------------------------------------
log "Copying dotfiles into ~/.config"
 
# Directory this script lives in (so it works no matter where you run it from)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
 
mkdir -p ~/.config
 
# Folders that map directly into ~/.config/<name>
config_dirs=(fastfetch foot fish fuzzel mako nvim sway swaylock waybar yazi)
 
for dir in "${config_dirs[@]}"; do
    src="$SCRIPT_DIR/$dir"
    dest="$HOME/.config/$dir"
    if [[ -d "$src" ]]; then
        if [[ -e "$dest" ]]; then
            warn "Backing up existing $dest to $dest.bak"
            rm -rf "$dest.bak"
            mv "$dest" "$dest.bak"
        fi
        cp -r "$src" "$dest"
        echo "  copied $dir -> $dest"
    else
        warn "$src not found, skipping"
    fi
done
 
# starship.toml is a single file, not a folder
if [[ -f "$SCRIPT_DIR/starship.toml" ]]; then
    cp "$SCRIPT_DIR/starship.toml" ~/.config/starship.toml
    echo "  copied starship.toml -> ~/.config/starship.toml"
fi
 
# wallpaper folder — copy to ~/.config/wallpaper (adjust if you keep it elsewhere)
if [[ -d "$SCRIPT_DIR/wallpaper" ]]; then
    mkdir -p ~/.config/wallpaper
    cp -r "$SCRIPT_DIR/wallpaper/." ~/.config/wallpaper/
    echo "  copied wallpaper/ -> ~/.config/wallpaper/"
fi

# ---------------------------------------------------------------------------
# 10. Cleanup orphaned packages + cache
# ---------------------------------------------------------------------------
log "Cleaning up orphans and package cache"
orphans=$(pacman -Qtdq || true)
if [[ -n "$orphans" ]]; then
    sudo pacman -Rns --noconfirm $orphans
else
    echo "No orphaned packages."
fi
yay -Scc --noconfirm || true

# ---------------------------------------------------------------------------
# 11. Finishing
# ---------------------------------------------------------------------------
log "Setup complete!"
echo "Reboot recommended: sudo reboot"
echo "Then start sway with: sway"
