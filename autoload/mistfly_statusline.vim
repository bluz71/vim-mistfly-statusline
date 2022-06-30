let s:modes = {
  \  'n':      ['%#MistflyNormal#', ' normal '],
  \  'i':      ['%#MistflyInsert#', ' insert '],
  \  'R':      ['%#MistflyReplace#', ' r-mode '],
  \  'v':      ['%#MistflyVisual#', ' visual '],
  \  'V':      ['%#MistflyVisual#', ' v-line '],
  \  "\<C-v>": ['%#MistflyVisual#', ' v-rect '],
  \  'c':      ['%#MistflyNormal#', ' c-mode '],
  \  's':      ['%#MistflyVisual#', ' select '],
  \  'S':      ['%#MistflyVisual#', ' s-line '],
  \  "\<C-s>": ['%#MistflyVisual#', ' s-rect '],
  \  't':      ['%#MistflyInsert#', ' term '],
  \}

function! mistfly_statusline#ModeColor(mode) abort
    return get(s:modes, a:mode, '%*1')[0]
endfunction

function! mistfly_statusline#ModeText(mode) abort
    return get(s:modes, a:mode, ' normal ')[1]
endfunction

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
    if has('nvim-0.5') && luaeval("pcall(require, 'gitsigns')")
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

    if g:mistflyWithGitBranchCharacter
        return '[ ' . l:git_branch_name . ']  '
    else
        return '[' . l:git_branch_name . ']  '
    endif
endfunction

function! mistfly_statusline#PluginsStatus() abort
    let l:status = ''
    let l:errors = 0
    let l:warnings = 0

    " Gitsigns status.
    if g:mistflyWithGitsignsStatus && has('nvim-0.5') && luaeval("pcall(require, 'gitsigns')")
        let l:status .= get(b:, 'gitsigns_status', '')
        if len(l:status) > 0
            let l:status .= '  '
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
        let l:status .= g:mistflyErrorSymbol . ' ' . l:errors . ' ' . g:mistflyWarningSymbol . ' ' . l:warnings . '  '
    elseif l:errors > 0
        let l:status .= g:mistflyErrorSymbol . ' ' . l:errors . '  '
    elseif l:warnings > 0
        let l:status .= g:mistflyWarningSymbol . ' ' . l:warnings . '  '
    endif

    " Obsession plugin status.
    if exists('g:loaded_obsession')
        if g:mistflyUnicodeShapes
            let l:status .= ObsessionStatus('●', '■')
        else
            let l:status .= ObsessionStatus('$', 'S')
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

function! mistfly_statusline#Divider() abort
    if g:mistflyUnicodeShapes
        return '│'
    else
        return '|'
    endif
endfunction

function! mistfly_statusline#Arrow() abort
    if g:mistflyUnicodeShapes
        return '↓'
    else
        return ''
    endif
endfunction

function! mistfly_statusline#TabDivider(active) abort
    if g:mistflyUnicodeShapes
        if a:active
            return '▎'
        else
            return '▏'
        endif
    else
        return '|'
    endif
endfunction

function! mistfly_statusline#TabPrefix(active) abort
    if g:mistflyUnicodeShapes
        if a:active
            return '■ '
        else
            return '□ '
        endif
    else
        return 'Tab:'
    endif
endfunction

function! mistfly_statusline#ActiveStatusLine() abort
    let l:mode = mode()
    let l:divider = mistfly_statusline#Divider()
    let l:statusline = ''
    let l:statusline = mistfly_statusline#ModeColor(l:mode)
    let l:statusline .= mistfly_statusline#ModeText(l:mode)
    let l:statusline .= '%* %<%{mistfly_statusline#File()}'
    let l:statusline .= "%{&modified ? '+\ ' : ' \ \ '}"
    let l:statusline .= "%{&readonly ? 'RO\ ' : ''}"
    let l:statusline .= '%#MistflyEmphasis#%{mistfly_statusline#GitBranch()}'
    let l:statusline .= '%#MistflyNotification#%{mistfly_statusline#PluginsStatus()}'
    let l:statusline .= '%*%=%l:%c %#MistflyDiscreet#' . l:divider
    let l:statusline .= '%* %#MistflyEmphasis#%L%* %{mistfly_statusline#Arrow()}%P '
    if g:mistflyWithIndentStatus
        let l:statusline .= '%#MistflyDiscreet#' . l:divider . '%* %{mistfly_statusline#IndentStatus()} '
    endif

    return l:statusline
endfunction

function! mistfly_statusline#InactiveStatusLine() abort
    let l:divider = mistfly_statusline#Divider()
    let l:statusline = ' %*%<%{mistfly_statusline#File()}'
    let l:statusline .= "%{&modified?'+\ ':' \ \ '}"
    let l:statusline .= "%{&readonly?'RO\ ':''}"
    let l:statusline .= '%*%=%l:%c ' . l:divider
    let l:statusline .= ' %L %{mistfly_statusline#Arrow()}%P '
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
    let l:winbar = mistfly_statusline#ModeColor(l:mode)
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
    let l:tabline = ''
    let l:counter = 0

    for i in range(tabpagenr('$'))
        let l:counter = l:counter + 1
        if tabpagenr() == counter
            let l:tabline .= '%#TablineSel#%{mistfly_statusline#TabDivider(v:true)}  '
            let l:tabline .= '%{mistfly_statusline#TabPrefix(v:true)}'
        else
            let l:tabline .= '%#TabLine#%{mistfly_statusline#TabDivider(v:false)}  '
            let l:tabline .= '%{mistfly_statusline#TabPrefix(v:false)}'
        endif
        let l:tabline .= l:counter . '   %#TabLineFill#'
    endfor

    return l:tabline
endfunction

" The following Git branch functionality derives from:
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
