return {
	'saghen/blink.cmp',
	dependencies = { 'rafamadriz/friendly-snippets' },

	-- use a release tag to download pre-built binaries
	version = '1.*',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = 'default',
			['<Tab>'] = { 'select_and_accept', 'fallback' },
			['<S-Tab>'] = { 'cancel', 'fallback' },
			['<C-j>'] = { 'select_next', 'fallback' },
			['<C-k>'] = { 'select_prev', 'fallback' },
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = 'mono'
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			documentation = { auto_show = true },
			list = { selection = { preselect = false, auto_insert = true } },
			menu = { draw = { treesitter = { 'lsp' } } }
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		-- sources = {
		-- 	default = { 'lsp', 'path', 'snippets', 'buffer' },
		-- },

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
		signature = { enabled = true },

		cmdline = {
			keymap = {
				preset = 'inherit',
				['<Tab>'] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.accept()
						else
							return cmp.show_and_insert()
						end
					end,
				}
			},
			sources = { 'buffer', 'cmdline' },
			completion = {
				trigger = {
					show_on_blocked_trigger_characters = {},
					show_on_x_blocked_trigger_characters = {},
				},
				list = {
					selection = {
						-- When `true`, will automatically select the first item in the completion list
						preselect = true,
						-- When `true`, inserts the completion item automatically when selecting it
						auto_insert = true,
					},
				},
				-- Whether to automatically show the window when new completion items are available
				-- Default is false for cmdline, true for cmdwin (command-line window)
				menu = { auto_show = function(ctx, _) return ctx.mode == 'cmdwin' end },
				-- Displays a preview of the selected item on the current line
				ghost_text = { enabled = true },
			}
		}
	},
	opts_extend = { "sources.default" }
}
