local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- config.color_scheme_dirs = { '~/.config/wezterm/colors/' }

-- config.color_scheme_dirs = { os.getenv("HOME") .. "/.config/wezterm/colors/" }

config.color_scheme = 'embark'

return config
