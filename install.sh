#!/usr/bin/env bash
set -e

echo "[+] Step 1: Installing all required Fedora native packages..."
sudo dnf install -y \
    hyprland \
    hyprland-guiutils \
    kitty \
    rofi-wayland \
    waybar \
    dunst \
    swww \
    grim \
    slurp \
    wl-clipboard \
    polkit-gnome \
    qt5-qtwayland \
    qt6-qtwayland \
    pamixer \
    brightnessctl \
    playerctl \
    ImageMagick \
    jq \
    libnotify 2>/dev/null || true

echo "[+] Step 2: Purging old user configurations..."
rm -rf ~/.config/hypr ~/.config/rofi ~/.config/hyde ~/.config/waybar ~/.config/dunst
rm -rf ~/.local/share/hypr ~/.local/share/hyde ~/.local/lib/hyde ~/.local/bin/hyde*
rm -rf ~/.cache/hyde ~/HyDe ~/hyde-themes

echo "[+] Step 3: Rebuilding XDG directories..."
mkdir -p ~/.config/hypr ~/.config/rofi ~/.config/hyde ~/.local/lib/hyde ~/.local/share/hypr ~/.local/share/hyde ~/.local/bin

echo "[+] Step 4: Cloning HyDE and hyde-themes..."
git clone --recursive https://github.com/HyDE-Project/HyDE.git "$HOME/HyDe"
git clone --recursive https://github.com/HyDE-Project/hyde-themes.git "$HOME/.config/hyde/themes"

echo "[+] Step 5: Manually deploying HyDE configurations & libraries..."
cp -rf "$HOME/HyDe/Configs/.config/hypr/"* ~/.config/hypr/
cp -rf "$HOME/HyDe/Configs/.config/rofi/"* ~/.config/rofi/ 2>/dev/null || true
cp -rf "$HOME/HyDe/Configs/.config/hyde/"* ~/.config/hyde/ 2>/dev/null || true

cp -rf "$HOME/HyDe/Configs/.local/share/hypr/"* ~/.local/share/hypr/ 2>/dev/null || true
cp -rf "$HOME/HyDe/Configs/.local/share/hyde/"* ~/.local/share/hyde/ 2>/dev/null || true

cp -rf "$HOME/HyDe/Scripts/"* ~/.local/lib/hyde/ 2>/dev/null || true
cp -rf "$HOME/HyDe/Source/bin/"* ~/.local/bin/ 2>/dev/null || true

chmod +x ~/.local/lib/hyde/*.sh 2>/dev/null || true
chmod +x ~/.local/bin/* 2>/dev/null || true

echo "[+] Step 6: Linking active theme..."
FIRST_THEME=$(ls -d ~/.config/hyde/themes/*/ 2>/dev/null | grep -v '\.git' | head -n 1)
if [ -n "$FIRST_THEME" ]; then
    ln -snf "$FIRST_THEME" ~/.config/hyde/active_theme
fi

echo "[+] Step 7: Applying Apple Silicon GPU patches & keybindings..."
cat << 'EOF' > ~/.config/hypr/userprefs.conf
$mainMod = SUPER

input {
    touchpad {
        natural_scroll = true
    }
}

cursor {
    no_hardware_cursors = true
}

render {
    explicit_sync = 0
}
EOF

touch ~/.config/hypr/theme.conf

echo "[+] Manual HyDE deployment for Fedora completed!"
