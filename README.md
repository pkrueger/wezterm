# WezTerm config

Make sure to clone this repo into `~/.config/wezterm`

That should set the `init.lua` file location to `~/.config/wezterm/init.lua`

After that create `~/.wezterm.lua` and put in the following line:
```lua
require 'init'
```

A template system has been put in place to make loading workspace tab/pane configs a breeze.
See the example in the layouts folder for more info on how to create them.
