-- basic settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.number = false
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 600
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.confirm = true
vim.o.showcmd = true
vim.o.scrolloff = 10
vim.o.winborder = 'rounded'
vim.o.jumpoptions = 'view'
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.schedule(function()
	vim.o.clipboard = 'unnamedplus'
end)

-- basic keymaps
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
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

vim.opt.rtp:prepend(lazypath)

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
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>" },
            { "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>" },
            { "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>" },
            { "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>" },
            { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<CR>" },
        },
    },

	{
		'echasnovski/mini.nvim',
		config = function()
            local brackets = {
                ['('] = { '(', ')' },
                ['['] = { '[', ']' },
                ['{'] = { '{', '}' },
                ['<'] = { '<', '>' },
            }
            require('mini.surround').setup({
                -- custom surrounding mapping to add newlines
                custom_surroundings = {
                    ['n'] = {
                        output = function()
                            local id = vim.fn.getcharstr()
                            local left, right = unpack(brackets[id])
                            local indent = vim.api.nvim_get_current_line():match('^%s*')
                            local sw = vim.bo.shiftwidth
                            local tab_text = vim.bo.expandtab and string.rep(' ', sw == 0 and vim.bo.tabstop or sw) or '\t'
                            return { left = left .. '\n' .. indent .. tab_text, right = '\n' .. indent .. right }
                        end,
                    },
                }
            })
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
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        keys = {
            -- load the session for the current directory
            { "<leader>qs", function() require("persistence").load() end },
            -- select a session to load
            { "<leader>qS", function() require("persistence").select() end },
            -- load the last session
            { "<leader>ql", function() require("persistence").load({ last = true }) end },
        },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        opts = {
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
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
                inlay_hints = { enabled = true },
            }

            vim.lsp.config('gopls', {
                settings = {
                    ['gopls'] = {
                        buildFlags = { '-tags=test' },
                        hints = { parameterNames = true, },
                        analyses = { unusedparams = true, },
                        staticcheck = true,
                        gofumpt = true,
                    }
                }
            })
        end,
    },

    {
        'filipdutescu/renamer.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        opts = {},
        keys = {
            { "<leader>rn", function() require('renamer').rename() end, desc = "Rename variable" },
        },
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
            signature = { enabled = true },
        },
    },

    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-neotest/nvim-nio',
            'nvim-treesitter/nvim-treesitter',
            'fredrikaverpil/neotest-golang',
        },
        config = function()
            require('neotest').setup({
                adapters = {
                    require('neotest-golang') {
                        runner = 'gotestsum',
                        testify_enabled = true,
                    },
                },
            })
        end,
    },

    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            'mfussenegger/nvim-dap',
            'theHamsta/nvim-dap-virtual-text',
            'leoluz/nvim-dap-go',
        },
        config = function()
            local dap, dapui = require('dap'), require('dapui')

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            vim.keymap.set('n', '<F5>', function() dap.continue() end)
            vim.keymap.set('n', '<F8>', function() dap.step_over() end)
            vim.keymap.set('n', '<F7>', function() dap.step_into() end)
            vim.keymap.set('n', '<F8>', function() dap.step_out() end)
            vim.keymap.set('n', '<M-b>', function() dap.toggle_breakpoint() end)
            vim.keymap.set('n', '<M-e>', function() dapui.eval() end)

            require('nvim-dap-virtual-text').setup()
            require('dap-go').setup()
        end,
    },
})
