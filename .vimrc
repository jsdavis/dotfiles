set nocompatible                "no vi compatibility

"Change leader to ,
let mapleader = ","

"********************** Vundle Settings *************************

filetype plugin indent on
set rtp+=~/.vim/bundle/Vundle.vim
set shell=/bin/bash
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

"Molokai color theme
Plugin 'tomasr/molokai'

"Airline
Plugin 'bling/vim-airline'

"NERDTree
Plugin 'scrooloose/nerdtree'

"NERDTree Tabs
Plugin 'jistr/vim-nerdtree-tabs'

"Syntastic
Plugin 'scrooloose/syntastic'

"delimitMate
Plugin 'Raimondi/delimitMate'

"better whitespace
Plugin 'ntpeters/vim-better-whitespace'

"NERDCommenter
Plugin 'scrooloose/nerdcommenter'

"HTML-AutoCloseTag
Plugin 'vim-scripts/HTML-AutoCloseTag'

call vundle#end()

"Airline settings
set laststatus=2
let g:airline_powerline_fonts=1 "COMMENT OUT FOR COMPATIBILITY
"let g:airline_powerline_fonts=0 "UNCOMMENT FOR COMPATIBILITY
let g:airline_detect_paste=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#show_buffers=0
let g:airline#extensions#tabline#tab_min_count=2
let g:airline_theme = 'molokai'

set encoding=utf-8
set guifont=PowerlineConsolas:h10 "COMMENT OUT FOR COMPATIBILITY

"NERDTree Settings
nmap <silent><leader>t :NERDTreeTabsToggle<CR>

"Syntastic Settings
"let g:syntastic_error_symbol ='✘'
"let g:syntastic_warning_symbol= '▲'
let g:syntastic_enable_signs = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_debug = 0

nnoremap <leader>ln :lnext<cr>
nnoremap <leader>lp :lprevious<cr>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"Better whitespace settings
augroup togglestrip
  au!
  autocmd VimEnter * CurrentLineWhitespaceOff soft
  autocmd VimEnter * ToggleStripWhitespaceOnSave
augroup END

"NERDCommenter Settings
let g:NERDSpaceDelims=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Options in alphabetical order
set autoindent                  "keep indents when making new lines
set backspace=indent,eol,start  "fix backspace
set bs=2                        "more fix backspace
set expandtab                   "expand tabs into spaces
set exrc                        "make it easy to implement local .vimrc
set fileformats=unix,dos,mac    "open files from all OS
set foldcolumn=1                "see my folds
set foldenable                  "autofold code
set foldlevelstart=1            "don't fold the whole file
set foldmethod=syntax           "fold automatically by syntax
set foldnestmax=1               "don't nest my folds
set history=1000                "way more than 20
set hlsearch                    "highlighted search
set incsearch                   "incremental search
set ignorecase                  "ignore cases in search
set linebreak                   "only break at words
set linespace=0                 "no space between lines
set modeline                    "show what I'm doing
set noerrorbells                "don't yell at me
set nojoinspaces                "don't make whitespace on joins
set number                      "line numbers
set ruler                       "show ruler
set scrolloff=3                 "don't allow cursor less than 3 lines from edge
set shiftwidth=4                "make tabs 4 spaces
set showcmd                     "show incomplete commands
set showmatch                   "show matched parentheses/brackets
set showmode                    "show what mode I'm on
set smartcase                   "allow uppercase searches
set softtabstop=4               "make tabs 4 spaces
set splitbelow                  "open new windows below
set splitright                  "open new windows to the right
set tabstop=4                   "make tabs 4 spaces
set virtualedit=onemore         "let cursor go past end of line
set winminheight=0              "minimum window height zero lines
set shellslash                  "fix Cygwin and Syntastic

syntax on                       "highlighting is a necessity

:colors molokai "Color scheme COMMENT OUT FOR COMPATIBILITY
":colors elflord "UNCOMMENT FOR COMPATIBILITY

command! C let @/ = "" "Clear last search pattern with :C

"Add mouse support
if has('mouse')
  set mouse=a
  set mousehide "hide when typing
endif


"Set cursor position to last known position when opening file
augroup cursorpos
  au!
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
augroup END

"Make navigating wrapped lines behave like normal lines
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$
noremap <silent> ^ g^
noremap <silent> _ g_

"Better tab navigation
nnoremap <C-J> :tabnext<CR>

"Better window navigation
nnoremap <C-K> <C-W>w<C-W>_
nnoremap <leader>= <C-W>=

"Better buffer navigation
nnoremap <C-L> :bnext<CR>

"Better undo/redo
nnoremap U <C-R>
nnoremap <C-R> U

"Easily edit and source .vimrc
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"Exit/Save files faster
nnoremap <leader>q :q<cr>
nnoremap <leader>x :x<cr>
nnoremap <leader>w :w<cr>

"Easy Java compiling
noremap <F5> :w<cr>:!javac %<cr>

"Get to normal mode with jk in insert mode
inoremap jk <esc>

"Fix indents without leaving visual mode
vnoremap < <gv
vnoremap > >gv

"Make opening help faster
cabbrev h tab help

"Make opening tabs faster
cabbrev t tabedit

"Make opening new buffers faster
cabbrev e edit

"Go ALL the way to the end
vnoremap G G$

"Wrap text to 80 lines and highlight any lines that go over 80 chars
match ErrorMsg '\%>90v.\+'
setlocal textwidth=90
if exists('&breakindent')
 set breakindent   "Indent wrapped lines up to the same level
endif
