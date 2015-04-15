" UpdateStatus - Updates the status bar to display a list of buffers
" must escape all spaces to statusline
"   this function replaces displays underscores instead of spaces in filenames
function! UpdateStatus()
	let delim='\ \|\ '
	let bcount = bufnr('$')
	let i = 1
	set statusline=
	while(i <= bcount)
		if buflisted(i)
			let btitle = i . '\ ' . fnamemodify(bufname(i),":t:gs? ?_?")
			if i == bufnr('%')
				let color = &modified ? 'CurMod' : 'CurBuf'
			else
				let color = getbufvar(i, "&modified") ? 'ModBuf' : 'AltBuf'
			endif
			execute "set statusline+=%#SyntaxLine#" . (i > 1 ? delim : '') . "%#".color."#" . btitle
		endif
		let i += 1
	endwhile
	set statusline+=%#SyntaxLine#%=%l/%L
endfunction

