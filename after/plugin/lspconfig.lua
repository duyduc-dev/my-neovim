local status, nvim_lsp = pcall(require, "lspconfig")

if not status then
	print("lspconfig is not installed")
	return
end

local masonStatus, mason = pcall(require, "mason")
local masonLspconfigStatus, masonLspconfig = pcall(require, "mason-lspconfig")

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

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

local on_attach = function(_, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.lsp.omnifunc")
	local opts = { buffer = bufnr, noremap = true, slient = true }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
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
}

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
for key, _ in pairs(servers) do
	nvim_lsp[key].setup({
		on_attach = on_attach,
		settings = servers[key],
		capabilities = capabilities,
	})
end
