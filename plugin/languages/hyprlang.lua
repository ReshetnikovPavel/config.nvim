vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
	pattern = { "*.hl", "hypr*.conf" },
	callback = function(_)
		vim.bo.commentstring = "# %s"
		vim.lsp.start {
			name = "hyprlang",
			cmd = { "/home/pavelresh/go/bin/hyprls" },
			root_dir = vim.fn.getcwd(),
		}
	end
})
