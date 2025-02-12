local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'embark'

config.font = wezterm.font('IosevkaNerdFont', { weight = 'Medium' })
config.font_size = 16.0

config.hide_tab_bar_if_only_one_tab = true

config.check_for_updates = false

-- config.default_prog = { 'nu', '-c', "zellij -l welcome --config-dir ~/.config/yazelix/zellij options --layout-dir ~/.config/yazelix/zellij/layouts" }
-- config.default_prog = { 'nu' }

config.window_decorations = "NONE"

-- config.window_background_opacity = 0.7

-- config.window_padding = {
--   left = 0,
--   right = 0,
--   top = 0,
--   bottom = 0,
-- }

return config
