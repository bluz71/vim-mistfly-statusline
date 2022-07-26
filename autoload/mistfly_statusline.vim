let s:modes = {
  \  'n':      ['%#MistflyNormal#', ' normal ', '%#MistflyNormalEmphasis#'],
  \  'i':      ['%#MistflyInsert#', ' insert ', '%#MistflyInsertEmphasis#'],
  \  'R':      ['%#MistflyReplace#', ' r-mode ', '%#MistflyReplaceEmphasis#'],
  \  'v':      ['%#MistflyVisual#', ' visual ', '%#MistflyVisualEmphasis#'],
  \  'V':      ['%#MistflyVisual#', ' v-line ', '%#MistflyVisualEmphasis#'],
  \  "\<C-v>": ['%#MistflyVisual#', ' v-rect ', '%#MistflyVisualEmphasis#'],
  \  'c':      ['%#MistflyCommand#', ' c-mode ', '%#MistflyCommandEmphasis#'],
  \  's':      ['%#MistflyVisual#', ' select ', '%#MistflyVisualEmphasis#'],
  \  'S':      ['%#MistflyVisual#', ' s-line ', '%#MistflyVisualEmphasis#'],
  \  "\<C-s>": ['%#MistflyVisual#', ' s-rect ', '%#MistflyVisualEmphasis#'],
  \  't':      ['%#MistflyInsert#', ' term ', '%#MistflyInsertEmphasis#'],
  \}

" Cache current colorscheme and the associated statusline background for
" performance reasons; that being to avoid needless highlight extraction and
" generation.
let s:current_colorscheme = ''
let s:statusline_bg = ''

function! mistfly_statusline#File() abort
    return s:FileIcon() . s:ShortFilePath()
endfunction

function! s:FileIcon() abort
    if !g:mistflyWithNerdIcon || bufname('%') == ''
        return ''
    endif

    if exists('g:nvim_web_devicons')
        return luaeval("require'nvim-web-devicons'.get_icon(vim.fn.expand('%'), vim.fn.expand('%:e'))") . ' '
    elseif exists('g:loaded_webdevicons')
        return WebDevIconsGetFileTypeSymbol() . ' '
    else
        return ''
    endif
endfunction

function! s:ShortFilePath() abort
    if &buftype ==# 'terminal'
        return expand('%:t')
    else
        if len(expand('%:f')) == 0
            return ''
        else
            let l:separator = '/'
            if has('win32') || has('win64')
                let l:separator = '\'
            endif
            let l:path = pathshorten(fnamemodify(expand('%:f'), ':~:.'))
            let l:pathComponents = split(l:path, l:separator)
            let l:numPathComponents = len(l:pathComponents)
            if l:numPathComponents > 4
                return '.../' . join(l:pathComponents[l:numPathComponents - 4:], l:separator)
            else
                return l:path
            endif
        endif
    endif
endfunction

function! mistfly_statusline#ShortCurrentPath() abort
    return pathshorten(fnamemodify(getcwd(), ':~:.'))
endfunction

function! mistfly_statusline#GitBranch() abort
    if !g:mistflyWithGitBranch || bufname('%') == ''
        return ''
    endif

    let l:git_branch_name = ''
    if g:mistflyWithGitsignsStatus && has('nvim-0.5') && luaeval("pcall(require, 'gitsigns')")
        " Gitsigns is available, let's use it to get the branch name since it
        " will already be in memory.
        let l:git_branch_name = get(b:, 'gitsigns_head', '')
    else
        " Fallback to traditional filesystem-based branch name detection.
        let l:git_branch_name = s:GitBranchName()
    endif

    if len(l:git_branch_name) == 0
        return ''
    endif

    if g:mistflyAsciiShapes
        return ' ' . l:git_branch_name
    else
        return '  ' . l:git_branch_name
    endif
endfunction

function! mistfly_statusline#PluginsStatus() abort
    let l:status = ''
    let l:errors = 0
    let l:warnings = 0
    let l:divider = g:mistflyAsciiShapes ? '| ' : '⎪ '

    " Gitsigns status.
    if g:mistflyWithGitsignsStatus && has('nvim-0.5')
        let l:counts = get(b:, 'gitsigns_status_dict', {})
        if has_key(l:counts, 'added')
            if l:counts['added'] > 0
                let l:status .= ' %#MistflyGitAdd#+' . l:counts['added'] . '%*'
            endif
            if l:counts['changed'] > 0
                let l:status .= ' %#MistflyGitChange#~' . l:counts['changed'] . '%*'
            endif
            if l:counts['removed'] > 0
                let l:status .= ' %#MistflyGitDelete#-' . l:counts['removed'] . '%*'
            endif
        endif
        if len(l:status) > 0
            let l:status .= ' '
        endif
    endif

    " Neovim Diagnostic status.
    if g:mistflyWithNvimDiagnosticStatus
        if has('nvim-0.6')
            let l:errors = luaeval('#vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})')
            let l:warnings = luaeval('#vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})')
        elseif has('nvim-0.5')
            let l:errors = luaeval('vim.lsp.diagnostic.get_count(0, [[Error]])')
            let l:warnings = luaeval('vim.lsp.diagnostic.get_count(0, [[Warning]])')
        endif
    endif

    " ALE status.
    if g:mistflyWithALEStatus && exists('g:loaded_ale')
        let l:counts = ale#statusline#Count(bufnr(''))
        if has_key(l:counts, 'error')
            let l:errors = l:counts['error']
        endif
        if has_key(l:counts, 'warning')
            let l:warnings = l:counts['warning']
        endif
    endif

    " Coc status.
    if g:mistflyWithCocStatus && exists('g:did_coc_loaded')
        let l:counts = get(b:, 'coc_diagnostic_info', {})
        if has_key(l:counts, 'error')
            let l:errors = l:counts['error']
        endif
        if has_key(l:counts, 'warning')
            let l:warnings = l:counts['warning']
        endif
    endif

    " Display errors and warnings from any of the previous diagnostic or linting
    " systems.
    if l:errors > 0 && l:warnings > 0
        let l:status .= ' %#MistflyDiagnosticError#' . g:mistflyErrorSymbol
        let l:status .= ' ' . l:errors . '%* %#MistflyDiagnosticWarning#'
        let l:status .= g:mistflyWarningSymbol . ' ' . l:warnings . '%* '
    elseif l:errors > 0
        let l:status .= ' %#MistflyDiagnosticError#' . g:mistflyErrorSymbol
        let l:status .= ' ' . l:errors . '%* '
    elseif l:warnings > 0
        let l:status .= ' %#MistflyDiagnosticWarning#' . g:mistflyWarningSymbol
        let l:status .= ' ' . l:warnings . '%* '
    endif

    " Obsession plugin status.
    if exists('g:loaded_obsession')
        if g:mistflyAsciiShapes
            let l:obsession_status = ObsessionStatus('$', 'S')
        else
            let l:obsession_status = ObsessionStatus('●', '■')
        endif
        if len(l:obsession_status) > 0
            let l:status .= ' %#MistflyObsession#' . l:obsession_status . '%*'
        endif
    endif

    return l:status
endfunction

function! mistfly_statusline#IndentStatus() abort
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

function! mistfly_statusline#ActiveStatusLine() abort
    let l:mode = mode()
    let l:divider = g:mistflyAsciiShapes ? '|' : '⎪'
    let l:arrow =  g:mistflyAsciiShapes ?  '' : '↓'
    let l:git_branch = mistfly_statusline#GitBranch()
    let l:mode_emphasis = get(s:modes, l:mode, '%#MistflyNormalEmphasis#')[2]

    let l:statusline = get(s:modes, l:mode, '%#MistflyNormal#')[0]
    let l:statusline .= get(s:modes, l:mode, ' normal ')[1]
    let l:statusline .= '%* %<%{mistfly_statusline#File()}'
    let l:statusline .= "%{&modified ? '+\ ' : ' \ \ '}"
    let l:statusline .= "%{&readonly ? 'RO\ ' : ''}"
    if len(l:git_branch) > 0
        let l:statusline .= '%*' . l:divider . l:mode_emphasis
        let l:statusline .= l:git_branch . '%* '
    endif
    let l:statusline .= mistfly_statusline#PluginsStatus()
    let l:statusline .= '%*%=%l:%c %*' . l:divider
    let l:statusline .= '%* ' . l:mode_emphasis . '%L%* ' . l:arrow . '%P '
    if g:mistflyWithIndentStatus
        let l:statusline .= '%*' . l:divider
        let l:statusline .= '%* %{mistfly_statusline#IndentStatus()} '
    endif

    return l:statusline
endfunction

function! mistfly_statusline#InactiveStatusLine() abort
    let l:divider = g:mistflyAsciiShapes ? '|' : '⎪'
    let l:arrow =  g:mistflyAsciiShapes ? '' : '↓'

    let l:statusline = ' %*%<%{mistfly_statusline#File()}'
    let l:statusline .= "%{&modified?'+\ ':' \ \ '}"
    let l:statusline .= "%{&readonly?'RO\ ':''}"
    let l:statusline .= '%*%=%l:%c ' . l:divider . ' %L ' . l:arrow . '%P '
    if g:mistflyWithIndentStatus
        let l:statusline .= l:divider . ' %{mistfly_statusline#IndentStatus()} '
    endif

    return l:statusline
endfunction

function! mistfly_statusline#NoFileStatusLine() abort
    return ' %{mistfly_statusline#ShortCurrentPath()}'
endfunction

function! mistfly_statusline#ActiveWinBar() abort
    let l:mode = mode()
    let l:winbar = get(s:modes, l:mode, '%#MistflyNormal#')[0]
    let l:winbar .= ' '
    let l:winbar .= '%* %<%{mistfly_statusline#File()}'
    let l:winbar .= "%{&modified ? '+\ ' : ' \ \ '}"
    let l:winbar .= "%{&readonly ? 'RO\ ' : ''}"
    let l:winbar .= '%#Normal#'

    return l:winbar
endfunction

function! mistfly_statusline#InactiveWinBar() abort
    let l:winbar = ' %*%<%{mistfly_statusline#File()}'
    let l:winbar .= "%{&modified?'+\ ':' \ \ '}"
    let l:winbar .= "%{&readonly?'RO\ ':''}"
    let l:winbar .= '%#NonText#'

    return l:winbar
endfunction

function! mistfly_statusline#TabLine() abort
    let l:divider = g:mistflyAsciiShapes ? '|' : '▎'
    let l:tabline = ''
    let l:counter = 0

    for i in range(tabpagenr('$'))
        let l:counter = l:counter + 1
        if has('tablineat')
            let l:tabline .= '%' . l:counter . 'T'
        endif
        if tabpagenr() == counter
            let l:tabline .= '%#TablineSel#' . l:divider . ' Tab:'
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

function! mistfly_statusline#GenerateHighlightGroups() abort
    if !exists('g:colors_name')
        echomsg 'mistfly-statusline requires a colorscheme that sets g:colors_name'
        return
    endif

    " Early exit if we have already generated highlight groups for the current
    " colorscheme.
    if g:colors_name == s:current_colorscheme
        return
    else
        " New colorscheme detected, let's cache its name.
        let s:current_colorscheme = g:colors_name
        " Also, extract current StatusLine background color, we will likely need
        " it.
        if synIDattr(synIDtrans(hlID('StatusLine')), 'reverse', 'gui') == 1
            " Need to handle reversed highlights, such as gruvbox StatusLine.
            let s:statusline_bg = synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'gui')
        else
            " Most colorschemes fall through to here.
            let s:statusline_bg = synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'gui')
        endif
    endif

    " Mode highlights.
    if g:colors_name == 'moonfly' || g:colors_name == 'nightfly'
        " Do nothing since both themes already set mistfly mode colors.
    elseif g:colors_name == 'catppuccin'
        call mistfly_statusline#SynthesizeModeHighlight('MistflyNormal', 'DiffText', 'VertSplit')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyInsert', 'DiffAdd', 'VertSplit')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyVisual', 'Statement', 'VertSplit')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyCommand', 'Constant', 'VertSplit')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyReplace', 'DiffDelete', 'VertSplit')
    elseif g:colors_name == 'embark'
        call mistfly_statusline#SynthesizeModeHighlight('MistflyNormal', 'Title', 'VertSplit')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyInsert', 'SpellLocal', 'VertSplit')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyVisual', 'Identifier', 'VertSplit')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyCommand', 'Constant', 'VertSplit')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyReplace', 'SpellRare', 'VertSplit')
    elseif g:colors_name == 'edge' || g:colors_name == 'everforest' || g:colors_name == 'gruvbox-material' || g:colors_name == 'sonokai'
        highlight! link MistflyNormal MiniStatuslineModeNormal
        highlight! link MistflyInsert MiniStatuslineModeInsert
        highlight! link MistflyVisual MiniStatuslineModeVisual
        highlight! link MistflyCommand MiniStatuslineModeCommand
        highlight! link MistflyReplace MiniStatuslineModeReplace
    elseif g:colors_name == 'gruvbox'
        call mistfly_statusline#SynthesizeModeHighlight('MistflyNormal', 'GruvboxFg4', 'GruvboxBg0')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyInsert', 'GruvboxBlue', 'GruvboxBg0')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyVisual', 'GruvboxOrange', 'GruvboxBg0')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyCommand', 'GruvboxGreen', 'GruvboxBg0')
        call mistfly_statusline#SynthesizeModeHighlight('MistflyReplace', 'GruvboxRed', 'GruvboxBg0')
    elseif g:colors_name == 'nightfox' || g:colors_name == 'nordfox' || g:colors_name == 'terafox'
        highlight! link MistflyNormal Todo
        highlight! link MistflyInsert MiniStatuslineModeInsert
        highlight! link MistflyVisual MiniStatuslineModeVisual
        highlight! link MistflyCommand MiniStatuslineModeCommand
        highlight! link MistflyReplace MiniStatuslineModeReplace
    elseif g:colors_name == 'tokyonight'
        highlight! link MistflyNormal TablineSel
        call mistfly_statusline#SynthesizeModeHighlight('MistflyInsert', 'String', 'VertSplit')
        highlight! link MistflyVisual Sneak
        highlight! link MistflyReplace Substitute
        highlight! link MistflyCommand Todo
    else
        " Fallback for all other colorschemes.
        if !hlexists('MistflyNormal') || synIDattr(synIDtrans(hlID('MistflyNormal')), 'bg') == ''
            call mistfly_statusline#SynthesizeModeHighlight('MistflyNormal', 'Directory', 'VertSplit')
        endif
        if !hlexists('MistflyInsert') || synIDattr(synIDtrans(hlID('MistflyInsert')), 'bg') == ''
            call mistfly_statusline#SynthesizeModeHighlight('MistflyInsert', 'String', 'VertSplit')
        endif
        if !hlexists('MistflyVisual') || synIDattr(synIDtrans(hlID('MistflyVisual')), 'bg') == ''
            call mistfly_statusline#SynthesizeModeHighlight('MistflyVisual', 'Statement', 'VertSplit')
        endif
        if !hlexists('MistflyCommand') || synIDattr(synIDtrans(hlID('MistflyCommand')), 'bg') == ''
            call mistfly_statusline#SynthesizeModeHighlight('MistflyCommand', 'WarningMsg', 'VertSplit')
        endif
        if !hlexists('MistflyReplace') || synIDattr(synIDtrans(hlID('MistflyReplace')), 'bg') == ''
            call mistfly_statusline#SynthesizeModeHighlight('MistflyReplace', 'Error', 'VertSplit')
        endif
    endif

    " Synthesize emphasis colors from the existing mode colors.
    call mistfly_statusline#SynthesizeHighlight('MistflyNormalEmphasis', 'MistflyNormal', v:true)
    call mistfly_statusline#SynthesizeHighlight('MistflyInsertEmphasis', 'MistflyInsert', v:true)
    call mistfly_statusline#SynthesizeHighlight('MistflyVisualEmphasis', 'MistflyVisual', v:true)
    call mistfly_statusline#SynthesizeHighlight('MistflyCommandEmphasis', 'MistflyCommand', v:true)
    call mistfly_statusline#SynthesizeHighlight('MistflyReplaceEmphasis', 'MistflyReplace', v:true)

    " Synthesize plugin colors from existing highlight groups.
    if g:mistflyWithGitsignsStatus " has('nvim-0.5') && luaeval('pcall(require, 'gitsigns')')
        call mistfly_statusline#SynthesizeHighlight('MistflyGitAdd', 'GitSignsAdd', v:false)
        call mistfly_statusline#SynthesizeHighlight('MistflyGitChange', 'GitSignsChange', v:false)
        call mistfly_statusline#SynthesizeHighlight('MistflyGitDelete', 'GitSignsDelete', v:false)
    endif
    if g:mistflyWithNvimDiagnosticStatus " if exists('g:lspconfig')
        call mistfly_statusline#SynthesizeHighlight('MistflyDiagnosticError', 'DiagnosticError', v:false)
        call mistfly_statusline#SynthesizeHighlight('MistflyDiagnosticWarning', 'DiagnosticWarn', v:false)
    endif
    if g:mistflyWithALEStatus " if exists('g:loaded_ale')
        call mistfly_statusline#SynthesizeHighlight('MistflyDiagnosticError', 'ALEErrorSign', v:false)
        call mistfly_statusline#SynthesizeHighlight('MistflyDiagnosticWarning', 'ALEWarningSign', v:false)
    endif
    if g:mistflyWithCocStatus " if exists('g:did_coc_loaded')
        call mistfly_statusline#SynthesizeHighlight('MistflyDiagnosticError', 'CocErrorSign', v:false)
        call mistfly_statusline#SynthesizeHighlight('MistflyDiagnosticWarning', 'CocWarningSign', v:false)
    endif
    if exists('g:loaded_obsession')
        call mistfly_statusline#SynthesizeHighlight('MistflyObsession', 'Error', v:false)
    endif
endfunction

function! mistfly_statusline#SynthesizeModeHighlight(target, background, foreground) abort
    let l:mode_bg = synIDattr(synIDtrans(hlID(a:background)), 'fg', 'gui')
    let l:mode_fg = synIDattr(synIDtrans(hlID(a:foreground)), 'fg', 'gui')

    if len(l:mode_bg) > 0 && len(l:mode_fg) > 0
        exec 'highlight ' . a:target . ' guibg=' . l:mode_bg . ' guifg=' . l:mode_fg
    else
        " Fallback to statusline highlighting.
        exec 'highlight! link ' . a:target . ' StatusLine'
    endif
endfunction

function! mistfly_statusline#SynthesizeHighlight(target, source, reverse) abort
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

" The following Git branch name functionality derives from:
"   https://github.com/itchyny/vim-gitbranch
"
" MIT Licensed Copyright (c) 2014-2017 itchyny
"
function! s:GitBranchName() abort
    if get(b:, 'gitbranch_pwd', '') !=# expand('%:p:h') || !has_key(b:, 'gitbranch_path')
        call s:GitDetect()
    endif

    if has_key(b:, 'gitbranch_path') && filereadable(b:gitbranch_path)
        let l:branchDetails = get(readfile(b:gitbranch_path), 0, '')
        if l:branchDetails =~# '^ref: '
            return substitute(l:branchDetails, '^ref: \%(refs/\%(heads/\|remotes/\|tags/\)\=\)\=', '', '')
        elseif l:branchDetails =~# '^\x\{20\}'
            return l:branchDetails[:6]
        endif
    endif

    return ''
endfunction

function! s:GitDetect() abort
    unlet! b:gitbranch_path
    let b:gitbranch_pwd = expand('%:p:h')
    let l:dir = s:GitDir(b:gitbranch_pwd)

    if l:dir !=# ''
        let l:path = l:dir . '/HEAD'
        if filereadable(l:path)
            let b:gitbranch_path = l:path
        endif
    endif
endfunction

function! s:GitDir(path) abort
    let l:path = a:path
    let l:prev = ''

    while l:path !=# prev
        let l:dir = path . '/.git'
        let l:type = getftype(l:dir)
        if l:type ==# 'dir' && isdirectory(l:dir . '/objects')
                    \ && isdirectory(l:dir . '/refs')
                    \ && getfsize(l:dir . '/HEAD') > 10
            " Looks like we found a '.git' directory.
            return l:dir
        elseif l:type ==# 'file'
            let l:reldir = get(readfile(l:dir), 0, '')
            if l:reldir =~# '^gitdir: '
                return simplify(l:path . '/' . l:reldir[8:])
            endif
        endif
        let l:prev = l:path
        " Go up a directory searching for a '.git' directory.
        let path = fnamemodify(l:path, ':h')
    endwhile

    return ''
endfunction
