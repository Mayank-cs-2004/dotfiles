# Kuro's Arch + Hyprland Dotfiles

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-00A4C7?style=for-the-badge&logo=hyprland&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh-F1502F?style=for-the-badge&logo=zsh&logoColor=white)

Welcome to my personal configuration files (dotfiles). This setup is focused on aesthetics, speed, and keyboard-driven productivity using **Hyprland** on **Arch Linux**.

---

## 🖼️ Gallery
> ![Desktop](./screenshots/1.png)

---

## 🛠️ The Stack
| Category | Tool | Description |
|:---|:---|:---|
| **Window Manager** | [Hyprland](https://hyprland.org/) | The tiling compositor |
| **Shell** | Zsh | With [Starship](https://starship.rs/) & [Fastfetch](https://github.com/fastfetch-cli/fastfetch) |
| **Terminal** | [Foot](https://codeberg.org/dnkl/foot) | Fast, lightweight Wayland terminal |
| **Launcher** | [Tofi](https://github.com/philj5011/tofi) | Minimal menu/launcher |
| **Bar** | [Waybar](https://github.com/Alexays/Waybar) | Highly customizable status bar |
| **Notifications** | SwayNC | Notification center |
| **File Manager** | [Yazi](https://github.com/sxyazi/yazi) | Terminal-based file manager |
| **Browser** | Zen Browser | Privacy-focused browser |
| **Lock Screen** | Hyprlock | Screen locker |
| **Logout Menu** | Wlogout | Logout/Reboot/Shutdown menu |
| **Media** | MPV + UOSC | Video player with custom UI |
| **Audio** | Pipewire | Managed via `pamixer` |

---

## 📂 Repository Structure
```text
~/dotfiles
├── .config/
│   ├── hypr/          # Main Hyprland config & Wallpapers
│   ├── waybar/        # Status Bar config
│   ├── wlogout/       # Logout menu icons & style
│   ├── foot/          # Terminal settings
│   ├── tofi/          # Launcher theme
│   ├── yazi/          # File manager config
│   ├── fastfetch/     # System fetch config
│   ├── starship.toml  # Shell prompt
│   ├── mimeapps.list  # Default app associations
│   └── gtk-3.0/       # GTK Theme settings
├── .zshrc             # Zsh configuration
├── .zprofile          # Autostart Hyprland logic
├── .gitconfig         # Git identity
└── packages.txt       # List of installed packages

🚀 Installation
1. Clone the Repository
Bash

git clone [https://github.com/YOUR_USERNAME/dotfiles.git](https://github.com/YOUR_USERNAME/dotfiles.git) ~/dotfiles
cd ~/dotfiles

2. Install Packages

Install the official packages using the saved list:
Bash

sudo pacman -S --needed - < packages.txt

(Note: You may need to manually install AUR packages like wlogout, swww, or zen-browser-bin using yay or paru if they aren't in the standard repos.)
3. Restore Configurations

Warning: This will overwrite your existing configs. Back them up if needed.
Bash

# 1. Link the config folders
cp -r .config/* ~/.config/

# 2. Restore Home directory files
cp .zshrc ~/
cp .zprofile ~/
cp .gitconfig ~/
cp .gtkrc-2.0 ~/

# 3. Apply Zsh changes
source ~/.zshrc

4. Final Setup

    Wallpaper: The wallpaper is located at ~/.config/hypr/wallpapers/76.jpg. Hyprland should load it automatically.

    Reboot: Restart your computer to ensure all services and environment variables load correctly.

⌨️ Keybindings (Cheat Sheet)
Key	Action
Super + T	Open Terminal (Foot)
Super + Z	Open Browser (Zen)
Super + F	File Manager (Yazi)
Super + A	App Launcher (Tofi)
Super + Q	Close Window
Super + V	Clipboard History
Super + Esc	Power Menu (Wlogout)
Super + Shift + S	Screenshot (Select Area)
Super + 1-0	Switch Workspace
