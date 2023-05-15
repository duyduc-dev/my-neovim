local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	-- colorschema
	use({ "catppuccin/nvim", as = "catppuccin" })
	--use("Mofiqul/dracula.nvim")

	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("nvim-treesitter/playground")

	use({ "jiaoshijie/undotree" })
	use("nvim-tree/nvim-web-devicons")
	use({
		"nvim-tree/nvim-tree.lua",
		requires = { "nvim-tree/nvim-web-devicons" }, -- optional ,
	})
	use({ "folke/which-key.nvim" })
	use({ "akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons" })
	use({ "stevearc/dressing.nvim" })
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})
	use("lukas-reineke/indent-blankline.nvim")
	use("echasnovski/mini.indentscope")
	use("rcarriga/nvim-notify")
	use({
		"folke/noice.nvim",
		requires = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	})
	use({ "windwp/nvim-autopairs" })
	use({ "numToStr/Comment.nvim" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")
	use("hrsh7th/vim-vsnip-integ")
	use({ "L3MON4D3/LuaSnip", requires = {
		"rafamadriz/friendly-snippets",
	} }) --snippet engine
	use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to

	-- LSP
	use({ "neovim/nvim-lspconfig" })
	use("glepnir/lspsaga.nvim")
	use({ "williamboman/mason.nvim" })
	use({ "williamboman/mason-lspconfig.nvim" })
	use({ "lewis6991/gitsigns.nvim" })
	use("dinhhuy258/git.nvim")

	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
	})
	use({
		"jose-elias-alvarez/null-ls.nvim",
	})
	use("MunifTanjim/prettier.nvim")
	use({
		"kylechui/nvim-surround",
		tag = "*",
	})

	use({ "akinsho/toggleterm.nvim" })
	use({ "windwp/nvim-ts-autotag" })
	use("norcalli/nvim-colorizer.lua")
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
	use({ "roobert/tailwindcss-colorizer-cmp.nvim" })

	use("mattn/emmet-vim")
	use("dcampos/cmp-emmet-vim")
	use("AndrewRadev/tagalong.vim")
	use("axelvc/template-string.nvim")
	use("mg979/vim-visual-multi")

	use({ "m00qek/baleia.nvim", tag = "v1.3.0" })
	use({
		"samodostal/image.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})

	use({ "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" })
	use("yamatsum/nvim-cursorline")
	use("monkoose/matchparen.nvim")
	use("HiPhish/nvim-ts-rainbow2")
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
