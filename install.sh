#!/usr/bin/env bash
set -e

echo "[+] Repairing HyDE & Hyprland environment..."

# 1. Clean broken configurations
rm -rf ~/.config/hypr ~/.config/rofi ~/.config/hyde

# 2. Re-create base directories
mkdir -p ~/.config/hypr ~/.config/rofi ~/.config/hyde/themes ~/.local/lib/hyde ~/.local/bin

# 3. Clone official HyDE dotfiles & theme submodules
if [ ! -d "$HOME/HyDe" ]; then
    git clone --recursive https://github.com/HyDE-Project/HyDE.git "$HOME/HyDe"
else
    cd "$HOME/HyDe" && git pull && git submodule update --init --recursive
fi

# 4. Copy required script libraries and configurations
cp -rf "$HOME/HyDe/Configs/.config/hypr/"* ~/.config/hypr/ 2>/dev/null || true
cp -rf "$HOME/HyDe/Configs/.config/rofi/"* ~/.config/rofi/ 2>/dev/null || true
cp -rf "$HOME/HyDe/Scripts/"* ~/.local/lib/hyde/ 2>/dev/null || true
cp -rf "$HOME/HyDe/Source/bin/"* ~/.local/bin/ 2>/dev/null || true

# Fix execution permissions
chmod +x ~/.local/lib/hyde/*.sh 2>/dev/null || true
chmod +x ~/.local/bin/* 2>/dev/null || true

# 5. Populate default HyDE Themes
if [ ! -d "$HOME/.config/hyde/themes" ] || [ -z "$(ls -A $HOME/.config/hyde/themes)" ]; then
    git clone --recursive https://github.com/HyDE-Project/hyde-themes.git ~/.config/hyde/themes
fi

# 6. Apply Mac-style Natural Touchpad Scroll
cat << 'EOF' >> ~/.config/hypr/userprefs.conf

input {
    touchpad {
        natural_scroll = true
    }
}
EOF

# 7. Create placeholder files expected by Hyprland
touch ~/.config/hypr/hyprland.lua
touch ~/.config/hypr/theme.conf
touch ~/.config/rofi/selector.rasi

echo "[+] Setup complete! Reboot or launch hyde-shell reload."
