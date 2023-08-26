mistfly statusline
==================

_mistfly statusline_ is a simple, fast and informative `statusline` for Vim and
(legacy) Neovim coded in Vimscript.

:point_right: Contemporary Neovim users will need to use the pure-Lua
[linefly](https://github.com/bluz71/nvim-linefly) plugin instead of _mistfly_.

_mistfly_ provides optional `tabline` support when the appropriate setting is
enabled; refer to
[`mistflyTabLine`](https://github.com/bluz71/vim-mistfly-statusline#mistflytabline).

_mistfly_ will adapt it's colors to the colorscheme currently in effect. Colors
can also be
[customized](https://github.com/bluz71/vim-mistfly-statusline#highlight-groups-and-colors)
if desired.

Lastly, _mistfly_ is a lean `statusline` plugin clocking in at about 500 lines
of code. For comparison, the
[lightline](https://github.com/itchyny/lightline.vim),
[airline](https://github.com/vim-airline/vim-airline) and
[lualine](https://github.com/nvim-lualine/lualine.nvim) `statusline` plugins
contain over 3,600, 7,300 and 8,000 lines of code respectively. In fairness, the
latter plugins are more featureful, configurable and visually pleasing.

:warning: _mistfly_ has a predominantly fixed layout, this will **not** be an
appropriate `statusline` plugin if layout flexibility is desired.

Screenshots
-----------

![normal](https://raw.githubusercontent.com/bluz71/misc-binaries/master/statusline/statusline-normal.png)
![insert](https://raw.githubusercontent.com/bluz71/misc-binaries/master/statusline/statusline-insert.png)
![visual](https://raw.githubusercontent.com/bluz71/misc-binaries/master/statusline/statusline-visual.png)
![command](https://raw.githubusercontent.com/bluz71/misc-binaries/master/statusline/statusline-command.png)
![replace](https://raw.githubusercontent.com/bluz71/misc-binaries/master/statusline/statusline-replace.png)

The above screenshots are using the
[nightfly](https://github.com/bluz71/vim-moonfly-colors) colorscheme and the
[Iosevka](https://github.com/be5invis/Iosevka) font with Git changes,
diagnostics and indent-status enabled.

Statusline Startup Comparison
-----------------------------

A startup comparison of _mistfly_ against various popular `statusline`
plugins, with their out-of-the-box defaults, on a clean and minimal Neovim setup
with the [moonfly](https://github.com/bluz71/vim-moonfly-colors) colorscheme.
The Neovim startup times in the following table are provived by the
[dstein64/vim-startuptime](https://github.com/dstein64/vim-startuptime) plugin.

Startup times are the average of five consecutive runs. Note, `stock` is run
without any `statusline` plugin.

| stock  | mistfly | lightline | airline | lualine
|--------|---------|-----------|---------|--------
| 20.2ms | 22.9ms  | 32.3ms    | 117.6ms | 26.9ms

Startup times as of January 2023 on my system; performance on other systems will
vary.

Plugins, Linters and Diagnostics supported
------------------------------------------

- [vim-devicons](https://github.com/ryanoasis/vim-devicons) and
  [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)

- [Gitsigns](https://github.com/lewis6991/gitsigns.nvim)

- [GitGutter](https://github.com/airblade/vim-gitgutter)

- [Signify](https://github.com/mhinz/vim-signify)

- [Neovim Diagnostic](https://neovim.io/doc/user/diagnostic.html)

- [ALE](https://github.com/dense-analysis/ale)

- [Coc](https://github.com/neoclide/coc.nvim)

- [Obsession](https://github.com/tpope/vim-obsession)

:zap: Requirements
------------------

_mistfly_ requires Vim 8 (or later) or Neovim 0.8 (or earlier); Neovim 0.9 (or
later) is not supported; the pure-Lua
[linefly](https://github.com/bluz71/nvim-linefly) plugin should instead be used
with contemporary versions of Neovim.

_mistfly_ requires a **GUI** capable version of Vim or Neovim with an
appropriate `colorscheme` set. A GUI client, or a modern version of Vim or
Neovim with the `termguicolors` option enabled in a true-color terminal, is
required.

Please also make sure that the `laststatus` option is set to either: `1`, `2`
or `3`.

Installation
------------

Install **bluz71/vim-mistfly-statusline** with your preferred plugin manager.

[vim-plug](https://github.com/junegunn/vim-plug):

```viml
Plug 'bluz71/vim-mistfly-statusline'
```

[packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use 'bluz71/vim-mistfly-statusline'
```

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ 'bluz71/vim-mistfly-statusline' },
```

Please do **not** lazy-load _mistfly_.

Layout And Default Colors
-------------------------

The *mistfly-statusline* layout consists of three groupings, the left-side,
middle and right-side as follows:

```
+-------------------------------------------------+
| A | B | C | D          M          W | X | Y | Z |
+-------------------------------------------------+
```

| Section | Purpose
|---------|------------------
| A`*`    | Mode status (normal, insert, visual, command and replace modes)
| B       | Filename (refer below for details)
| C`*`    | Git branch name (if applicable)
| D`*`    | Plugins notification (git, diagnostic and session status)
| W       | Optional search count and spell status
| X       | Current position
| Y`*`    | Total lines and current location as percentage
| Z       | Optional indent status (spaces and tabs shift width)

Sections marked with a `*` are linked to a highlight group and are colored,
refer to the next section for details.

Sections C, D & W will **not** be displayed when the `statusline` width is less
than 80 columns.

Note, filenames will be displayed as follows:

- Pathless filenames only for files in the current working directory

- Relative paths in preference to absolute paths for files not in the current
  working directory

- `~`-style home directory paths in preference to absolute paths

- Possibly shortened, for example `foo/bar/bazz/hello.txt` will be displayed as
  `f/b/b/hello.txt` when `statusline` width is less than 120 columns.

- Possibly trimmed. A maximum of four path components will be displayed for a
  filename; if a filename is more deeply nested then only the four most
  significant components, including the filename, will be displayed with an
  ellipses `…` prefix used to indicate path trimming.

Highlight Groups And Colors
---------------------------

Sections marked with `*` in the previous section are linked to the following
custom highlight groups with their associated fallbacks if the current
colorscheme does not support _mistfly_.

| Segment                  | Custom Highlight Group | Synthesized Highlight Fallback
|--------------------------|------------------------|-------------------------------
| Normal Mode              | `MistflyNormal`        | `Directory`
| Insert Mode              | `MistflyInsert`        | `String`
| Visual Mode              | `MistflyVisual`        | `Statement`
| Command Mode             | `MistflyCommand`       | `WarningMsg`
| Replace Mode             | `MistflyReplace`       | `Error`

Note, the following colorschemes support _mistfly_, either within the
colorscheme (moonfly & nightfly) or within this plugin (all others):

- [moonfly](https://github.com/bluz71/vim-moonfly-colors)

- [nightfly](https://github.com/bluz71/vim-nightfly-guicolors)

- [dracula](https://github.com/dracula/vim)

- [edge](https://github.com/sainnhe/edge)

- [embark](https://github.com/embark-theme/vim)

- [everforest](https://github.com/sainnhe/everforest)

- [gruvbox](https://github.com/gruvbox-community/gruvbox)

- [gruvbox-material](https://github.com/sainnhe/gruvbox-material)

- [sonokai](https://github.com/sainnhe/sonokai)

Lastly, if the fallback colors do not suit then it is very easy to override with
your own highlights.

:gift: Here is a simple example of customized _mistfly_ colors. Save the
following at the end of your initialization file after setting your
`colorscheme`.

```viml
highlight! link MistflyNormal DiffChange
highlight! link MistflyInsert WildMenu
highlight! link MistflyVisual IncSearch
highlight! link MistflyCommand WildMenu
highlight! link MistflyReplace ErrorMsg
```

:wrench: Options
----------------

| Option | Default State
|--------|--------------
| [mistflySeparatorSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflyseparatorsymbol)                   | `⎪`
| [mistflyProgressSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflyprogresssymbol)                     | `↓`
| [mistflyActiveTabSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflyactivetabsymbol)                   | `▪`
| [mistflyGitBranchSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflygitbranchsymbol)                   | ``
| [mistflyErrorSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflyerrorsymbol)                           | `E`
| [mistflyWarningSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflywarningsymbol)                       | `W`
| [mistflyInformationSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflyinformationsymbol)               | `I`
| [mistflyTabLine](https://github.com/bluz71/vim-mistfly-statusline#mistflytabline)                                   | Disabled
| [mistflyWithFileIcon](https://github.com/bluz71/vim-mistfly-statusline#mistflywithfileicon)                         | Enabled
| [mistflyWithGitBranch](https://github.com/bluz71/vim-mistfly-statusline#mistflywithgitbranch)                       | Enabled
| [mistflyWithGitStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithgitstatus)                       | Enabled
| [mistflyWithDiagnosticStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithdiagnosticstatus)         | Enabled
| [mistflyWithSessionStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithsessionstatus)               | Enabled
| [mistflyWithSearchCount](https://github.com/bluz71/vim-mistfly-statusline#mistflywithsearchcount)                   | Disabled
| [mistflyWithSpellStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflyWithspellstatus)                   | Disabled
| [mistflyWithIndentStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithindentstatus)                 | Disabled

---

### mistflySeparatorSymbol

The `mistflySeparatorSymbol` option specifies which character symbol to use
for segment separators in the `statusline`.

By default, the `⎪` character (Unicode `U+23AA`) will be displayed.

To specify your own separator symbol please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflySeparatorSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

```lua
-- Lua initialization file
vim.g.mistflySeparatorSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

---

### mistflyProgressSymbol

The `mistflyProgressSymbol` option specifies which character symbol to use to
indicate location-as-percentage in the `statusline`.

By default, the `↓` character (Unicode `U+2193`) will be displayed.

To specify your own progress symbol, or no symbol at all, please add the
following to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyProgressSymbol = '<<SYMBOL-OF-YOUR-CHOOSING-OR-EMPTY>>'
```

```lua
-- Lua initialization file
vim.g.mistflyProgressSymbol = '<<SYMBOL-OF-YOUR-CHOOSING-OR-EMPTY>>'
```

---

### mistflyActiveTabSymbol

The `mistflyActiveTabSymbol` option specifies which character symbol to use to
signify the active tab in the `tabline`.

By default, the `▪` character (Unicode `U+25AA`) will be displayed.

To specify your own active tab symbol please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyActiveTabSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

```lua
-- Lua initialization file
vim.g.mistflyActiveTabSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

---

### mistflyGitBranchSymbol

The `mistflyGitBranchSymbol` option specifies which character symbol to use
when displaying Git branch details.

By default, the `` character (Powerline `U+E0A0`) will be displayed. Many
modern monospace fonts will contain that character.

To specify your own Git branch symbol, or no symbol at all, please add the
following to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyGitBranchSymbol = '<<SYMBOL-OF-YOUR-CHOOSING-OR-EMPTY>>'
```

```lua
-- Lua initialization file
vim.g.mistflyGitBranchSymbol = '<<SYMBOL-OF-YOUR-CHOOSING-OR-EMPTY>>'
```

---

### mistflyErrorSymbol

The `mistflyErrorSymbol` option specifies which character symbol to use when
displaying diagnostic errors.

By default, the `E` character will be displayed.

To specify your own error symbol please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyErrorSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

```lua
-- Lua initialization file
vim.g.mistflyErrorSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

---

### mistflyWarningSymbol

The `mistflyWarningSymbol` option specifies which character symbol to use when
displaying diagnostic warnings.

By default, the `W` character will be displayed.

To specify your own warning symbol please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWarningSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

```lua
-- Lua initialization file
vim.g.mistflyWarningSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

---

### mistflyInformationSymbol

The `mistflyInformationSymbol` option specifies which character symbol to use
when displaying diagnostic information.

By default, the `I` character will be displayed.

To specify your own information symbol please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyInformationSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

```lua
-- Lua initialization file
vim.g.mistflyInformationSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

---

### mistflyTabLine

The `mistflyTabLine` option specifies whether to let this plugin manage the
`tabline` in addition to the `statusline`.

By default, `tabline` management will not be undertaken.

If enabled, _mistfly_ will render a simple numbered, and clickable,
window-space layout in the `tabline`; note, no buffers will be displayed in
the `tabline` since there are many plugins that already provide that
capability.

To enable `tabline` support please add the following to your initialization
file:

```viml
" Vimscript initialization file
let g:mistflyTabLine = v:true
```

```lua
-- Lua initialization file
vim.g.mistflyTabLine = true
```

:bulb: Mappings, such as the following, may be useful to quickly switch between
the numbered window-spaces:

```viml
nnoremap <Leader>1 1gt
nnoremap <Leader>2 2gt
nnoremap <Leader>3 3gt
nnoremap <Leader>4 4gt
nnoremap <Leader>5 5gt
nnoremap <Leader>6 6gt
nnoremap <Leader>7 7gt
nnoremap <Leader>8 8gt
nnoremap <Leader>9 9gt
```

A screenshot of the `tabline`:

![tabline](https://raw.githubusercontent.com/bluz71/misc-binaries/master/statusline/tabline.png)

---

### mistflyWithFileIcon

The `mistflyWithFileIcon` option specifies whether a filetype icon, from a
Nerd Font, will be displayed prior to the filename in the `statusline`.

Note, a [Nerd Font](https://www.nerdfonts.com) must be active **and** the
[vim-devicons](https://github.com/ryanoasis/vim-devicons) or
[nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) plugin
must also be installed and active.

By default, a filetype icon will be displayed if possible.

To disable the display of a filetype icon please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithFileIcon = v:false
```

```lua
-- lua initialization file
vim.g.mistflyWithFileIcon = false
```

---

### mistflyWithGitBranch

The `mistflyWithGitBranch` option specifies whether to display Git branch
details in the `statusline`.

By default, Git branches will be displayed in the `statusline`.

To disable the display of Git branches in the `statusline` please add the
following to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithGitBranch = v:false
```

```lua
-- Lua initialization file
vim.g.mistflyWithGitBranch = false
```

---

### mistflyWithGitStatus

The `mistflyWithGitStatus` option specifies whether to display the Git status
of the current buffer in the `statusline`.

The [Gitsigns](https://github.com/lewis6991/gitsigns.nvim),
[GitGutter](https://github.com/airblade/vim-gitgutter) and
[Signify](https://github.com/mhinz/vim-signify) plugins are supported.

By default, the Git status will be displayed if one of the above plugins is
loaded.

To disable the display of Git status in the `statusline` please add the
following to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithGitStatus = v:false
```

```lua
-- Lua initialization file
vim.g.mistflyWithGitStatus = false
```

---

### mistflyWithDiagnosticStatus

The `mistflyWithDiagnosticStatus` option specifies whether to indicate the
presence of the diagnostics in the current buffer.

[Neovim Diagnositics](https://neovim.io/doc/user/diagnostic.html),
[ALE](https://github.com/dense-analysis/ale) and
[Coc](https://github.com/neoclide/coc.nvim) are supported.

By default, diagnostics will be displayed if one of the above plugins is
loaded.

If diagnostic display is not wanted then please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithDiagnosticStatus = v:false
```

```lua
-- Lua initialization file
vim.g.mistflyWithDiagnosticStatus = false
```

---

### mistflyWithSessionStatus

The `mistflyWithSessionStatus` option specifies whether to display
[Obsession](https://github.com/tpope/vim-obsession) session details in the
`statusline`.

By default, session details will be displayed if the plugin is loaded.

To disable the display of session details in the `statusline` please add the
following to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithSessionStatus = v:false
```

```lua
-- Lua initialization file
vim.g.mistflyWithSessionStatus = false
```

---

### mistflyWithSearchCount

The `mistflyWithSearchCount` option specifies whether to display the search
count in the `statusline`.

By default, search count will not be displayed.

To enable the display of the search count in the `statusline` please add the
following to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithSearchCount = v:true
```

```lua
-- Lua initialization file
vim.g.mistflyWithSearchCount = true
```

Note, the search count is only displayed when the `hlsearch` option is set and
the search count result is not zero.

---

### mistflyWithSpellStatus

The `mistflyWithSpellStatus` option specifies whether to display the spell
status in the `statusline`.

By default, spell status will not be displayed.

To enable spell status in the `statusline` please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithSpellStatus = v:true
```

```lua
-- Lua initialization file
vim.g.mistflyWithSpellStatus = true
```

---

### mistflyWithIndentStatus

The `mistflyWithIndentStatus` option specifies whether to display the
indentation status as the last component in the `statusline`.

By default, indentation status will not be displayed.

Note, if the `expandtab` option is set, for the current buffer, then tab stop
will be displayed, for example `Tab:4` (tab equals four spaces); if on the
other hand `noexpandtab` option is set then shift width will be displayed
instead, for example `Spc:2` ('spc' short for 'space').

To enable indentation status please add the following to your initialization
file:

```viml
" Vimscript initialization file
let g:mistflyWithIndentStatus = v:true
```

```lua
-- Lua initialization file
vim.g.mistflyWithIndentStatus = true
```

Sponsor
-------

[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/bluz71)

License
-------

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
