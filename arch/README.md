# Arch Install

## Option 1: Custom Boo ISO (Recommended)

Build a custom installer ISO that automates everything.

### Build the ISO

On an existing Arch system:

```
cd ~/code/boo/arch/iso
./build.sh
```

This creates `arch/iso/out/boo-arch-*.iso`.

### Flash to USB

Use [Balena Etcher](https://etcher.balena.io/#download-etcher) or:

```
sudo dd if=arch/iso/out/boo-arch-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### Install

1. Boot from USB (F12 on Framework)
2. Follow the TUI wizard - enter WiFi, encryption password, hostname, timezone, username
3. Wait for installation to complete
4. Remove USB and reboot into Hyprland

---

## Option 2: Manual Install

### 1. Create bootable USB

[Download Arch ISO](https://archlinux.org/download/)

[Download Balena Etcher](https://etcher.balena.io/#download-etcher)

Flash the ISO to USB with Balena Etcher.

### 2. Boot from USB

Plug USB into Framework laptop and boot while spamming F12. Select "Arch Linux install medium".

### 3. Connect to WiFi

```
iwctl --passphrase "PASSWORD" station wlan0 connect "NETWORK_NAME"
```

### 4. Run archinstall

```
archinstall
```

Settings:
- Mirrors → United States
- Disk Configuration → Use best-effort → Select SSD → ext4 → No separate /home
- Disk Encryption → LUKS (set password)
- Hostname → Name your machine
- Root Password → Set one
- User Account → Create user with sudo
- Profile → Minimal
- Timezone → Your timezone
- Network Configuration → NetworkManager (default backend)

Install and reboot.

### 5. First boot

Sign in (ignore Framework USB-C errors).

Double the font size:
```
setfont -d
```

Connect to WiFi:
```
nmtui
```

### 6. Clone and install

```
sudo pacman -S git
git clone https://github.com/pachun/boo ~/code/boo
cd ~/code/boo
./install.sh
```

### 7. Set up GitHub SSH keys

```
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

Add the public key to GitHub: https://github.com/settings/ssh/new

Switch repo to SSH:
```
cd ~/code/boo
git remote set-url origin git@github.com:pachun/boo.git
```

---

## Hyprland Keybindings

- Super + Enter → Terminal (Ghostty)
- Super + B → Browser (Chromium)
- Super + Q → Close window
- Super + M → Exit Hyprland
