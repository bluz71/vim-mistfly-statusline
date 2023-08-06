" A simple Vim / Neovim statusline.
"
" URL:          github.com/bluz71/vim-mistfly-statusline
" License:      MIT (https://opensource.org/licenses/MIT)

if has('nvim-0.9')
    lua vim.api.nvim_echo({
        \ { "vim-mistfly-statusline does not support Neovim 0.9 (or later).\n", "WarningMsg" },
        \ { "Please use pure-Lua nvim-linefly (https://github.com/bluz71/nvim-linefly) instead.\n", "Normal"} },
        \ false, {})
    finish
endif

if exists('g:loaded_mistfly_statusline')
  finish
endif
let g:loaded_mistfly_statusline = 1

" Options.
let g:mistflySeparatorSymbol = get(g:, 'mistflySeparatorSymbol', "⎪")
let g:mistflyProgressSymbol = get(g:, 'mistflyProgressSymbol', "↓")
let g:mistflyActiveTabSymbol = get(g:, 'mistflyActiveTabSymbol', "▪")
let g:mistflyGitBranchSymbol = get(g:, 'mistflyGitBranchSymbol', "")
let g:mistflyErrorSymbol = get(g:, 'mistflyErrorSymbol', 'E')
let g:mistflyWarningSymbol = get(g:, 'mistflyWarningSymbol', 'W')
let g:mistflyInformationSymbol = get(g:, 'mistflyWarningSymbol', 'I')
let g:mistflyTabLine = get(g:, 'mistflyTabLine', v:false)
let g:mistflyWinBar = get(g:, 'mistflyWinBar', v:false)
let g:mistflyWithFileIcon = get(g:, 'mistflyWithFileIcon', v:true)
let g:mistflyWithGitBranch = get(g:, 'mistflyWithGitBranch', v:true)
let g:mistflyWithGitStatus = get(g:, 'mistflyWithGitStatus', v:true)
let g:mistflyWithDiagnosticStatus = get(g:, 'mistflyWithDiagnosticStatus', v:true)
let g:mistflyWithSessionStatus = get(g:, 'mistflyWithSessionStatus', v:true)
let g:mistflyWithSpellStatus = get(g:, 'mistflyWithSpellStatus', v:false)
let g:mistflyWithIndentStatus = get(g:, 'mistflyWithIndentStatus', v:false)

augroup mistflyStatuslineEvents
    autocmd!
    autocmd VimEnter,ColorScheme * call mistfly#GenerateHighlightGroups()
    autocmd VimEnter * call mistfly#UpdateInactiveWindows()
    autocmd VimEnter * call mistfly#TabLine()
    autocmd WinEnter,BufWinEnter * call mistfly#StatusLine(v:true)
    autocmd WinLeave * call mistfly#StatusLine(v:false)
    autocmd BufEnter,BufWrite,FocusGained * call mistfly#DetectBranchName()
augroup END
