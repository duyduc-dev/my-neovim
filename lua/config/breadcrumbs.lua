local M = {}

local localIcon = require("utils.icons")

local iconsVar = localIcon.kind

local icons = {
	Array = iconsVar.Array .. " ",
	Boolean = iconsVar.Boolean .. " ",
	Class = iconsVar.Class .. " ",
	Color = iconsVar.Color .. " ",
	Constant = iconsVar.Constant .. " ",
	Constructor = iconsVar.Constructor .. " ",
	Enum = iconsVar.Enum .. " ",
	EnumMember = iconsVar.EnumMember .. " ",
	Event = iconsVar.Event .. " ",
	Field = iconsVar.Field .. " ",
	File = iconsVar.File .. " ",
	Folder = iconsVar.Folder .. " ",
	Function = iconsVar.Function .. " ",
	Interface = iconsVar.Interface .. " ",
	Key = iconsVar.Key .. " ",
	Keyword = iconsVar.Keyword .. " ",
	Method = iconsVar.Method .. " ",
	Module = iconsVar.Module .. " ",
	Namespace = iconsVar.Namespace .. " ",
	Null = iconsVar.Null .. " ",
	Number = iconsVar.Number .. " ",
	Object = iconsVar.Object .. " ",
	Operator = iconsVar.Operator .. " ",
	Package = iconsVar.Package .. " ",
	Property = iconsVar.Property .. " ",
	Reference = iconsVar.Reference .. " ",
	Snippet = iconsVar.Snippet .. " ",
	String = iconsVar.String .. " ",
	Struct = iconsVar.Struct .. " ",
	Text = iconsVar.Text .. " ",
	TypeParameter = iconsVar.TypeParameter .. " ",
	Unit = iconsVar.Unit .. " ",
	Value = iconsVar.Value .. " ",
	Variable = iconsVar.Variable .. " ",
}

local options = {
	icons = icons,
	highlight = true,
	separator = " " .. localIcon.ui.ChevronRight .. " ",
	depth_limit = 0,
	depth_limit_indicator = "..",
}

local breadcrumbs = {
	active = true,
	on_config_done = nil,
	winbar_filetype_exclude = {
		"help",
		"startify",
		"dashboard",
		"lazy",
		"neo-tree",
		"neogitstatus",
		"NvimTree",
		"Trouble",
		"alpha",
		"lir",
		"Outline",
		"spectre_panel",
		"toggleterm",
		"DressingSelect",
		"Jaq",
		"harpoon",
		"dap-repl",
		"dap-terminal",
		"dapui_console",
		"dapui_hover",
		"lab",
		"notify",
		"noice",
		"neotest-summary",
		"",
	},
	options = options,
}

local get_gps = function()
	local status_gps_ok, gps = pcall(require, "nvim-navic")
	if not status_gps_ok then
		return ""
	end

	local status_ok, gps_location = pcall(gps.get_location, {})
	if not status_ok then
		return ""
	end

	if not gps.is_available() or gps_location == "error" then
		return ""
	end

	if not require("utils.functions").isempty(gps_location) then
		return "%#NavicSeparator#" .. localIcon.ui.ChevronRight .. "%* " .. gps_location
	else
		return ""
	end
end

local excludes = function()
	return vim.tbl_contains(breadcrumbs.winbar_filetype_exclude or {}, vim.bo.filetype)
end

local use_icons = true

M.get_filename = function()
	local filename = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	local f = require("utils.functions")

	if not f.isempty(filename) then
		local file_icon, hl_group
		local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
		if use_icons and devicons_ok then
			file_icon, hl_group = devicons.get_icon(filename, extension, { default = true })

			if f.isempty(file_icon) then
				file_icon = localIcon.kind.File
			end
		else
			file_icon = ""
			hl_group = "Normal"
		end

		local buf_ft = vim.bo.filetype

		if buf_ft == "dapui_breakpoints" then
			file_icon = localIcon.ui.Bug
		end

		if buf_ft == "dapui_stacks" then
			file_icon = localIcon.ui.Stacks
		end

		if buf_ft == "dapui_scopes" then
			file_icon = localIcon.ui.Scopes
		end

		if buf_ft == "dapui_watches" then
			file_icon = localIcon.ui.Watches
		end

		-- if buf_ft == "dapui_console" then
		--   file_icon = lvim.icons.ui.DebugConsole
		-- end

		local navic_text = vim.api.nvim_get_hl_by_name("Normal", true)
		vim.api.nvim_set_hl(0, "Winbar", { fg = navic_text.foreground })

		return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
	end
end

M.get_winbar = function()
	if excludes() then
		return
	end
	local f = require("utils.functions")
	local value = M.get_filename()

	local gps_added = false
	if not f.isempty(value) then
		local gps_value = get_gps()
		value = value .. " " .. gps_value
		if not f.isempty(gps_value) then
			gps_added = true
		end
	end

	if not f.isempty(value) and f.get_buf_option("mod") then
		-- TODO: replace with circle
		local mod = "%#LspCodeLens#" .. localIcon.ui.Circle .. "%*"
		if gps_added then
			value = value .. " " .. mod
		else
			value = value .. mod
		end
	end

	local num_tabs = #vim.api.nvim_list_tabpages()

	if num_tabs > 1 and not f.isempty(value) then
		local tabpage_number = tostring(vim.api.nvim_tabpage_get_number(0))
		value = value .. "%=" .. tabpage_number .. "/" .. tostring(num_tabs)
	end

	local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
	if not status_ok then
		return
	end
end

M.create_winbar = function()
	vim.api.nvim_create_augroup("_winbar", {})
	vim.api.nvim_create_autocmd({
		"CursorHoldI",
		"CursorHold",
		"BufWinEnter",
		"BufFilePost",
		"InsertEnter",
		"BufWritePost",
		"TabClosed",
		"TabEnter",
	}, {
		group = "_winbar",
		callback = function()
			if breadcrumbs.active then
				local status_ok, _ = pcall(vim.api.nvim_buf_get_var, 0, "lsp_floating_window")
				if not status_ok then
					-- TODO:
					M.get_winbar()
				end
			end
		end,
	})
end

M.setup = function()
	local status_ok, navic = pcall(require, "nvim-navic")
	if not status_ok then
		return
	end

	M.create_winbar()
	navic.setup(breadcrumbs.options)

	if breadcrumbs.on_config_done then
		breadcrumbs.on_config_done()
	end
end

return M
