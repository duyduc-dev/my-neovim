require("catppuccin").setup({
	flavour = "mocha", -- latte, frappe, macchiato, mocha
	background = { -- :h background
		light = "latte",
		dark = "mocha",
	},
	transparent_background = false,
	show_end_of_buffer = false, -- show the '~' characters after the end of buffers
	term_colors = true,
	dim_inactive = {
		enabled = true,
		shade = "dark",
		percentage = 0.15,
	},
	no_italic = false, -- Force no italic
	no_bold = false, -- Force no bold
	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	color_overrides = {
		all = {},
	},
	custom_highlights = {},
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		telescope = true,
		notify = true,
		mini = true,
		-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
	},
})

--
-- require("tokyonight").setup({
-- 	on_highlights = function(hl, c)
-- 		hl.IndentBlanklineContextChar = {
-- 			fg = c.dark5,
-- 		}
-- 		hl.TSConstructor = {
-- 			fg = c.blue1,
-- 		}
-- 		hl.TSTagDelimiter = {
-- 			fg = c.dark5,
-- 		}
-- 	end,
-- 	style = "moon", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
-- 	transparent = false, --lvim.transparent_window, -- Enable this to disable setting the background color
-- 	terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
-- 	styles = {
-- 		-- Style to be applied to different syntax groups
-- 		-- Value is any valid attr-list value for `:help nvim_set_hl`
-- 		comments = { italic = true },
-- 		keywords = { italic = true },
-- 		functions = {},
-- 		variables = {},
-- 		-- Background styles. Can be "dark", "transparent" or "normal"
-- 		sidebars = "dark", -- style for sidebars, see below
-- 		floats = "dark", -- style for floating windows
-- 	},
-- 	-- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
-- 	sidebars = {
-- 		"qf",
-- 		"vista_kind",
-- 		"terminal",
-- 		"packer",
-- 		"spectre_panel",
-- 		"NeogitStatus",
-- 		"help",
-- 	},
-- 	day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
-- 	hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
-- 	dim_inactive = false, -- dims inactive windows
-- 	lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
-- 	use_background = true, -- can be light/dark/auto. When auto, background will be set to vim.o.background
-- })
--
-- -- setup must be called before loading
-- vim.cmd.colorscheme("tokyonight")

vim.cmd.colorscheme("catppuccin")
