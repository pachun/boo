#!/bin/bash
# Boo Arch Installer - TUI wizard for automated Arch installation

set -e

# Colors for non-dialog output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Variables to collect
WIFI_SSID=""
WIFI_PASS=""
LUKS_PASS=""
HOSTNAME=""
TIMEZONE=""
USERNAME=""
USER_PASS=""
GIT_NAME=""
GIT_EMAIL=""
TARGET_DISK=""

# Find the main disk (usually nvme or sda)
detect_disk() {
    # Prefer NVMe, fall back to sda
    if [[ -b /dev/nvme0n1 ]]; then
        echo "/dev/nvme0n1"
    elif [[ -b /dev/sda ]]; then
        echo "/dev/sda"
    else
        echo ""
    fi
}

# Welcome screen
welcome() {
    dialog --title "Boo Arch Installer" --msgbox "\nWelcome to the Boo Arch Installer!\n\nThis will install Arch Linux with:\n- LUKS disk encryption\n- Hyprland desktop\n- Your custom dotfiles\n\nPress OK to continue." 14 50
}

# WiFi configuration
configure_wifi() {
    # Scan for networks
    dialog --title "WiFi Setup" --infobox "Scanning for WiFi networks..." 3 40
    iwctl station wlan0 scan
    sleep 3

    # Get list of networks
    NETWORKS=$(iwctl station wlan0 get-networks | tail -n +5 | head -n -1 | awk '{print $1}' | grep -v '^$' | head -10)

    if [[ -z "$NETWORKS" ]]; then
        # Fallback to manual entry if no networks found
        WIFI_SSID=$(dialog --title "WiFi Setup" --inputbox "No networks found. Enter WiFi network name (SSID):" 8 50 3>&1 1>&2 2>&3)
    else
        # Build menu options
        MENU_OPTIONS=()
        while IFS= read -r network; do
            MENU_OPTIONS+=("$network" "")
        done <<< "$NETWORKS"
        MENU_OPTIONS+=("Other" "Enter manually")

        WIFI_SSID=$(dialog --title "WiFi Setup" --menu "Select WiFi network:" 18 50 10 "${MENU_OPTIONS[@]}" 3>&1 1>&2 2>&3)

        if [[ "$WIFI_SSID" == "Other" ]]; then
            WIFI_SSID=$(dialog --title "WiFi Setup" --inputbox "Enter WiFi network name (SSID):" 8 50 3>&1 1>&2 2>&3)
        fi
    fi

    [[ -z "$WIFI_SSID" ]] && exit 1

    WIFI_PASS=$(dialog --title "WiFi Setup" --insecure --passwordbox "Enter WiFi password for '$WIFI_SSID':" 8 50 3>&1 1>&2 2>&3)
    [[ -z "$WIFI_PASS" ]] && exit 1
}

# Disk encryption password
configure_luks() {
    while true; do
        LUKS_PASS=$(dialog --title "Disk Encryption" --insecure --passwordbox "Enter disk encryption password:" 8 50 3>&1 1>&2 2>&3)
        [[ -z "$LUKS_PASS" ]] && exit 1

        LUKS_PASS_CONFIRM=$(dialog --title "Disk Encryption" --insecure --passwordbox "Confirm disk encryption password:" 8 50 3>&1 1>&2 2>&3)

        if [[ "$LUKS_PASS" == "$LUKS_PASS_CONFIRM" ]]; then
            break
        else
            dialog --title "Error" --msgbox "Passwords do not match. Try again." 6 40
        fi
    done
}

# Hostname
configure_hostname() {
    HOSTNAME=$(dialog --title "Hostname" --inputbox "Enter hostname for this machine:" 8 50 "archbox" 3>&1 1>&2 2>&3)
    [[ -z "$HOSTNAME" ]] && exit 1
}

# Timezone
configure_timezone() {
    # Common US timezones for simplicity
    TIMEZONE=$(dialog --title "Timezone" --menu "Select your timezone:" 15 50 8 \
        "America/New_York" "Eastern" \
        "America/Chicago" "Central" \
        "America/Denver" "Mountain" \
        "America/Los_Angeles" "Pacific" \
        "America/Anchorage" "Alaska" \
        "Pacific/Honolulu" "Hawaii" \
        "UTC" "UTC" \
        3>&1 1>&2 2>&3)
    [[ -z "$TIMEZONE" ]] && exit 1
}

# User account
configure_user() {
    USERNAME=$(dialog --title "User Account" --inputbox "Enter username:" 8 50 3>&1 1>&2 2>&3)
    [[ -z "$USERNAME" ]] && exit 1

    while true; do
        USER_PASS=$(dialog --title "User Account" --insecure --passwordbox "Enter password for $USERNAME:" 8 50 3>&1 1>&2 2>&3)
        [[ -z "$USER_PASS" ]] && exit 1

        USER_PASS_CONFIRM=$(dialog --title "User Account" --insecure --passwordbox "Confirm password:" 8 50 3>&1 1>&2 2>&3)

        if [[ "$USER_PASS" == "$USER_PASS_CONFIRM" ]]; then
            break
        else
            dialog --title "Error" --msgbox "Passwords do not match. Try again." 6 40
        fi
    done
}

# Git configuration
configure_git() {
    GIT_NAME=$(dialog --title "Git Setup" --inputbox "Enter your name for git commits:" 8 50 3>&1 1>&2 2>&3)
    [[ -z "$GIT_NAME" ]] && exit 1

    GIT_EMAIL=$(dialog --title "Git Setup" --inputbox "Enter your email for git commits:" 8 50 3>&1 1>&2 2>&3)
    [[ -z "$GIT_EMAIL" ]] && exit 1
}

# Confirm settings
confirm_settings() {
    TARGET_DISK=$(detect_disk)

    if [[ -z "$TARGET_DISK" ]]; then
        dialog --title "Error" --msgbox "No suitable disk found!" 6 40
        exit 1
    fi

    dialog --title "Confirm Installation" --yesno "\nReady to install with these settings:\n\n\
WiFi: $WIFI_SSID\n\
Hostname: $HOSTNAME\n\
Timezone: $TIMEZONE\n\
Username: $USERNAME\n\
Git: $GIT_NAME <$GIT_EMAIL>\n\
Target Disk: $TARGET_DISK\n\n\
WARNING: This will ERASE $TARGET_DISK!\n\n\
Continue?" 20 50
}

# Connect to WiFi
connect_wifi() {
    echo -e "${GREEN}Connecting to WiFi...${NC}"
    iwctl --passphrase "$WIFI_PASS" station wlan0 connect "$WIFI_SSID"
    sleep 3

    # Verify connection
    if ! ping -c 1 archlinux.org &>/dev/null; then
        echo -e "${RED}WiFi connection failed!${NC}"
        exit 1
    fi
    echo -e "${GREEN}Connected!${NC}"
}

# Partition and encrypt disk
setup_disk() {
    echo -e "${GREEN}Setting up disk...${NC}"

    # Determine partition suffix (nvme uses p1, sda uses 1)
    if [[ "$TARGET_DISK" == *"nvme"* ]]; then
        PART_BOOT="${TARGET_DISK}p1"
        PART_ROOT="${TARGET_DISK}p2"
    else
        PART_BOOT="${TARGET_DISK}1"
        PART_ROOT="${TARGET_DISK}2"
    fi

    # Wipe and partition
    wipefs -af "$TARGET_DISK"
    parted -s "$TARGET_DISK" mklabel gpt
    parted -s "$TARGET_DISK" mkpart ESP fat32 1MiB 1GiB
    parted -s "$TARGET_DISK" set 1 esp on
    parted -s "$TARGET_DISK" mkpart primary 1GiB 100%

    # Format boot partition
    mkfs.fat -F32 "$PART_BOOT"

    # Setup LUKS encryption
    echo -n "$LUKS_PASS" | cryptsetup luksFormat "$PART_ROOT" -
    echo -n "$LUKS_PASS" | cryptsetup open "$PART_ROOT" cryptroot -

    # Format root partition
    mkfs.ext4 /dev/mapper/cryptroot

    # Mount
    mount /dev/mapper/cryptroot /mnt
    mkdir -p /mnt/boot
    mount "$PART_BOOT" /mnt/boot

    echo -e "${GREEN}Disk setup complete!${NC}"
}

# Install base system
install_base() {
    echo -e "${GREEN}Installing base system...${NC}"

    pacstrap -K /mnt base linux linux-firmware networkmanager sudo neovim git

    # Generate fstab
    genfstab -U /mnt >> /mnt/etc/fstab

    echo -e "${GREEN}Base system installed!${NC}"
}

# Configure the installed system
configure_system() {
    echo -e "${GREEN}Configuring system...${NC}"

    # Get the UUID of the LUKS partition
    LUKS_UUID=$(blkid -s UUID -o value "$PART_ROOT")

    arch-chroot /mnt /bin/bash <<CHROOT
# Timezone
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
echo "$HOSTNAME" > /etc/hostname

# Hosts
cat > /etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
EOF

# mkinitcpio - add encrypt hook
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Bootloader (systemd-boot)
bootctl install

cat > /boot/loader/loader.conf <<EOF
default arch.conf
timeout 0
editor no
EOF

cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options cryptdevice=UUID=$LUKS_UUID:cryptroot root=/dev/mapper/cryptroot rw quiet loglevel=0
EOF

# Create user
useradd -m -G wheel -s /bin/zsh "$USERNAME" || useradd -m -G wheel "$USERNAME"
echo "$USERNAME:$USER_PASS" | chpasswd

# Sudo access
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

# Enable NetworkManager
systemctl enable NetworkManager
CHROOT

    echo -e "${GREEN}System configured!${NC}"
}

# Clone boo and run install script
install_boo() {
    echo -e "${GREEN}Installing boo dotfiles...${NC}"

    arch-chroot /mnt /bin/bash <<CHROOT
su - $USERNAME <<USERCHROOT
mkdir -p ~/code
git clone https://github.com/pachun/boo ~/code/boo

# Create gitconfig before running install.sh to avoid interactive prompt
cat > ~/code/boo/dotfiles/gitconfig <<EOF
[user]
  name = $GIT_NAME
  email = $GIT_EMAIL

[init]
  defaultBranch = main

[format]
  pretty = format:%C(yellow)%h%C(green)%d%Creset %C(blue)%s %C(magenta) [%an, %cr]%Creset

[core]
  editor = nvim
  excludesFile = ~/.gitignore
EOF

cd ~/code/boo
./install.sh
USERCHROOT
CHROOT

    echo -e "${GREEN}Boo installed!${NC}"
}

# Finish up
finish() {
    umount -R /mnt

    dialog --title "Installation Complete" --msgbox "\nInstallation complete!\n\nThe system will now reboot.\n\nRemove the USB drive when prompted." 12 50

    reboot
}

# Main flow
main() {
    clear
    welcome
    configure_wifi
    configure_luks
    configure_hostname
    configure_timezone
    configure_user
    configure_git
    confirm_settings

    # Exit dialog mode for installation output
    clear

    connect_wifi
    setup_disk
    install_base
    configure_system
    install_boo
    finish
}

main "$@"
