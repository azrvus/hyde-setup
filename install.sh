#!/usr/bin/env bash
set -e

echo "[+] Nuking broken environment and initializing complete HyDE setup..."

# 1. Install missing runtime packages on Fedora Asahi
sudo dnf install -y hyprland-guiutils kitty 2>/dev/null || true

# 2. Nuke existing broken configurations and leftovers
rm -rf ~/.config/hypr ~/.config/rofi ~/.config/hyde ~/.local/lib/hyde ~/.local/share/hypr ~/.local/share/hyde ~/.local/bin ~/HyDe ~/hyde-themes

# 3. Create required directory structures
mkdir -p ~/.config ~/.local/lib/hyde ~/.local/share/hypr ~/.local/share/hyde ~/.local/bin

# 4. Fresh recursive clone of HyDE and official hyde-themes
git clone --recursive https://github.com/HyDE-Project/HyDE.git "$HOME/HyDe"
git clone --recursive https://github.com/HyDE-Project/hyde-themes.git "$HOME/.config/hyde/themes"

# 5. Deploy configurations and core HyDE shared backend files
cp -rf "$HOME/HyDe/Configs/.config/hypr" ~/.config/
cp -rf "$HOME/HyDe/Configs/.config/rofi" ~/.config/
cp -rf "$HOME/HyDe/Configs/.config/hyde" ~/.config/ 2>/dev/null || true

# Copy shared runtime libraries (fixes missing hyde.lua error)
cp -rf "$HOME/HyDe/Configs/.local/share/hypr/"* ~/.local/share/hypr/ 2>/dev/null || true
cp -rf "$HOME/HyDe/Configs/.local/share/hyde/"* ~/.local/share/hyde/ 2>/dev/null || true

# Copy scripts and binaries
cp -rf "$HOME/HyDe/Scripts/"* ~/.local/lib/hyde/ 2>/dev/null || true
cp -rf "$HOME/HyDe/Source/bin/"* ~/.local/bin/ 2>/dev/null || true

# 6. Fix executable permissions
chmod +x ~/.local/lib/hyde/*.sh 2>/dev/null || true
chmod +x ~/.local/bin/* 2>/dev/null || true

# 7. Set the active theme symlink
FIRST_THEME=$(ls -d ~/.config/hyde/themes/*/ 2>/dev/null | grep -v '\.git' | head -n 1)
if [ -n "$FIRST_THEME" ]; then
    ln -snf "$FIRST_THEME" ~/.config/hyde/active_theme
    echo "[+] Active theme linked to: $FIRST_THEME"
fi

# 8. Configure user preferences ($mainMod and Natural Touchpad Scrolling)
cat << 'EOF' > ~/.config/hypr/userprefs.conf
$mainMod = SUPER

input {
    touchpad {
        natural_scroll = true
    }
}
EOF

# Ensure secondary setup files exist
touch ~/.config/hypr/theme.conf

echo "[+] HyDE deployment completed successfully!"
