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

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- basic keymaps
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '<esc>', vim.cmd.nohlsearch)
vim.keymap.set('n', '<leader>ev', function() vim.cmd.edit('$MYVIMRC') end)
vim.keymap.set('n', '<leader>r', vim.cmd.restart)
vim.keymap.set('i', '<c-\\>', function() end)
vim.keymap.set('n', 'grf', vim.lsp.buf.format)

-- diagnostics
vim.diagnostic.config({ underline = true, virtual_text = true, })

-- remember last position for files (works for files outside sessions)
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- plugins
vim.pack.add({
    { src = 'https://github.com/folke/lazy.nvim.git', name = 'lazy' }
}, { confirm = false })
require('lazy').bootstrap()
require('lazy').setup({
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        config = function()
            require('catppuccin').setup({ transparent_background = true })
            vim.cmd.colorscheme('catppuccin')
        end
    },

    {
        'tpope/vim-sleuth',
    },

    {
        'christoomey/vim-tmux-navigator',
        cmd = {
            'TmuxNavigateLeft',
            'TmuxNavigateDown',
            'TmuxNavigateUp',
            'TmuxNavigateRight',
        },
        keys = {
            { '<C-h>', '<cmd><C-U>TmuxNavigateLeft<CR>' },
            { '<C-j>', '<cmd><C-U>TmuxNavigateDown<CR>' },
            { '<C-k>', '<cmd><C-U>TmuxNavigateUp<CR>' },
            { '<C-l>', '<cmd><C-U>TmuxNavigateRight<CR>' },
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
            require('mini.cmdline').setup()
            require('mini.indentscope').setup()
            require('mini.visits').setup()
            require('mini.hipatterns').setup()
            require('mini.operators').setup()

            local trailspace = require('mini.trailspace')
            trailspace.setup()
            vim.api.nvim_create_autocmd('BufWritePre', {
                callback = function()
                    trailspace.trim()
                    trailspace.trim_last_lines()
                end,
            })

            local bufremove = require('mini.bufremove')
            bufremove.setup({ silent = true })
            vim.keymap.set('n', '<c-c>', bufremove.wipeout)

            local jump2d = require('mini.jump2d')
            vim.keymap.set({'n', 'x'}, 's', function()
                jump2d.start(jump2d.builtin_opts.single_character)
            end)

            local pick, extra = require('mini.pick'), require('mini.extra')
            pick.setup()
            extra.setup()

            vim.keymap.set('n', '<leader>fl', pick.builtin.resume)
            vim.keymap.set('n', '<leader>fb', pick.builtin.buffers)
            vim.keymap.set('n', '<leader>fg', pick.builtin.grep_live)
            vim.keymap.set('n', '<leader>ff', pick.builtin.files)

            vim.keymap.set('n', '<leader>sD', extra.pickers.diagnostic)
            vim.keymap.set('n', '<leader>sd', function()
                extra.pickers.diagnostic({ scope = 'current' })
            end)

            vim.keymap.set('n', '<leader>fR', function()
                extra.pickers.visit_paths({ recency_weight = 1, cwd = '' })
            end)
            vim.keymap.set('n', '<leader>fr', function()
                extra.pickers.visit_paths({
                    recency_weight = 1,
                    filter = function(data)
                        return vim.startswith(data.path, vim.fs.root(0, '.git') .. '/')
                    end,
                })
            end)

            local notify = require('mini.notify')
            notify.setup()
            vim.keymap.set('n', '<leader>n', function()
                pick.start({
                    source = {
                        name = 'Notifications',
                        items = vim.iter(notify.get_all())
                            :map(function(n) return n.msg end)
                            :totable()
                    }
                })
            end)

            local lsp = function(scope)
                return function()
                    local cur = vim.api.nvim_win_get_cursor(0)
                    vim.api.nvim_create_autocmd('User', {
                        pattern = 'MiniPickStart',
                        once = true,
                        callback = function(args)
                            -- filter out element under cursor
                            local opts = pick.get_picker_opts()
                            local filtered = vim.iter(opts.source.items):filter(function(item)
                                local row, col = cur[1], cur[2] + 1
                                return row < item.lnum or row > item.end_lnum or col < item.col or col > item.end_col
                            end):totable()
                            pick.set_picker_items(filtered)

                            -- choose element if it's the only one
                            vim.schedule(function()
                                if #filtered > 1 then return end
                                pick.stop()
                                if #filtered ~= 1 then return end
                                opts.source.choose(filtered[1])
                            end)
                        end,
                    })
                    extra.pickers.lsp({ scope = scope })
                end
            end
            vim.keymap.set('n', 'grd', lsp('definition'))
            vim.keymap.set('n', 'grD', lsp('declaration'))
            vim.keymap.set('n', 'grr', lsp('references'))
            vim.keymap.set('n', 'gri', lsp('implementation'))
            vim.keymap.set('n', 'grt', lsp('type_definition'))
            vim.keymap.set('n', 'gO', lsp('document_symbol'))
            vim.keymap.set('n', 'go', lsp('workspace_symbol'))

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
            keymap.map_multistep('i', '<BS>',    { 'hungry_bs', 'minipairs_bs' })
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
        'olimorris/persisted.nvim',
        config = function()
            local persisted = require('persisted')
            persisted.setup({ autoload = true })
            vim.keymap.set('n', '<leader>qs', function() persisted.select() end)
            vim.keymap.set('n', '<leader>ql', function() persisted.load({ last = true }) end)
        end
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

        end,
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
            neotest = require('neotest')
            neotest.setup({
                output = {
                    open_on_run = false,
                },
                adapters = {
                    require('neotest-golang') {
                        runner = 'go',
                        colorize_test_output = true,
                        -- testify_enabled = true,
                        go_test_args = {'-v', '-count=1', '-tags=test'},
                    },
                    require('neotest-python'),
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
            dap.listeners.before.attach.dapui_config = dapui.open
            dap.listeners.before.launch.dapui_config = dapui.open
            dap.listeners.before.event_terminated.dapui_config = dapui.close
            dap.listeners.before.event_exited.dapui_config = dapui.close

            vim.keymap.set('n', '<F5>', dap.continue)
            vim.keymap.set('n', '<F8>', dap.step_over)
            vim.keymap.set('n', '<F7>', dap.step_into)
            vim.keymap.set('n', '<F6>', dap.step_out)
            vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
            vim.keymap.set('n', '<leader>de', dapui.eval)
            vim.keymap.set('n', '<leader>du', dapui.toggle)

            require('nvim-dap-virtual-text').setup()
            require('mason-nvim-dap').setup({
                ensure_installed = {'go', 'python'},
                handlers = {}, -- sets up dap in the predefined manner
            })

            require('dap-go').setup {
                delve = {
                    port = '2345',
                },
                dap_configurations = {
                    {
                        type = 'go',
                        name = 'Attach remote',
                        mode = 'remote',
                        request = 'attach',
                    },
                },
            }
        end,
    },
})
