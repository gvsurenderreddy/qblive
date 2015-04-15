" UpdateStatus - Updates the status bar to display a list of buffers
function! UpdateStatus()
	let delim = ' | '
	let i = 1
	let newStatus = ''
	let curBufIdx = 0
	let allowedLength = winwidth(0) - 12
	let statusTruncated = 0
	let plainLength = 0
	let bgColor = '%#SyntaxLine#'
	while(i <= bufnr('$'))
		if buflisted(i)
			let bdelim = (empty(newStatus) ? '' : delim)
			let bname = fnamemodify(bufname(i),':t')
			let btitle = i . ' ' . bname
			if i == bufnr('%')
				let curBufIdx = plainLength
				let bcolor = &modified ? '%#CurMod#' : '%#CurBuf#'
			else
				let bcolor = getbufvar(i, '&modified') ? '%#ModBuf#' : '%#AltBuf#'
			endif
			let prevPlainLength = plainLength
			let plainLength += len(bdelim . btitle)
			if plainLength < allowedLength || i <= bufnr('%') || 
					\ (i-1 == bufnr('%') && (plainLength - curBufIdx) < allowedLength)
				let newStatus .= bgColor . bdelim . bcolor . btitle
			elseif statusTruncated == 0
				"need to fill the rest of allowedLength
				let pad = ''
				let remaining_chars = allowedLength - prevPlainLength
				if remaining_chars <= len(delim)
					"if the delimiter wont fit, pad with spaces to the >
					let pad=strpart('    ', 0, remaining_chars - 1)
				else
					let newStatus .= bgColor . delim . bcolor . strpart(btitle, 0, remaining_chars - len(delim) - 1)
				endif
				let newStatus .= bgColor.pad.'>'
				let statusTruncated = 1
			end
		endif
		let i += 1
	endwhile
	let newStatus .= bgColor . '%=%6l/%5L'
	execute 'set statusline='.substitute(newStatus, '\([ |]\)', '\\\1', 'g')
endfunction

