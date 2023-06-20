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
	use("folke/tokyonight.nvim")

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
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("RRethy/vim-illuminate")
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
	use("aca/emmet-ls")
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

	use("monkoose/matchparen.nvim")
	use("HiPhish/nvim-ts-rainbow2")
	use({ "junegunn/fzf.vim", requires = {
		"junegunn/fzf",
	} })
	use({ "barrett-ruth/import-cost.nvim", run = "sh install.sh yarn" })
	use("lewis6991/impatient.nvim")

	use("ludovicchabant/vim-gutentags")
	use({ "kristijanhusak/vim-js-file-import", run = "npm install" })
	use("folke/neodev.nvim")
	use({
		"SmiteshP/nvim-navic",
		config = function()
			require("config.breadcrumbs").setup()
		end,
		requires = "neovim/nvim-lspconfig",
	})
	use({ "gorbit99/codewindow.nvim" })
	use("jonsmithers/vim-html-template-literals")
	use("pangloss/vim-javascript")
	use("alvan/vim-closetag")
	use({ "codota/tabnine-nvim", run = "./dl_binaries.sh" })
	use({ "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" })
	use("nikvdp/ejs-syntax")
	use({
		"tamago324/lir.nvim",
		config = function()
			require("config.lir").setup()
		end,
		enabled = true,
		event = "User DirOpened",
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
