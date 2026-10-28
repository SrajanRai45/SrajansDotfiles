#!/usr/bin/env fish

# Wallpaper directory (respects WALLPAPERS_DIR from .env, with fallback)
set wall_dir "$HOME/Pictures/Wallpapers"
if set -q WALLPAPERS_DIR; and test -n "$WALLPAPERS_DIR"
    set wall_dir "$WALLPAPERS_DIR"
end

# Select wallpaper using fzf with a side preview panel via chafa
set selected (find "$wall_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | \
    fzf --preview 'chafa --size=60x35 {}' \
        --preview-window=right:65%:wrap \
        --prompt="Wallpaper ❯ " \
        --border=none \
        --color=16)

if test -n "$selected"
    wal -n -i "$selected"

    # pick the one you use:
    awww img "$selected" --transition-type grow --transition-pos center --transition-duration 1.5
    # or: setsid swaybg -i "$selected" -m fill &; disown
end
