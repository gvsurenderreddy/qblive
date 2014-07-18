"general display stuff
syntax on   "syntax highlighting on
set number  "line numbers on
"set colorcolumn=80 "draw right margin at 80 chars
set so=3  "set number of lines from top/bottom of screen where scrolling activates
set foldmethod=indent "enable folding. use indentation
set foldlevel=100 "unfold everything by default


"tabs and indentation
set tabstop=4      "set width of tab characters
set shiftwidth=4   "set the size used for vim's re-indent operator ( shift-> and shift-< )
set softtabstop=4  "backspace over expanded tabs
"set expandtab     "use spaces for tabs instead of tabs for tabs
set autoindent     "match indentation level of previous line
set copyindent     "match indentation characters (tabs vs spaces) of previous line

" buffer management
set hidden "suppress warning when switching from unsaved buffer
map <C-k> :bp<CR>
map <C-h> :bp<CR>
map <C-j> :bn<CR>
map <C-l> :bn<CR>
imap <C-k> <esc>:bp<CR>
imap <C-h> <esc>:bp<CR>
imap <C-j> <esc>:bn<CR>
imap <C-l> <esc>:bn<CR>
"map <C-w> :bd<CR> "removed since C-w is used for window commands.
so ~/.vim/statusline.vim "get a status line with buffers listed

"indenting/unindenting visual blocks
vnoremap < <gv
vnoremap > >gv

"rainbow parens
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

