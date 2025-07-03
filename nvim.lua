-- basic settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.number = false
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.confirm = true
vim.o.showcmd = true
vim.o.scrolloff = 10
vim.o.winborder = 'rounded'
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.schedule(function()
	vim.o.clipboard = 'unnamedplus'
end)

-- basic keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')
vim.keymap.set('n', '<leader>ev', ':edit $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>sv', ':source $MYVIMRC<CR>')

-- diagnostics
vim.diagnostic.config({ underline = true, virtual_text = true, })
vim.keymap.set('n', '<c-w>d', function() vim.diagnostic.open_float({ border = 'rounded' }) end)

-- plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- plugins
require('lazy').setup({
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        config = function()
            require('catppuccin').setup({
                flavour = 'macchiato',
                transparent_background = true,
            })
            vim.cmd.colorscheme('catppuccin')
        end
    },

	{
		'folke/lazydev.nvim',
		ft = 'lua',
		opts = {}
	},

	{
		'echasnovski/mini.nvim',
		config = function()
			require('mini.ai').setup { n_lines = 500 }
			require('mini.surround').setup()
			require('mini.comment').setup()
			require('mini.pairs').setup()
            require('mini.move').setup()
            require('mini.icons').setup()
            require('mini.statusline').setup()
		end,
	},

	{
		'folke/snacks.nvim',
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			explorer = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			words = { enabled = true },
		},
        keys = {
            { "<leader>:",  function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<leader>n",  function() Snacks.picker.notifications() end, desc = "Notification History" },
            { "<leader>e",  function() Snacks.explorer() end, desc = "File Explorer" },

            { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
            { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
            { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
            { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
            { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
            { "<leader>pf", function() Snacks.picker.git_files() end, desc = "Find Git Files" },

            { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
            { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
            { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics" },
            { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Buffer Diagnostics" },

            { "grd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
            { "grD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
            { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
            { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
            { "grt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
            { "gO", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
            { "go", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

            { "<C-c>",  function() Snacks.bufdelete() end, desc = "Close buffer" },
            { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
            { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
            { "<leader>bd",  function() Snacks.bufdelete() end, desc = "Delete Buffer" },
            { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
            { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
            { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
        },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs',
        opts = {
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'mason-org/mason-lspconfig.nvim',
        },
        config = function()
            require('mason-lspconfig').setup {
                ensure_installed = {},
                automatic_enable = true,
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup()
                    end,
                },
            }
        end,
    },

    {
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                version = '2.*',
                dependencies = {
                    -- `friendly-snippets` contains a variety of premade snippets.
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
                opts = {},
            },
            'folke/lazydev.nvim',
        },
        opts = {
            keymap = { preset = 'enter' },
            completion = {
                list = { selection = { preselect = false } },
                documentation = { auto_show = true, auto_show_delay_ms = 500 }
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'lazydev' },
                providers = {
                    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                },
            },
            snippets = { preset = 'luasnip' },
            fuzzy = { implementation = 'lua' },
            ghost_text = { enabled = true },
            signature = { enabled = true },
        },
    },
})
