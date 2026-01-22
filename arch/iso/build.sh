#!/bin/bash
# Build the Boo Arch installer ISO
# Requires: archiso package

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="/tmp/boo-archiso"
OUT_DIR="$SCRIPT_DIR/out"

# Check for archiso
if ! pacman -Qi archiso &>/dev/null; then
    echo "Installing archiso..."
    sudo pacman -S --needed --noconfirm archiso
fi

# Clean previous builds (needs sudo since mkarchiso creates root-owned files)
sudo rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR" "$OUT_DIR"

# Copy the releng profile as our base
cp -r /usr/share/archiso/configs/releng/* "$WORK_DIR/"

# Add dialog to packages (for TUI)
echo "dialog" >> "$WORK_DIR/packages.x86_64"

# Copy our installer script
mkdir -p "$WORK_DIR/airootfs/root"
cp "$SCRIPT_DIR/installer.sh" "$WORK_DIR/airootfs/root/installer.sh"
chmod +x "$WORK_DIR/airootfs/root/installer.sh"

# Create auto-start script that runs on login
mkdir -p "$WORK_DIR/airootfs/etc/profile.d"
cat > "$WORK_DIR/airootfs/etc/profile.d/boo-installer.sh" <<'EOF'
# Auto-start the Boo installer on root login
if [[ $(tty) == "/dev/tty1" ]] && [[ $EUID -eq 0 ]]; then
    /root/installer.sh
fi
EOF

# Auto-login root on tty1
mkdir -p "$WORK_DIR/airootfs/etc/systemd/system/getty@tty1.service.d"
cat > "$WORK_DIR/airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf" <<'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --noclear %I 38400 linux
EOF

# Set ISO label and name
sed -i 's/iso_name="archlinux"/iso_name="boo-arch"/' "$WORK_DIR/profiledef.sh"
sed -i 's/iso_label="ARCH_[0-9]*/iso_label="BOO_ARCH/' "$WORK_DIR/profiledef.sh"

# Build the ISO
echo "Building ISO..."
sudo mkarchiso -v -w "$WORK_DIR/work" -o "$OUT_DIR" "$WORK_DIR"

# Clean up work directory
sudo rm -rf "$WORK_DIR"

echo ""
echo "ISO built successfully!"
echo "Output: $OUT_DIR"
ls -lh "$OUT_DIR"/*.iso
