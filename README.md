# WezTerm Configuration

This repository contains a customized configuration for [WezTerm](https://wezfurlong.org/wezterm/), a powerful cross-platform terminal emulator and multiplexer. It includes a flexible layout system, custom color schemes, and various quality-of-life improvements.

## Quick Start

1. Clone this repository into your WezTerm configuration directory:

   ```bash
   git clone https://github.com/pkrueger/wezterm.git ~/.config/
   ```

2. Create a `~/.wezterm.lua` file in your home directory with the following content:

   ```lua
   require 'init'
   ```

3. Restart WezTerm or reload your configuration.

## Features

### Custom Layout System

This configuration includes a powerful custom layout system that allows you to define and quickly switch between predefined workspace layouts.

- **Layout Files**: Store your layout definitions in `~/.config/wezterm/layouts/` as Lua files.
- **Layout Picker**: Use the leader key + `L` to open the layout picker and switch between layouts.
- **Dynamic Workspace Creation**: Layouts are loaded dynamically and create new workspaces on demand.

### Color Scheme Switching

The configuration automatically switches between light and dark themes based on your system appearance.

- Light theme: Dawn
- Dark theme: Moon

### Key Bindings

Some notable key bindings include:

- `CTRL+S` as the leader key
- `LEADER + c`: Create a new named tab
- `LEADER + r`: Rename the current tab
- `LEADER + n`: Create a new named workspace
- `LEADER + s`: Switch between workspaces
- `LEADER + L`: Open the layout picker

Check the `init.lua` file for a full list of custom key bindings.

### Other Features

- Smart Splits integration for better pane management
- Automatic opacity toggling
- Custom font settings (FiraCode Nerd Font by default)
- Enhanced tab bar appearance

## Customization

### Adding New Layouts

To add a new layout:

1. Create a new Lua file in the `~/.config/wezterm/layouts/` directory.
2. Define your layout using the structure shown in the existing `lumiquill.lua` file.
3. The new layout will automatically appear in the layout picker.

Example layout file (`layouts/mylayout.lua`):

```lua
return {
  name = "MyProject",
  base_dir = "~/code/myproject",
  {
    name = "Editor",
    splits = {
      {
        command = "vim",
      },
      {
        direction = "Bottom",
        size = 0.3,
        command = "npm run dev",
      },
    },
  },
  {
    name = "Terminal",
  },
}
```

### Modifying Key Bindings

To change key bindings, edit the `config.keys` table in `init.lua`. You can add new bindings or modify existing ones.

## Plugins

This configuration uses the following plugins:

- [smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim) for enhanced pane management
- Custom color schemes from [neapsix/wezterm](https://github.com/neapsix/wezterm)

## Troubleshooting

If you encounter any issues:

1. Check the WezTerm debug console for error messages.
2. Ensure all required plugins are installed and up to date.
3. Verify that your `~/.wezterm.lua` file is correctly set up.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This WezTerm configuration is open-source software licensed under the MIT license.
