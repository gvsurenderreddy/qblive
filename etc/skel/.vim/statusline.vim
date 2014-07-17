set laststatus=2
hi CurBuf term=bold ctermfg=Cyan
let g:BufsLeft  = ""
let g:CurBuffer = ""
let g:BufsRight = ""
set statusline=%{g:BufsLeft}
set statusline+=%#CurBuf#
set statusline+=%{g:CurBuffer}
set statusline+=%#SyntaxLine#
set statusline+=%{g:BufsRight}
set statusline+=%<%=[%l][%c][%P][%L]%<

"updatestatus - updates the status bar to display a list of buffers
function! UpdateStatus(lmarg,rmarg)
	"reset globals
	let g:CurBuffer = '[' . bufnr('%') . ' ' . expand('%:t') . ((&modified) ? ' +]' : ']')
	let g:BufsLeft = ""
	let g:BufsRight = ""

	let tot_margin = a:lmarg+ a:rmarg
	let my_left_len = (winwidth(0) - len(g:CurBuffer) - tot_margin)
	let my_right_len = 0
	let i = bufnr('$')

	while(i > 0)
		if buflisted(i) && getbufvar(i, "&modifiable") && i != bufnr('%')
			let bufName = '[' . i . ' ' . fnamemodify(bufname(i), ":t")
			let bufName .= (getbufvar(i, "&modified") ? ' +]' : ']' )
			if i < bufnr('%')
				let g:BufsLeft = bufName . g:BufsLeft
			else
				let g:BufsRight = bufName . g:BufsRight
			endif
		endif
		let i -= 1
	endwhile

	if len(g:BufsLeft) < my_left_len
		let my_right_len = winwidth(0) - (len(g:BufsLeft) + len(g:CurBuffer) + tot_margin)
	endif

	if len(g:BufsRight) < my_right_len
		let my_left_len = winwidth(0) - (len(g:BufsRight) + len(g:CurBuffer) + tot_margin)
	endif

	if len(g:BufsLeft) > my_left_len
		let g:BufsLeft = '<' . strpart(g:BufsLeft, len(g:BufsLeft) - my_left_len, my_left_len)
	endif

	if len(g:BufsRight) > my_right_len
		let g:BufsRight = strpart(g:BufsRight, 0, my_right_len) . '>'
	endif
endfunction

"update the buffer list in the status line
autocmd VimEnter,BufNew,BufEnter,BufWritePost,VimResized,FocusLost,FocusGained,InsertLeave * call UpdateStatus(0,20)

