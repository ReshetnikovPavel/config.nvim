local command = vim.api.nvim_create_user_command

command("CdToFileDir", function()
	local current_file_dir = vim.fn.expand("%:p:h")
	vim.cmd("cd " .. current_file_dir)
end, {})

command("CopyFilePath", function()
	local file_path = vim.fn.expand("%:p")
	vim.fn.setreg("+", file_path)
end, {})

vim.cmd([[
	command! W w
	command! Wq wq
	command! WQ wq
	command! Wa wa
	command! WA wa
]])
