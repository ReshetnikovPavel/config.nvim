local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
	mapping = {
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "cody" },
		{ name = "path" },
		{ name = "buffer" },
	},
})
