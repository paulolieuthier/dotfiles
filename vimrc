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
call plug#begin('~/.vim/bundle')

" colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes'

" helpers
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-update-rc' }
Plug 'junegunn/fzf.vim'

" ide
Plug 'airblade/vim-rooter'
Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'SirVer/ultisnips'
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'numkil/ag.nvim'

" misc
Plug 'easymotion/vim-easymotion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-commentary'
Plug 'matze/vim-move'
Plug 'moll/vim-bbye'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'airblade/vim-gitgutter'

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
set nonumber
set autoindent
set nobackup
set nowritebackup
set nowb
set noswapfile
set scrolloff=5
set background=dark
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
set list
set fileformats=unix
set listchars=tab:>-,trail:·,extends:>,precedes:<,space:·,nbsp:·
set encoding=utf-8
set guifont=Fira\ Code\ 12
colo gruvbox

set mouse=a

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

" always set the current file directory as the local current directory
autocmd BufEnter * silent! lcd %:p:h

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

" centralize screen on jumping
noremap n nzz
noremap N Nzz
noremap <c-d> <c-d>zz
noremap <c-u> <c-u>zz

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
autocmd FileType json,javascript setlocal tabstop=2
autocmd FileType yml,yaml setlocal tabstop=2
autocmd FileType go setlocal tabstop=4 noexpandtab

"
" plugins
"

" rooter
let g:rooter_change_directory_for_non_project_files = 'current'

" easymotion
nnoremap <leader>j <plug>(easymotion-prefix)

" vim-bbye: close buffer without closing split view
nnoremap <silent><c-c> :Bdelete<cr>

" nerdtree: open/focus or hide
nnoremap <silent><expr> <a-1> winnr()==g:NERDTree.GetWinNum() ? ":NERDTreeClose\<cr>" : ":NERDTreeFocus\<cr>"

" ctrlp
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['.git'] 
let g:ctrlp_mruf_relative = 1 
nnoremap <leader>pf :CtrlPMixed<cr>
nnoremap <leader>pr :CtrlPMRU<cr>

" airline
let g:airline_theme = 'base16'

" ag
let g:ag_working_path_mode="r" 

" ale
let g:ale_fix_on_save = 1

"
" COC
"

" fuzzy commands
nnoremap <leader><space> :CocList<cr>

" tabs and completion
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-Tab> pumvisible() ? "\<c-p>" : "\<c-h>"
inoremap <silent><expr><c-space> coc#refresh()
inoremap <expr><cr> complete_info()["selected"] != "-1" ? "\<c-y>" : "\<c-g>u\<cr>"

" gotos
nmap <silent>gd <plug>(coc-definition)
nmap <silent>gy <plug>(coc-type-definition)
nmap <silent>gi <plug>(coc-implementation)
nmap <silent>gr <plug>(coc-references)

" show documentation in preview window
nnoremap <silent> K :call <sid>show_documentation()<cr>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" show completion hint
inoremap <silent><c-\> <c-o>:call CocActionAsync('showSignatureHelp')<cr>

" remap for rename current word or rename locally in visual mode
nnoremap <leader>rr <plug>(coc-rename)
vnoremap <leader>rr y:%s/<c-r>"/<c-r>"

" remap for format selected region
xmap <leader>f <plug>(coc-format-selected)
nmap <leader>f <plug>(coc-format-selected)

" codeaction for current line
nmap <leader>ac <plug>(coc-codeaction)

" autofix for current line
nmap <leader>qf <plug>(coc-fix-current)

" add status line support, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
