" Refer to ':help mode()' for the full list of available modes. For now only
" handle the most common modes.
let s:modes_map = {
  \  'n':      ['%#MistflyNormal#', ' normal ', '%#MistflyNormalEmphasis#'],
  \  'no':     ['%#MistflyNormal#', ' o-pend ', '%#MistflyNormalEmphasis#'],
  \  'niI':    ['%#MistflyNormal#', ' i-pend ', '%#MistflyNormalEmphasis#'],
  \  'niR':    ['%#MistflyNormal#', ' r-pend ', '%#MistflyNormalEmphasis#'],
  \  'i':      ['%#MistflyInsert#', ' insert ', '%#MistflyInsertEmphasis#'],
  \  'ic':      ['%#MistflyInsert#', ' i-comp ', '%#MistflyInsertEmphasis#'],
  \  'ix':      ['%#MistflyInsert#', ' i-comp ', '%#MistflyInsertEmphasis#'],
  \  'v':      ['%#MistflyVisual#', ' visual ', '%#MistflyVisualEmphasis#'],
  \  'vs':      ['%#MistflyVisual#', ' visual ', '%#MistflyVisualEmphasis#'],
  \  'V':      ['%#MistflyVisual#', ' v-line ', '%#MistflyVisualEmphasis#'],
  \  'Vs':      ['%#MistflyVisual#', ' v-line ', '%#MistflyVisualEmphasis#'],
  \  "\<C-v>": ['%#MistflyVisual#', ' v-bloc ', '%#MistflyVisualEmphasis#'],
  \  's':      ['%#MistflyVisual#', ' select ', '%#MistflyVisualEmphasis#'],
  \  'S':      ['%#MistflyVisual#', ' s-line ', '%#MistflyVisualEmphasis#'],
  \  "\<C-s>": ['%#MistflyVisual#', ' s-bloc ', '%#MistflyVisualEmphasis#'],
  \  'c':      ['%#MistflyCommand#', ' c-mode ', '%#MistflyCommandEmphasis#'],
  \  'r':      ['%#MistflyCommand#', ' prompt ', '%#MistflyCommandEmphasis#'],
  \  'rm':      ['%#MistflyCommand#', ' prompt ', '%#MistflyCommandEmphasis#'],
  \  'r?':      ['%#MistflyCommand#', ' prompt ', '%#MistflyCommandEmphasis#'],
  \  '!':      ['%#MistflyCommand#', ' !-mode ', '%#MistflyCommandEmphasis#'],
  \  'R':      ['%#MistflyReplace#', ' r-mode ', '%#MistflyReplaceEmphasis#'],
  \  'Rc':      ['%#MistflyReplace#', ' r-comp ', '%#MistflyReplaceEmphasis#'],
  \  'Rx':      ['%#MistflyReplace#', ' r-comp ', '%#MistflyReplaceEmphasis#'],
  \  't':      ['%#MistflyInsert#', ' t-mode ', '%#MistflyInsertEmphasis#'],
  \  'nt':      ['%#MistflyInsert#', ' normal ', '%#MistflyInsertEmphasis#'],
  \}

" Cache current statusline background for performance reasons; that being to
" avoid needless highlight extraction and generation.
let s:statusline_bg = ''

"===========================================================
" Utilities
"===========================================================

function! s:StatuslineWidth() abort
    if &laststatus == 3
        return &columns
    else
        return winwidth(0)
    end
endfunction

function! mistfly#File() abort
    let l:statusline_width = s:StatuslineWidth()

    return s:FileIcon() . s:FilePath(l:statusline_width < 120)
endfunction

function! s:FileIcon() abort
    if !g:mistflyWithFileIcon || bufname('%') == ''
        return ''
    endif

    if exists('g:nvim_web_devicons')
        return luaeval("require'nvim-web-devicons'.get_icon(vim.fn.expand('%'), nil, { default = true })") . ' '
    elseif exists('g:loaded_webdevicons')
        return WebDevIconsGetFileTypeSymbol() . ' '
    else
        return ''
    endif
endfunction

function! s:FilePath(short_path) abort
    if len(expand('%:f')) == 0
        return ''
    end

    if &buftype ==# 'terminal'
        return expand('%:t')
    endif

    let l:separator = '/'
    if has('win64')
        let l:separator = '\'
    endif

    if a:short_path
        let l:path = pathshorten(fnamemodify(expand('%:f'), ':~:.'))
    else
        let l:path = fnamemodify(expand('%:f'), ':~:.')
    endif
    let l:pathComponents = split(l:path, l:separator)
    let l:numPathComponents = len(l:pathComponents)
    if l:numPathComponents > 4
        let l:path = g:mistflyEllipsisSymbol . l:separator
        let l:path .= join(l:pathComponents[l:numPathComponents - 4:], l:separator)
    endif

    return l:path
endfunction

" Iterate though the windows and update the statusline for all inactive windows.
"
" This is needed when starting Vim with multiple splits, for example 'vim -O
" file1 file2', otherwise all statuslines will be rendered as if they are
" active. Inactive statuslines are usually rendered via the WinLeave and
" BufLeave events, but those events are not triggered when starting Vim.
"
" Note - https://jip.dev/posts/a-simpler-vim-statusline/#inactive-statuslines
function! mistfly#UpdateInactiveWindows() abort
    for winnum in range(1, winnr('$'))
        if winnum != winnr()
            call setwinvar(winnum, '&statusline', '%!mistfly#InactiveStatusLine()')
        endif
    endfor
endfunction

function! mistfly#GitBranchName() abort
    if !g:mistflyWithGitBranch || bufname('%') == ''
        return ''
    endif

    let l:git_branch_name = ''
    if exists('g:loaded_fugitive')
        " Fugitive is available, let's use it to access the branch name.
        let l:git_branch_name = FugitiveHead()
    elseif exists('b:git_branch_name')
        " Else use fallback detection.
        let l:git_branch_name = b:git_branch_name
    endif

    if len(l:git_branch_name) == 0
        return ''
    elseif strlen(l:git_branch_name) > 30
        " Truncate long branch names to 30 characters.
        let l:git_branch_name = strpart(l:git_branch_name, 0, 29) . g:mistflyEllipsisSymbol
    endif

    if len(g:mistflyGitBranchSymbol) == 0
        return ' ' . l:git_branch_name
    else
        return ' ' . g:mistflyGitBranchSymbol . ' ' . l:git_branch_name
    endif
endfunction

function! mistfly#PluginsStatus() abort
    let l:segments = ''
    let l:added = 0
    let l:changed = 0
    let l:removed = 0
    let l:errors = 0
    let l:warnings = 0
    let l:information = 0

    if g:mistflyWithGitStatus && has('nvim-0.5') && luaeval("package.loaded.gitsigns ~= nil")
        " Gitsigns status.
        let l:counts = get(b:, 'gitsigns_status_dict', {})
        let l:added = get(l:counts, 'added', 0)
        let l:changed = get(l:counts, 'changed', 0)
        let l:removed = get(l:counts, 'removed', 0)
    elseif g:mistflyWithGitStatus && exists('g:loaded_gitgutter') && get(g:, 'gitgutter_enabled')
        " GitGutter status.
        let [l:added, l:changed, l:removed] = GitGutterGetHunkSummary()
    elseif g:mistflyWithGitStatus && exists('g:loaded_signify')
        " Signify status.
        let [l:added, l:changed, l:removed] = sy#repo#get_stats()
    endif

    " Git plugin status.
    if l:added > 0
        let l:segments .= ' %#MistflyGitAdd#+' . l:added . '%*'
    endif
    if l:changed > 0
        let l:segments .= ' %#MistflyGitChange#~' . l:changed . '%*'
    endif
    if l:removed > 0
        let l:segments .= ' %#MistflyGitDelete#-' . l:removed . '%*'
    endif
    if len(l:segments) > 0
        let l:segments .= ' '
    endif

    if g:mistflyWithDiagnosticStatus && exists('g:loaded_ale')
        " ALE status.
        let l:counts = ale#statusline#Count(bufnr(''))
        if has_key(l:counts, 'error')
            let l:errors = l:counts['error']
        endif
        if has_key(l:counts, 'warning')
            let l:warnings = l:counts['warning']
        endif
        if has_key(l:counts, 'info')
            let l:information = l:counts['info']
        endif
    elseif g:mistflyWithDiagnosticStatus && exists('g:did_coc_loaded')
        " Coc status.
        let l:counts = get(b:, 'coc_diagnostic_info', {})
        if has_key(l:counts, 'error')
            let l:errors = l:counts['error']
        endif
        if has_key(l:counts, 'warning')
            let l:warnings = l:counts['warning']
        endif
        if has_key(l:counts, 'information')
            let l:information = l:counts['information']
        endif
    endif

    " Display errors and warnings from any of the previous diagnostic or linting
    " systems.
    if l:errors > 0
        let l:segments .= ' %#MistflyDiagnosticError#' . g:mistflyErrorSymbol
        let l:segments .= ' ' . l:errors . '%*'
    endif
    if l:warnings > 0
        let l:segments .= ' %#MistflyDiagnosticWarning#' . g:mistflyWarningSymbol
        let l:segments .= ' ' . l:warnings . '%*'
    endif
    if l:information > 0
        let l:segments .= ' %#MistflyDiagnosticInformation#' . g:mistflyInformationSymbol
        let l:segments .= ' ' . l:information . '%*'
    endif
    if l:errors > 0 || l:warnings > 0 || l:information > 0
        let l:segments .= ' '
    endif

    " Obsession plugin status.
    if g:mistflyWithSessionStatus && exists('g:loaded_obsession')
        let l:obsession_status = ObsessionStatus('obsession', '!obsession')
        if len(l:obsession_status) > 0
            let l:segments .= ' %#MistflySession#' . l:obsession_status . '%*'
        endif
    endif

    return l:segments
endfunction

function! mistfly#SearchCount() abort
    if !exists('*searchcount')
        return ''
    endif
    let l:result = searchcount(#{recompute: 1, maxcount: 0})
    if empty(l:result)
        return ''
    endif
    if l:result.incomplete == 1 " timed out
        return '[?/??]'
    elseif l:result.incomplete == 2 " max count exceeded
        if l:result.total > l:result.maxcount && l:result.current > l:result.maxcount
            return printf('[>%d/>%d]', l:result.current, l:result.total)
        elseif l:result.total > l:result.maxcount
            return printf('[%d/>%d]', l:result.current, l:result.total)
        endif
    endif
    if l:result.total ==# 0
        return ''
    endif
    return printf('[%d/%d]', l:result.current, l:result.total)
endfunction

function! mistfly#IndentStatus() abort
    if !&expandtab
        return 'Tab:' . &tabstop
    else
        let l:size = &shiftwidth
        if l:size == 0
            let l:size = &tabstop
        end
        return 'Spc:' . l:size
    endif
endfunction

"===========================================================
" Status line
"===========================================================

function! mistfly#ActiveStatusLine() abort
    let l:statusline_width = s:StatuslineWidth()

    let l:mode = mode()
    let l:separator = g:mistflySeparatorSymbol
    let l:progress =  g:mistflyProgressSymbol
    let l:branch_name = mistfly#GitBranchName()
    let l:plugins_status = mistfly#PluginsStatus()
    let l:mode_emphasis = get(s:modes_map, l:mode, '%#MistflyNormalEmphasis#')[2]

    let l:statusline = get(s:modes_map, l:mode, '%#MistflyNormal#')[0]
    if l:statusline_width < 80
        let l:statusline .= strpart(get(s:modes_map, l:mode, 'n')[1], 0, 2) . ' '
    else
        let l:statusline .= get(s:modes_map, l:mode, ' normal ')[1]
    endif
    let l:statusline .= '%* %<%{mistfly#File()}'
    let l:statusline .= "%q%{exists('w:quickfix_title')? ' ' . w:quickfix_title : ''}"
    let l:statusline .= "%{&modified ? '+\ ' : ' \ \ '}"
    let l:statusline .= "%{&readonly ? 'RO\ ' : ''}"
    if len(l:branch_name) > 0 && l:statusline_width >= 80
        let l:statusline .= '%*' . l:separator . l:mode_emphasis
        let l:statusline .= l:branch_name . '%* '
    endif
    if len(l:plugins_status) > 0 && l:statusline_width >= 80
        let l:statusline .= mistfly#PluginsStatus()
        let l:statusline .= '%*'
    endif
    let l:statusline .= '%='
    if g:mistflyWithSearchCount && v:hlsearch && l:statusline_width >= 80
        let l:search_count = mistfly#SearchCount()
        if len(l:search_count) > 0
            let l:statusline .= l:search_count . ' ' . l:separator . ' '
        endif
    endif
    if g:mistflyWithSpellStatus && &spell && l:statusline_width >= 80
        let l:statusline .= 'Spell ' . l:separator . ' '
    endif
    let l:statusline .= '%l:%c ' . l:separator
    let l:statusline .= ' ' . l:mode_emphasis . '%L%* ' . l:progress . '%P '
    if g:mistflyWithIndentStatus
        let l:statusline .= l:separator . ' %{mistfly#IndentStatus()} '
    endif

    return l:statusline
endfunction

function! mistfly#InactiveStatusLine() abort
    let l:separator = g:mistflySeparatorSymbol
    let l:progress =  g:mistflyProgressSymbol

    let l:statusline = ' %<%{mistfly#File()}'
    let l:statusline .= "%{&modified?'+\ ':' \ \ '}"
    let l:statusline .= "%{&readonly?'RO\ ':''}"
    let l:statusline .= '%=%l:%c ' . l:separator . ' %L ' . l:progress . '%P '
    if g:mistflyWithIndentStatus
        let l:statusline .= l:separator . ' %{mistfly#IndentStatus()} '
    endif

    return l:statusline
endfunction

function! mistfly#NoFileStatusLine() abort
    return pathshorten(fnamemodify(getcwd(), ':~:.'))
endfunction

function! mistfly#StatusLine(active) abort
    if &buftype ==# 'nofile' || &filetype ==# 'netrw'
        " Likely a file explorer or some other special type of buffer. Set a
        " short path statusline for these types of buffers.
        setlocal statusline=%!mistfly#NoFileStatusLine()
    elseif &buftype ==# 'nowrite'
        " Don't set a custom statusline for certain special windows.
        return
    elseif a:active == v:true
        setlocal statusline=%!mistfly#ActiveStatusLine()
    elseif a:active == v:false
        setlocal statusline=%!mistfly#InactiveStatusLine()
    endif
endfunction

"===========================================================
" Tab line
"===========================================================

function! mistfly#ActiveTabLine() abort
    let l:symbol = g:mistflyActiveTabSymbol
    let l:tabline = ''
    let l:counter = 0

    for i in range(tabpagenr('$'))
        let l:counter = l:counter + 1
        if has('tablineat')
            let l:tabline .= '%' . l:counter . 'T'
        endif
        if tabpagenr() == counter
            let l:tabline .= '%#TablineSelSymbol#' . l:symbol
            let l:tabline .= '%#TablineSel# Tab:'
        else
            let l:tabline .= '%#TabLine#  Tab:'
        endif
        let l:tabline .= l:counter
        if has('tablineat')
            let l:tabline .= '%T'
        endif
        let l:tabline .= '  %#TabLineFill#'
    endfor

    return l:tabline
endfunction

function! mistfly#TabLine() abort
    if g:mistflyTabLine
        set tabline=%!mistfly#ActiveTabLine()
    endif
endfunction

"===========================================================
" Highlights
"===========================================================

function! mistfly#GenerateHighlightGroups() abort
    if !exists('g:colors_name')
        return
    endif

    " Extract current StatusLine background color, we will likely need it.
    if synIDattr(synIDtrans(hlID('StatusLine')), 'reverse', 'gui') == 1
        " Need to handle reversed highlights, such as Gruvbox StatusLine.
        let s:statusline_bg = synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'gui')
    else
        " Most colorschemes fall through to here.
        let s:statusline_bg = synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'gui')
    endif

    " Mode highlights.
    call s:ColorSchemeModeHighlights()

    " Synthesize emphasis colors from the existing mode colors.
    call s:SynthesizeHighlight('MistflyNormalEmphasis', 'MistflyNormal', v:true)
    call s:SynthesizeHighlight('MistflyInsertEmphasis', 'MistflyInsert', v:true)
    call s:SynthesizeHighlight('MistflyVisualEmphasis', 'MistflyVisual', v:true)
    call s:SynthesizeHighlight('MistflyCommandEmphasis', 'MistflyCommand', v:true)
    call s:SynthesizeHighlight('MistflyReplaceEmphasis', 'MistflyReplace', v:true)

    " Synthesize plugin colors from relevant existing highlight groups.
    call s:ColorSchemeGitHighlights()
    call s:ColorSchemeDiagnosticHighlights()
    highlight! link LineflySession LineflyGitAdd

    if g:mistflyTabLine && (!hlexists('TablineSelSymbol') || synIDattr(synIDtrans(hlID('TablineSelSymbol')), 'bg') == '')
        highlight! link TablineSelSymbol TablineSel
    endif
endfunction

function! s:ColorSchemeModeHighlights() abort
    if g:colors_name == 'moonfly' || g:colors_name == 'nightfly'
        " Do nothing since both colorschemes already set mistfly mode colors.
        return
    elseif g:colors_name == 'edge' || g:colors_name == 'everforest' || g:colors_name == 'gruvbox-material' || g:colors_name == 'sonokai'
        highlight! link MistflyNormal MiniStatuslineModeNormal
        highlight! link MistflyInsert MiniStatuslineModeInsert
        highlight! link MistflyVisual MiniStatuslineModeVisual
        highlight! link MistflyCommand MiniStatuslineModeCommand
        highlight! link MistflyReplace MiniStatuslineModeReplace
    elseif g:colors_name == 'dracula'
        highlight! link MistflyNormal WildMenu
        highlight! link MistflyInsert Search
        call s:SynthesizeModeHighlight('MistflyVisual', 'String', 'WildMenu')
        highlight! link MistflyCommand WildMenu
        highlight! link MistflyReplace IncSearch
    elseif g:colors_name == 'gruvbox'
        call s:SynthesizeModeHighlight('MistflyNormal', 'GruvboxFg4', 'GruvboxBg0')
        call s:SynthesizeModeHighlight('MistflyInsert', 'GruvboxBlue', 'GruvboxBg0')
        call s:SynthesizeModeHighlight('MistflyVisual', 'GruvboxOrange', 'GruvboxBg0')
        call s:SynthesizeModeHighlight('MistflyCommand', 'GruvboxGreen', 'GruvboxBg0')
        call s:SynthesizeModeHighlight('MistflyReplace', 'GruvboxRed', 'GruvboxBg0')
    elseif g:colors_name == "retrobox"
        call s:SynthesizeModeHighlight('MistflyNormal', 'Structure', 'VertSplit')
        call s:SynthesizeModeHighlight('MistflyInsert', 'Directory', 'VertSplit')
        highlight! link MistflyVisual Visual
        call s:SynthesizeModeHighlight('MistflyCommand', 'MoreMsg', 'VertSplit')
        highlight! link MistflyReplace ErrorMsg
    else
        " Fallback for all other colorschemes.
        if !hlexists('MistflyNormal') || synIDattr(synIDtrans(hlID('MistflyNormal')), 'bg') == ''
            call s:SynthesizeModeHighlight('MistflyNormal', 'Directory', 'VertSplit')
        endif
        if !hlexists('MistflyInsert') || synIDattr(synIDtrans(hlID('MistflyInsert')), 'bg') == ''
            call s:SynthesizeModeHighlight('MistflyInsert', 'String', 'VertSplit')
        endif
        if !hlexists('MistflyVisual') || synIDattr(synIDtrans(hlID('MistflyVisual')), 'bg') == ''
            call s:SynthesizeModeHighlight('MistflyVisual', 'Statement', 'VertSplit')
        endif
        if !hlexists('MistflyCommand') || synIDattr(synIDtrans(hlID('MistflyCommand')), 'bg') == ''
            call s:SynthesizeModeHighlight('MistflyCommand', 'WarningMsg', 'VertSplit')
        endif
        if !hlexists('MistflyReplace') || synIDattr(synIDtrans(hlID('MistflyReplace')), 'bg') == ''
            call s:SynthesizeModeHighlight('MistflyReplace', 'Error', 'VertSplit')
        endif
    endif
endfunction

function s:ColorSchemeGitHighlights() abort
    if hlexists('GitSignsAdd')
        call s:SynthesizeHighlight('MistflyGitAdd', 'GitSignsAdd', v:false)
        call s:SynthesizeHighlight('MistflyGitChange', 'GitSignsChange', v:false)
        call s:SynthesizeHighlight('MistflyGitDelete', 'GitSignsDelete', v:false)
    elseif hlexists('GitGutterAdd')
        call s:SynthesizeHighlight('MistflyGitAdd', 'GitGutterAdd', v:false)
        call s:SynthesizeHighlight('MistflyGitChange', 'GitGutterChange', v:false)
        call s:SynthesizeHighlight('MistflyGitDelete', 'GitGutterDelete', v:false)
    elseif hlexists('SignifySignAdd')
        call s:SynthesizeHighlight('MistflyGitAdd', 'SignifySignAdd', v:false)
        call s:SynthesizeHighlight('MistflyGitChange', 'SignifySignChange', v:false)
        call s:SynthesizeHighlight('MistflyGitDelete', 'SignifySignDelete', v:false)
    elseif hlexists('diffAdded')
        call s:SynthesizeHighlight('MistflyGitAdd', 'diffAdded', v:false)
        call s:SynthesizeHighlight('MistflyGitChange', 'diffChanged', v:false)
        call s:SynthesizeHighlight('MistflyGitDelete', 'diffRemoved', v:false)
    else
        highlight! link MistflyGitAdd StatusLine
        highlight! link MistflyGitChange StatusLine
        highlight! link MistflyGitDelete StatusLine
    endif
endfunction

function s:ColorSchemeDiagnosticHighlights() abort
    if hlexists('DiagnosticError')
        call s:SynthesizeHighlight('MistflyDiagnosticError', 'DiagnosticError', v:false)
    elseif hlexists('ALEErrorSign')
        call s:SynthesizeHighlight('MistflyDiagnosticError', 'ALEErrorSign', v:false)
    elseif hlexists('CocErrorSign')
        call s:SynthesizeHighlight('MistflyDiagnosticError', 'CocErrorSign', v:false)
    else
        highlight! link MistflyDiagnosticError StatusLine
    endif
    if hlexists('DiagnosticWarn')
        call s:SynthesizeHighlight('MistflyDiagnosticWarning', 'DiagnosticWarn', v:false)
    elseif hlexists('ALEWarningSign')
        call s:SynthesizeHighlight('MistflyDiagnosticWarning', 'ALEWarningSign', v:false)
    elseif hlexists('CocWarningSign')
        call s:SynthesizeHighlight('MistflyDiagnosticWarning', 'CocWarningSign', v:false)
    else
        highlight! link MistflyDiagnosticWarning StatusLine
    endif
    if hlexists('DiagnosticInfo')
        call s:SynthesizeHighlight('MistflyDiagnosticInformation', 'DiagnosticInfo', v:false)
    elseif hlexists('ALEInfoSign')
        call s:SynthesizeHighlight('MistflyDiagnosticInformation', 'ALEInfoSign', v:false)
    elseif hlexists('CocInfoSign')
        call s:SynthesizeHighlight('MistflyDiagnosticInformation', 'CocInfoSign', v:false)
    else
        highlight! link MistflyDiagnosticInformation StatusLine
    endif
endfunction

function! s:SynthesizeModeHighlight(target, background, foreground) abort
    let l:mode_bg = synIDattr(synIDtrans(hlID(a:background)), 'fg', 'gui')
    let l:mode_fg = synIDattr(synIDtrans(hlID(a:foreground)), 'fg', 'gui')

    if len(l:mode_bg) > 0 && len(l:mode_fg) > 0
        exec 'highlight ' . a:target . ' guibg=' . l:mode_bg . ' guifg=' . l:mode_fg
    else
        " Fallback to statusline highlighting.
        exec 'highlight! link ' . a:target . ' StatusLine'
    endif
endfunction

function! s:SynthesizeHighlight(target, source, reverse) abort
    if a:reverse
        let l:source_fg = synIDattr(synIDtrans(hlID(a:source)), 'bg', 'gui')
    else
        let l:source_fg = synIDattr(synIDtrans(hlID(a:source)), 'fg', 'gui')
    endif

    if len(s:statusline_bg) > 0 && len(l:source_fg) > 0
        exec 'highlight ' . a:target . ' guibg=' . s:statusline_bg . ' guifg=' . l:source_fg
    else
        " Fallback to statusline highlighting.
        exec 'highlight! link ' . a:target . ' StatusLine'
    endif
endfunction

"===========================================================
" Git
"===========================================================

" Detect the branch name using an old-school system call. This function will
" only be called upon BufEnter, BufWrite and FocusGained events to avoid
" needlessly invoking that system call every time the statusline is redrawn.
function! mistfly#DetectBranchName() abort
    if !g:mistflyWithGitBranch || bufname('%') == ''
        " Don't calculate the branch name if it isn't wanted or the buffer is
        " empty.
        let b:git_branch_name = ''
        return
    endif

    if exists('g:loaded_fugitive')
        " Fugitive is available, it will provide us the current branch name.
        return
    endif

    " Use fallback Git branch name detection.
    let b:git_branch_name = trim(system("git branch --show-current 2>/dev/null"))
endfunction
