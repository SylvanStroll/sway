<div align="center">

# 🪻 sway

**minimal · wayland · catppuccin lavender**

my personal sway setup — full install script + dotfiles, tuned for a calm,
low-distraction desktop.

![shell](https://img.shields.io/badge/shell-fish-CBA6F7?style=for-the-badge&logo=gnubash&logoColor=1E1E2E)
![wm](https://img.shields.io/badge/wm-sway-B4BEFE?style=for-the-badge&logo=wayland&logoColor=1E1E2E)
![theme](https://img.shields.io/badge/theme-catppuccin-DDB6F2?style=for-the-badge)

</div>

---

## ✨ overview

A single `install.sh` bootstraps a fresh Arch install into this setup: base
system update, shell, window manager, core utilities, GUI apps, networking,
power management, then drops all dotfiles straight into `~/.config`.

```
https://github.com/kusalthemiya/sway/
cd sway
chmod +x install.sh
./install.sh
```

Not run as root — the script sudos only where it needs to.

---

## 🧩 stack

| category   | tools |
|------------|-------|
| shell      | `fish` + `starship` |
| wm         | `sway` (wayland) |
| terminal   | `foot` |
| launcher   | `fuzzel` |
| bar        | `waybar` |
| editor     | `neovim` |
| files      | `yazi` |
| notifications | `mako` |
| lock / idle | `swaylock`, `swayidle` |
| clipboard  | `wl-clipboard`, `cliphist` |
| screenshots | `grim` + `slurp` |
| media      | `mpv`, `imv` |
| misc       | `keepassxc`, `firefox`, `syncthing`, `ufw`, `tlp`, `thermald` |

---

## 📂 structure

```
.
├── fastfetch/
├── fish/
├── foot/
├── fuzzel/
├── mako/
├── nvim/
├── sway/
├── swaylock/
├── waybar/
├── yazi/
├── wallpaper/
├── starship.toml
├── import.json
└── install.sh
```

Every top-level folder here maps 1:1 onto `~/.config/<folder>` — the script
copies each one in, backing up anything that already exists as `*.bak`
before it overwrites it.

---

## ⚙️ what the script does

1. **update** — full system sync (`pacman -Syyu`)
2. **shell** — installs fish + starship, sets fish as default shell
3. **sway stack** — sway, foot, fuzzel, waybar, neovim, yazi, mako, clipboard tools, lock/idle
4. **cli utilities** — bat, btop, fastfetch, imagemagick, thermald, tlp, intel graphics drivers
5. **gui apps** — grim, slurp, mpv, imv, keepassxc, firefox + uBlock Origin
6. **networking** — syncthing (enabled as a user service) + ufw
7. **power** — enables thermald + tlp for thermal/battery management
8. **dotfiles** — copies every config folder + `starship.toml` + `wallpaper/` into `~/.config`
9. **cleanup** — removes orphaned packages and package cache

---

## 🖥️ after install

```bash
sudo reboot
sway
```

---

<div align="center">
</div>
