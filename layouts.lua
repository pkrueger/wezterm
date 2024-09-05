local wezterm = require("wezterm")
local M = {}

-- Function to load all layout files
local function load_layouts()
	local layouts = {}
	local layout_dir = wezterm.config_dir .. "/.config/wezterm/layouts"
	wezterm.log_info("Layouts directory: " .. layout_dir)
	for _, file in ipairs(wezterm.glob(layout_dir .. "/*.lua")) do
		local name = file:match("([^/]+)%.lua$")
		wezterm.log_info("Loading layout: " .. name)
		layouts[name] = file -- Store the file path instead of loading the content
	end
	return layouts
end

local function setup_workspace(window, name, layout_file)
	if not layout_file then
		return
	end

	-- Create a new workspace
	window:perform_action(
		wezterm.action.SwitchToWorkspace({
			name = name,
			spawn = {
				args = { wezterm.config_dir .. "/.config/wezterm/send_layout.sh", name },
			},
		}),
		window:active_pane()
	)
end

function M.show_layout_picker(window)
	wezterm.log_info("Getting the layouts")
	local layouts = load_layouts()
	local choices = {}
	for name, _ in pairs(layouts) do
		table.insert(choices, { label = name })
	end

	window:perform_action(
		wezterm.action.InputSelector({
			title = "Select Workspace",
			choices = choices,
			action = wezterm.action_callback(function(window, pane, id, label)
				if label then
					setup_workspace(window, label, layouts[label])
				end
			end),
		}),
		window:active_pane()
	)
end

function M.create_splits(window, pane, splits, base_dir)
	if not splits then
		return
	end

	for i, split in ipairs(splits) do
		local new_pane
		if i == 1 then
			new_pane = pane
		else
			local direction = split.direction or "Right"
			local size = split.size or 0.5
			new_pane = pane:split({ direction = direction, size = size })
		end

		new_pane:send_text("cd " .. (split.cwd or base_dir) .. "\n")

		if split.command then
			new_pane:send_text(split.command .. "\n")
		end

		if split.splits then
			M.create_splits(window, new_pane, split.splits)
		end
	end
end

return M
