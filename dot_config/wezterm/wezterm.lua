local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	LeftArrow = "Left",
	DownArrow = "Down",
	UpArrow = "Up",
	RightArrow = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

-- -- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = "Catppuccin Frappe"
-- config.color_scheme = "OneHalfDark"
-- config.color_scheme = "One Dark (Frappe)"

config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"

config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.7,
}

config.use_fancy_tab_bar = true

config.default_prog = { "powershell.exe" }

config.enable_scroll_bar = true

config.keys = {
	-- Scrolling up/down
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(1) },

	-- Activating tabs
	{ key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(1) },

	{ key = "LeftArrow", mods = "CTRL|ALT", action = act.MoveTabRelative(-1) },
	{ key = "RightArrow", mods = "CTRL|ALT", action = act.MoveTabRelative(1) },

	-- move between split panes
	split_nav("move", "LeftArrow"),
	split_nav("move", "DownArrow"),
	split_nav("move", "UpArrow"),
	split_nav("move", "RightArrow"),
	-- resize panes
	split_nav("resize", "LeftArrow"),
	split_nav("resize", "DownArrow"),
	split_nav("resize", "UpArrow"),
	split_nav("resize", "RightArrow"),

	-- split pane
	{ key = "h", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Windows
	-- { key = "n", mods = "LEADER", action = wezterm.action.SpawnWindow },
	{ key = "c", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
}

for i = 1, 8 do
	-- CTRL+ALT + number to move to that position
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL|ALT",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- config.keys = {
-- 	{
-- 		key = "sh",
-- 		mods = "LEADER",
-- 		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
-- 	},
-- 	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
-- 	{
-- 		key = "y",
-- 		mods = "LEADER|CTRL",
-- 		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
-- 	},
-- }

return config
