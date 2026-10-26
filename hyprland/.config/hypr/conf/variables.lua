-- Variable definitions
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local terminal = "kitty"
local fileManager = "nautilus"
local menu = "fuzzel"
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local browser = "zen-browser"
local ipc = "noctalia msg "
local clipBoard = "cliphist list | fuzzel -d | cliphist decode | wl-copy"
local ss = "sh -c 'grim - | wl-copy -t image/png' "
local ssSlurp = [[sh -c "grim -g \"\$(slurp)\" - | wl-copy -t image/png"]]
local openOrbit = "orbit show"
local closeOrbit = "orbit hide"
local themeSwitcher = [[kitty --class themeswitcher --title themeSwitcher -e fish -c "themeSwitcher.fish"]]

return {
	terminal = terminal,
	fileManager = fileManager,
	menu = menu,
	mainMod = mainMod,
	browser = browser,
	ipc = ipc,
	clipBoard = clipBoard,
	ss = ss,
	ssSlurp = ssSlurp,
	openOrbit = openOrbit,
	closeOrbit = closeOrbit,
	themeSwitcher = themeSwitcher,
}
