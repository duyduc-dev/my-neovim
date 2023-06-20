local status, nvim_lsp = pcall(require, "lspconfig")
local masonStatus, mason = pcall(require, "mason")
local masonLspconfigStatus, masonLspconfig = pcall(require, "mason-lspconfig")
local status_ok, illuminate = pcall(require, "illuminate")
local navic = require("nvim-navic")

if not status_ok then
	return
end

if not status then
	print("lspconfig is not installed")
	return
end

if not masonStatus then
	print("mason is not installed")
	return
end

if not masonLspconfigStatus then
	print("mason lspconfig is not installed")
	return
end

mason.setup()
masonLspconfig.setup({
	automatic_installation = true,
})

local M = {}
M.on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.lsp.omnifunc")

	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end

	illuminate.on_attach(client)
end

M.servers = {
	lua_ls = require("lsp.providers.lua_ls"),
	tsserver = {},
	tailwindcss = {},
	cssmodules_ls = {
		capabilities = {
			definitionProvider = true,
		},
	},
	cssls = {},
	html = {},
	jsonls = {},
	emmet_ls = {
		filetypes = {
			"css",
			"eruby",
			"html",
			"javascript",
			"javascriptreact",
			"less",
			"sass",
			"scss",
			"svelte",
			"pug",
			"typescriptreact",
			"vue",
			"ejs",
		},
		init_options = {
			html = {
				options = {
					-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
					["bem.enabled"] = true,
				},
			},
		},
	},
}

M.capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
--M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

M.loadServer = function(options)
	local opts = {
		on_attach = M.on_attach,
		capabilities = M.capabilities,
	}
	for key, value in pairs(options) do
		opts[key] = value
	end

	return opts
end

for key, _ in pairs(M.servers) do
	nvim_lsp[key].setup(M.loadServer(M.servers[key]))
end

-- nvim_lsp.emmet_ls.setup({
-- 	filetypes = {
-- 		"css",
-- 		"eruby",
-- 		"html",
-- 		"javascript",
-- 		"javascriptreact",
-- 		"less",
-- 		"sass",
-- 		"scss",
-- 		"svelte",
-- 		"pug",
-- 		"typescriptreact",
-- 		"vue",
-- 		"ejs",
-- 	},
-- 	init_options = {
-- 		html = {
-- 			options = {
-- 				-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
-- 				["bem.enabled"] = true,
-- 			},
-- 		},
-- 	},
-- })
--
-- nvim_lsp.lua_ls.setup(M.loadServer(require("lsp.providers.lua_ls")))
