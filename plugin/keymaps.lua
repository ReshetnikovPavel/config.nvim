vim.keymap.set("n", "<leader>#", ":b#<CR>")
vim.keymap.set("n", "<leader>/", ":noh<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Execute current line as lua" })
vim.keymap.set("n", "<leader><leader>x", ":source %<CR>", { desc = "Execute the current file" })
vim.keymap.set("n", "<leader><Enter>", ":.!bash<CR>", { desc = "Execute current line as bash" })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

vim.keymap.set(
	"n",
	"<leader>cwl",
	":.!python3 ~/scripts/fix_wrong_layout.py<CR>",
	{ desc = "Call a script to fix text written in wrong layout" }
)

vim.keymap.set("n", "<leader>№", ":b#<CR>")
vim.keymap.set("n", "<leader>,", ":noh<CR>")
vim.keymap.set("n", "<leader>ч", ":.lua<CR>", { desc = "Execute current line as lua" })
vim.keymap.set("n", "<leader><leader>ч", ":source %<CR>", { desc = "Execute the current file" })

vim.keymap.set("n", "<leader>ее", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end)

vim.keymap.set("n", "<leader>у", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

vim.keymap.set(
	"n",
	"<leader>сцд",
	":.!python3 ~/scripts/fix_wrong_layout.py<CR>",
	{ desc = "Call a script to fix text written in wrong layout" }
)
