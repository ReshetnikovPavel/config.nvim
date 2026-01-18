vim.g.mapleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true

vim.keymap.set("n", "<leader>#", ":b#<CR>")
vim.keymap.set("n", "<leader>/", ":noh<CR>")
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>D", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>q", ":cclose<CR>")

vim.keymap.set("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>fo", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<A-CR>", vim.lsp.buf.code_action)

vim.cmd([[
	command! W w
	command! Wq wq
	command! WQ wq
	command! Wa wa
	command! WA wa
]])

require('make')

vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 250 })
	end,
})

vim.pack.add({
	"https://github.com/rose-pine/neovim",
	"https://github.com/mbbill/undotree",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/saghen/blink.cmp",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/mikavilpas/yazi.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/norcalli/nvim-colorizer.lua",
})

vim.lsp.enable({
	"lua_ls",
	"rust_analyzer",
	"ty",
	"ruff"
})

require("nvim-treesitter").install({
	"rust",
	"python",
	"bash",
})

require("blink.cmp").setup({
	cmdline = {
		enabled = false
	},
	completion = {
		documentation = {
			auto_show = true
		},
		list = {
			selection = {
				preselect = true,
				auto_insert = false
			}
		}
	},
	fuzzy = {
		implementation = "lua"
	},
	keymap = {
		["<Tab>"] = { "accept", "fallback" },
	},
})

vim.cmd("colorscheme rose-pine")

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR><c-w>h<c-w>k")
vim.keymap.set("n", "<leader>y", ":Yazi<CR>")
vim.keymap.set("n", "<leader>Y", ":Yazi cwd<CR>")

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files)
vim.keymap.set("n", "<leader>fg", telescope.live_grep)
vim.keymap.set("n", "<leader>fb", telescope.buffers)

require("colorizer").setup()
