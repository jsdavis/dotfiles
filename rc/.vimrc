set nocompatible                "no vi compatibility

"********************** Vim Plug Settings *************************

" Auto install vim-plug if it's not installed already
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

"Solarized color theme
Plug 'altercation/vim-colors-solarized'

"Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"NERDTree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeTabsToggle' }

"NERDTree Tabs
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }

"Syntastic
Plug 'scrooloose/syntastic'

"delimitMate
Plug 'Raimondi/delimitMate'

"better whitespace
Plug 'ntpeters/vim-better-whitespace'

"NERDCommenter
Plug 'scrooloose/nerdcommenter'

"HTML-AutoCloseTag
Plug 'vim-scripts/HTML-AutoCloseTag', { 'for': ['html', 'javascript'] }

"Better JS Support
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'jsx', 'html'] }
Plug 'crusoexia/vim-javascript-lib', { 'for': ['javascript', 'jsx', 'html'] }
Plug 'jelera/vim-javascript-syntax', { 'for': ['javascript', 'jsx', 'html']}
Plug 'mxw/vim-jsx', { 'for': 'jsx' }

"Auto completion
Plug 'ervandew/supertab'

"Search previews
Plug 'osyo-manga/vim-over'

"Indentation guides
Plug 'Yggdroot/indentLine'
let g:vim_json_conceal=0     "stop hiding quotes in json
let g:vim_markdown_conceal=0 "stop hiding markup characters in markdown


call plug#end()

"Solarized settings
let g:solarized_termtrans=1

"Airline settings
set laststatus=2
let g:airline_powerline_fonts=1 "COMMENT OUT FOR COMPATIBILITY
"let g:airline_powerline_fonts=0 "UNCOMMENT FOR COMPATIBILITY
let g:airline_detect_paste=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#show_buffers=0
let g:airline#extensions#tabline#tab_min_count=2
let g:airline_theme = 'solarized'

set encoding=utf-8
"set guifont=PowerlineConsolas:h10 "COMMENT OUT FOR COMPATIBILITY

"NERDTree Settings
nmap <silent><leader>t :NERDTreeTabsToggle<CR>

"Syntastic Settings
"let g:syntastic_error_symbol ='✘'
"let g:syntastic_warning_symbol= '▲'
"let g:syntastic_enable_signs = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_debug = 0

nnoremap <leader>ln :lnext<cr>
nnoremap <leader>lp :lprevious<cr>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_javascript_checkers = ['eslint']

"Better whitespace settings
let g:current_line_whitespace_disabled_soft = 1
augroup togglestrip
  au!
  autocmd VimEnter * ToggleStripWhitespaceOnSave
augroup END

"NERDCommenter Settings
let g:NERDSpaceDelims=1

"SuperTab Settings
let g:SuperTabContextDefaultCompletionType = '<c-n>'

"vim-over Settings
cabbrev s OverCommandLine

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
set linebreak                   "only break at words
set linespace=0                 "no space between lines
set modeline                    "show what I'm doing
set noerrorbells                "don't yell at me
set nojoinspaces                "don't make whitespace on joins
set number relativenumber       "line numbers
set ruler                       "show ruler
set scrolloff=3                 "don't allow cursor less than 3 lines from edge
set shiftwidth=4                "make tabs 4 spaces
set showcmd                     "show incomplete commands
set showmatch                   "show matched parentheses/brackets
set showmode                    "show what mode I'm on
set softtabstop=4               "make tabs 4 spaces
set splitbelow                  "open new windows below
set splitright                  "open new windows to the right
set tabstop=4                   "make tabs 4 spaces
set term=xterm-256color         "tell vim we're using xterm. ConEmu scroll fix
set t_Co=256                    "force 256 colors
set virtualedit=onemore         "let cursor go past end of line
set winminheight=0              "minimum window height zero lines
set shellslash                  "fix Cygwin and Syntastic

:colorscheme solarized "Color scheme COMMENT OUT FOR COMPATIBILITY
":colorscheme elflord "UNCOMMENT FOR COMPATIBILITY

command! C let @/ = "" "Clear last search pattern with :C

"Add mouse support
if has('mouse')
  set mouse=a
  set mousehide "hide when typing

  " ConEmu scroll fix
  inoremap <Esc>[62~ <C-X><C-E>
  inoremap <Esc>[63~ <C-X><C-Y>
  nnoremap <Esc>[62~ <C-E>
  nnoremap <Esc>[63~ <C-Y>
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

"Easily edit and source .vimrc
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"Make opening help faster
cabbrev h tab help

"Make opening tabs faster
cabbrev t tabedit

"Make opening new buffers faster
cabbrev e edit

"Shared configuration between vim and JetBrains IDEs
source ~/.shared.vim
