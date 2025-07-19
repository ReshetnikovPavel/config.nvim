vim.keymap.set(
	{ "n", "o", "x" },
	"<M-w>",
	"<cmd>lua require('spider').motion('w')<CR>",
	{ desc = "Spider-w" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"<M-e>",
	"<cmd>lua require('spider').motion('e')<CR>",
	{ desc = "Spider-e" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"<M-b>",
	"<cmd>lua require('spider').motion('b')<CR>",
	{ desc = "Spider-b" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"<M-g><M-e>",
	"<cmd>lua require('spider').motion('ge')<CR>",
	{ desc = "Spider-ge" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"<M-W>",
	"<cmd>lua require('spider').motion('W')<CR>",
	{ desc = "Spider-W" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"<M-E>",
	"<cmd>lua require('spider').motion('E')<CR>",
	{ desc = "Spider-E" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"<M-B>",
	"<cmd>lua require('spider').motion('B')<CR>",
	{ desc = "Spider-B" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"<M-g><M-E>",
	"<cmd>lua require('spider').motion('gE')<CR>",
	{ desc = "Spider-gE" }
)
