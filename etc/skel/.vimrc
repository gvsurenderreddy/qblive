"status line with buffers listed
set laststatus=2
so ~/.vim/statusline.vim
autocmd BufEnter,BufWritePost,VimResized,CursorMoved,CursorMovedI,ColorScheme * call UpdateStatus()


"rainbow parens
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


"general display stuff
colorscheme desert
syntax on   "syntax highlighting on
"highlighting tweaks for status line
hi CurBuf ctermbg=Blue
hi CurMod ctermbg=Magenta
hi ModBuf ctermbg=Red
hi AltBuf ctermbg=Black
hi SyntaxLine ctermbg=Black
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
"indenting/unindenting visual blocks
vnoremap < <gv
vnoremap > >gv


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


" search-related
set incsearch
set nohlsearch
" clear previous highlight & enable highlighting on search
noremap * :set hlsearch<CR>:nohlsearch<CR>*
noremap / :set hlsearch<CR>:nohlsearch<CR>/
noremap ? :set hlsearch<CR>:nohlsearch<CR>?


" custom keyboard shortcuts
let mapleader = ";"
let g:mapleader = ";"
noremap <Leader>; :call UpdateStatus()<CR>
noremap <Leader>n :set number!<CR>
noremap <Leader>s :set spell!<CR>
noremap <Leader>h :set hls!<CR>
noremap <Leader>1 :b1<CR>
noremap <Leader>2 :b2<CR>
noremap <Leader>3 :b3<CR>
noremap <Leader>4 :b4<CR>
noremap <Leader>5 :b5<CR>
noremap <Leader>6 :b6<CR>
noremap <Leader>7 :b7<CR>
noremap <Leader>8 :b8<CR>
noremap <Leader>9 :b9<CR>
noremap <Leader>0 :b10<CR>
noremap S :w<CR>

