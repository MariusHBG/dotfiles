-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'Catppuccin Macchiato'
config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "OneHalfDark"
-- config.color_scheme = "One Dark (Gogh)"

config.default_prog = { "powershell.exe" }
-- config.font = wezterm.font("JetBrains Mono")

-- and finally, return the configuration to wezterm
return config
