local command = vim.api.nvim_buf_create_user_command

function Trim(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

command(0, "NewClass", function()
	vim.ui.input({ prompt = "New Class Name: " }, function(input)
		if input == nil or Trim(input) == "" then
			return
		end
		local current_file_dir = vim.fn.expand("%:p:h")
		vim.cmd(":e " .. current_file_dir .. "/" .. input .. ".cs" )
	end)
end, {})


function Rename(new_name, opts)
	local path_at_start = vim.fn.expand("%")
	local ts_info = vim.treesitter.get_captures_at_cursor(0)
	local is_class = vim.inspect(ts_info) == '{ "variable", "type" }'
	if is_class then
		vim.lsp.buf.definition()
		local path_with_definition = vim.fn.expand("%")
		local file_name = vim.fn.expand("%:r")
		local class_name = vim.fn.expand("<cword>")
		if file_name == class_name then
			local rename = function(name)
				name = Trim(name)
				-- vim.cmd(":Rename " .. name .. ".cs")
				-- vim.cmd(":LspRestart")
				vim.lsp.buf.rename(name, opts)
			end
			if new_name == nil or Trim(new_name) == "" then
				vim.ui.input({ prompt = "New Name: ", default = class_name, }, function(input)
					if input == nil or Trim(input) == "" then
						return
					end
					rename(input)
				end)
			else
				rename(new_name)
			end
			if path_at_start ~= path_with_definition then
				vim.cmd(":e " .. path_at_start)
			end
		else
			vim.cmd(":e " .. path_at_start)
		end
	else
		vim.lsp.buf.rename(new_name, opts)
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		map("<leader><leader>r", Rename, "[R]ename")
	end,
})
