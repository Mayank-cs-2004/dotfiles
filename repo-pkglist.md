# ==============================================================================
# INSTALL COMMAND (Run this in your terminal):
# sudo pacman -Syu --needed $(awk '/^[^#]/ {print $1}' repo-pkglist.md)
# ==============================================================================

# === CORE SYSTEM & BOOT ===
base                           # Minimal Arch Linux filesystem
base-devel                     # Compilation tools (gcc, make) needed for AUR packages
linux                          # The Arch Linux kernel
linux-firmware                 # Hardware drivers (Wi-Fi, Bluetooth, Audio)
efibootmgr                     # Tool to write boot entries to UEFI motherboard
grub                           # The actual bootloader menu
pacman-contrib                 # Extra pacman tools (includes paccache)
zram-generator                 # Compresses RAM

# === HYPRLAND & WAYLAND ECOSYSTEM ===
hyprland                       # Core tiling window manager
hypridle                       # Idle daemon (dims screen/locks when away)
hyprlock                       # Screen locker tailored for Hyprland
hyprpicker                     # Color picker for Wayland
hyprpolkitagent                # Authentication popup (when apps ask for sudo password)

# === UI, THEMING & DESKTOP ===
waybar                         # The top status bar
awww                           # Lightweight animated wallpaper daemon (Wayland)
swaync                         # Notification center daemon
nwg-look                       # GTK3/4 theme configuration tool (for Thunar/apps)
orchis-theme                   # The rounded dark GTK theme we applied

# === FILE MANAGEMENT & DRIVES ===
obsidian                       # The .md note-writing tool
ntfs-3g                        # Useful for NTFS partitions
gvfs                           # Virtual filesystem for user-space (mounts drives)
gvfs-mtp                       # Allows access to data from Android phones/tablets 

# === NETWORKING & BLUETOOTH ===
networkmanager                 # The core background service for internet
bluez                          # The core Linux Bluetooth protocol
bluez-utils                    # Command line tools for Bluetooth

# === AUDIO & MEDIA ===
pipewire-pulse                 # Modern audio backend (replaces old pulseaudio)
mpv                            # High-performance minimalist video player
gthumb                         # Image viewer and media organizer

# === TERMINAL & SHELL ===
foot                           # Extremely fast, lightweight Wayland terminal emulator
zsh                            # The Z shell (replaces bash)
zsh-autosuggestions            # Ghost-text autocomplete for commands
zsh-syntax-highlighting        # Colors valid commands green and errors red
starship                       # Cross-shell customizable prompt
fastfetch                      # System info fetcher (the Arch logo in terminal)
git                            # Version control system
neovim                         # Terminal-based text editor

# === UTILITIES ===
cliphist                       # Clipboard history manager
wl-clipboard                   # Command-line clipboard utilities for Wayland
grim                           # Grabs screenshots on Wayland
slurp                          # Lets you select a specific region for grim to capture
brightnessctl                  # Controls laptop screen brightness via terminal/keys
7zip                           # High-compression file archiver
btop                           # Interactive system resource monitor
fd                             # Simple, fast, and user-friendly alternative to 'find'

# === DATA ENGINEERING ===
jq                             # Command-line JSON processor
docker                         # Containerization platform
docker-compose                 # Multi-container orchestration for Docker
lazygit                        # Simple terminal UI for git commands
lazydocker                     # Simple terminal UI for both docker and docker-compose

# === OPTIONAL / COMMENTED OUT ===
# xdg-desktop-portal-hyprland  # Handles screen sharing and file dialogs
# os-prober                    # Detects Windows for dual-booting in GRUB menu
# ttf-ubuntu-mono-nerd         # Font that contains all the icons for Waybar
# thunar                       # The main lightweight GTK file manager
# thunar-archive-plugin        # Adds "Extract Here" to Thunar right-click menu
# tumbler                      # Thumbnail service for file managers
# file-roller                  # The actual extraction backend used by the plugin
# ffmpegthumbnailer            # Allows to view images on preview pane in thunar
