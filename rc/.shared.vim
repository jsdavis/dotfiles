"Change leader to ,
let mapleader = ","

set hlsearch                    "highlighted search
set incsearch                   "incremental search
set ignorecase                  "ignore cases in search
set smartcase                   "allow uppercase searches
set number relativenumber       "line numbers

"Better undo/redo
nnoremap U <C-R>
nnoremap <C-R> U

"Exit/Save files faster
nnoremap <leader>q :q<cr>
nnoremap <leader>x :x<cr>
nnoremap <leader>w :w<cr>

"Add newlines in command mode
nnoremap q o<esc>
nnoremap Q O<esc>

"Get to normal mode with jk in insert mode
inoremap jk <esc>

"Fix indents without leaving visual mode
vnoremap < <gv
vnoremap > >gv

"Go ALL the way to the end
vnoremap G G$
