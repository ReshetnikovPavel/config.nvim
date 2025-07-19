return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			"hrsh7th/nvim-cmp",
		},
	},
	{
		'Chaitanyabsprip/fastaction.nvim',
		opts = {},
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		config = function()
			require('tiny-code-action').setup({})
		end
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			progress = {
				display = {
					render_limit = 0,
					done_ttl = 1,
					done_style = "Comment",
					progress_style = "Comment",
					group_style = "Comment",
					icon_style = "Comment",
				},
			},
			notification = {
				window = {
					winblend = 0,
				},
			},
		},
	}
}
