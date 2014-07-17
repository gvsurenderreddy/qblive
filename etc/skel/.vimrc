"general display stuff
syntax on   "syntax highlighting on
set number  "line numbers on
"set colorcolumn=80 "draw right margin at 80 chars
set so=3  "set number of lines from top/bottom of screen where scrolling activates

"tabs and indentation
set tabstop=4      "set width of tab characters
set shiftwidth=4   "set the size used for vim's re-indent operator ( shift-> and shift-< )
set softtabstop=4  "backspace over expanded tabs
"set expandtab     "use spaces for tabs instead of tabs for tabs
set copyindent     "match indentation level of previous line

" buffers management
map <C-k> :bp!<CR>
map <C-h> :bp!<CR>
map <C-j> :bn!<CR>
map <C-l> :bn!<CR>
imap <C-k> <esc>:bp!<CR>
imap <C-h> <esc>:bp!<CR>
imap <C-j> <esc>:bn!<CR>
imap <C-l> <esc>:bn!<CR>
"map <C-w> :bd<CR> "removed since C-w is used for window commands.
so ~/.vim/statusline.vim "get a status line with buffers listed

"rainbow parens
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

