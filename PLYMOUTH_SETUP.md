# Plymouth Setup for Arch with LUKS Encryption

## Overview

Plymouth provides a graphical boot splash with a password prompt for LUKS disk encryption. To get proper visual feedback (dots when typing), you need **systemd-based mkinitcpio hooks** instead of the default busybox-based hooks.

## What the install script does

### 1. Installs plymouth from official repos
```bash
sudo pacman -S --needed plymouth
```

### 2. Converts mkinitcpio.conf to systemd hooks

**From (busybox-based):**
```
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
```

**To (systemd-based with plymouth):**
```
HOOKS=(base systemd plymouth autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)
```

Key changes:
- `udev` → `systemd plymouth` (systemd hook + plymouth for splash)
- `keymap consolefont` → `sd-vconsole` (systemd console config)
- `encrypt` → `sd-encrypt` (systemd encryption, integrates with plymouth)

### 3. Converts bootloader kernel parameters

**From:**
```
cryptdevice=PARTUUID=<partuuid>:root
```

**To:**
```
rd.luks.name=<luks-uuid>=root
```

Note: `sd-encrypt` uses LUKS UUID (not PARTUUID). The script auto-detects this.

### 4. Adds kernel parameters and sets theme
```bash
# Add quiet splash to boot options
# Set spinner theme and rebuild initramfs
sudo plymouth-set-default-theme -R spinner
```

## Recovery

### If boot fails

1. At boot menu, press `e` to edit boot entry
2. Remove `quiet splash` from options line to see boot messages
3. Boot and fix

### From a live USB

```bash
# Mount encrypted root
cryptsetup open /dev/nvme0n1p2 root  # adjust device as needed
mount /dev/mapper/root /mnt
mount /dev/nvme0n1p1 /mnt/boot  # EFI partition

# Chroot
arch-chroot /mnt

# Option 1: Revert to busybox hooks (no plymouth)
# Edit /etc/mkinitcpio.conf and restore:
# HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)

# Edit bootloader entry and restore:
# cryptdevice=PARTUUID=<your-partuuid>:root

# Rebuild
mkinitcpio -P

exit
umount -R /mnt
reboot
```

## Troubleshooting

### No dots when typing password
You're using busybox hooks (`encrypt`) instead of systemd hooks (`sd-encrypt`). The graphical password prompt only works properly with systemd hooks.

### Password prompt not appearing
Check that `plymouth` hook is after `systemd` and before `sd-encrypt` in HOOKS.

### Theme not showing / blank screen
Ensure `kms` hook is present to load graphics drivers early.

### Password box not appearing (custom theme)
The `script` module's programmatic image creation (`Image.SetPixel`) is unreliable. Use the `two-step` module instead, which has built-in password dialog support. Copy dialog images from spinner theme: `bullet.png`, `entry.png`, `lock.png`, `capslock.png`, `keyboard.png`.

### Slow boot / delay before password prompt
Edit `/etc/plymouth/plymouthd.conf` and reduce `DeviceTimeout` from 8 to 2 seconds.

## References
- [Arch Wiki - Plymouth](https://wiki.archlinux.org/title/Plymouth)
- [Arch Wiki - dm-crypt/System configuration](https://wiki.archlinux.org/title/Dm-crypt/System_configuration)
- [Graphical password prompt for disk decryption](https://srijan.ch/graphical-password-prompt-for-disk-decryption)
