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

" status line
so ~/.vim/statusline.vim

"rainbow parens
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

