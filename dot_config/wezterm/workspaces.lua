local workspaces = {}
local wezterm = require("wezterm")
local act = wezterm.action

function workspaces.launch_coding_workspace(inner_window, inner_pane, id, label)
	--[[
	-- Set a workspace for coding on a current project
	-- Top pane is for the editor, bottom pane is for the build tool
	local project_dir = wezterm.home_dir .. "/wezterm"
	local tab, build_pane, window = mux.spawn_window({
		workspace = "Source",
		cwd = project_dir,
		args = args,
	})
	local editor_pane = build_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = project_dir,
	})
	-- may as well kick off a build in that pane
	-- build_pane:send_text("cargo build\n")
]]
	inner_window:perform_action(
		act.SwitchToWorkspace({
			name = label,
			spawn = {
				label = "Workspace: " .. label,
				cwd = id,
			},
		}),
		inner_pane
	)
end

return workspaces
