-- Autostart configuration
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- hl.on("hyprland.start", function ()
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

-- Per-window CapsLock manager (requires ydotool + ydotoold)
hl.on("hyprland.start", function()
	hl.exec_cmd("~/.config/hypr/scripts/capslock-per-window.sh &")
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor Breeze 24")
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("hypridle")
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon &")
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("qs -c ~/.config/quickshell")
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("wal -R")
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("batteryNotify")
end)

--[[hl.on("hyprland.start", function()
	hl.exec_cmd("swaync")
end)]]
--
