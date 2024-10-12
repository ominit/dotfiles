local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'embark'

config.font = wezterm.font('IosevkaNerdFont', { weight = 'Medium' })
config.font_size = 14.0

config.default_prog = { 'nu' }

config.hide_tab_bar_if_only_one_tab = true

config.window_background_opacity = 0.75

return config
