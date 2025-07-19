require("telescope").setup({
	defaults = {
		theme = "center",
		sorting_strategy = "ascending",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.5,
			},
		},
		mappings = {
			i = {
				["<C-h>"] = "which_key",
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",
			},
		},
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({}),
			},
		},
	},
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>fw", builtin.grep_string, {})
vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
vim.keymap.set("n", "<leader>gb", builtin.git_branches, {})
vim.keymap.set("n", "<leader>gc", builtin.git_commits, {})
vim.keymap.set("n", "<leader>gs", builtin.git_stash, {})
vim.keymap.set("n", "<leader>gd", builtin.git_status, {})



vim.keymap.set("n", "<leader>аа", builtin.find_files, {})
vim.keymap.set("n", "<leader>ап", builtin.live_grep, {})
vim.keymap.set("n", "<leader>аи", builtin.buffers, {})
vim.keymap.set("n", "<leader>ащ", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>па", builtin.git_files, {})
vim.keymap.set("n", "<leader>ац", builtin.grep_string, {})

require("telescope").load_extension("ui-select")
