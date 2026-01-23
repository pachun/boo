# Arch Install

## 1. Create bootable USB

[Download Arch ISO](https://archlinux.org/download/)

[Download Balena Etcher](https://etcher.balena.io/#download-etcher)

Flash the ISO to USB with Balena Etcher.

## 2. Boot from USB

Plug USB into Framework laptop and boot while spamming F12. Select "Arch Linux install medium".

## 3. Connect to WiFi

```
iwctl --passphrase "PASSWORD" station wlan0 connect "NETWORK_NAME"
```

## 4. Run archinstall

```
archinstall
```

Settings:

- Mirrors → United States
- Disk Configuration → Use best-effort → Select SSD → ext4 → No separate /home
- Disk Encryption → LUKS (set password and partition or it won't apply)
- Hostname → Name your machine
- Root Password → Set one
- User Account → Create user with sudo
- Profile → Minimal
- Timezone → Your timezone
- Network Configuration → NetworkManager (default backend)

Install and reboot.

## 5. First boot

Sign in (ignore Framework USB-C errors).

Double the font size:

```
setfont -d
```

Connect to WiFi:

```
nmtui
```

## 6. Clone and install

```
sudo pacman -S git
git clone https://github.com/pachun/boo ~/code/boo
cd ~/code/boo
./install.sh
```

## 7. Add SSH key to GitHub

```
cat ~/.ssh/id_ed25519.pub
```

Copy the output and [add it to GitHub](https://github.com/settings/ssh/new).

Switch the repo to SSH:

```
cd ~/code/boo
git remote set-url origin git@github.com:pachun/boo.git
```

## Hyprland keybindings

- Super + Enter → Terminal (Ghostty)
- Super + b → Browser (Chromium)
- Super + q → Close window
- Super + m → Exit Hyprland
- Super + c → Copy
- Super + v → Paste
- Super + a → Select all
- Super + { → Select browser tab to the left
- Super + } → Select browser tab to the right
- Super + tab → Switch to next hyprland window
- Super + ` (grave) → Switch to previous hyprland window
