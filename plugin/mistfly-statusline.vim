" A simple Vim / Neovim statusline.
"
" URL:          github.com/bluz71/vim-mistfly-statusline
" License:      MIT (https://opensource.org/licenses/MIT)

if exists('g:loaded_mistfly_statusline')
  finish
endif
let g:loaded_mistfly_statusline = 1

" Please check that a true-color capable version of Vim or Neovim is currently
" running.
if has('nvim')
    if has('nvim-0.4') && len(nvim_list_uis()) > 0 && nvim_list_uis()[0]['ext_termcolors'] && !&termguicolors
        " The nvim_list_uis test indicates terminal Neovim vs GUI Neovim.
        " Note, versions prior to Neovim 0.4 did not set 'ext_termcolors'.
        echomsg 'The termguicolors option must be set'
        finish
    endif
else " Vim
    if !has('gui_running') && !exists('&termguicolors')
        echomsg 'A modern version of Vim with termguicolors is required'
        finish
    elseif !has('gui_running') && !&termguicolors
        echomsg 'The termguicolors option must be set'
        echomsg 'Be aware macOS default Vim is broken, use Homebrew Vim instead'
        finish
    endif
endif

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

" By default do not display indentation details.
let g:mistflyWithIndentStatus = get(g:, 'mistflyWithIndentStatus', 0)

" By default display Git branches.
let g:mistflyWithGitBranch = get(g:, 'mistflyWithGitBranch', 1)

" By default display Gitsigns status, if the plugin is loaded.
let g:mistflyWithGitsignsStatus = get(g:, 'mistflyWithGitsignsStatus', 1)

" By default don't display a Nerd Font filetype icon.
let g:mistflyWithNerdIcon = get(g:, 'mistflyWithNerdIcon', 0)

" By default do indicate Neovim Diagnostic status, if nvim-lsp plugin is loaded.
let g:mistflyWithNvimDiagnosticStatus = get(g:, 'mistflyWithNvimDiagnosticStatus', 1)

" By default do indicate ALE lint status, if the plugin is loaded.
let g:mistflyWithALEStatus = get(g:, 'mistflyWithALEStatus', 1)

" By default do indicate Coc diagnostic status, if the plugin is loaded.
let g:mistflyWithCocStatus = get(g:, 'mistflyWithCocStatus', 1)

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

augroup mistflyStatuslineEvents
    autocmd!
    autocmd VimEnter              * call s:UpdateInactiveWindows()
    autocmd VimEnter              * call s:TabLine()
    autocmd ColorScheme,SourcePre * call mistfly_statusline#GenerateHighlightGroups()
    autocmd WinEnter,BufWinEnter  * call s:StatusLine(v:true)
    autocmd WinLeave              * call s:StatusLine(v:false)
    if exists('##CmdlineEnter')
        autocmd CmdlineEnter      * call s:StatusLine(v:true) | redraw
    endif
augroup END
