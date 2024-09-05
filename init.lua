--------------------------------------------
---------------- INITIALIZE ----------------
--------------------------------------------

local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local act = wezterm.action

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

--------------------------------------------
--------------- COLOR SCHEME ---------------
--------------------------------------------

light_theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").dawn
dark_theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").moon

-- Set the color scheme based on system appearance
function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return dark_theme.colors(), dark_theme.window_frame()
	else
		return light_theme.colors(), light_theme.window_frame()
	end
end

local colors, window_frame = scheme_for_appearance(wezterm.gui.get_appearance())

config.colors = colors
config.window_frame = window_frame

-- Automatically reload configuration when system appearance changes
wezterm.on("window-config-reloaded", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local override_color, override_window_frame = scheme_for_appearance(wezterm.gui.get_appearance())
	overrides.colors = override_color
	overrides.window_frame = override_window_frame
	window:set_config_overrides(overrides)
end)

--------------------------------------------
------------------- FONT -------------------
--------------------------------------------

-- Optional: Set a default font
config.font = wezterm.font("FiraCode Nerd Font Mono")

-- Optional: Set font size
config.font_size = 15.0
config.line_height = 1.2

-- Cursor style
config.default_cursor_style = "SteadyBlock"

--------------------------------------------
---------------- APPEARANCE ----------------
--------------------------------------------

-- Optional: Enable the tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true

config.window_padding = {
	left = 5,
	right = 5,
	top = 2,
	bottom = 2,
}

-- Window decorations
config.window_decorations = "RESIZE"

-- Background opacity
config.window_background_opacity = 1.0

-- Disable annoying default behaviors
config.audible_bell = "Disabled"

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.85,
}

--------------------------------------------
-------------- KEY BINDINGS ----------------
--------------------------------------------

-- Function to toggle opacity
local function toggle_opacity(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.85
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end

-- Add leader key support
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- Tab management
	{
		key = "c",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new tab name",
			action = wezterm.action_callback(function(window, pane, line)
				if line and line ~= "" then
					window:perform_action(act.SpawnTab("CurrentPaneDomain"), pane)
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "r",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line and line ~= "" then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "W", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "l", mods = "ALT|SHIFT", action = act.ActivateTabRelative(1) },
	{ key = "h", mods = "ALT|SHIFT", action = act.ActivateTabRelative(-1) },
	-- { key = "s", mods = "LEADER", action = act.ShowTabNavigator },

	-- Pane management
	{ key = '"', mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "'", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "w", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{
		mods = "LEADER",
		key = "Space",
		action = wezterm.action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	{
		mods = "LEADER",
		key = "z",
		action = wezterm.action.TogglePaneZoomState,
	},

	-- Font size adjustment
	{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },

	-- Toggle opacity
	{ key = "u", mods = "LEADER", action = wezterm.action_callback(toggle_opacity) },

	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "n",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line and line ~= "" then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	-- "Detach" and go to default workspace
	{
		key = "d",
		mods = "LEADER",
		action = act.SwitchToWorkspace({
			name = "default",
		}),
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},

	{ key = "m", mods = "ALT", action = wezterm.action.ShowLauncher },

	-- activate copy mode or vim mode
	{
		key = "Enter",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
}

-- Smart Splits Config for Neovim Support --
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
-- you can put the rest of your Wezterm config here
smart_splits.apply_to_config(config, {
	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

--------------------------------------------
---------------- BEHAVIOR ------------------
--------------------------------------------

-- Enable OSC 8 hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Make task numbers clickable
-- table.insert(config.hyperlink_rules, {
-- 	regex = [[\b[tT](\d+)\b]],
-- 	format = "https://example.com/tasks/?t=$1",
-- })

config.scrollback_lines = 10000

return config
