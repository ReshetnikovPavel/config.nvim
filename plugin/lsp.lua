local builtin = require("telescope.builtin")
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
		map("gr", builtin.lsp_references, "[G]oto [R]eferences")
		map("gi", builtin.lsp_implementations, "[G]oto [I]mplementation")
		map("gt", builtin.lsp_type_definitions, "[G]oto [T]ype")
		map("<leader>r", vim.lsp.buf.rename, "[R]ename")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("<leader>d", builtin.diagnostics, "[D]iagnostics")

		map("<leader>tt", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
		end, "Toggle inlay hints")

		vim.api.nvim_buf_create_user_command(event.buf, "Format", function(_)
			require("conform").format({ bufnr = event.buf, lsp_fallback = true })
		end, { desc = "Format current buffer with Conform" })
	end,
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

local default_setup = function(server)
	require("lspconfig")[server].setup({
		capabilities = lsp_capabilities,
	})
end

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {},
	handlers = {
		default_setup,
		lua_ls = function()
			require("lspconfig").lua_ls.setup({
				capabilities = lsp_capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					},
				},
			})
			require("lspconfig").omnisharp.setup({
				capabilities = lsp_capabilities,
				settings = {
					csharp = {
						inlayHints = {
							enableInlayHintsForImplicitObjectCreation = true,
							enableInlayHintsForImplicitVariableTypes = true,
							enableInlayHintsForLambdaParameterTypes = true,
							enableInlayHintsForTypes = true,
							enableInlayHintsForIndexerParameters = true,
							enableInlayHintsForLiteralParameters = true,
							enableInlayHintsForObjectCreationParameters = true,
							enableInlayHintsForOtherParameters = true,
							enableInlayHintsForParameters = true,
							suppressInlayHintsForParametersThatDifferOnlyBySuffix = true,
							suppressInlayHintsForParametersThatMatchArgumentName = true,
							suppressInlayHintsForParametersThatMatchMethodIntent = true,
						},
					},
				},
			})
		end,
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
	},
})
