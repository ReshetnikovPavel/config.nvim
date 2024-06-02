local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.editorconfig = true


vim.g.mapleader = ' '
vim.o.clipboard = 'unnamedplus'
vim.o.undofile = true

vim.cmd [[
 command! W w
 command! Wq wq
 command! WQ wq
]]



vim.keymap.set('n', '<leader>k', function() vim.lsp.inlay_hint(0, nil) end,
    { desc = 'Toggle inlay hints' }
)
-- I had to map this because foot terminal outputs <D-Space> shit for some reason
vim.api.nvim_set_keymap('i', '<D-Space>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<leader>#', ':b#<CR>', {})


vim.api.nvim_create_user_command('CdToFileDir', function()
    local current_file_dir = vim.fn.expand('%:p:h')
    vim.cmd('cd ' .. current_file_dir)
end, {})

vim.api.nvim_create_user_command('Rename', function(data)
    local newFilePath
    if data.args and #data.args > 0 then
        newFilePath = data.args
    else
        newFilePath = vim.fn.input("Enter new file name: ")
        if newFilePath == nil or newFilePath == "" then
            print("Didn't rename file. No new name provided")
            return
        end
    end

    local currentDir = vim.fn.expand('%:p:h')
    if not newFilePath:match("^/") then
        newFilePath = currentDir .. "/" .. newFilePath
    end

    local currentFilePath = vim.fn.expand('%:p')

    if vim.fn.filereadable(newFilePath) == 1 then
        local confirm = vim.fn.confirm("File already exists. Overwrite?", "&Yes\n&No", 2)
        if confirm == 2 then
            return
        elseif confirm == 0 then
            return
        end
    end

    vim.cmd(string.format("saveas! %s", newFilePath))
    if vim.fn.filereadable(currentFilePath) == 1 then
        vim.fn.system(string.format("rm %s", currentFilePath))
    end

    local bufferId = vim.fn.bufnr(currentFilePath)
    if bufferId ~= -1 then
        vim.api.nvim_buf_delete(bufferId, { force = true })
    else
        print("Buffer not found.")
    end
end, { nargs = '?' })


vim.api.nvim_create_user_command('CopyFilePath', function()
    local file_path = vim.fn.expand('%:p')
    vim.fn.setreg('+', file_path)
end, {})

vim.keymap.set('v', '<leader>t', ':!python3 ~/scripts/fix_wrong_layout.py<CR>', {})
vim.keymap.set('n', '<leader>/', ':noh<CR>', {})
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', {})
vim.keymap.set('v', '<leader><Enter>', ':!bash<CR>', {})

local plugins = {
    { 'rose-pine/neovim',                name = 'rose-pine' },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    'natecraddock/workspaces.nvim',

    'stsewd/isort.nvim',

    'Slotos/telescope-lsp-handlers.nvim',

    'numToStr/Comment.nvim',
    'mbbill/undotree',
    'norcalli/nvim-colorizer.lua',
    'aveplen/ruscmd.nvim',
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        "DreamMaoMao/yazi.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },

        keys = {
            { "<leader>y", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
        },
    },
    { "folke/neodev.nvim",    opts = {} },
    'mfussenegger/nvim-dap',
    { 'rcarriga/nvim-dap-ui', dependencies = { 'https://github.com/nvim-neotest/nvim-nio' } },
    'lvimuser/lsp-inlayhints.nvim',
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {                            -- Optional
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.api.nvim_command, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    },
}

local opts = {}
require('lazy').setup(plugins, opts)

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { 'c', 'lua', 'vim', 'python', 'yaml' },
    sync_install = true,
    auto_install = true,
    highlight = {
        enable = true,
        disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },
}


local lsp = require('lsp-zero').preset({})
lsp.on_attach(function(_, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({ buffer = bufnr })
end)
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
lsp.setup()


local cmp = require('cmp')
require('lsp-zero').cmp_action()

cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
    }
})

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {})

require('rose-pine').setup({ disable_italics = false })
vim.cmd('colorscheme rose-pine')
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.cmd(':highlight SignColumn guibg=NONE')

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50

local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

require('workspaces').setup()
telescope.load_extension('workspaces')
vim.keymap.set('n', '<leader>fw', ':Telescope workspaces<CR>', {})

telescope.load_extension('harpoon')
vim.keymap.set('n', '<leader>fh', ':Telescope harpoon marks<CR>', {})
local mark = require('harpoon.mark')
local ui = require('harpoon.ui')
vim.keymap.set('n', '<leader>a', mark.add_file)
vim.keymap.set('n', '<leader>h', ui.toggle_quick_menu)
vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end)
vim.keymap.set('n', '<C-j>', function() ui.nav_file(2) end)
vim.keymap.set('n', '<C-k>', function() ui.nav_file(3) end)
vim.keymap.set('n', '<C-l>', function() ui.nav_file(4) end)

require 'telescope-lsp-handlers'.setup()

require 'yazi'
-- local smart_splits = require('smart-splits')
--
-- vim.keymap.set('n', '<A-C-h>', smart_splits.resize_left)
-- vim.keymap.set('n', '<A-C-j>', smart_splits.resize_down)
-- vim.keymap.set('n', '<A-C-k>', smart_splits.resize_up)
-- vim.keymap.set('n', '<A-C-l>', smart_splits.resize_right)
--
-- vim.keymap.set('n', '<A-h>', smart_splits.move_cursor_left)
-- vim.keymap.set('n', '<A-j>', smart_splits.move_cursor_down)
-- vim.keymap.set('n', '<A-k>', smart_splits.move_cursor_up)
-- vim.keymap.set('n', '<A-l>', smart_splits.move_cursor_right)
--
-- vim.keymap.set('n', '<leader><leader>h', smart_splits.swap_buf_left)
-- vim.keymap.set('n', '<leader><leader>j', smart_splits.swap_buf_down)
-- vim.keymap.set('n', '<leader><leader>k', smart_splits.swap_buf_up)
-- vim.keymap.set('n', '<leader><leader>l', smart_splits.swap_buf_right)
--
-- vim.keymap.set('n', '<leader>V','<CMD>split<CR>')
-- vim.keymap.set('n', '<leader>H','<CMD>vertical split<CR>')

require('Comment').setup()

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.hypr = {
    install_info = {
        url = "https://github.com/luckasRanarison/tree-sitter-hypr",
        files = { "src/parser.c" },
        branch = "master",
    },
    filetype = "hypr",
}

require('colorizer').setup()
require('ruscmd').setup {}

local on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            on_attach = on_attach,
        }
    end,
}

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


local dap = require('dap')
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
    name = 'lldb'
}
dap.configurations.cpp = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
    -- ...
})
require("dapui").setup()
require("lsp-inlayhints").setup()
-- vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = "LspAttach_inlayhints",
--   callback = function(args)
--     if not (args.data and args.data.client_id) then
--       return
--     end
--
--     local bufnr = args.buf
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     require("lsp-inlayhints").on_attach(client, bufnr)
--   end,
-- })
vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { "*.hl", "hypr*.conf" },
    callback = function(event)
        print(string.format("starting hyprls for %s", vim.inspect(event)))
        vim.lsp.start {
            name = "hyprlang",
            cmd = { "/home/pavelresh/go/bin/hyprls" },
            root_dir = vim.fn.getcwd(),
        }
    end
})
