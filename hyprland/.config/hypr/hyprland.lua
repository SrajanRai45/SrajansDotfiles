-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- HYPRLAND MODULAR CONFIG                                --
-- Each module is in the conf/ directory                 --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Modules are loaded in order; dependencies should be
-- loaded first (e.g., variables before keybindings)

require("conf.variables")
require("conf.cursor")
require("conf.monitors")
require("conf.autostart")
require("conf.env")
require("conf.permissions")
require("conf.appearance")
require("conf.animations")
require("conf.input")
require("conf.keybindings")
require("conf.workspaceRules")