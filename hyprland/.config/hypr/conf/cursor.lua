-- Cursor configuration
-- Theme: Breeze (installed system-wide)
-- Using environment variables (works across all Hyprland versions)
-- The cursor{} config block is not supported in this version

hl.env("XCURSOR_THEME", "Breeze")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Breeze")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_CURSOR_THEME", "Breeze")
hl.env("QT_QPA_CURSOR_THEME", "Breeze")

-- For no_hardware_cursors, use hyprctl at runtime if needed:
-- hyprctl keyword cursor:no_hardware_cursors false