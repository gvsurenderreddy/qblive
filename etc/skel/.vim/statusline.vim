" UpdateStatus - Updates the status bar to display a list of buffers
function! UpdateStatus()
	let delim = ' | '
	let i = 1
	let newStatus = ''
	let curBufIdx = 0
	let allowedLength = winwidth(0) - 12
	let plainLength = 0
	let bgColor = '%#SyntaxLine#'
	while(i <= bufnr('$'))
		if buflisted(i)
			let bdelim = (empty(newStatus) ? '' : delim)
			let btitle = i . ' ' . fnamemodify(bufname(i),':t')
			if i == bufnr('%')
				let curBufIdx = plainLength
				let bcolor = &modified ? '%#CurMod#' : '%#CurBuf#'
			else
				let bcolor = getbufvar(i, '&modified') ? '%#ModBuf#' : '%#AltBuf#'
			endif
			let remainingChars = allowedLength - plainLength
			let plainLength += len(bdelim . btitle)
			if plainLength < allowedLength || i <= bufnr('%') || 
					\ (i-1 == bufnr('%') && (plainLength - curBufIdx) < allowedLength)
				let newStatus .= bgColor . bdelim . bcolor . btitle
			else
				"need to fill the rest of allowedLength
				let pad = ''
				if remainingChars <= len(delim)
					"if the delimiter wont fit, pad with spaces to the >
					let pad=strpart('    ', 0, remainingChars - 1)
				else
					let newStatus .= bgColor . delim . bcolor . strpart(btitle, 0, remainingChars - len(delim) - 1)
				endif
				let newStatus .= bgColor.pad.'>'
				break
			end
		endif
		let i += 1
	endwhile
	let newStatus .= bgColor . '%=%6l/%5L'
	execute 'set statusline='.substitute(newStatus, '\([ |]\)', '\\\1', 'g')
endfunction

