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

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.lsp.omnifunc")

	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end

	illuminate.on_attach(client)
end

local servers = {
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
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
}

local M = {}

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

for key, _ in pairs(servers) do
	nvim_lsp[key].setup({
		on_attach = on_attach,
		settings = servers[key],
		capabilities = M.capabilities,
	})
end
