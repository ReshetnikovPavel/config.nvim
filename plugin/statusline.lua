local function separate()
	return "        "
end


local function filepath()
	local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.")
	if fpath == "" or fpath == "." then
		return " "
	end

	return string.format("%%<%s", fpath)
end

local function diagnostics()
	local current_buffer_count = {}
	local all_buffers_count = {}
	local levels = {
		errors = "Error",
		warnings = "Warn",
		info = "Info",
		hints = "Hint",
	}

	for k, level in pairs(levels) do
		current_buffer_count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
		all_buffers_count[k] = vim.tbl_count(vim.diagnostic.get(nil, { severity = level }))
	end

	local errors = ""
	local warnings = ""
	local hints = ""
	local info = ""

	if all_buffers_count["errors"] ~= 0 then
		errors = " E " .. current_buffer_count["errors"] .. "/" .. all_buffers_count["errors"]
	end
	if all_buffers_count["warnings"] ~= 0 then
		warnings = " W " .. current_buffer_count["warnings"] .. "/" .. all_buffers_count["warnings"]
	end
	if all_buffers_count["hints"] ~= 0 then
		hints = " H " .. current_buffer_count["hints"] .. "/" .. all_buffers_count["hints"]
	end
	if all_buffers_count["info"] ~= 0 then
		info = " I " .. current_buffer_count["info"] .. "/" .. all_buffers_count["info"]
	end

	return errors .. warnings .. hints .. info
end

local function lineinfo()
	if vim.bo.filetype == "alpha" then
		return ""
	end
	return "%l,%c" .. separate() .. "%P"
end

Statusline = {}

Statusline.active = function()
	return table.concat {
		filepath(),
		"%=%#StatusLineExtra#",
		diagnostics(),
		separate(),
		lineinfo(),
	}
end

function Statusline.inactive()
	return "%F"
end

vim.cmd([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  augroup END
]], false)

