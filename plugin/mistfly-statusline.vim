" A simple Vim / Neovim statusline.
"
" URL:          github.com/bluz71/vim-mistfly-statusline
" License:      MIT (https://opensource.org/licenses/MIT)

if exists('g:loaded_mistfly_statusline')
  finish
endif
let g:loaded_mistfly_statusline = 1

" Options.
let g:mistflySeparatorSymbol = get(g:, 'mistflySeparatorSymbol', "⎪")
let g:mistflyArrowSymbol = get(g:, 'mistflyArrowSymbol', "↓")
let g:mistflyActiveTabSymbol = get(g:, 'mistflyActiveTabSymbol', "▪")
let g:mistflyGitBranchSymbol = get(g:, 'mistflyGitBranchSymbol', "")
let g:mistflyErrorSymbol = get(g:, 'mistflyErrorSymbol', 'E')
let g:mistflyWarningSymbol = get(g:, 'mistflyWarningSymbol', 'W')
let g:mistflyInformationSymbol = get(g:, 'mistflyWarningSymbol', 'I')
let g:mistflyTabLine = get(g:, 'mistflyTabLine', v:false)
let g:mistflyWinBar = get(g:, 'mistflyWinBar', v:false)
let g:mistflyWithIndentStatus = get(g:, 'mistflyWithIndentStatus', v:false)
let g:mistflyWithFileIcon = get(g:, 'mistflyWithFileIcon', v:true)
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
    autocmd VimEnter * call mistfly#UpdateInactiveWindows()
    autocmd VimEnter * call mistfly#TabLine()
    autocmd WinEnter,BufWinEnter * call mistfly#StatusLine(v:true)
    autocmd WinLeave * call mistfly#StatusLine(v:false)
    autocmd BufEnter,BufWrite,FocusGained * call mistfly#DetectBranchName()
augroup END
