-- basic settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = false
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.autoindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 600
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.confirm = true
vim.opt.showcmd = true
vim.opt.autoread = true
vim.opt.scrolloff = 10
vim.opt.winborder = 'rounded'
vim.opt.jumpoptions = 'view'
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.sessionoptions:append 'localoptions'

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- basic keymaps
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>ev', ':edit $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>sv', ':source $MYVIMRC<CR>')
vim.keymap.set('i', '<c-\\>', function() end)

-- diagnostics
vim.diagnostic.config({ underline = true, virtual_text = true, })

-- plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end

-- remember last position for files not in a automatic session
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
        if vim.v.this_session == '' then
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end
    end,
})

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
        'tpope/vim-sleuth',
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
        'nvim-mini/mini.nvim',
        config = function()
            require('mini.ai').setup()
            require('mini.surround').setup()
            require('mini.comment').setup()
            require('mini.pairs').setup()
            require('mini.move').setup()
            require('mini.icons').setup()
            require('mini.statusline').setup()
            require('mini.cursorword').setup()
            require('mini.splitjoin').setup()
            require('mini.snippets').setup()
            require('mini.completion').setup()
            require('mini.clue').setup()
            require('mini.indentscope').setup()
            require('mini.visits').setup()
            require('mini.starter').setup()

            local bufremove = require('mini.bufremove')
            bufremove.setup({
                silent = true,
            })
            vim.keymap.set('n', '<C-c>', bufremove.wipeout)

            local jump2d = require('mini.jump2d')
            vim.keymap.set({'n', 'x'}, 's', function() jump2d.start(jump2d.builtin_opts.single_character) end)

            local pick, extra = require('mini.pick'), require('mini.extra')
            pick.setup()
            extra.setup()

            vim.keymap.set('n', '<leader>fl', pick.builtin.resume)
            vim.keymap.set('n', '<leader>fb', pick.builtin.buffers)
            vim.keymap.set('n', '<leader>fg', pick.builtin.grep_live)
            vim.keymap.set('n', '<leader>ff', pick.builtin.files)

            vim.keymap.set('n', '<leader>sD', extra.pickers.diagnostic)
            vim.keymap.set('n', '<leader>sd', function() extra.pickers.diagnostic({ scope = 'current' }) end)

            vim.keymap.set('n', '<leader>fR', function() extra.pickers.visit_paths({ recency_weight = 1, cwd = '' }) end)
            vim.keymap.set('n', '<leader>fr', function()
                extra.pickers.visit_paths({
                    recency_weight = 1,
                    filter = function(data) return vim.startswith(data.path, vim.fs.root(0, '.git') .. '/') end,
                }) 
            end)

            local notify = require('mini.notify')
            notify.setup()
            vim.keymap.set('n', '<leader>n', function()
                pick.start({ source = { items = vim.iter(notify.get_all()):map(function(n) return n.msg end):totable() } })
            end)

            vim.keymap.set('n', 'grd', function() extra.pickers.lsp({ scope = 'definition' }) end)
            vim.keymap.set('n', 'grD', function() extra.pickers.lsp({ scope = 'declaration' }) end)
            vim.keymap.set('n', 'grr', function() extra.pickers.lsp({ scope = 'references' }) end)
            vim.keymap.set('n', 'gri', function() extra.pickers.lsp({ scope = 'implementation' }) end)
            vim.keymap.set('n', 'grt', function() extra.pickers.lsp({ scope = 'type_definition' }) end)
            vim.keymap.set('n', 'gO', function() extra.pickers.lsp({ scope = 'document_symbol' }) end)
            vim.keymap.set('n', 'go', function() extra.pickers.lsp({ scope = 'workspace_symbol_live' }) end)

            local files = require('mini.files')
            files.setup({
                mappings = {
                    go_in  = '<cr>',
                    go_out = '<bs>',
                    reset  = '',
                }
            })
            vim.keymap.set('n', '<leader>e', files.open)

            local keymap = require('mini.keymap')
            keymap.setup()
            keymap.map_multistep('i', '<Tab>',   { 'pmenu_next' })
            keymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
            keymap.map_multistep('i', '<CR>',    { 'pmenu_accept', 'minipairs_cr' })
            keymap.map_multistep('i', '<BS>',    { 'minipairs_bs' })

            local sessions = require('mini.sessions')
            sessions.setup({ autoread = true })

            local function git_session_name()
                local git_root = vim.fs.root(0, '.git')
                -- safe filename (/home/user/projects/skynet -> projects%skynet)
                return git_root and git_root:gsub('[/\\]', '%%')
            end

            vim.api.nvim_create_autocmd('VimEnter', {
                callback = function()
                    if vim.fn.argc() == 0 then
                        local name = git_session_name()
                        if name and sessions.detected[name] then
                            sessions.read(name)
                        elseif name then 
                            sessions.write(name)
                        end
                    end
                end,
            })
        end,
    },

    {
        },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        config = function()
            vim.api.nvim_create_autocmd('FileType', {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if lang and vim.treesitter.language.add(lang) then
                        vim.treesitter.start()
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end
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

            vim.keymap.set('n', 'grf', function() vim.lsp.buf.format() end)
        end,
    },

    {
        'Bekaboo/dropbar.nvim',
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        },
        config = function()
            local dropbar = require('dropbar.api')
            vim.keymap.set('n', '<leader>;', dropbar.pick)
        end
    },

    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-neotest/nvim-nio',
            'nvim-treesitter/nvim-treesitter',
            'nvim-lua/plenary.nvim',
            'fredrikaverpil/neotest-golang',
            'nvim-neotest/neotest-python',
        },
        config = function()
            neotest = require("neotest")
            neotest.setup({
                output = {
                    open_on_run = false,
                },
                adapters = {
                    require('neotest-golang') {
                        runner = 'go',
                        colorize_test_output = true,
                        -- testify_enabled = true,
                        go_test_args = {"-v", "-count=1", "-tags=test"},
                    },
                    require("neotest-python"),
                },
            })

            clear_panel_and_run = function(command)
                neotest.output_panel.clear()
                command()
            end

            vim.keymap.set('n', '<leader>tr', function() clear_panel_and_run(function() neotest.run.run() end) end)
            vim.keymap.set('n', '<leader>tf', function() clear_panel_and_run(function() neotest.run.run(vim.fn.expand('%')) end) end)
            vim.keymap.set('n', '<leader>tl', function() clear_panel_and_run(function() neotest.run.run_last() end) end)
            vim.keymap.set('n', '<leader>tld', function() clear_panel_and_run(function() neotest.run.run_last({strategy = 'dap'}) end) end)
            vim.keymap.set('n', '<leader>td', function() clear_panel_and_run(function() neotest.run.run({strategy = 'dap'}) end) end)
            vim.keymap.set('n', '<leader>te', function() neotest.run.stop() end)
            vim.keymap.set('n', '<leader>to', function() neotest.output.open({ enter = true }) end)
            vim.keymap.set('n', '<leader>tp', function() neotest.output_panel.toggle() end)
            vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end)
        end,
    },

    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            'mfussenegger/nvim-dap',
            'theHamsta/nvim-dap-virtual-text',
            'jay-babu/mason-nvim-dap.nvim',
            'leoluz/nvim-dap-go', -- necessary for neotest-go
        },
        config = function()
            local dap, dapui = require('dap'), require('dapui')

            dapui.setup()
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
            vim.keymap.set('n', '<F6>', function() dap.step_out() end)
            vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
            vim.keymap.set('n', '<leader>de', function() dapui.eval() end)
            vim.keymap.set('n', '<leader>du', function() dapui.toggle({}) end)

            require('nvim-dap-virtual-text').setup()
            require('mason-nvim-dap').setup({
                ensure_installed = {'go', 'python'},
                handlers = {}, -- sets up dap in the predefined manner
            })

            require('dap-go').setup {
                delve = {
                    port = "2345",
                },
                dap_configurations = {
                    {
                        type = "go",
                        name = "Attach remote",
                        mode = "remote",
                        request = "attach",
                    },
                },
            }
        end,
    },
})
