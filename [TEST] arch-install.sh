#!/bin/bash
set -e

# ── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

section() {
  echo -e "\n${BLUE}${BOLD}┌─ $1${NC}"
  echo -e "${BLUE}${BOLD}└$(printf '─%.0s' $(seq 1 $((${#1} + 2))))${NC}"
}
ok() { echo -e "  ${GREEN}✓${NC}  $1"; }
warn() { echo -e "  ${YELLOW}⚠${NC}   $1"; }
ask() { echo -ne "  ${BOLD}→ $1: ${NC}"; }

# ════════════════════════════════════════════════════════════════════════════
#  CONFIGURATION — all prompts upfront, nothing asked mid-install
# ════════════════════════════════════════════════════════════════════════════
clear
echo -e "${BOLD}"
echo "  ╔══════════════════════════════════╗"
echo "  ║   Arch Linux Install Script      ║"
echo "  ╚══════════════════════════════════╝"
echo -e "${NC}"

section "Drive"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
echo ""
ask "Install drive (e.g. sda, nvme0n1)"
read DRIVE
ask "Swap size (e.g. 8G)"
read SWAP_SIZE

section "Wi-Fi"
ip link show | grep -E '^[0-9]+: w' | awk -F': ' '{print "  "$2}'
ask "WiFi device (e.g. wlan0)"
read WIFI_DEV
ask "WiFi SSID"
read WIFI_SSID
ask "WiFi password"
read -s WIFI_PASS
echo ""

section "User"
ask "Root password"
read -s ROOT_PASS
echo ""
ask "User (kuro) password"
read -s USER_PASS
echo ""

section "Home folder"
ask "Copy home from USB? (y/n)"
read COPY_HOME
if [[ "$COPY_HOME" == "y" ]]; then
  echo ""
  lsblk -o NAME,SIZE,TYPE,LABEL
  echo ""
  ask "Data USB partition (e.g. sdb1)"
  read USB_PART
fi

# ── Confirmation ─────────────────────────────────────────────────────────────
echo ""
echo -e "  ${RED}${BOLD}WARNING: /dev/$DRIVE will be wiped completely.${NC}"
warn "Press Enter to start, or Ctrl+C to abort."
read

# ════════════════════════════════════════════════════════════════════════════
#  1. FONT
# ════════════════════════════════════════════════════════════════════════════
section "1. Setting font"
setfont -d
ok "Font doubled for HiDPI"

# ════════════════════════════════════════════════════════════════════════════
#  2. WI-FI
# ════════════════════════════════════════════════════════════════════════════
section "2. Connecting to Wi-Fi"
iwctl --passphrase "$WIFI_PASS" station "$WIFI_DEV" connect "$WIFI_SSID"
sleep 3
ping -c 3 google.com >/dev/null
ok "Connected to $WIFI_SSID"

# ════════════════════════════════════════════════════════════════════════════
#  3. PARTITION
# ════════════════════════════════════════════════════════════════════════════
section "3. Partitioning /dev/$DRIVE"
sgdisk -Z /dev/$DRIVE
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI" /dev/$DRIVE
sgdisk -n 2:0:+$SWAP_SIZE -t 2:8200 -c 2:"swap" /dev/$DRIVE
sgdisk -n 3:0:0 -t 3:8300 -c 3:"root" /dev/$DRIVE
partprobe /dev/$DRIVE
sleep 1
ok "Partitioned"

# Detect partition suffix — nvme uses p1, sda uses 1
if [[ $DRIVE == nvme* ]]; then
  PART_PREFIX="${DRIVE}p"
else
  PART_PREFIX="${DRIVE}"
fi
EFI="/dev/${PART_PREFIX}1"
SWAP="/dev/${PART_PREFIX}2"
ROOT="/dev/${PART_PREFIX}3"

# ════════════════════════════════════════════════════════════════════════════
#  4. FORMAT & MOUNT
# ════════════════════════════════════════════════════════════════════════════
section "4. Formatting & Mounting"
mkfs.fat -F32 "$EFI"
mkswap "$SWAP" && swapon "$SWAP"
mkfs.btrfs -f "$ROOT"
mount "$ROOT" /mnt
mkdir -p /mnt/boot/efi
mount "$EFI" /mnt/boot/efi
ok "Formatted and mounted"

# ════════════════════════════════════════════════════════════════════════════
#  5. COPY HOME FROM USB
# ════════════════════════════════════════════════════════════════════════════
if [[ "$COPY_HOME" == "y" ]]; then
  section "5. Copying home folder from USB"
  mkdir /usb
  mount /dev/$USB_PART /usb
  mkdir -p /mnt/home/kuro
  cp -r /usb/archlinux/home/. /mnt/home/kuro/
  umount /usb
  rmdir /usb
  ok "Home folder copied"
fi

# ════════════════════════════════════════════════════════════════════════════
#  6. PACSTRAP
# ════════════════════════════════════════════════════════════════════════════
section "6. Installing base system"
pacstrap /mnt base base-devel linux linux-firmware grub efibootmgr pacman-contrib git zram-generator networkmanager bluez bluez-utils hyprland hypridle hyprlock hyprpicker lxqt-policykit waybar rofi awww swaync nwg-look orchis-theme pipewire-pulse mpv gthumb yazi udiskie foot neovim zsh zsh-autosuggestions zsh-syntax-highlighting starship fastfetch obsidian ntfs-3g gvfs gvfs-mtp cliphist wl-clipboard grim slurp brightnessctl 7zip btop fd jq docker docker-compose lazygit lazydocker
ok "Base system installed"

# ════════════════════════════════════════════════════════════════════════════
#  7. FSTAB
# ════════════════════════════════════════════════════════════════════════════
section "7. Generating fstab"
genfstab -U /mnt >>/mnt/etc/fstab
ok "fstab generated"

# ════════════════════════════════════════════════════════════════════════════
#  8. CHROOT — timezone, locale, users, services, paru, AUR, GRUB
#  Note: heredoc is unquoted so $ROOT_PASS and $USER_PASS expand from here
# ════════════════════════════════════════════════════════════════════════════
section "8. Configuring system (chroot)"
arch-chroot /mnt /bin/bash <<CHROOT

set -e

# ── Timezone ────────────────────────────────────────────
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

# ── Locale ──────────────────────────────────────────────
sed -i 's/^#en_IN.UTF-8 UTF-8/en_IN.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_IN.UTF-8" > /etc/locale.conf

# ── Hostname ────────────────────────────────────────────
echo 'arch' > /etc/hostname

# ── Passwords ───────────────────────────────────────────
echo "root:${ROOT_PASS}" | chpasswd

# ── User ────────────────────────────────────────────────
useradd -m -G wheel -s /usr/bin/zsh kuro
echo "kuro:${USER_PASS}" | chpasswd
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# ── Fix home ownership ──────────────────────────────────
chown -R kuro:kuro /home/kuro

# ── Services ────────────────────────────────────────────
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable docker

# ── Paru + AUR packages (must run as kuro) ──────────────
su - kuro -c "
    set -e
    git clone https://aur.archlinux.org/paru.git ~/paru
    cd ~/paru
    makepkg -si --noconfirm
    paru -S --needed --noconfirm helium-browser-bin mpv-uosc-git localsend-bin overskride-bin
"

# ── GRUB ────────────────────────────────────────────────
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

CHROOT

ok "System fully configured"

# ════════════════════════════════════════════════════════════════════════════
#  9. DONE
# ════════════════════════════════════════════════════════════════════════════
echo ""
echo -e "  ${GREEN}${BOLD}╔══════════════════════════════════╗${NC}"
echo -e "  ${GREEN}${BOLD}║   Installation complete!         ║${NC}"
echo -e "  ${GREEN}${BOLD}╚══════════════════════════════════╝${NC}"
echo ""
warn "Remove all USB drives, then press Enter to reboot."
read
umount -R /mnt
reboot
