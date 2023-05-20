local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

local cmp_window = require("cmp.config.window")

-- vscode format
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })

-- snipmate format
require("luasnip.loaders.from_snipmate").load()
require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })

-- lua format
require("luasnip.loaders.from_lua").load()
require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

--   פּ ﯟ   some other good icons
local kind_icons = {
	Reference = "",
	Folder = "",
	Text = "",
	File = " ",
	Module = " ",
	Namespace = " ",
	Package = " ",
	Class = " ",
	Method = " ",
	Property = " ",
	Field = " ",
	Constructor = " ",
	--    Constructor = "",
	Enum = " ",
	Interface = " ",
	Function = " ",
	Variable = " ",
	Constant = " ",
	String = " ",
	Number = " ",
	Boolean = " ",
	Array = " ",
	Object = " ",
	Key = " ",
	Null = " ",
	EnumMember = " ",
	Struct = " ",
	Event = " ",
	Operator = " ",
	TypeParameter = " ",
	Snippet = " ",
	Unit = " ",
	Value = " ",
	Color = " ",
	Keyword = " ",
	TabNine = " ",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local color_square_width = 2
			local tailwindcss_colors = require("tailwindcss-colorizer-cmp.colors").TailwindcssColors
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			--vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
				cmp_tabnine = "[TN]",
			})[entry.source.name]

			local words = {}
			for word in string.gmatch(vim_item.word, "[^-]+") do
				table.insert(words, word)
			end

			local color_name, color_number
			if
				words[2] == "x"
				or words[2] == "y"
				or words[2] == "t"
				or words[2] == "b"
				or words[2] == "l"
				or words[2] == "r"
			then
				color_name = words[3]
				color_number = words[4]
			else
				color_name = words[2]
				color_number = words[3]
			end

			if color_name == "white" or color_name == "black" then
				local color
				if color_name == "white" then
					color = "ffffff"
				else
					color = "000000"
				end

				local hl_group = "lsp_documentColor_mf_" .. color
				vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color, bg = "#" .. color })
				vim_item.kind_hl_group = hl_group

				-- make the color square 2 chars wide
				vim_item.kind = string.rep("X", color_square_width)

				return vim_item
			elseif #words < 3 or #words > 4 then
				-- doesn't look like this is a tailwind css color
				return vim_item
			end

			if not color_name or not color_number then
				return vim_item
			end

			local color_index = tonumber(color_number)
			if not tailwindcss_colors[color_name] then
				return vim_item
			end

			if not tailwindcss_colors[color_name][color_index] then
				return vim_item
			end

			local color = tailwindcss_colors[color_name][color_index]

			local hl_group = "lsp_documentColor_mf_" .. color
			vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color, bg = "#" .. color })

			vim_item.kind_hl_group = hl_group

			-- make the color square 2 chars wide
			vim_item.kind = string.rep("X", color_square_width)

			return vim_item
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "emmet_vim" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "vsnip" },
		{ name = "nvim_lua" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		documentation = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
		completion = cmp_window.bordered(),
	},
	experimental = {
		ghost_text = false,
		native_menu = false,
	},
})

-- cmp.setup.cmdline(":", {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = cmp.config.sources({
-- 		{ name = "path" },
-- 	}, {
-- 		{
-- 			name = "cmdline",
-- 			option = {
-- 				ignore_cmds = { "Man", "!" },
-- 			},
-- 		},
-- 	}),
-- })

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})
