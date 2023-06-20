return {
	leader = "space",
	reload_config_on_save = true,
	colorscheme = "lunar",
	transparent_window = false,
	format_on_save = {
		---@usage boolean: format on save (Default: false)
		enabled = false,
		---@usage pattern string pattern used for the autocommand (Default: '*')
		pattern = "*",
		---@usage timeout number timeout in ms for the format request (Default: 1000)
		timeout = 1000,
		---@usage filter func to select client
		filter = require("lvim.lsp.utils").format_filter,
	},
	keys = {},

	use_icons = true,
	icons = require("utils.icons"),

	builtin = {},

	plugins = {
		-- use config.lua for this not put here
	},
}
