" A simple Vim/Neovim status line using moonfly colors.
"
" URL:          github.com/bluz71/vim-moonfly-statusline
" License:      MIT (https://opensource.org/licenses/MIT)

if exists("g:loaded_moonfly_statusline")
  finish
endif
let g:loaded_moonfly_statusline = 1

" By default don't indicate ALE lint errors via the defined
" g:moonflyDiagnosticsIndicator.
let g:moonflyWithALEIndicator = get(g:, "moonflyWithALEIndicator", 0)

" The character used to indicate the presence of diagnostic errors in the
" current buffer. By default the U+2716 cross symbol will be used. Currently
" only ALE linting errors may be indicated. In future other diagnostic systems
" may also be supported.
let g:moonflyDiagnosticsIndicator = get(g:, "moonflyDiagnosticsIndicator", "✖")

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
        return ObsessionStatus("● ", "■ ")
    else
        return ObsessionStatus("$ ", "S ")
    endif
endfunction

function! MoonflyDiagnosticsStatus()
    if !g:moonflyWithALEIndicator || !exists("g:loaded_ale")
        return ""
    endif

    if ale#statusline#Count(bufnr('')).total > 0
        return g:moonflyDiagnosticsIndicator . " "
    else
        return ""
    endif
endfunction

function! MoonflyShortFilePath()
    if &buftype == "terminal"
        return expand("%:t")
    else
        let l:path = expand("%:f")
        if len(l:path) == 0
            return ""
        else
            return pathshorten(fnamemodify(expand("%:f"), ":~:."))
        endif
    endif
endfunction

function! MoonflyActiveStatusLine()
    let l:mode = mode()
    let l:statusline = MoonflyModeColor(l:mode)
    let l:statusline .= MoonflyModeText(l:mode)
    let l:statusline .= "%* %<%{MoonflyShortFilePath()} %H%M%R"
    let l:statusline .= "%5* %{MoonflyFugitiveBranch()} "
    let l:statusline .= "%8*%{MoonflyObsessionStatus()}%{MoonflyDiagnosticsStatus()}"
    let l:statusline .= "%6*%=%l:%c | %7*%L%6* | %P "
    return l:statusline
endfunction

function! MoonflyInactiveStatusLine()
    let l:statusline  = " %*%<%{MoonflyShortFilePath()}\ %h%m%r"
    let l:statusline .= "%*%=%l:%c | %L | %P "
    return l:statusline
endfunction

function! MoonflyNoFileStatusLine()
    let l:statusline = " %{pathshorten(fnamemodify(getcwd(), ':~:.'))}"
    return l:statusline
endfunction

function! s:StatusLine(active)
    let l:bn = bufname("%")
    if &buftype == "nofile" || &filetype == "netrw"
        setlocal statusline=%!MoonflyNoFileStatusLine()
    elseif l:bn == "undotree_2"
        " Don't set a custom status line for certain special windows.
        return
    elseif a:active == v:true
        setlocal statusline=%!MoonflyActiveStatusLine()
    else
        setlocal statusline=%!MoonflyInactiveStatusLine()
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

    " Set user colors that will be used to color certain sections of the status
    " line.
    exec "highlight User1 ctermbg=4   guibg=" . s:blue    . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User2 ctermbg=251 guibg=" . s:white   . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User3 ctermbg=13  guibg=" . s:purple  . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User4 ctermbg=9   guibg=" . s:crimson . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User5 ctermbg=236 guibg=" . s:grey236 . " ctermfg=4   guifg=" . s:blue    . " gui=none"
    exec "highlight User6 ctermbg=236 guibg=" . s:grey236 . " ctermfg=251 guifg=" . s:white   . " gui=none"
    exec "highlight User7 ctermbg=236 guibg=" . s:grey236 . " ctermfg=4   guifg=" . s:blue    . " gui=none"
    exec "highlight User8 ctermbg=236 guibg=" . s:grey236 . " ctermfg=9   guifg=" . s:crimson . " gui=none"
endfunction

augroup MoonflyStatuslineAutocmds
    autocmd!
    autocmd VimEnter              * call s:UpdateInactiveWindows()
    autocmd ColorScheme,SourcePre * call s:UserColors()
    autocmd WinEnter,BufWinEnter  * call s:StatusLine(v:true)
    autocmd WinLeave              * call s:StatusLine(v:false)
    if exists("##CmdlineEnter")
        autocmd CmdlineEnter      * call s:StatusLine(v:true) | redraw
    endif
augroup END
