mistfly statusline
==================

_mistfly statusline_ is a simple, fast and informative `statusline` for Vim and
(legacy) Neovim coded in Vimscript.

:point_right: Contemporary Neovim users should use the pure-Lua
[linefly](https://github.com/bluz71/nvim-linefly) plugin instead of _mistfly_.

_mistfly_ provides optional `tabline` and Neovim `winbar` support when the
appropriate settings are enabled; refer to
[`mistflyTabLine`](https://github.com/bluz71/vim-mistfly-statusline#mistflytabline)
and
[`mistflyWinBar`](https://github.com/bluz71/vim-mistfly-statusline#mistflywinbar).

_mistfly_ will adapt it's colors to the colorscheme currently in effect. Colors
can also be
[customized](https://github.com/bluz71/vim-mistfly-statusline#highlight-groups-and-colors)
if desired.

Lastly, _mistfly_ is a light _statusline_ plugin clocking in at about 500 lines
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

![normal](https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly-normal.png)
![insert](https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly-insert.png)
![visual](https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly-visual.png)
![command](https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly-command.png)
![replace](https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly-replace.png)

The above screenshots are using the
[nightfly](https://github.com/bluz71/vim-nightfly-colors) colorscheme and the
[Iosevka](https://github.com/be5invis/Iosevka) font with a couple Git changes,
a single Diagnostic warning and indent-status enabled.

Statusline Performance Comparison
---------------------------------

A performance comparison of _mistfly_ against various popular `statusline`
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

The *mistfly-statusline* layout consists of two main groupings, the left-side
and right-side groups as follows:

```
+-------------------------------------------------+
| A | B | C | D                         X | Y | Z |
+-------------------------------------------------+
```

| Section | Purpose
|---------|------------------
| A`*`    | Mode status (normal, insert, visual, command and replace modes)
| B       | Filename (refer below for details)
| C`*`    | Git branch name (if applicable)
| D`*`    | Plugins notification (git, diagnostic and session status)
| X       | Current position
| Y`*`    | Total lines and current location as percentage
| Z       | Optional indent status (spaces and tabs shift width)

Sections marked with a `*` are linked to a highlight group and are colored,
refer to the next section for details.

Note, filenames will be displayed as follows:

- Pathless filenames only for files in the current working directory

- Relative paths in preference to absolute paths for files not in the current
  working directory

- `~`-style home directory paths in preference to absolute paths

- Shortened, for example `foo/bar/bazz/hello.txt` will be displayed as
  `f/b/b/hello.txt`, but not when Neovim's global statusline (`set
  laststatus=3`) is in effect.

- Trimmed, a maximum of four path components will be displayed for a filename,
  if a filename is more deeply nested then only the four most significant
  components, including the filename, will be displayed with an ellipses `...`
  prefix used to indicate path trimming.

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

- [catppuccin](https://github.com/catppuccin/nvim)

- [dracula](https://github.com/dracula/vim)

- [edge](https://github.com/sainnhe/edge)

- [embark](https://github.com/embark-theme/vim)

- [everforest](https://github.com/sainnhe/everforest)

- [gruvbox](https://github.com/gruvbox-community/gruvbox)

- [gruvbox-material](https://github.com/sainnhe/gruvbox-material)

- [nightfox](https://github.com/EdenEast/nightfox.nvim)

- [sonokai](https://github.com/sainnhe/sonokai)

- [tokyonight](https://github.com/folke/tokyonight.nvim)

Lastly, if the fallback colors do not suit then it is very easy to override with
your own highlights.

:gift: Here is a simple example of customized _mistfly_ colors. Save the
following either at the end of your initialization file after setting your
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
| [mistflyArrowSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflyarrowsymbol)                           | `↓`
| [mistflyActiveTabSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflyactivetabsymbol)                   | `▪`
| [mistflyGitBranchSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflygitbranchsymbol)                   | ``
| [mistflyErrorSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflyerrorsymbol)                           | `E`
| [mistflyWarningSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflywarningsymbol)                       | `W`
| [mistflyInformationSymbol](https://github.com/bluz71/vim-mistfly-statusline#mistflyinformationsymbol)               | `I`
| [mistflyTabLine](https://github.com/bluz71/vim-mistfly-statusline#mistflytabline)                                   | Disabled
| [mistflyWinBar](https://github.com/bluz71/vim-mistfly-statusline#mistflywinbar)                                     | Disabled
| [mistflyWithIndentStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithindentstatus)                 | Disabled
| [mistflyWithFileIcon](https://github.com/bluz71/vim-mistfly-statusline#mistflywithfileicon)                         | Enabled
| [mistflyWithGitBranch](https://github.com/bluz71/vim-mistfly-statusline#mistflywithgitbranch)                       | Enabled
| [mistflyWithGitsignsStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithgitsignsstatus)             | Enabled if Gitsigns plugin is loaded
| [mistflyWithGitGutterStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithgitgutterstatus)           | Enabled if GitGutter plugin is loaded
| [mistflyWithSignifyStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithsignifystatus)               | Enabled if Signify plugin is loaded
| [mistflyWithNvimDiagnosticStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithnvimdiagnosticstatus) | Enabled if nvim-lspconfig plugin is loaded
| [mistflyWithALEStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithalestatus)                       | Enabled if ALE plugin is loaded
| [mistflyWithCocStatus](https://github.com/bluz71/vim-mistfly-statusline#mistflywithcocstatus)                       | Enabled if Coc plugin is loaded

---

### mistflySeparatorSymbol

The `mistflySeparatorSymbol` option specifies which character symbol to use for
segment separators in the `statusline`.

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

### mistflyArrowSymbol

The `mistflyArrowSymbol` option specifies which character symbol to use to
indicate location-as-percentage in the `statusline`.

By default, the `↓` character (Unicode `U+2193`) will be displayed.

To specify your own arrow symbol, or no symbol at all, please add the following
to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyArrowSymbol = '<<SYMBOL-OF-YOUR-CHOOSING-OR-EMPTY>>'
```

```lua
-- Lua initialization file
vim.g.mistflyArrowSymbol = '<<SYMBOL-OF-YOUR-CHOOSING-OR-EMPTY>>'
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

The `mistflyGitBranchSymbol` option specifies which character symbol to use to
signify the active tab in the `tabline`.

By default, the `` character (Powerline `U+E0A0`) will be displayed. Many
modern monospace fonts will contain that character.

To specify your own active tab symbol, or no symbol at all, please add the
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
displaying [Neovim Diagnostic](https://neovim.io/doc/user/diagnostic.html),
[ALE](https://github.com/dense-analysis/ale) or
[Coc](https://github.com/neoclide/coc.nvim) errors.

By default, the `E` character, will be displayed.

To specify your own error symbol please add the following to your initialization
file:

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
displaying [Neovim Diagnostic](https://neovim.io/doc/user/diagnostic.html),
[ALE](https://github.com/dense-analysis/ale) or
[Coc](https://github.com/neoclide/coc.nvim) warnings.

By default, the `W` character, will be displayed.

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
when displaying [Neovim Diagnostic](https://neovim.io/doc/user/diagnostic.html),
[ALE](https://github.com/dense-analysis/ale) or
[Coc](https://github.com/neoclide/coc.nvim) information.

By default, the `I` character, will be displayed.

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
`tabline` in addition to the `statusline`. By default `tabline` management will
not be undertaken.

If enabled, _mistfly_ will render a simple numbered, and clickable, window-space
layout in the `tabline`; note, no buffers will be displayed in the `tabline`
since there are many plugins that already provide that capability.

To enable _mistfly_'s `tabline` support please add the following to your
initialization file:

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

![tabline](https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly-tabline.png)

---

### mistflyWinBar

The `mistflyWinBar` option specifies whether to display Neovim's window bar at
the top of each window. By default window bars will not be displayed.

Note, Neovim 0.8 (or later) is required for this feature.

Displaying a window bar is recommended when Neovim's global statusline is
enabled via `set laststatus=3`; the `winbar` will then display the file name at
the top of each window to disambiguate splits. Also, if there only one window in
the current tab then a `winbar` will not be displayed (it won't be needed).

To enable Neovim's `winbar` feature please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWinBar = v:true
```

```lua
-- Lua initialization file
vim.g.mistflyWinBar = true
```

---

### mistflyWithIndentStatus

The `mistflyWithIndentStatus` option specifies whether to display the
indentation status as the last component in the statusline. By default
indentation status will not be displayed.

Note, if the `expandtab` option is set, for the current buffer, then tab stop
will be displayed, for example `Tab:4` (tab equals four spaces); if on the other
hand `noexpandtab` option is set then shift width will be displayed instead, for
example `Spc:2` ('spc' short for 'space').

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

---

### mistflyWithGitBranch

The `mistflyWithGitBranch` option specifies whether to display Git branch
details in the _statusline_. By default Git branches will be displayed in the
`statusline`.

To disable the display of Git branches in the _statusline_ please add the
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

### mistflyWithGitsignsStatus

The `mistflyWithGitsignsStatus` option specifies whether to display
[Gitsigns](https://github.com/lewis6991/gitsigns.nvim) of the current buffer in
the _statusline_.

By default, Gitsigns will be displayed if the plugin is loaded.

To disable the display of Gitsigns in the _statusline_ please add the following
to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithGitsignsStatus = v:false
```

```lua
-- Lua initialization file
vim.g.mistflyWithGitsignsStatus = false
```

---

### mistflyWithGitGutterStatus

The `mistflyWithGitGutterStatus` option specifies whether to display
[GitGutter](https://github.com/airblade/vim-gitgutter) status of the current
buffer in the _statusline_.

By default, GitGutter status will be displayed if the plugin is loaded.

To disable the display of GitGutter status in the _statusline_ please add the
following to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithGitGutterStatus = v:false
```

```lua
-- Lua initialization file
vim.g.mistflyWithGitGutterStatus = false
```

---

### mistflyWithSignifyStatus

The `mistflyWithSignifyStatus` option specifies whether to display
[Signify](https://github.com/mhinz/vim-signify) status of the current
buffer in the _statusline_.

By default, Signify status will be displayed if the plugin is loaded.

To disable the display of Signify status in the _statusline_ please add the
following to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithSignifyStatus = v:false
```

```lua
-- Lua initialization file
vim.g.mistflyWithSignifyStatus = false
```

---

### mistflyWithFileIcon

The `mistflyWithFileIcon` option specifies whether a filetype icon, from a Nerd
Font, will be displayed prior to the filename in the `statusline` (and optional
`winbar`).

Note, a [Nerd Font](https://www.nerdfonts.com) must be active **and** the
[vim-devicons](https://github.com/ryanoasis/vim-devicons) or
[nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) plugin must
also be installed and active.

By default a filetype icon will be displayed if possible.

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

### mistflyWithNvimDiagnosticStatus

_mistfly_ supports [Neovim
Diagnostics](https://neovim.io/doc/user/diagnostic.html)

The `mistflyWithNvimDiagnosticStatus` option specifies whether to indicate the
presence of the Neovim Diagnostics in the current buffer.

By default, Neovim Diagnositics will be displayed if the
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) plugin is loaded.

If Neovim Diagnostic display is not wanted then please add the following to
your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithNvimDiagnosticStatus = v:false
```

```lua
-- Lua initialization file
vim.g.mistflyWithNvimDiagnosticStatus = false
```

---

### mistflyWithALEStatus

_mistfly_ supports the [ALE](https://github.com/dense-analysis/ale) plugin.

The `mistflyWithALEStatus` option specifies whether to indicate the presence of
the ALE problems in the current buffer.

By default, ALE problems will be displayed if the plugin is loaded.

If ALE problems display is not wanted then please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithALEStatus = v:false
```

```lua
-- Lua initialization file
vim.g.mistflyWithALEStatus = false
```

---

### mistflyWithCocStatus

_mistfly_ supports the [Coc](https://github.com/neoclide/coc.nvim) plugin.

The `mistflyWithCocStatus` option specifies whether to indicate the presence of
the Coc diagnostics in the current buffer.

By default, Coc diagnostics will be displayed if the plugin is loaded.

If Coc diagnostics are not wanted then please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithCocStatus = v:false
```

```lua
-- Lua initialization file
vim.g.mistflyWithCocStatus = false
```

Sponsor
-------

[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/bluz71)

License
-------

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
