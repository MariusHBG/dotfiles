local workspaces = {}
local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux
local log = wezterm.log_info

function workspaces.launch_coding_workspace(inner_window, inner_pane, id, label)
    -- Working dir for all opened tabs should be same from where this command was triggered
    local project_dir = inner_pane:get_current_working_dir().file_path:sub(2) -- Need to strip first char from "/C:/Users/..."

    -- Top pane is for the editor, bottom pane is for the build tool
    local tab, build_pane, window = mux.spawn_window {
        workspace = 'Source',
        cwd = project_dir,
    }
    local editor_pane = build_pane:split {
        direction = 'Top',
        size = 0.6,
        cwd = project_dir,
    }
    -- may as well kick off a build in that pane
    -- build_pane:send_text("cargo build\n")

    inner_window:perform_action(
        act.SwitchToWorkspace {
            name = label,
        },
        inner_pane
    )
end

return workspaces
