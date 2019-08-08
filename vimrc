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
Plug 'cohama/lexima.vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-update-rc' }
Plug 'junegunn/fzf.vim'

" Completion/IDE
Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'neoclide/coc-json'
Plug 'neoclide/coc-yaml'
Plug 'neoclide/coc-snippets'

" Snippets
Plug 'SirVer/ultisnips'

" Languages
Plug 'othree/yajs.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rust-lang/rust.vim'
Plug 'tinco/haskell.vim'
Plug 'jodosha/vim-godebug'

" Misc
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
set shiftwidth=4
set tabstop=4
set inccommand=nosplit
set laststatus=2
set t_Co=256
set shortmess+=c
set completeopt=menu,menuone,noinsert,noselect
set clipboard=unnamedplus
set updatetime=300
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

    " Remove clipboard autoselection
    set guioptions-=a
    set guioptions-=A

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
nnoremap <leader>wc <C-w>c

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
noremap j gj
noremap k gk

" Remove search highlight
nnoremap <Leader>n :noh<CR>

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
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>lv :so $MYVIMRC<CR>

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

" Don't copy over-pasted text in visual mode
xnoremap p "_dp
xnoremap P "_dP

" Easily replace the current word and all its occurrences.
nnoremap <Leader>rr :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>rr y:%s/<C-r>"/<C-r>"

" No more accidentally showing up command window (Use C-f to show it)
map q: :q<CR>

" Custom tab size
autocmd FileType json,javascript setlocal tabstop=2 shiftwidth=2
autocmd FileType yml,yaml setlocal tabstop=2 shiftwidth=2
autocmd FileType go setlocal tabstop=8 shiftwidth=8 noexpandtab

"""""""""""
" Plugins "
"""""""""""

" Easymotion
map <Leader>j <Plug>(easymotion-prefix)

" vim-bbye: close buffer without closing split view
nnoremap <C-c> :Bdelete<CR>

" SingleCompile
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_cmd = ''
nnoremap <leader>pf :CtrlP<CR>
nnoremap <leader>pr :CtrlPMRUFiles<CR>

" Airline
"let g:rehash256 = 1
let g:airline_theme = 'base16'

" Ag
let g:ag_working_path_mode="r" 

" ALE
let g:ale_fix_on_save = 1

"""""""
" COC "
"""""""

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rr <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
