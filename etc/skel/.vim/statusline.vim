" UpdateStatus - Updates the status bar to display a list of buffers
function! UpdateStatus()
    " Reset our Globals
    let g:CurBuffer =  bufnr('%') . ' ' . expand('%:t')
    let g:BufsLeft = ""
    let g:BufsRight = ""

    let my_left_len = (winwidth(0) - len(g:CurBuffer))
    let my_right_len = 0
    let i = bufnr('$')

    while(i > 0)
        if buflisted(i) && getbufvar(i, "&modifiable") && i != bufnr('%')
            let bufName  =  i . ' ' . fnamemodify(bufname(i), ":t") " . ' | '
            let bufName .= (getbufvar(i, "&modified") ? '[+]' : '' )
            if i < bufnr('%')
                let g:BufsLeft = bufName . ' | ' . g:BufsLeft
            else
                let g:BufsRight = ' | ' . bufName . g:BufsRight
            endif
        endif
        let i -= 1
    endwhile
    let g:BufsRight = ' ' . g:BufsRight

    if len(g:BufsLeft) < my_left_len
        let my_right_len = winwidth(0) - (len(g:BufsLeft) + len(g:CurBuffer))
    endif

    if len(g:BufsRight) < my_right_len
        let my_left_len = winwidth(0) - (len(g:BufsRight) + len(g:CurBuffer))
    endif

    if len(g:BufsLeft) > my_left_len
        let g:BufsLeft = '<' . strpart(g:BufsLeft, len(g:BufsLeft) - my_left_len, my_left_len)
    endif

    if len(g:BufsRight) > my_right_len
        let g:BufsRight = strpart(g:BufsRight, 0, my_right_len) . '>'
    endif

    set statusline=%#SyntaxLine#%{g:BufsLeft}
    set statusline+=%#CurBuf#
    set statusline+=%{g:CurBuffer}%m
    set statusline+=%#SyntaxLine#
    set statusline+=%{g:BufsRight}
    set statusline+=%<%=[%l][%c][%P][%L]%<
endfunction

