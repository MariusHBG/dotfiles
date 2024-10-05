local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = "Catppuccin Frappe"
-- config.color_scheme = "OneHalfDark"
-- config.color_scheme = "One Dark (Frappe)"

config.default_prog = { "powershell.exe" }

config.enable_scroll_bar = true

config.keys = {
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(1) },
}

return config
