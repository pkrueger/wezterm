return {
	name = "LumiQuill",
	base_dir = "~/code/personal/lumiquill",
	{
		name = "Docker Compose",
	},
	{
		name = "Backend",
		splits = {
			{
				cwd = "~/code/personal/lumiquill/backend",
				command = "vim",
			},
			{
				direction = "Bottom",
				cwd = "~/code/personal/lumiquill/backend",
				command = "gst",
				size = 0.2,
			},
		},
	},
}
