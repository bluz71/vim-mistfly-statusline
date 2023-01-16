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

" Options.
let g:mistflyAsciiShapes = get(g:, 'mistflyAsciiShapes', v:false)
let g:mistflyErrorSymbol = get(g:, 'mistflyErrorSymbol', 'x')
let g:mistflyWarningSymbol = get(g:, 'mistflyWarningSymbol', '!')
let g:mistflyInformationSymbol = get(g:, 'mistflyWarningSymbol', 'i')
let g:mistflyTabLine = get(g:, 'mistflyTabLine', v:false)
let g:mistflyWinBar = get(g:, 'mistflyWinBar', v:false)
let g:mistflyWithIndentStatus = get(g:, 'mistflyWithIndentStatus', v:false)
let g:mistflyWithFileIcon = get(g:, 'mistflyWithFileIcon', v:false)
let g:mistflyWithGitBranch = get(g:, 'mistflyWithGitBranch', v:true)
let g:mistflyWithGitsignsStatus = get(g:, 'mistflyWithGitsignsStatus', v:true)
let g:mistflyWithGitGutterStatus = get(g:, 'mistflyWithGitGutterStatus', v:true)
let g:mistflyWithSignifyStatus = get(g:, 'mistflyWithSignifyStatus', v:true)
let g:mistflyWithNvimDiagnosticStatus = get(g:, 'mistflyWithNvimDiagnosticStatus', v:true)
let g:mistflyWithALEStatus = get(g:, 'mistflyWithALEStatus', v:true)
let g:mistflyWithCocStatus = get(g:, 'mistflyWithCocStatus', v:true)

augroup mistflyStatuslineEvents
    autocmd!
    autocmd VimEnter,ColorScheme * call mistfly#GenerateHighlightGroups()
    autocmd VimEnter             * call mistfly#UpdateInactiveWindows()
    autocmd VimEnter             * call mistfly#TabLine()
    autocmd WinEnter,BufWinEnter * call mistfly#StatusLine(v:true)
    autocmd WinLeave             * call mistfly#StatusLine(v:false)
    autocmd BufEnter,FocusGained * call mistfly#DetectBranchName()
augroup END
