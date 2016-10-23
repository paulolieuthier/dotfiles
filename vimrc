"
" My .vimrc :D
"

set nocompatible
set shell=/usr/bin/bash
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Plugins:
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'flazz/vim-colorschemes'
Plugin 'benekastah/neomake'
Plugin 'vim-scripts/SingleCompile'
Plugin 'majutsushi/tagbar'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'cohama/lexima.vim'
Plugin 'moll/vim-bbye'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'othree/yajs.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'rust-lang/rust.vim'
call vundle#end()

filetype plugin indent on
syntax on
set backspace=eol,start,indent
set cursorline
"set cursorcolumn
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
set background=dark
set hid
set noerrorbells
set novisualbell
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set laststatus=2
set t_Co=256
set completeopt=menu
set clipboard=unnamedplus
set autochdir
set list
set listchars=tab:>-,trail:·,extends:>,precedes:<,space:·,nbsp:·
set encoding=utf-8
set guifont=Monaco\ for\ Powerline\ 10
colo gruvbox

set mouse=v

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

" Switch between files in buffer
nmap <C-Tab> :bn<CR>
nmap <C-Right> :bn<CR>
nmap <A-l> :bn<CR>
nmap <C-S-Tab> :bp<CR>
nmap <C-Left> :bp<CR>
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

" User comma as leader key
let mapleader=","
let g:mapleader=","

" Remove search highlight
noremap <Leader>n :noh<CR>

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

" Quickly move current line(s)
"nnoremap <C-J> :m .+1<CR>==
"nnoremap <C-K> :m .-2<CR>==
"inoremap <C-J> <Esc>:m .+1<CR>==gi
"inoremap <C-K> <Esc>:m .-2<CR>==gi
"vnoremap <C-J> :m '>+1<CR>gv=gv
"vnoremap <C-K> :m '<-2<CR>gv=gv

" Exit terminal mode with ,ESC
if has('nvim')
    tnoremap <leader><ESC> <C-\><C-n>
end

" Edit and source .vimrc easily
noremap <leader>ev :e $MYVIMRC<cr>
noremap <leader>sv :so $MYVIMRC<cr>

" Don't yank to default register when changing something
nnoremap c "xc
xnoremap c "xc

" After block yank and paste, move cursor to the end of operated text
" Also, don't copy over-pasted text in visual mode
vnoremap y y`]
nnoremap p p`]
vnoremap p "_dP`]

" Easily replace the current word and all its occurrences.
nnoremap <Leader>cc :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cc y:%s/<C-r>"/<C-r>"

" No more accidentally showing up command window (Use C-f to show it)
map q: :q

" Windows resizing using arrow keys
if has("gui_running")
    nnoremap <silent> <Left> :vertical resize -1<CR>
    nnoremap <silent> <Right> :vertical resize +1<CR>
    nnoremap <silent> <Up> :resize +1<CR>
    nnoremap <silent> <Down> :resize -1<CR>
end

" Listen to Alt keys
let c='a'
while c <= 'z'
    exec "set <A-".c.">=\e".c
    exec "imap \e".c." <A-".c.">"
    let c = nr2char(1+char2nr(c))
endw

" Omnicomplete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""

" vim-bbye: close buffer without closing split view
nnoremap <C-c> :Bdelete<CR>

" SingleCompile
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

" NERDTree
let g:NERDTreeDirArrows = 0
let g:NERDTreeMinimalUI = 1
let g:NERDTreeWinSize  =35
let g:NERDTreeAutoDeleteBuffer  =0
nnoremap <leader>m :NERDTreeToggle<CR>

" EasyTags
let g:easytags_async = 1
let g:easytags_syntax_keyword = 'always'
let g:easytags_auto_highlight = 0

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
nnoremap <leader>. :CtrlPTag<CR>

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:rehash256 = 1
let g:airline_theme = 'base16'

" Ultisnips
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

" YouCompleteMe
let g:ycm_server_python_interpreter = '/usr/bin/python'
let g:ycm_confirm_extra_conf = 0
let g:syntastic_always_populate_loc_list = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_global_ycm_extra_conf = '~/Dropbox/DotFiles/.ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/Workspace/*', '~/Desktop/*', '!~/*']
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_rust_src_path = '/home/paulo/Workspace/rust/src'
set completeopt-=preview
