#!/usr/bin/env bash
set -e

echo "[+] Nuking broken environment and initializing fresh HyDE setup..."

# 1. Nuke existing configurations and repository leftovers
rm -rf ~/.config/hypr ~/.config/rofi ~/.config/hyde ~/.local/lib/hyde ~/.local/bin ~/HyDe ~/hyde-themes

# 2. Re-create essential directory structures
mkdir -p ~/.config ~/.local/lib/hyde ~/.local/bin

# 3. Fresh recursive clone of HyDE and official hyde-themes
git clone --recursive https://github.com/HyDE-Project/HyDE.git "$HOME/HyDe"
git clone --recursive https://github.com/HyDE-Project/hyde-themes.git "$HOME/.config/hyde/themes"

# 4. Copy configurations and system binaries into place
cp -rf "$HOME/HyDe/Configs/.config/hypr" ~/.config/
cp -rf "$HOME/HyDe/Configs/.config/rofi" ~/.config/
cp -rf "$HOME/HyDe/Configs/.config/hyde" ~/.config/ 2>/dev/null || true

cp -rf "$HOME/HyDe/Scripts/"* ~/.local/lib/hyde/ 2>/dev/null || true
cp -rf "$HOME/HyDe/Source/bin/"* ~/.local/bin/ 2>/dev/null || true

# 5. Fix all execution permissions across scripts and binaries
chmod +x ~/.local/lib/hyde/*.sh 2>/dev/null || true
chmod +x ~/.local/bin/* 2>/dev/null || true

# 6. Set the active theme symlink to the first available theme folder
FIRST_THEME=$(ls -d ~/.config/hyde/themes/*/ 2>/dev/null | grep -v '\.git' | head -n 1)
if [ -n "$FIRST_THEME" ]; then
    ln -snf "$FIRST_THEME" ~/.config/hyde/active_theme
    echo "[+] Active theme linked to: $FIRST_THEME"
fi

# 7. Configure user preferences ($mainMod and Natural Touchpad Scrolling)
cat << 'EOF' > ~/.config/hypr/userprefs.conf
$mainMod = SUPER

input {
    touchpad {
        natural_scroll = true
    }
}
EOF

# 8. Create essential files expected by the compositor
touch ~/.config/hypr/hyprland.lua
touch ~/.config/hypr/theme.conf

echo "[+] Fresh install complete!"
