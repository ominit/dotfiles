local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'embark'

config.font = wezterm.font('Iosevka')

return config
