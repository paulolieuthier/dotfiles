"
" my .vimrc :D
"

set nocompatible
set shell=/usr/bin/bash

" install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

filetype off
call plug#begin('~/.config/nvim/bundle')

" colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sainnhe/gruvbox-material'

" helpers
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'mg979/vim-visual-multi'

" ide
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'w0rp/ale'
Plug 'SirVer/ultisnips'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fannheyward/telescope-coc.nvim'

" misc
Plug 'christoomey/vim-tmux-navigator'
Plug 'airblade/vim-gitgutter'
Plug 'moll/vim-bbye'
Plug 'psliwka/vim-smoothie'

" languages
Plug 'udalov/kotlin-vim'
Plug 'pedrohdz/vim-yaml-folds'

call plug#end()

filetype plugin indent on
syntax on
set noshowmode
set cmdheight=2
set showcmd
set backspace=eol,start,indent
set cursorline
set cursorcolumn
set wildmenu
set wildmode=longest,list:longest,full
set ruler
set ignorecase
set smartcase
set infercase
set hlsearch
set incsearch
set showmatch
set nostartofline
set nonumber
set autoindent
set nobackup
set nowritebackup
set noswapfile
set scrolloff=5
set hidden
set noerrorbells
set novisualbell
set signcolumn=yes
set expandtab
set smarttab
set shiftwidth=0
set tabstop=4
set laststatus=2
set cmdheight=2
set t_Co=256
set shortmess+=c
set completeopt=menu,menuone,preview,noinsert,noselect
set clipboard=unnamedplus
set updatetime=300
set fileformats=unix
set list
set listchars=tab:│\ ,trail:-,extends:>,precedes:<
set encoding=utf-8
set mouse=a
set foldmethod=syntax
set nofoldenable

" colors
set termguicolors
let g:gruvbox_material_background='hard'
let g:gruvbox_material_cursor='green'
let g:gruvbox_material_enable_bold=1
let g:gruvbox_material_enable_italic=1
let g:gruvbox_material_transparent_background=1
colorscheme gruvbox-material

if has("nvim")
    set inccommand=nosplit
endif

if has("gui_running")
    " remove menus and toolbars
    set guioptions-=m
    set guioptions-=g
    set guioptions-=t
    set guioptions-=T

    " remove scrollbars
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    set guioptions-=b

    " remove clipboard autoselection
    set guioptions-=a
    set guioptions-=A

    " console dialogs
    set guioptions+=c
endif

" basic mappings
noremap ; :
noremap j gj
noremap k gk

" user space as leader key
let mapleader="\<space>"
let g:mapleader="\<space>"

" listen to Alt keys
if !has('nvim')
    let c = 'a'
    while c <= 'z'
        exec "set <a-" . c . ">=\e" . c
        exec "imap \e" . c . " <a-" . c . ">"
        let c = nr2char(1 + char2nr(c))
    endw
end

" easily move between splits
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <leader>wc <c-w>c

" easily create splits
nnoremap <leader>sv :vsp<cr>
nnoremap <leader>sh :sp<cr>

" switch between files in buffer
nmap <a-l> :bn<cr>
nmap <a-h> :bp<cr>

" don't close buffer on :bd if it's displayed more than once
let bclose_multiple = 0

" remove search highlight
nnoremap <silent><leader>n :noh<cr>

" useful for keeping sanity
cab W! w!
cab Q! q!
cab Wq wq
cab Wa wa
cab wQ wq
cab WQ wq
cab W w
cab Q q
cab E e
map q: :q

" save with sudo
cmap w!! w !sudo tee > /dev/null %

" diffing
nnoremap <leader>do :diffget<cr>
nnoremap <leader>dp :diffput<cr>

" don't lose selection when shifting sidewards
xnoremap < <gv
xnoremap > >gv

" edit and source .vimrc easily
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>lv :so $MYVIMRC<CR>

" create necessary directories on saving files
augroup vimrc-auto-mkdir
    autocmd!
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    function! s:auto_mkdir(dir, force)
        if !isdirectory(a:dir)
                    \   && (a:force
                    \       || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
            call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
        endif
    endfunction
augroup END

" don't yank to default register when changing something
nnoremap c "xc
xnoremap c "xc

" don't copy over-pasted text in visual mode
xnoremap p "_s<c-r>+<esc>
xnoremap P "_s<c-r>+<esc>

" different settings for some file types
autocmd FileType json,javascript,typescript setlocal tabstop=2
autocmd FileType yml,yaml setlocal tabstop=2 indentkeys-=<:> foldmethod=indent
autocmd FileType go setlocal tabstop=4 noexpandtab

augroup TerminalMappings
  autocmd!
  if has('nvim')
    autocmd TermOpen * nnoremap <buffer> <C-c> i
  endif
augroup END

"
" plugins
"

" Tree Sitter
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  indent = { enable = true },
  highlight = { enable = true },
}
EOF

" vim-bbye: close buffer without closing split view
nnoremap <silent><c-c> :Bdelete<cr>

" nvim-tree
nnoremap <silent><expr> <a-1> &filetype == 'NvimTree' ? ":NvimTreeClose\<cr>" : ":NvimTreeFocus\<cr>"
nnoremap <silent> <leader>nc <cmd>NvimTreeFindFile<cr>
lua <<EOF
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  require("nvim-tree").setup {
    view = {
      adaptive_size = true,
      mappings = {
        list = {
          { key = "u", action = "dir_up" },
        },
      },
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
  }
EOF

" telescope
nnoremap <silent> <leader>pf <cmd>Telescope find_files<cr>
nnoremap <silent> <leader>pg <cmd>Telescope live_grep<cr>
nnoremap <silent> <leader>pb <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>pr <cmd>Telescope oldfiles<cr>
nnoremap <silent> <leader>pt <cmd>Telescope file_browser<cr>
nnoremap <silent> <leader>pp <cmd>Telescope pickers<cr>

lua <<EOF
require('telescope').setup {
    defaults = {
        cache_picker = {
            num_pickers = -1
        },
        file_ignore_patterns = { "node_modules" }
    }
}
EOF

" airline
let g:airline_theme = 'gruvbox_material'

" ag
let g:ag_working_path_mode="r" 

" ale
let g:ale_fix_on_save = 1

"
" coc
"

nnoremap <silent> gd <cmd>Telescope coc definitions<cr>
nnoremap <silent> gt <cmd>Telescope coc type_definitions<cr>
nnoremap <silent> gi <cmd>Telescope coc implementations<cr>
nnoremap <silent> gr <cmd>Telescope coc references<cr>
nnoremap <silent> gs <cmd>Telescope coc document_symbols<cr>
nnoremap <silent> gS <cmd>Telescope coc workspace_symbols<cr>
nnoremap <silent> ge <cmd>Telescope coc diagnostics<cr>
nnoremap <silent> gE <cmd>Telescope coc workspace_diagnostics<cr>

" highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" symbol renaming.
nmap <leader>rr <Plug>(coc-rename)

" use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" show signature help
inoremap <silent><c-k> <c-o>:call CocActionAsync('showSignatureHelp')<cr>

" remap keys for applying codeAction to the current buffer.
nmap <leader>ac <Plug>(coc-codeaction)

" apply AutoFix to problem on the current line.
nmap <leader>qf <Plug>(coc-codeaction-line)
