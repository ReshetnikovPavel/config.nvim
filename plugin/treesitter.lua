local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

require("nvim-treesitter.configs").setup({
	sync_install = true,
	auto_install = true,
	highlight = {
		enable = true,
	},
})

vim.filetype.add({
	pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
