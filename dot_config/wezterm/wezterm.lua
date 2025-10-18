local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

local function is_vim(pane)
    -- this is set by the plugin, and unset on ExitPre in Neovim
    return pane:get_user_vars().IS_NVIM == 'true'
end

local function is_wsl(pane)
    local process_name = pane:get_foreground_process_name()
    if string.find(process_name, 'WSL') then
        return true
    end
    return false
end

local direction_keys = {
    LeftArrow = 'Left',
    DownArrow = 'Down',
    UpArrow = 'Up',
    RightArrow = 'Right',
}

local function split_nav(resize_or_move, key)
    return {
        key = key,
        mods = resize_or_move == 'resize' and 'META|CTRL' or 'CTRL',
        action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) or is_wsl(pane) then
                -- pass the keys through to vim/nvim
                win:perform_action({
                    SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
                }, pane)
            else
                if resize_or_move == 'resize' then
                    win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
                else
                    win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
                end
            end
        end),
    }
end

local choose_workspace_callback = function(window, pane)
    -- Function to find the entry by id
    local home = wezterm.home_dir
    local workspace_lib = require 'workspaces'
    local workspace_templates = {
        Source = workspace_lib.launch_coding_workspace,
    }
    local workspaces = {
        { id = home .. '/source', label = 'Source' },
        { id = home .. '/other', label = 'Other' },
        { id = home .. '/.config', label = 'Config' },
    }

    window:perform_action(
        act.InputSelector {
            action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
                if not id and not label then
                    wezterm.log_info 'cancelled'
                else
                    wezterm.log_info('id = ' .. id)
                    wezterm.log_info('label = ' .. label)

                    local activate = workspace_templates[label]

                    if activate ~= nil then
                        wezterm.log_info 'Executing custom workspace activation logic'
                        activate(inner_window, inner_pane, id, label)
                    else
                        wezterm.log_info 'Executing default activation logic'
                        inner_window:perform_action(
                            act.SwitchToWorkspace {
                                name = label,
                                spawn = {
                                    label = 'Workspace: ' .. label,
                                    cwd = id,
                                },
                            },
                            inner_pane
                        )
                    end
                end
            end),
            title = 'Choose Workspace',
            choices = workspaces,
            fuzzy = true,
            fuzzy_description = 'Fuzzy find and/or make a workspace',
        },
        pane
    )
end

local debug_callback = function(window, pane)
    wezterm.log_info 'In the debug function'
    wezterm.log_info(pane:get_current_working_dir())
end

-- -- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = 'Space', mods = 'SHIFT', timeout_milliseconds = 1000 }

-- config.color_scheme = 'Catppuccin Mocha'
-- config.color_scheme = 'Tokyo Night'
config.color_scheme = 'Catppuccin Macchiato'
-- config.color_scheme = 'Catppuccin Frappe'
-- config.color_scheme = "OneHalfDark"
-- config.color_scheme = "One Dark (Frappe)"

config.window_background_opacity = 0.98
-- config.win32_system_backdrop = 'Acrylic'  -- Does not work, breaks the terminal
config.window_decorations = 'RESIZE'

-- Fix for bright green background on some folders in ls output in  WSL
-- config.text_background_opacity = 0.3

config.quit_when_all_windows_are_closed = true
config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7,
}

config.use_fancy_tab_bar = true

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = { 'powershell.exe' }
end

config.enable_scroll_bar = true

config.keys = {
    -- Scrolling up/down
    { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollByLine(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollByLine(1) },

    -- Activating tabs
    { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
    { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'p', mods = 'LEADER', action = act.MoveTabRelative(1) },
    { key = 'n', mods = 'LEADER', action = act.MoveTabRelative(-1) },

    -- move between split panes
    split_nav('move', 'LeftArrow'),
    split_nav('move', 'DownArrow'),
    split_nav('move', 'UpArrow'),
    split_nav('move', 'RightArrow'),
    -- resize panes
    split_nav('resize', 'LeftArrow'),
    split_nav('resize', 'DownArrow'),
    split_nav('resize', 'UpArrow'),
    split_nav('resize', 'RightArrow'),

    -- split pane
    -- Inverted vertical and horizontal because this matches the nvim definition
    { key = 'h', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'v', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    -- Windows
    -- { key = "n", mods = "LEADER", action = wezterm.action.SpawnWindow },
    { key = 'c', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },

    -- Workspace input selector input selector
    {
        key = 'w',
        mods = 'LEADER',
        action = wezterm.action_callback(choose_workspace_callback),
    },

    { key = 'l', mods = 'LEADER', action = wezterm.action.ShowLauncherArgs { flags = 'WORKSPACES' } },

    { key = 'q', mods = 'LEADER', action = wezterm.action_callback(debug_callback) },
}

for i = 1, 8 do
    -- CTRL+ALT + number to move to that position
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = wezterm.action.ActivateTab(i - 1),
    })
end

wezterm.on('gui-startup', function(cmd) end)

-- require('statusbar').configure()

-- config.underline_thickness = '200%'
-- config.underline_position = '-3pt'
-- config.term = 'wezterm'

return config
