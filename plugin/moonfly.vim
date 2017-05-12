" A simple Vim/Neovim statusline using moonfly colors.
"
" URL:          github.com/bluz71/vim-moonfly-statusline
" License:      MIT (https://opensource.org/licenses/MIT)

function! s:StatusLine(mode)
    if &buftype == "nofile" || bufname("%") == "[BufExplorer]"
        " Don't set a custom status line for file explorers.
        return
    elseif a:mode == "not-current"
        " This is the status line for inactive windows.
        setlocal statusline=\ %*%<%f\ %h%m%r
        setlocal statusline+=%*%=%-14.(%l,%c%V%)[%L]\ %P
        return
    " All cases from here on relate to the status line of the active window.
    elseif &buftype == "terminal" || a:mode == "terminal"
        setlocal statusline=%5*\ terminal\ 
    elseif &buftype == "help"
        setlocal statusline=%1*\ help\ 
    elseif &buftype == "quickfix"
        setlocal statusline=%5*\ quickfix\ 
    elseif a:mode == "normal"
        setlocal statusline=%1*\ normal\ 
    elseif a:mode == "insert"
        setlocal statusline=%2*\ insert\ 
    elseif a:mode == "visual"
        setlocal statusline=%3*\ visual\ 
    elseif a:mode == "replace"
        setlocal statusline=%4*\ replace\ 
    endif

    setlocal statusline+=%*\ %<%f\ %h%m%r
    setlocal statusline+=%6*\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}\ 
    setlocal statusline+=%7*%=%-14.(%l,%c%V%)
    setlocal statusline+=%8*[%L]\ 
    setlocal statusline+=%9*%P
endfunction

function! s:WindowFocus(mode)
    if a:mode == "Enter"
        call s:StatusLine("normal")
    elseif a:mode == "Leave"
        call s:StatusLine("not-current")
    endif
endfunction

function! s:InsertMode(mode)
    if a:mode == "i"
        call s:StatusLine("insert")
    elseif a:mode == "r"
        call s:StatusLine("replace")
    else
        return
    endif
endfunction

function! s:VisualMode()
    if mode()=~#"^[vV\<C-v>]"
        call s:StatusLine("visual")
        let g:normalMode = 0
    elseif g:normalMode == 0
        call s:StatusLine("normal")
        let g:normalMode = 1
    endif
endfunction


augroup moonflyStatusLine
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter,InsertLeave * call s:WindowFocus("Enter")
    autocmd WinLeave,FilterWritePost * call s:WindowFocus("Leave")
    autocmd InsertEnter * call s:InsertMode(v:insertmode)
    autocmd CursorMoved,CursorHold * call s:VisualMode()
    if has("nvim")
        autocmd TermOpen * call s:StatusLine("terminal")
    endif
augroup END


" The set of available moonfly colors (https://github.com/bluz71/vim-moonfly-colors)

let s:black       = "#080808"
let s:white       = "#c6c6c6"
let s:grey247     = "#9e9e9e"
let s:grey0       = "#373c40"
let s:grey237     = "#3a3a3a"
let s:grey236     = "#303030"
let s:grey235     = "#262626"
let s:grey234     = "#1c1c1c"
let s:grey233     = "#121212"
let s:wheat       = "#cfcfb0"
let s:khaki       = "#e3c78a"
let s:orange      = "#de935f"
let s:coral       = "#f09479"
let s:light_green = "#85dc85"
let s:green       = "#8cc85f"
let s:emerald     = "#42cf89"
let s:blue        = "#80a0ff"
let s:sky_blue    = "#87afff"
let s:light_blue  = "#78c2ff"
let s:turquoise   = "#7ee0ce"
let s:purple      = "#ae81ff"
let s:violet      = "#e2637f"
let s:magenta     = "#ce76e8"
let s:crimson     = "#fe3b7b"
let s:red         = "#ff5454"

" black       = 232
" white       = 251
" grey247     = 247
" grey0       = 0
" grey237     = 237
" grey236     = 236
" grey235     = 235
" grey234     = 234
" grey233     = 233
" wheat       = 11
" khaki       = 3
" orange      = 7
" coral       = 8
" light_green = 14
" green       = 2
" emerald     = 10
" blue        = 4
" sky_blue    = 111
" light_blue  = 12
" turquoise   = 6
" purple      = 13
" violet      = 15
" magenta     = 5
" crimson     = 9
" red         = 1

exec "highlight User1 ctermbg=4 guibg=" . s:blue . " ctermfg=234 guifg=" . s:grey234
exec "highlight User2 ctermbg=3 guibg=" . s:khaki . " ctermfg=234 guifg=" . s:grey234
exec "highlight User3 ctermbg=13 guibg=" . s:purple . " ctermfg=234 guifg=" . s:grey234
exec "highlight User4 ctermbg=7 guibg=" . s:orange . " ctermfg=234 guifg=" . s:grey234
exec "highlight User5 ctermbg=9 guibg=" . s:crimson . " ctermfg=234 guifg=" . s:grey234
exec "highlight User6 ctermbg=236 guibg=" . s:grey236 . " ctermfg=10 guifg=" . s:emerald . " gui=none"
exec "highlight User7 ctermbg=236 guibg=" . s:grey236 . " ctermfg=251 guifg=" . s:white . " gui=none"
exec "highlight User8 ctermbg=236 guibg=" . s:grey236 . " ctermfg=111 guifg=" . s:sky_blue . " gui=none"
exec "highlight User9 ctermbg=236 guibg=" . s:grey236 . " ctermfg=2 guifg=" . s:green . " gui=none"
