#!/usr/bin/env bash
set -e

echo "[+] Step 1: Restoring JaKooLit's master hyprland.conf..."
if [ -f "$HOME/JaKooLit-Dots/config/hypr/hyprland.conf" ]; then
    cp "$HOME/JaKooLit-Dots/config/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
elif [ -f "$HOME/.config/hypr/default/hyprland.conf" ]; then
    cp "$HOME/.config/hypr/default/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
elif [ -d "$HOME/Fedora-Hyprland/config/hypr" ]; then
    cp "$HOME/Fedora-Hyprland/config/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
else
    echo "[-] JaKooLit configuration backup not found."
    exit 1
fi

echo "[+] Step 2: Ensuring UserConfigs directory structure exists..."
mkdir -p "$HOME/.config/hypr/UserConfigs"

echo "[+] Step 3: Injecting Asahi Apple Silicon hardware patches..."
cat << 'EOF' >> "$HOME/.config/hypr/UserConfigs/UserSettings.conf"

# Asahi Apple Silicon Hardware Overrides
cursor {
    no_hardware_cursors = true
}

render {
    explicit_sync = 0
}

env = WLR_NO_HARDWARE_CURSORS,1
env = GDK_BACKEND,wayland,x11
env = QT_QPA_PLATFORM,wayland;xcb
EOF

echo "[+] Step 4: Setting up launch environment..."
chmod +x "$HOME/.config/hypr/initial-boot.sh" 2>/dev/null || true

echo "[+] Setup complete!"
