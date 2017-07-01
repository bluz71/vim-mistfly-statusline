" A simple Vim/Neovim statusline using moonfly colors.
"
" URL:          github.com/bluz71/vim-moonfly-statusline
" License:      MIT (https://opensource.org/licenses/MIT)

if exists("g:loaded_moonfly_statusline")
  finish
endif
let g:loaded_moonfly_statusline = 1

let s:normal_mode = 1

" The set of available moonfly colors (https://github.com/bluz71/vim-moonfly-colors)
let s:black       = "#080808"  " black       = 232
let s:white       = "#c6c6c6"  " white       = 251
let s:grey247     = "#9e9e9e"  " grey247     = 247
let s:grey0       = "#373c40"  " grey0       = 0
let s:grey237     = "#3a3a3a"  " grey237     = 237
let s:grey236     = "#303030"  " grey236     = 236
let s:grey235     = "#262626"  " grey235     = 235
let s:grey234     = "#1c1c1c"  " grey234     = 234
let s:grey233     = "#121212"  " grey233     = 233
let s:wheat       = "#cfcfb0"  " wheat       = 11
let s:khaki       = "#e3c78a"  " khaki       = 3
let s:orange      = "#de935f"  " orange      = 7
let s:coral       = "#f09479"  " coral       = 8
let s:light_green = "#85dc85"  " light_green = 14
let s:green       = "#8cc85f"  " green       = 2
let s:emerald     = "#42cf89"  " emerald     = 10
let s:blue        = "#80a0ff"  " blue        = 4
let s:light_blue  = "#78c2ff"  " light_blue  = 12
let s:turquoise   = "#7ee0ce"  " turquoise   = 6
let s:purple      = "#ae81ff"  " purple      = 13
let s:violet      = "#e2637f"  " violet      = 15
let s:magenta     = "#ce76e8"  " magenta     = 5
let s:crimson     = "#f74782"  " crimson     = 9
let s:red         = "#ff5454"  " red         = 1


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
        setlocal statusline=%6*\ terminal\ 
    elseif &buftype == "help"
        setlocal statusline=%1*\ help\ 
    elseif &buftype == "quickfix"
        setlocal statusline=%5*\ list\ 
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
    setlocal statusline+=%7*\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}\ 
    setlocal statusline+=%8*%=%-14.(%l,%c%V%)
    setlocal statusline+=%9*[%L]\ 
    setlocal statusline+=%8*%P 
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
        let s:normal_mode = 0
    elseif s:normal_mode == 0
        call s:StatusLine("normal")
        let s:normal_mode = 1
    endif
endfunction

function! s:UserColors()
    exec "highlight User1 ctermbg=4 guibg="   . s:blue    . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User2 ctermbg=251 guibg=" . s:white   . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User3 ctermbg=13 guibg="  . s:purple  . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User4 ctermbg=9 guibg="   . s:crimson . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User5 ctermbg=8 guibg="   . s:coral   . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User6 ctermbg=11 guibg="  . s:wheat   . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User7 ctermbg=236 guibg=" . s:grey236 . " ctermfg=10 guifg="  . s:emerald . " gui=none"
    exec "highlight User8 ctermbg=236 guibg=" . s:grey236 . " ctermfg=251 guifg=" . s:white   . " gui=none"
    exec "highlight User9 ctermbg=236 guibg=" . s:grey236 . " ctermfg=4 guifg="   . s:blue    . " gui=none"
endfunction


augroup moonflyStatusline
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter,InsertLeave * call s:WindowFocus("Enter")
    autocmd WinLeave,FilterWritePost * call s:WindowFocus("Leave")
    autocmd InsertEnter * call s:InsertMode(v:insertmode)
    autocmd CursorMoved,CursorHold * call s:VisualMode()
    if has("nvim")
        autocmd TermOpen * call s:StatusLine("terminal")
    endif
    autocmd SourcePre * call s:UserColors()
augroup END


call s:UserColors()
