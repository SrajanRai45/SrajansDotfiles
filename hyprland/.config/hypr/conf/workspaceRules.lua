-- Window and Workspace rules configuration
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Suppress maximize requests from all apps
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Hyprland-run window rule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

-- Opacity rules
hl.window_rule({
	name = "opacity-browsers",
	match = { class = "^(firefox|Google-chrome|Brave-browser)$" },
	opacity = "0.80 0.80",
})

hl.window_rule({
	name = "opacity-editors",
	match = { class = "^(code-oss|code|code-url-handler|code-insiders-url-handler)$" },
	opacity = "0.80 0.80",
})

hl.window_rule({
	name = "opacity-terminals",
	match = { class = "^(kitty|ghostty|alacritty|foot)$" },
	opacity = "0.80 0.80",
})

hl.window_rule({
	name = "opacity-system",
	match = {
		class = "^(org.kde.dolphin|org.kde.ark|nwg-look|qt5ct|qt6ct|kvantummanager|org.pulseaudio.pavucontrol|blueman-manager|nm-applet|nm-connection-editor|org.kde.polkit-kde-authentication-agent-1|polkit-gnome-authentication-agent-1|org.freedesktop.impl.portal.desktop.gtk|org.freedesktop.impl.portal.desktop.hyprland)$",
	},
	opacity = "0.80 0.70",
})

hl.window_rule({
	name = "opacity-steam-spotify",
	match = { class = "^(steam|steamwebhelper|Spotify)$" },
	opacity = "0.70 0.70",
})

hl.window_rule({
	name = "opacity-media",
	match = { class = "^(mpv|vlc|celluloid|io.mpv.Mpv)$" },
	opacity = "0.95 0.95",
})

hl.window_rule({
	name = "opacity-chat",
	match = { class = "^(discord|vesktop|slack|telegramdesktop|Signal|element)$" },
	opacity = "0.90 0.90",
})

-- Float rules - dialogs and popups
hl.window_rule({
	name = "float-dialogs",
	match = {
		title = "^(Open|Choose Files|Save As|Confirm to replace files|File Operation Progress|About Mozilla Firefox|Picture-in-Picture|Library)$",
	},
	float = true,
})

hl.window_rule({
	name = "float-dolphin-dialogs",
	match = { class = "org.kde.dolphin", title = "(Progress Dialog — Dolphin|Copying — Dolphin)$" },
	float = true,
})

hl.window_rule({
	name = "float-kitty-tools",
	match = { class = "kitty", title = "^(top|btop|htop)$" },
	float = true,
})

hl.window_rule({
	name = "float-system-tools",
	match = {
		class = "^(vlc|kvantummanager|qt5ct|qt6ct|nwg-look|org.kde.ark|org.pulseaudio.pavucontrol|blueman-manager|nm-applet|nm-connection-editor|org.kde.polkit-kde-authentication-agent-1|Signal|com.github.rafostar.Clapper|app.drey.Warp|net.davidotek.pupgui2|yad|eog|io.github.alainm23.planify|io.gitlab.theevilskeleton.Upscaler|com.github.unrud.VideoDownloader|io.gitlab.adhami3310.Impression|io.missioncenter.MissionCenter|io.github.flattool.Warehouse)$",
	},
	float = true,
})

-- More comprehensive float rules for dialogs, popups, file pickers, PiP
hl.window_rule({
	name = "float-file-pickers",
	match = { title = "^(Open File|Select File|Save File|Choose Folder|Select Folder|Upload|Attach)$" },
	float = true,
})

hl.window_rule({
	name = "float-popups",
	match = { title = "^(Popup|Pop-up|Tooltip|Tooltip.*|Context Menu|Dropdown)$" },
	float = true,
})

hl.window_rule({
	name = "float-pip",
	match = { title = "^(Picture.in.Picture|PiP|Video Popout|Mini Player)$" },
	float = true,
	pin = true,
})

hl.window_rule({
	name = "float-calculator",
	match = { class = "^(gnome-calculator|kcalc|qalculate-gtk|calculator|galculator)$" },
	float = true,
})

hl.window_rule({
	name = "float-password-managers",
	match = { class = "^(keepassxc|bitwarden|1password|bitwarden-desktop|org.keepassxc.KeePassXC)$" },
	float = true,
})

hl.window_rule({
	name = "float-settings",
	match = { title = "^(Settings|Preferences|Options|Properties|Configuration)$" },
	float = true,
})

hl.window_rule({
	name = "float-about-dialogs",
	match = { title = "^(About |About .*|Credits|License|Changelog)$" },
	float = true,
})

hl.window_rule({
	name = "float-find-replace",
	match = { title = "^(Find|Replace|Find and Replace|Search|Go to)$" },
	float = true,
})

hl.window_rule({
	name = "float-print-dialogs",
	match = { title = "^(Print|Print Preview|Page Setup)$" },
	float = true,
})

hl.window_rule({
	name = "float-confirm-dialogs",
	match = { title = "^(Confirm|Are you sure|Delete|Remove|Quit|Exit|Close|Discard changes)$" },
	float = true,
})

hl.window_rule({
	name = "float-git-dialogs",
	match = { class = "^(gitk|git-gui|github-desktop|gitkraken|lazygit)$" },
	float = true,
})

hl.window_rule({
	name = "float-ssh-askpass",
	match = { class = "^(ssh-askpass|gnome-ssh-askpass|ksshaskpass)$" },
	float = true,
})

hl.window_rule({
	name = "float-pinentry",
	match = { class = "^(pinentry|pinentry-gtk-2|pinentry-qt)$" },
	float = true,
})

-- Size rules
hl.window_rule({
	name = "center-float-windows",
	match = { float = true },
	size = "80% 80%",
})

hl.window_rule({
	name = "terminal-size",
	match = { class = "^(kitty|ghostty|alacritty|foot|wezterm)$" },
	size = "90% 90%",
})

-- Layer rules
hl.layer_rule({
	name = "blur-rofi",
	match = { namespace = "rofi" },
	blur = true,
})

hl.layer_rule({
	name = "blur-notifications",
	match = { namespace = "^(notifications|swaync-notification-window|swaync-control-center)$" },
	blur = true,
})

hl.layer_rule({
	name = "blur-logout",
	match = { namespace = "logout_dialog" },
	blur = true,
})

hl.layer_rule({
	name = "blur-fuzzel",
	match = { namespace = "fuzzel" },
	blur = true,
})

hl.layer_rule({
	name = "blur-waybar",
	match = { namespace = "waybar" },
	blur = true,
})

hl.layer_rule({
	name = "blur-wlogout",
	match = { namespace = "wlogout" },
	blur = true,
})

hl.layer_rule({
	name = "blur-swayosd",
	match = { namespace = "swayosd" },
	blur = true,
})

hl.layer_rule({
	name = "blur-hyprlock",
	match = { namespace = "hyprlock" },
	blur = true,
})

-- No blur for specific layers
hl.layer_rule({
	name = "no-blur-gamemode",
	match = { namespace = "gamescope" },
	blur = false,
})

hl.layer_rule({
	name = "no-blur-fullscreen",
	match = { namespace = "fullscreen" },
	blur = false,
})

-- Animation rules for specific windows (no_anim not noanim)
hl.window_rule({
	name = "no-anim-for-games",
	match = { class = "^(steam_app_.*|lutris|heroic|bottles)$" },
	no_anim = true,
})

hl.window_rule({
	name = "no-anim-for-vms",
	match = { class = "^(virt-manager|qemu|vmware|virtualbox)$" },
	no_anim = true,
})

-- Pin rules
hl.window_rule({
	name = "pin-media-players",
	match = { class = "^(mpv|vlc|celluloid)$", title = "^.*Picture.in.Picture.*$" },
	pin = true,
})

-- XWayland specific rules
hl.window_rule({
	name = "xwayland-scale",
	match = { xwayland = true, class = "^(steam|Steam)$" },
	size = "100% 100%",
})

hl.window_rule({
	name = "float-themeswitcher",
	match = { class = "themeswitcher" },
	float = true,
	center = true,
	size = "1000 650",
	dim_around = true,
	stay_focused = true,
})
