" A simple Vim / Neovim statusline.
"
" URL:          github.com/bluz71/vim-mistfly-statusline
" License:      MIT (https://opensource.org/licenses/MIT)

if exists('g:loaded_mistfly_statusline')
  finish
endif
let g:loaded_mistfly_statusline = 1

" By default do not use Ascii character shapes for dividers and symbols.
let g:mistflyAsciiShapes = get(g:, 'mistflyAsciiShapes', 0)

" The symbol used to indicate the presence of errors in the current buffer. By
" default the x character will be used.
let g:mistflyErrorSymbol = get(g:, 'mistflyErrorSymbol', 'x')

" The symbol used to indicate the presence of warnings in the current buffer. By
" default the exclamation symbol will be used.
let g:mistflyWarningSymbol = get(g:, 'mistflyWarningSymbol', '!')

" By default do not enable tabline support.
let g:mistflyTabLine = get(g:, 'mistflyTabLine', 0)

" By default do not enable Neovim's winbar support.
let g:mistflyWinBar = get(g:, 'mistflyWinBar', 0)

" By default display Git branches.
let g:mistflyWithGitBranch = get(g:, 'mistflyWithGitBranch', 1)

" By default don't display Gitsigns status.
let g:mistflyWithGitsignsStatus = get(g:, 'mistflyWithGitsignsStatus', 0)

" By default do not display indentation details.
let g:mistflyWithIndentStatus = get(g:, 'mistflyWithIndentStatus', 0)

" By default don't display a Nerd Font filetype icon.
let g:mistflyWithNerdIcon = get(g:, 'mistflyWithNerdIcon', 0)

" By default don't indicate Neovim Diagnostic status.
let g:mistflyWithNvimDiagnosticStatus = get(g:, 'mistflyWithNvimDiagnosticStatus', 0)

" By default don't indicate ALE lint status.
let g:mistflyWithALEStatus = get(g:, 'mistflyWithALEStatus', 0)

" By default don't indicate Coc lint status.
let g:mistflyWithCocStatus = get(g:, 'mistflyWithCocStatus', 0)

function! s:StatusLine(active) abort
    if &buftype ==# 'nofile' || &filetype ==# 'netrw'
        " Likely a file explorer.
        setlocal statusline=%!mistfly_statusline#NoFileStatusLine()
        if exists('&winbar')
            setlocal winbar=
        endif
    elseif &buftype ==# 'nowrite'
        " Don't set a custom status line for certain special windows.
        return
    elseif a:active == v:true
        setlocal statusline=%!mistfly_statusline#ActiveStatusLine()
        if g:mistflyWinBar && exists('&winbar')
            setlocal winbar=%!mistfly_statusline#ActiveWinBar()
        endif
    elseif a:active == v:false
        setlocal statusline=%!mistfly_statusline#InactiveStatusLine()
        if g:mistflyWinBar && exists('&winbar') && winheight(0) > 1
            setlocal winbar=%!mistfly_statusline#InactiveWinBar()
        endif
    endif
endfunction

" Iterate though the windows and update the statusline and winbar for all
" inactive windows.
"
" This is needed when starting Vim with multiple splits, for example 'vim -O
" file1 file2', otherwise all statuslines/winbars will be rendered as if they
" are active. Inactive statuslines/winbar are usually rendered via the WinLeave
" and BufLeave events, but those events are not triggered when starting Vim.
"
" Note - https://jip.dev/posts/a-simpler-vim-statusline/#inactive-statuslines
function! s:UpdateInactiveWindows() abort
    for winnum in range(1, winnr('$'))
        if winnum != winnr()
            call setwinvar(winnum, '&statusline', '%!mistfly_statusline#InactiveStatusLine()')
            if g:mistflyWinBar && exists('&winbar') && winheight(0) > 1
                call setwinvar(winnum, '&winbar', '%!mistfly_statusline#InactiveWinBar()')
            endif
        endif
    endfor
endfunction

function! s:TabLine() abort
    if g:mistflyTabLine
        set tabline=%!mistfly_statusline#TabLine()
    endif
endfunction

function! s:ThemeColors() abort
    if !exists('g:colors_name')
        return
    endif

    if g:colors_name == 'moonfly' || g:colors_name == 'nightfly'
        " Do nothing since both themes already set mistfly mode colors.
    elseif g:colors_name == 'catppuccin'
        call mistfly_statusline#SynthesizeModeHighlight('MistflyNormal', 'DiffText', 'VertSplit', v:false)
        call mistfly_statusline#SynthesizeModeHighlight('MistflyInsert', 'DiffAdd', 'VertSplit', v:false)
        call mistfly_statusline#SynthesizeModeHighlight('MistflyVisual', 'Statement', 'VertSplit', v:false)
        call mistfly_statusline#SynthesizeModeHighlight('MistflyCommand', 'Constant', 'VertSplit', v:false)
        call mistfly_statusline#SynthesizeModeHighlight('MistflyReplace', 'DiffDelete', 'VertSplit', v:false)
    elseif g:colors_name == 'edge' || g:colors_name == 'everforest' || g:colors_name == 'gruvbox-material' || g:colors_name == 'sonokai'
        highlight! link MistflyNormal MiniStatuslineModeNormal
        highlight! link MistflyInsert MiniStatuslineModeInsert
        highlight! link MistflyVisual MiniStatuslineModeVisual
        highlight! link MistflyCommand MiniStatuslineModeCommand
        highlight! link MistflyReplace MiniStatuslineModeReplace
    elseif g:colors_name == 'gruvbox'
        call mistfly_statusline#SynthesizeModeHighlight('MistflyNormal', 'GruvboxFg4', 'GruvboxBg0', v:false)
        call mistfly_statusline#SynthesizeModeHighlight('MistflyInsert', 'GruvboxBlue', 'GruvboxBg0', v:false)
        call mistfly_statusline#SynthesizeModeHighlight('MistflyVisual', 'GruvboxOrange', 'GruvboxBg0', v:false)
        call mistfly_statusline#SynthesizeModeHighlight('MistflyCommand', 'GruvboxGreen', 'GruvboxBg0', v:false)
        call mistfly_statusline#SynthesizeModeHighlight('MistflyReplace', 'GruvboxRed', 'GruvboxBg0', v:false)
    elseif g:colors_name == 'nightfox' || g:colors_name == 'nordfox' || g:colors_name == 'terafox'
        highlight! link MistflyNormal Todo
        highlight! link MistflyInsert MiniStatuslineModeInsert
        highlight! link MistflyVisual MiniStatuslineModeVisual
        highlight! link MistflyCommand MiniStatuslineModeCommand
        highlight! link MistflyReplace MiniStatuslineModeReplace
    elseif g:colors_name == 'tokyonight'
        highlight! link MistflyNormal TablineSel
        call mistfly_statusline#SynthesizeModeHighlight('MistflyInsert', 'String', 'VertSplit', v:false)
        highlight! link MistflyVisual Sneak
        highlight! link MistflyReplace Substitute
        highlight! link MistflyCommand Todo
    else
        " Fallback for all other colorschemes.
        if !hlexists('MistflyNormal') || synIDattr(synIDtrans(hlID('MistflyNormal')), 'bg') == ''
            call mistfly_statusline#SynthesizeModeHighlight('MistflyNormal', 'Directory', 'VertSplit', v:false)
        endif
        if !hlexists('MistflyInsert') || synIDattr(synIDtrans(hlID('MistflyInsert')), 'bg') == ''
            call mistfly_statusline#SynthesizeModeHighlight('MistflyInsert', 'String', 'VertSplit', v:false)
        endif
        if !hlexists('MistflyVisual') || synIDattr(synIDtrans(hlID('MistflyVisual')), 'bg') == ''
            call mistfly_statusline#SynthesizeModeHighlight('MistflyVisual', 'Statement', 'VertSplit', v:false)
        endif
        if !hlexists('MistflyCommand') || synIDattr(synIDtrans(hlID('MistflyCommand')), 'bg') == ''
            call mistfly_statusline#SynthesizeModeHighlight('MistflyCommand', 'WarningMsg', 'VertSplit', v:false)
        endif
        if !hlexists('MistflyReplace') || synIDattr(synIDtrans(hlID('MistflyReplace')), 'bg') == ''
            call mistfly_statusline#SynthesizeModeHighlight('MistflyReplace', 'Error', 'VertSplit', v:false)
        endif
    endif

    " Synthesize emphasis colors from the existing mode colors.
    call mistfly_statusline#SynthesizeModeHighlight('MistflyNormalEmphasis', 'StatusLine', 'MistflyNormal', v:true)
    call mistfly_statusline#SynthesizeModeHighlight('MistflyInsertEmphasis', 'StatusLine', 'MistflyInsert', v:true)
    call mistfly_statusline#SynthesizeModeHighlight('MistflyVisualEmphasis', 'StatusLine', 'MistflyVisual', v:true)
    call mistfly_statusline#SynthesizeModeHighlight('MistflyCommandEmphasis', 'StatusLine', 'MistflyCommand', v:true)
    call mistfly_statusline#SynthesizeModeHighlight('MistflyReplaceEmphasis', 'StatusLine', 'MistflyReplace', v:true)

    " Synthesize plugin colors from existing highlight groups.
    if g:mistflyWithGitsignsStatus
        call mistfly_statusline#SynthesizeHighlight('MistflyGitAdd', 'GitSignsAdd')
        call mistfly_statusline#SynthesizeHighlight('MistflyGitChange', 'GitSignsChange')
        call mistfly_statusline#SynthesizeHighlight('MistflyGitDelete', 'GitSignsDelete')
    endif
    if g:mistflyWithNvimDiagnosticStatus
        call mistfly_statusline#SynthesizeHighlight('MistflyDiagnosticError', 'DiagnosticError')
        call mistfly_statusline#SynthesizeHighlight('MistflyDiagnosticWarning', 'DiagnosticWarn')
    endif
    if g:mistflyWithALEStatus
        call mistfly_statusline#SynthesizeHighlight('MistflyDiagnosticError', 'ALEErrorSign')
        call mistfly_statusline#SynthesizeHighlight('MistflyDiagnosticWarning', 'ALEWarningSign')
    endif
    if g:mistflyWithCocStatus
        highlight! link MistflyDiagnosticError MistflyNotification
        highlight! link MistflyDiagnosticWarning MistflyNotification
    endif
    if exists('g:loaded_obsession')
        call mistfly_statusline#SynthesizeHighlight('MistflyObsession', 'Error')
    endif
endfunction

augroup mistflyStatuslineEvents
    autocmd!
    autocmd VimEnter              * call s:UpdateInactiveWindows()
    autocmd VimEnter              * call s:TabLine()
    autocmd ColorScheme,SourcePre * call s:ThemeColors()
    autocmd WinEnter,BufWinEnter  * call s:StatusLine(v:true)
    autocmd WinLeave              * call s:StatusLine(v:false)
    if exists('##CmdlineEnter')
        autocmd CmdlineEnter      * call s:StatusLine(v:true) | redraw
    endif
augroup END
