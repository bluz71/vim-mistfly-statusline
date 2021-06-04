" A simple Vim / Neovim statusline that uses moonfly colors by default.
"
" URL:          github.com/bluz71/vim-moonfly-statusline
" License:      MIT (https://opensource.org/licenses/MIT)

if exists('g:loaded_moonfly_statusline')
  finish
endif
let g:loaded_moonfly_statusline = 1

" By default use moonfly colors.
let g:moonflyIgnoreDefaultColors = get(g:, 'moonflyIgnoreDefaultColors', 0)
" DEPRECATED option, use 'g:moonflyIgnoreDefaultColors' option instead.
let g:moonflyHonorUserDefinedColors = get(g:, 'moonflyHonorUserDefinedColors', 0)

" By default display Git branches.
let g:moonflyWithGitBranch = get(g:, 'moonflyWithGitBranch', 1)

" By default don't display Git branches with the U+E0A0 branch character.
let g:moonflyWithGitBranchCharacter = get(g:, 'moonflyWithGitBranchCharacter', 0)

" The character used to indicate the presence of linter errors and warnings in
" the current buffer. By default the U+2716 cross symbol will be used.
let g:moonflyLinterIndicator = get(g:, 'moonflyLinterIndicator', '✖')

" The character used to indicate the presence of diagnostics in the current
" buffer. By default the U+2716 cross symbol will be used.
let g:moonflyDiagnosticsIndicator = get(g:, 'moonflyDiagnosticsIndicator', '✖')

" By default don't display a Nerd Font filetype icon.
let g:moonflyWithNerdIcon = get(g:, 'moonflyWithNerdIcon', 0)

" By default don't indicate ALE lint errors via the defined
" g:moonflyLinterIndicator.
let g:moonflyWithALEIndicator = get(g:, 'moonflyWithALEIndicator', 0)

" By default don't indicate Coc lint errors via the defined
" g:moonflyDiagnosticsIndicator.
let g:moonflyWithCocIndicator = get(g:, 'moonflyWithCocIndicator', 0)

" By default don't indicate Neovim LSP diagnostics via the defined
" g:moonflyDiagnosticsIndicator.
let g:moonflyWithNvimLspIndicator = get(g:, 'moonflyWithNvimLspIndicator', 0)

" By default don't use geometric shapes, U+25A0 - Black Square & U+25CF - Black
" Circle, to indicate the obsession (https://github.com/tpope/vim-obsession)
" status.
let g:moonflyWithObessionGeometricCharacters = get(g:, 'moonflyWithObessionGeometricCharacters', 0)

" The moonfly colors (https://github.com/bluz71/vim-moonfly-colors)
let s:white   = '#c6c6c6' " white   = 251
let s:grey234 = '#1c1c1c' " grey234 = 234
let s:emerald = '#42cf89' " emerald = 10
let s:blue    = '#80a0ff' " blue    = 4
let s:purple  = '#ae81ff' " purple  = 13
let s:crimson = '#f74782' " crimson = 9

function! s:StatusLine(active) abort
    if &buftype ==# 'nofile' || &filetype ==# 'netrw'
        " Likely a file explorer.
        setlocal statusline=%!moonfly_statusline#NoFileStatusLine()
    elseif &buftype ==# 'nowrite'
        " Don't set a custom status line for certain special windows.
        return
    elseif a:active == 1
        setlocal statusline=%!moonfly_statusline#ActiveStatusLine()
    else
        setlocal statusline=%!moonfly_statusline#InactiveStatusLine()
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
function! s:UpdateInactiveWindows() abort
    for winnum in range(1, winnr('$'))
        if winnum != winnr()
            call setwinvar(winnum, '&statusline', '%!moonfly_statusline#InactiveStatusLine()')
        endif
    endfor
endfunction

function! s:UserColors() abort
    if g:moonflyIgnoreDefaultColors || g:moonflyHonorUserDefinedColors
        return
    endif

    " Leverage existing 'colorscheme' StatusLine colors taking into account the
    " 'reverse' option.
    if synIDattr(synIDtrans(hlID('StatusLine')), 'reverse', 'cterm') == 1
        let l:slBgCterm = synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'cterm')
    else
        let l:slBgCterm = synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'cterm')
    endif
    if synIDattr(synIDtrans(hlID('StatusLine')), 'reverse', 'gui') == 1
        let l:slBgGui = synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'gui')
    else
        let l:slBgGui = synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'gui')
    endif
    " Fallback to moonfly colors when the current color scheme does not define
    " StatusLine colors.
    if len(l:slBgCterm) == 0
        let l:slBgCterm = '236'
    endif
    if len(l:slBgGui) == 0
        let l:slBgGui = '#303030'
    endif

    " Set user colors that will be used to color certain sections of the status
    " line.
    exec 'highlight User1 ctermbg=4   guibg=' . s:blue    . ' ctermfg=234 guifg=' . s:grey234
    exec 'highlight User2 ctermbg=251 guibg=' . s:white   . ' ctermfg=234 guifg=' . s:grey234
    exec 'highlight User3 ctermbg=13  guibg=' . s:purple  . ' ctermfg=234 guifg=' . s:grey234
    exec 'highlight User4 ctermbg=9   guibg=' . s:crimson . ' ctermfg=234 guifg=' . s:grey234
    exec 'highlight User5 ctermbg=' . l:slBgCterm . ' guibg=' . l:slBgGui . ' ctermfg=4   guifg=' . s:blue    . ' gui=none'
    exec 'highlight User6 ctermbg=' . l:slBgCterm . ' guibg=' . l:slBgGui . ' ctermfg=9   guifg=' . s:crimson . ' gui=none'
    exec 'highlight User7 ctermbg=' . l:slBgCterm . ' guibg=' . l:slBgGui . ' ctermfg=4   guifg=' . s:blue    . ' gui=none'
endfunction

augroup MoonflyStatuslineEvents
    autocmd!
    autocmd VimEnter              * call s:UpdateInactiveWindows()
    autocmd ColorScheme,SourcePre * call s:UserColors()
    autocmd WinEnter,BufWinEnter  * call s:StatusLine(1)
    autocmd WinLeave              * call s:StatusLine(0)
    if exists('##CmdlineEnter')
        autocmd CmdlineEnter      * call s:StatusLine(1) | redraw
    endif
augroup END
