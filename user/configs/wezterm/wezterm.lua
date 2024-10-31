local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'embark'

config.font = wezterm.font('IosevkaNerdFont', { weight = 'Medium' })
config.font_size = 14.0

config.default_prog = { 'nu' }

config.hide_tab_bar_if_only_one_tab = true

-- config.window_background_opacity = 0.7

-- config.window_padding = {
--   left = 0,
--   right = 0,
--   top = 0,
--   bottom = 0,
-- }

return config
