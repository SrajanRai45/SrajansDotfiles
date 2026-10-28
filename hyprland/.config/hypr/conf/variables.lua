-- Variable definitions
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

-- Optional local configuration overrides (ignored by Git: conf/local.lua)
local has_local, local_overrides = pcall(require, "conf.local")
if not has_local or type(local_overrides) ~= "table" then
	local_overrides = {}
end

-- Helper to read environment variables (e.g. from .env) with fallback defaults
local function env_or(key, fallback)
	local val = os.getenv(key)
	if val and val ~= "" then
		return val
	end
	return fallback
end

local home = os.getenv("HOME") or ""
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

-- Dynamic paths from environment / .env
local privateRepo = env_or("PRIVATE_REPO_DIR", home .. "/Repositories")
local obsidianVault = env_or("OBSIDIAN_VAULT_DIR", home .. "/Repositories/obsidian_notes_sync")
local wallpapersDir = env_or("WALLPAPERS_DIR", home .. "/Pictures/Wallpapers")

local vars = {
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
	privateRepo = privateRepo,
	obsidianVault = obsidianVault,
	wallpapersDir = wallpapersDir,
}

-- Merge local uncommitted overrides if present (from conf/local.lua)
for k, v in pairs(local_overrides) do
	vars[k] = v
end

return vars
