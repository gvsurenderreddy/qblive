" UpdateStatus - Updates the status bar to display a list of buffers
function! UpdateStatus()
	let delim = ' | '
	let i = 1
	let newStatus = ''
	let curBufIdx = 0
	let allowedLength = winwidth(0) - 12
	let statusLength = 0
	let bgColor = '%#SyntaxLine#'
	while(i <= bufnr('$'))
		if buflisted(i)
			let bdelim = (empty(newStatus) ? '' : delim)
			let btitle = i . ' ' . fnamemodify(bufname(i),':t')
			if i == bufnr('%')
				let curBufIdx = statusLength
				let bcolor = &modified ? '%#CurMod#' : '%#CurBuf#'
			else
				let bcolor = getbufvar(i, '&modified') ? '%#ModBuf#' : '%#AltBuf#'
			endif
			let remainingChars = allowedLength - statusLength
			let statusLength += len(bdelim . btitle)
			if statusLength < allowedLength || i <= bufnr('%') || 
					\ (i-1 == bufnr('%') && (statusLength - curBufIdx) < allowedLength)
				let newStatus .= bgColor . bdelim . bcolor . btitle
			else
				let bdelim = strpart(delim, 0, remainingChars - 1)
				let btitle = strpart(btitle, 0, remainingChars - len(delim) - 1)
				let newStatus .= bgColor . bdelim . bcolor . btitle . bgColor . '>'
				break
			end
		endif
		let i += 1
	endwhile
	let newStatus .= bgColor . '%=%6l/%5L'
	execute 'set statusline='.substitute(newStatus, '\([ |]\)', '\\\1', 'g')
endfunction

