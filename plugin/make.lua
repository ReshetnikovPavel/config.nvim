vim.api.nvim_create_user_command("Make", function(command)
	local file_path = vim.fn.stdpath('data') .. '/Make.json'
	io.popen("touch '" .. file_path .. "'")
	local file = io.open(file_path, 'r')
	if not file then
		print("ERROR: " .. file_path .. " does not exist but it should")
		return
	end

	local content = file:read('*all')
	file:close()
	if not content then
		print("ERROR: file should've had some content")
		return
	end
	if content == "" then
		content = "{}"
	end

	local cwd = vim.fn.getcwd()
	local commands = vim.json.decode(content)
	if command.args ~= "" then
		commands[cwd] = command.args
	end

	if not commands[cwd] then
		print("Set `Make` command with a shell command to execute. Example: `Make cargo build`")
		return
	end


	file = io.open(file_path, 'w')
	if not file then
		print("ERROR: " .. file_path .. " does not exist but it should")
		return
	end

	file:write(vim.json.encode(commands))
	file:close()

	vim.cmd("term " .. commands[cwd])
end, { nargs = "*" }
)
