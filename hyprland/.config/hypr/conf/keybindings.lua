-- Keybindings configuration
-- See https://wiki.hypr.land/Configuring/Basics/Binds/
-- Combines current config with mylinuxforwork/dotfiles keybindings

local vars = require("conf.variables")
local mainMod = vars.mainMod
local terminal = vars.terminal
local fileManager = vars.fileManager
local menu = vars.menu
local browser = vars.browser
local ipc = vars.ipc
local clipBoard = vars.clipBoard
local ss = vars.ss
local ssSlurp = vars.ssSlurp
local openOrbit = vars.openOrbit
local closeOrbit = vars.closeOrbit
local themeSwitcher = vars.themeSwitcher

-- ============================================================
-- MAIN KEYBINDS
-- ============================================================

-- Window/Session actions
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(openOrbit), { description = "open orbit" })
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(closeOrbit), { description = "close orbit" })
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal), { description = "Open terminal" })
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"),
	{ description = "Exit Hyprland" }
)
hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"), { description = "Open application launcher" })
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"), { description = "Open settings" })
hl.bind(
	mainMod .. " + S",
	hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"),
	{ description = "Open noctalia control center" }
)
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(themeSwitcher), { description = "Open theme switcher" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "Open file manager" })
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipBoard), { description = "Open clipboard manager" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu), { description = "Open application launcher" })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser), { description = "Open browser" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Toggle pseudo tiling" })
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle split" }) -- dwindle only
hl.bind("Print", hl.dsp.exec_cmd(ss), { description = "screenshot fullscreen" })
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(ssSlurp), { description = "Take a screenshot that can be cropped" })
hl.bind(
	mainMod .. " + N",
	hl.dsp.exec_cmd("qs -c ~/.config/quickshell/ ipc call notifications toggle"),
	{ description = "open notification center and close it" }
)
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty nvim"), { description = "open neovim" })

-- Additional window actions
hl.bind(
	mainMod .. " + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
	{ description = "Toggle fullscreen" }
)
hl.bind(
	mainMod .. " + SHIFT + F",
	hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
	{ description = "Toggle maximize" }
)
hl.bind(
	mainMod .. " + SHIFT + Q",
	hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"),
	{ description = "Force kill window" }
)
hl.bind(mainMod .. " + ALT + T", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.pin())
end, { description = "Toggle floating + pinned" })
hl.bind(mainMod .. " + K", hl.dsp.layout("swapsplit"), { description = "Swap split" })
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { description = "Toggle window group" })

-- Window swapping
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "l" }), { description = "Swap window left" })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "r" }), { description = "Swap window right" })
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "u" }), { description = "Swap window up" })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "d" }), { description = "Swap window down" })

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Move focus left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Move focus up" })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Move focus down" })

-- Switch workspaces with mainMod + [0-9]
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Focus workspace " .. i })
	hl.bind(
		mainMod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move window to workspace " .. i }
	)
end

-- Move window to workspace silently
for i = 1, 10 do
	local key = i % 10
	hl.bind(
		mainMod .. " + ALT + " .. key,
		hl.dsp.window.move({ workspace = i, silent = true }),
		{ description = "Move window to workspace " .. i .. " silently" }
	)
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"), { description = "Toggle scratchpad" })
hl.bind(mainMod .. " + SHIFT + S", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
end, { description = "Move window to scratchpad" })

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })

-- Move/Resize windows with mainMod + LMB/RMB
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window with mouse" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with mouse" })

-- Super +/- window resizing
hl.bind(
	mainMod .. " + equal",
	hl.dsp.window.resize({ x = 50, y = 50, relative = true }),
	{ repeating = true, description = "Increase window size" }
)
hl.bind(
	mainMod .. " + minus",
	hl.dsp.window.resize({ x = -50, y = -50, relative = true }),
	{ repeating = true, description = "Decrease window size" }
)

-- Keyboard resize
hl.bind(
	mainMod .. " + SHIFT + right",
	hl.dsp.window.resize({ x = 100, y = 0, relative = true }),
	{ repeating = true, description = "Increase width" }
)
hl.bind(
	mainMod .. " + SHIFT + left",
	hl.dsp.window.resize({ x = -100, y = 0, relative = true }),
	{ repeating = true, description = "Decrease width" }
)
hl.bind(
	mainMod .. " + SHIFT + down",
	hl.dsp.window.resize({ x = 0, y = 100, relative = true }),
	{ repeating = true, description = "Increase height" }
)
hl.bind(
	mainMod .. " + SHIFT + up",
	hl.dsp.window.resize({ x = 0, y = -100, relative = true }),
	{ repeating = true, description = "Decrease height" }
)

-- ============================================================
-- RESIZE SUBMAP (Modal resize mode from mylinuxforwork)
-- Press SUPER + R to enter, then use arrows/hjkl to resize, ESC/Enter to exit
-- ============================================================
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"), { description = "Enter resize mode" })

hl.define_submap("resize", function()
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("return", hl.dsp.submap("reset"))
	hl.bind("q", hl.dsp.submap("reset"))
	hl.bind("left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
	hl.bind("right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
	hl.bind("h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
	hl.bind("l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
end)

-- ============================================================
-- MOVE SUBMAP (Modal move mode from mylinuxforwork)
-- Press SUPER + SHIFT + R to enter, then use arrows/hjkl to move, ESC/Enter to exit
-- ============================================================
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.submap("move"), { description = "Enter move mode" })

hl.define_submap("move", function()
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("return", hl.dsp.submap("reset"))
	hl.bind("q", hl.dsp.submap("reset"))
	hl.bind("left", hl.dsp.window.move({ direction = "l" }), { repeating = true })
	hl.bind("right", hl.dsp.window.move({ direction = "r" }), { repeating = true })
	hl.bind("down", hl.dsp.window.move({ direction = "d" }), { repeating = true })
	hl.bind("up", hl.dsp.window.move({ direction = "u" }), { repeating = true })
	hl.bind("h", hl.dsp.window.move({ direction = "l" }), { repeating = true })
	hl.bind("l", hl.dsp.window.move({ direction = "r" }), { repeating = true })
	hl.bind("j", hl.dsp.window.move({ direction = "d" }), { repeating = true })
	hl.bind("k", hl.dsp.window.move({ direction = "u" }), { repeating = true })
end)

-- ============================================================
-- Laptop multimedia keys
-- ============================================================

--hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
--hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
--hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
--hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
--hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

--fallback for non noctalia
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true, description = "Raise volume" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true, description = "Lower volume" }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true, description = "Mute audio" }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true, description = "Mute microphone" }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
	{ locked = true, repeating = true, description = "Increase brightness" }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
	{ locked = true, repeating = true, description = "Decrease brightness" }
)

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, description = "Next track" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Pause audio" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play audio" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Previous track" })

-- ============================================================
-- System actions
-- ============================================================
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Reload Hyprland configuration" })
hl.bind(
	mainMod .. " + SHIFT + A",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-animations.sh"),
	{ description = "Toggle animations" }
)
hl.bind(
	mainMod .. " + PRINT",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"),
	{ description = "Take screenshot" }
)
hl.bind(
	mainMod .. " + CTRL + P",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/powermenu.sh"),
	{ description = "Open power menu" }
)
hl.bind(
	mainMod .. " + CTRL + K",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/keybinds.sh"),
	{ description = "Show keybindings" }
)
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"), { description = "Lock screen" })

-- ============================================================
-- Additional useful binds
-- ============================================================
-- Toggle gaps
hl.bind(
	mainMod .. " + CTRL + G",
	hl.dsp.exec_cmd("hyprctl keyword general:gaps_in 0; hyprctl keyword general:gaps_out 0"),
	{ description = "Disable gaps" }
)
hl.bind(
	mainMod .. " + SHIFT + G",
	hl.dsp.exec_cmd("hyprctl keyword general:gaps_in 5; hyprctl keyword general:gaps_out 20"),
	{ description = "Enable gaps" }
)

-- Toggle blur
hl.bind(
	mainMod .. " + B",
	hl.dsp.exec_cmd("hyprctl keyword decoration:blur:enabled true"),
	{ description = "Enable blur" }
)
hl.bind(
	mainMod .. " + SHIFT + B",
	hl.dsp.exec_cmd("hyprctl keyword decoration:blur:enabled false"),
	{ description = "Disable blur" }
)

-- Toggle window decorations
hl.bind(
	mainMod .. " + ALT + B",
	hl.dsp.exec_cmd("hyprctl keyword general:border_size 0"),
	{ description = "Disable borders" }
)
hl.bind(
	mainMod .. " + ALT + SHIFT + B",
	hl.dsp.exec_cmd("hyprctl keyword general:border_size 2"),
	{ description = "Enable borders" }
)

-- Kill all windows in workspace
hl.bind(
	mainMod .. " + SHIFT + X",
	hl.dsp.exec_cmd("hyprctl dispatch workspace r; hyprctl dispatch closewindow"),
	{ description = "Close all windows in workspace" }
)

-- Center window
hl.bind(mainMod .. " + O", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.move({ x = "50%", y = "50%" }))
end, { description = "Toggle float and center" })
