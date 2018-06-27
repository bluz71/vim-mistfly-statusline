" A simple Vim/Neovim statusline using moonfly colors.
"
" URL:          github.com/bluz71/vim-moonfly-statusline
" License:      MIT (https://opensource.org/licenses/MIT)

if exists("g:loaded_moonfly_statusline")
  finish
endif
let g:loaded_moonfly_statusline = 1

" By default don't display Git branches using the U+E0A0 branch character.
let g:moonflyWithGitBranchCharacter = get(g:, "moonflyWithGitBranchCharacter", 0)

let s:normal_mode = 1
let s:orig_updatetime = &updatetime

" The set of available moonfly colors (https://github.com/bluz71/vim-moonfly-colors)
let s:white   = "#c6c6c6" " white   = 251
let s:grey236 = "#303030" " grey236 = 236
let s:grey234 = "#1c1c1c" " grey234 = 234
let s:wheat   = "#cfcfb0" " wheat   = 11
let s:coral   = "#f09479" " coral   = 8
let s:emerald = "#42cf89" " emerald = 10
let s:blue    = "#80a0ff" " blue    = 4
let s:purple  = "#ae81ff" " purple  = 13
let s:crimson = "#f74782" " crimson = 9

function MoonflyFugitiveBranch()
    if !exists('g:loaded_fugitive') || !exists('b:git_dir')
        return ''
    endif

    if g:moonflyWithGitBranchCharacter
        return '[ '.fugitive#head().']'
    else
        return fugitive#statusline()
    endif
endfunction

function! MoonflyTerminalMode()
    let l:curr_mode = mode()

    if (l:curr_mode ==# "t")
        return "term"
    elseif (l:curr_mode ==# "v")
        return "visual"
    elseif (l:curr_mode ==# "V")
        return "v-line"
    elseif (l:curr_mode ==# "\<C-v>")
        return "v-rect"
    else
        return "normal"
    endif
endfunction

function! MoonflyShortFilePath()
    if &buftype == "terminal"
        return expand('%:t')
    else
        return pathshorten(expand('%:f'))
    endif
endfunction

function! s:StatusLine(mode)
    if &buftype == "nofile" || bufname("%") == "[BufExplorer]"
        " Don't set a custom status line for file explorers.
        return
    elseif a:mode == "not-current"
        " This is the status line for inactive windows.
        setlocal statusline=\ %*%<%{MoonflyShortFilePath()}\ %h%m%r
        setlocal statusline+=%*%=%-14.(%l,%c%V%)[%L]\ %P
        return
    " All cases from here on relate to the status line of the active window.
    elseif &buftype == "terminal" || a:mode == "terminal"
        setlocal statusline=%6*\ %{MoonflyTerminalMode()}\ 
    elseif &buftype == "help"
        setlocal statusline=%1*\ help\ 
    elseif &buftype == "quickfix"
        setlocal statusline=%5*\ list\ 
    elseif a:mode == "normal"
        setlocal statusline=%1*\ normal\ 
    elseif a:mode == "command"
        setlocal statusline=%1*\ c-mode\ 
    elseif a:mode == "insert"
        setlocal statusline=%2*\ insert\ 
    elseif a:mode == "visual"
        setlocal statusline=%3*\ visual\ 
    elseif a:mode == "v-line"
        setlocal statusline=%3*\ v-line\ 
    elseif a:mode == "v-rect"
        setlocal statusline=%3*\ v-rect\ 
    elseif a:mode == "replace"
        setlocal statusline=%4*\ r-mode\ 
    endif

    setlocal statusline+=%*\ %<%{MoonflyShortFilePath()}\ %h%m%r
    setlocal statusline+=%7*\ %{MoonflyFugitiveBranch()}\ 
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
    let l:curr_mode = mode()

    if (l:curr_mode ==# "v")
        call s:StatusLine("visual")
        let s:normal_mode = 0
        let &updatetime = 0
    elseif (l:curr_mode ==# "V")
        call s:StatusLine("v-line")
        let s:normal_mode = 0
        let &updatetime = 0
    elseif (l:curr_mode ==# "\<C-v>")
        call s:StatusLine("v-rect")
        let s:normal_mode = 0
        let &updatetime = 0
    elseif s:normal_mode == 0
        " We are no longer in a visual mode.
        call s:StatusLine("normal")
        let s:normal_mode = 1
        let &updatetime = s:orig_updatetime
    endif
endfunction

augroup moonflyStatusline
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * call s:WindowFocus("Enter")
    autocmd InsertLeave                   * call s:WindowFocus("Enter")
    autocmd WinLeave,FilterWritePost      * call s:WindowFocus("Leave")
    autocmd InsertEnter                   * call s:InsertMode(v:insertmode)
    autocmd CursorMoved,CursorHold        * call s:VisualMode()
    if exists('##TermOpen')
        autocmd TermOpen                  * call s:StatusLine("terminal")
    endif
    if exists('##TerminalOpen')
        autocmd TerminalOpen              * call s:StatusLine("terminal")
    endif
    if exists('##CmdlineEnter')
        autocmd CmdlineEnter              * call s:StatusLine("command") | redraw
        autocmd CmdlineLeave              * call s:StatusLine("normal")
    endif
    autocmd SourcePre                     * call s:UserColors()
augroup END

function! s:UserColors()
    exec "highlight User1 ctermbg=4   guibg=" . s:blue    . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User2 ctermbg=251 guibg=" . s:white   . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User3 ctermbg=13  guibg=" . s:purple  . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User4 ctermbg=9   guibg=" . s:crimson . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User5 ctermbg=8   guibg=" . s:coral   . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User6 ctermbg=11  guibg=" . s:wheat   . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User7 ctermbg=236 guibg=" . s:grey236 . " ctermfg=10  guifg=" . s:emerald . " gui=none"
    exec "highlight User8 ctermbg=236 guibg=" . s:grey236 . " ctermfg=251 guifg=" . s:white   . " gui=none"
    exec "highlight User9 ctermbg=236 guibg=" . s:grey236 . " ctermfg=4   guifg=" . s:blue    . " gui=none"
endfunction

call s:UserColors()
