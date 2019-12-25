" A simple Vim/Neovim status line using moonfly colors.
"
" URL:          github.com/bluz71/vim-moonfly-statusline
" License:      MIT (https://opensource.org/licenses/MIT)

if exists("g:loaded_moonfly_statusline")
  finish
endif
let g:loaded_moonfly_statusline = 1

" By default don't display Git branches using the U+E0A0 branch character.
let g:moonflyWithGitBranchCharacter = get(g:, "moonflyWithGitBranchCharacter", 0)

" By default don't use geometric shapes, U+25A0 - Black Square & U+25CF - Black
" Circle, to indicate the obsession (https://github.com/tpope/vim-obsession)
" status.
let g:moonflyWithObessionGeometricCharacters = get(g:, "moonflyWithObessionGeometricCharacters", 0)

" By default always use moonfly colors and ignore any user-defined colors.
let g:moonflyHonorUserDefinedColors = get(g:, "moonflyHonorUserDefinedColors", 0)

let s:modes = {
  \  "n":      ["%1*", " normal "],
  \  "i":      ["%2*", " insert "],
  \  "R":      ["%4*", " r-mode "],
  \  "v":      ["%3*", " visual "],
  \  "V":      ["%3*", " v-line "],
  \  "\<C-v>": ["%3*", " v-rect "],
  \  "c":      ["%1*", " c-mode "],
  \  "s":      ["%3*", " select "],
  \  "S":      ["%3*", " s-line "],
  \  "\<C-s>": ["%3*", " s-rect "],
  \  "t":      ["%2*", " term "],
  \}

" The moonfly colors (https://github.com/bluz71/vim-moonfly-colors)
let s:white   = "#c6c6c6" " white   = 251
let s:grey236 = "#303030" " grey236 = 236
let s:grey234 = "#1c1c1c" " grey234 = 234
let s:grey247 = "#9e9e9e" " grey247 = 247
let s:emerald = "#42cf89" " emerald = 10
let s:blue    = "#80a0ff" " blue    = 4
let s:purple  = "#ae81ff" " purple  = 13
let s:crimson = "#f74782" " crimson = 9

function! MoonflyModeColor(mode)
  return get(s:modes, a:mode, "%*1")[0]
endfunction

function! MoonflyModeText(mode)
  return get(s:modes, a:mode, " normal ")[1]
endfunction

function! MoonflyFugitiveBranch()
    if !exists("g:loaded_fugitive") || !exists("b:git_dir")
        return ""
    endif

    if g:moonflyWithGitBranchCharacter
        return "[ " . fugitive#head() . "]"
    else
        return fugitive#statusline()
    endif
endfunction

function! MoonflyObsessionStatus()
    if !exists("g:loaded_obsession")
        return ""
    endif

    if g:moonflyWithObessionGeometricCharacters
        return ObsessionStatus("[●] ", "[■] ")
    else
        return ObsessionStatus("[$] ", "[S] ")
    endif
endfunction

function! MoonflyShortFilePath()
    if &buftype == "terminal"
        return expand("%:t")
    else
        return pathshorten(expand("%:f"))
    endif
endfunction

function! MoonflyActiveStatusLine()
    let l:statusline = ""
    let l:mode = mode()

    let l:statusline  = MoonflyModeColor(l:mode)
    let l:statusline .= MoonflyModeText(l:mode)
    let l:statusline .= "%* %<%{MoonflyShortFilePath()} %h%m%r"
    let l:statusline .= "%5* %{MoonflyFugitiveBranch()} "
    let l:statusline .= "%6*%=%-12.(%l,%c%V%)"
    let l:statusline .= "%7*[%L] "
    let l:statusline .= "%8*%{MoonflyObsessionStatus()}"
    let l:statusline .= "%6*%P "

    return l:statusline
endfunction

function! MoonflyInactiveStatusLine()
    let l:statusline = ""

    let l:statusline  = " %*%<%{MoonflyShortFilePath()}\ %h%m%r"
    let l:statusline .= "%*%=%-14.(%l,%c%V%)[%L]\ %P"

    return l:statusline
endfunction

function! s:StatusLine(mode)
    let l:bn = bufname("%")
    if &buftype == "nofile" || l:bn == "[BufExplorer]" || l:bn == "undotree_2"
        " Don't set a custom status line for special windows.
        return
    elseif a:mode == "inactive"
        setlocal statusline=%!MoonflyInactiveStatusLine()
    else
        setlocal statusline=%!MoonflyActiveStatusLine()
    endif
endfunction

" Iterate though the windows and update the status line for all inactive
" windows.
"
" This is needed when starting Vim with multiple splits, for example 'vim -O
" file1 file2', otherwise all 'status lines will be rendered as if they are
" active. Inactive statuslines are usually rendered via the WinLeave and
" BufLeave events, but those events are not triggered when starting Vim.
"
" Note - https://jip.dev/posts/a-simpler-vim-statusline/#inactive-statuslines
function! s:UpdateInactiveWindows()
    for winnum in range(1, winnr('$'))
        if winnum != winnr()
            call setwinvar(winnum, '&statusline', '%!MoonflyInactiveStatusLine()')
        endif
    endfor
endfunction

function! s:UserColors()
    if g:moonflyHonorUserDefinedColors
        return
    endif

    " Set base status line colors.
    exec "highlight StatusLine   ctermbg=236 guibg=" . s:grey236 . " ctermfg=251 guifg=" . s:white . "   cterm=none gui=none"
    exec "highlight StatusLineNC ctermbg=236 guibg=" . s:grey236 . " ctermfg=247 guifg=" . s:grey247 . " cterm=none gui=none"

    " Set user colors that will be used to color certain sections of the status
    " line.
    exec "highlight User1 ctermbg=4   guibg=" . s:blue    . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User2 ctermbg=251 guibg=" . s:white   . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User3 ctermbg=13  guibg=" . s:purple  . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User4 ctermbg=9   guibg=" . s:crimson . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User5 ctermbg=236 guibg=" . s:grey236 . " ctermfg=10  guifg=" . s:emerald . " gui=none"
    exec "highlight User6 ctermbg=236 guibg=" . s:grey236 . " ctermfg=251 guifg=" . s:white   . " gui=none"
    exec "highlight User7 ctermbg=236 guibg=" . s:grey236 . " ctermfg=4   guifg=" . s:blue    . " gui=none"
    exec "highlight User8 ctermbg=236 guibg=" . s:grey236 . " ctermfg=9   guifg=" . s:crimson . " gui=none"
endfunction

augroup MoonflyStatuslineAutocmds
    autocmd!
    autocmd VimEnter              * call s:UpdateInactiveWindows()
    autocmd ColorScheme,SourcePre * call s:UserColors()
    autocmd WinEnter,BufWinEnter  * call s:StatusLine("active")
    autocmd WinLeave              * call s:StatusLine("inactive")
    if exists("##CmdlineEnter")
        autocmd CmdlineEnter      * call s:StatusLine("command") | redraw
    endif
augroup END
