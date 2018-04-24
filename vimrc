"
" My .vimrc :D
"

set nocompatible
set shell=/usr/bin/bash
filetype off
call plug#begin('~/.vim/bundle')

" File management
Plug 'kien/ctrlp.vim'
Plug 'numkil/ag.nvim'

" Colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes'

" Compilation
Plug 'benekastah/neomake'
Plug 'vim-scripts/SingleCompile'

" Helpers
Plug 'majutsushi/tagbar'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'cohama/lexima.vim'
Plug 'tpope/vim-surround'

" Completion/IDE
Plug 'Valloric/YouCompleteMe'

" Languages
Plug 'othree/yajs.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rust-lang/rust.vim'
Plug 'tinco/haskell.vim'

" Misc
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-commentary'
Plug 'matze/vim-move'
Plug 'moll/vim-bbye'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'airblade/vim-gitgutter'

call plug#end()

filetype plugin indent on
syntax on
set backspace=eol,start,indent
set cursorline
set cursorcolumn
set wildmenu
set wildmode=longest,list:longest
set ruler
set ignorecase
set smartcase
set infercase
set hlsearch
set incsearch
set showmatch
set number
set autoindent
set nobackup
set nowb
set noswapfile
set scrolloff=5
set background=dark
set hid
set noerrorbells
set novisualbell
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set inccommand=nosplit
set laststatus=2
set t_Co=256
set completeopt=menu
set clipboard=unnamedplus
set autochdir
set list
set listchars=tab:>-,trail:·,extends:>,precedes:<,space:·,nbsp:·
set encoding=utf-8
set guifont=Fira\ Code\ 12
colo gruvbox

set mouse=a

if has("gui_running")
    " Remove menus and toolbars
    set guioptions-=m
    set guioptions-=g
    set guioptions-=t
    set guioptions-=T

    " Remove scrollbars
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    set guioptions-=b

    " Remove autoselection
    "set guioptions-=a
    "set guioptions-=A

    " Console dialogs
    set guioptions+=c
endif

" Listen to Alt keys
if !has('nvim')
    let c = 'a'
    while c <= 'z'
        exec "set <A-" . c . ">=\e" . c
        exec "imap \e" . c . " <A-" . c . ">"
        let c = nr2char(1 + char2nr(c))
    endw
end

" User space as leader key
let mapleader="\<Space>"
let g:mapleader="\<Space>"

" Easily move between splits
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
noremap <leader>wc <C-w>c

" Easily create splits
nnoremap <leader>sv :vsp<CR>
nnoremap <leader>sh :sp<CR>

" Switch between files in buffer
nmap <C-Tab> :bn<CR>
nmap <A-l> :bn<CR>
nmap <C-S-Tab> :bp<CR>
nmap <A-h> :bp<CR>

" Don't close buffer on :bd if it's displayed more than once
let bclose_multiple = 0

" Always set the current file directory as the local current directory
autocmd BufEnter * silent! lcd %:p:h

" Basic mappings
noremap ; :
inoremap jk <Esc>
noremap j gj
noremap k gk

" Remove search highlight
noremap <Leader>n :noh<CR>

" Enable C-BS
imap <C-BS> <C-w>

" Accepting case errors
cab W! w!
cab Q! q!
cab Wq wq
cab Wa wa
cab wQ wq
cab WQ wq
cab W w
cab Q q
cab E e

" Save with sudo
cmap w!! w !sudo tee > /dev/null %

" Centralize screen on jumping
noremap n nzz
noremap N Nzz
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

" Vimdiff
nnoremap <leader>do :diffget<CR>
nnoremap <leader>dp :diffput<CR>

" Don't lose selection when shifting sidewards
xnoremap < <gv
xnoremap > >gv

" Exit terminal mode with ,ESC
if has('nvim')
    tnoremap jk <C-\><C-n>
end

" Edit and source .vimrc easily
noremap <leader>ev :e $MYVIMRC<CR>
noremap <leader>lv :so $MYVIMRC<CR>

" Create necessary directories on saving files
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

" Don't yank to default register when changing something
nnoremap c "xc
xnoremap c "xc

" After block yank and paste, move cursor to the end of operated text
" Also, don't copy over-pasted text in visual mode
vnoremap y y`]
nnoremap p p`]
vnoremap p "_dP`]

" Easily replace the current word and all its occurrences.
nnoremap <Leader>rr :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>rr y:%s/<C-r>"/<C-r>"

" No more accidentally showing up command window (Use C-f to show it)
map q: :q

" Omnicomplete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Custom tab size
autocmd FileType json,javascript setlocal tabstop=2 shiftwidth=2
autocmd FileType yml,yaml setlocal tabstop=2 shiftwidth=2

"""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""

" vim-bbye: close buffer without closing split view
nnoremap <C-c> :Bdelete<CR>

" SingleCompile
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
nnoremap <leader>pf :CtrlP<CR>
nnoremap <leader>pr :CtrlPMRUFiles<CR>

" Airline
"let g:rehash256 = 1
let g:airline_theme = 'base16'

" Ultisnips
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

" Ag
let g:ag_working_path_mode="r" 

" Language Client
"let g:LanguageClient_serverCommands = { 'cpp': ['clangd'] }
