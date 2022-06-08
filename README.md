mistfly statusline
==================

_mistfly statusline_ is a simple, yet informative, `statusline` for Vim and
Neovim. _mistfly statusline_ also supports Neovim's `winbar` feature when the
[appropriate option is
enabled](https://github.com/bluz71/vim-mistfly-statusline#mistflywinbar).

_mistfly statusline_ will adapt it's colors to the colorscheme currently in
effect. Colors can also be
[customized](https://github.com/bluz71/vim-mistfly-statusline#highlight-groups-and-colors)
if desired.

Lastly, _mistfly statusline_ is a very light _statusline_ plugin clocking in at
around 300 lines of Vimscript. For comparison, the
[lightline](https://github.com/itchyny/lightline.vim) and
[airline](https://github.com/vim-airline/vim-airline) `statusline` plugins
contain over 3,500 and 6,500 lines of Vimscript respectively. In fairness, the
latter plugins are also more featureful.

Screenshots
-----------

<img width="900" alt="normal" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly_normal.png">

<img width="900" alt="insert" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly_insert.png">

<img width="900" alt="visual" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly_visual.png">

<img width="900" alt="visual" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly_replace.png">

The above screenshots are using the
[moonfly](https://github.com/bluz71/vim-moonfly-colors) colorscheme with the
[Iosevka](https://github.com/be5invis/Iosevka) font. Also, the
`mistflyWithGitBranchCharacter` option is set to `1`.

Plugins, Linters and Diagnostics supported
------------------------------------------

- [vim-devicons](https://github.com/ryanoasis/vim-devicons) and
  [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) via the
  `mistflyWithNerdIcon` option

- [Neovim Diagnostic](https://neovim.io/doc/user/diagnostic.html) via the
  `mistflyWithNvimDiagnosticStatus` option

- [ALE](https://github.com/dense-analysis/ale) via the
  `mistflyWithALEStatus` option

- [Coc](https://github.com/neoclide/coc.nvim) via the
  `mistflyWithCocStatus` option

- [Obsession](https://github.com/tpope/vim-obsession)

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

Legacy Installation
-------------------

_mistfly statusline_ still supports the legacy version of this plugin,
previously named _moonfly statusline_, via the `moonfly-compat` branch. That
legacy version can be installed with your preferred plugin manager.

[vim-plug](https://github.com/junegunn/vim-plug):

```viml
Plug 'bluz71/vim-mistfly-statusline', { 'branch': 'moonfly-compat' }
```

[packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use { 'bluz71/vim-mistfly-statusline', branch = 'moonfly-compat' }
```

Notice
------

File explorers, such as _NERDTree_ and _netrw_, and certain other special
windows will **not** be directly styled by this plugin.

Layout And Default Colors
-------------------------

The *mistfly-statusline* layout contains two segments, the left-side segment:

```
<Mode *> <Filename & Flags> <Git Branch *> <Plugins Notification *>
```

And the right-side segment:

```
<Line:Column> | <Total Lines *> | <% Position> | <% Optional Indentation Status >
```

Sub-segments marked with a `*` are linked to a highlight group and may be
colored, refer to the next section for details.

Note also, filenames will be displayed as follows:

- Pathless filenames only for files in the current working directory

- Relative paths in preference to absolute paths for files not in the current
  working directory

- `~`-style home directory paths in preference to absolute paths

- Compacted, for example `foo/bar/bazz/hello.txt` will be displayed as
  `f/b/b/hello.txt`

- Trimmed, a maximum of four path components will be displayed for a filename,
  if a filename is more deeply nested then only the four most significant
  components, including the filename, will be displayed with an ellipses `...`
  prefix used to indicate path trimming.

Highlight Groups And Colors
---------------------------

Sub-segments marked with `*` in the previous section are linked to the following
custom highlight groups and their associated linked fallback highlight groups if
the current colorscheme does not directly support _mistfly statusline_ (which
will be the case for most colorschemes).

| Segment                  | Custom Highlight Group | Fallback Highlight Group
|--------------------------|------------------------|-------------------------
| Normal Mode              | `MistflyNormal`        | `DiffText`
| Insert Mode              | `MistflyInsert`        | `DiffAdd`
| Visual Mode              | `MistflyVisual`        | `Search`
| Replace Mode             | `MistflyReplace`       | `DiffDelete`
| Git Branch & Total Lines | `MistflyEmphasis`      | `Statusline`
| Plugins Notification     | `MistflyNotification`  | `StatusLine`

The above fallbacks should work well for most colorschemes.

Note, the [moonfly](https://github.com/bluz71/vim-moonfly-colors)
and [nightfly](https://github.com/bluz71/vim-nightfly-guicolors) colorschemes do
directly support _mistfly statusline_.

If the fallback colors do not suit then it is very easy to override with your
own highlights.

:gift: Here is an example of customized _mistfly statusline_ colors. Save the
following either at the end of your initialization file, after setting your
`colorscheme`, or in an appropriate `after` file such as
`~/.vim/after/plugin/mistfly-statusline.vim`.

```viml
highlight! link MistflyNormal DiffChange
highlight! link MistflyInsert WildMenu
highlight! link MistflyVisual IncSearch
highlight! link MistflyReplace ErrorMsg
highlight! link MistflyEmphasis TabLineSel
highlight! link MistflyNotification TabLine
```

:wrench: Options
----------------

### mistflyDiagnosticSymbol

The `mistflyDiagnosticSymbol` option specifies which character symbol to use to
indicate diagnostics. Currently,
[Neovim](https://neovim.io/doc/user/diagnostic.html),
[ALE](https://github.com/dense-analysis/ale) and
[Coc](https://github.com/neoclide/coc.nvim) diagnostics may be indicated with
this symbol (when the appropriate diagnostic option is set, see below).

By default, the Unicode cross character (`U+2716`), `✖`, will be displayed. A
modern font, such as [Iosevka](https://github.com/be5invis/Iosevka), will
contain that Unicode character.

To specify your own diagnostics symbol please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyDiagnosticSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

```lua
-- Lua initialization file
vim.g.mistflyDiagnosticSymbol = '<<SYMBOL-OF-YOUR-CHOOSING>>'
```

---

### mistflyWinBar

The `mistflyWinBar` option specifies whether to display Neovim's window bar at
the top of each window. By default window bars will not be displayed.

Displaying a window bar is reasonable when Neovim's global statusline is
enabled via `set laststatus=3`; the `winbar` will then display the file name at
the top of each window to disambiguate splits. Note, Neovim 0.8 is required for
this feature.

To enable Neovim's `winbar` feature please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWinBar = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWinBar = 1
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
let g:mistflyWithGitBranch = 0
```

```lua
-- Lua initialization file
vim.g.mistflyWithGitBranch = 0
```

---

### mistflyWithGitBranchCharacter

The `mistflyWithGitBranchCharacter` option specifies whether to display Git
branch details with the Unicode Git branch character `U+E0A0`. By default Git
branches displayed in the `statusline` will not use that character since many
monospace fonts will not contain it. However, some modern fonts, such as [Fira
Code](https://github.com/tonsky/FiraCode) and
[Iosevka](https://github.com/be5invis/Iosevka), do contain that Git branch
character.

If `mistflyWithGitBranchCharacter` is unset or set to zero then the current
Git branch will be displayed inside square brackets.

To display with the Unicode Git branch character please add the following to
your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithGitBranchCharacter = 1
```

```Lua
-- Lua initialization file
vim.g.mistflyWithGitBranchCharacter = 1
```

The above screenshots are displayed with the Git branch character.

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
let g:mistflyWithIndentStatus = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWithIndentStatus = 1
```

---

### mistflyWithNerdIcon

The `mistflyWithNerdIcon` option specifies whether a filetype icon, from the
current Nerd Font, will be displayed next to the filename in the `statusline`.

Note, a [Nerd Font](https://www.nerdfonts.com) must be in-use **and** the
[vim-devicons](https://github.com/ryanoasis/vim-devicons) or
[nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) plugin must
be installed and active.

By default a Nerd Font filetype icon will not be displayed in the
`statusline`.

To display a Nerd Font filetype icon please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithNerdIcon = 1
```

```lua
-- lua initialization file
vim.g.mistflyWithNerdIcon = 1
```

---

### mistflyWithNvimDiagnosticStatus

_mistfly statusline_ supports [Neovim
Diagnostics](https://neovim.io/doc/user/diagnostic.html)

The `mistflyWithNvimDiagnosticStatus` option specifies whether to indicate
the presence of the Neovim Diagnostics in the current buffer via the defined
`mistflyDiagnosticSymbol` (the Unicode `U+2716` `✖` symbol by default). If
enabled, the status will be displayed in the left-side section of the
_statusline_.

By default, Neovim Diagnositics will **not** be indicated.

If Neovim Diagnostic indication is desired then please add the following to
your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithNvimDiagnosticStatus = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWithNvimDiagnosticStatus = 1
```

---

### mistflyWithALEStatus

_mistfly statusline_ supports the [ALE](https://github.com/dense-analysis/ale)
plugin.

The `mistflyWithALEStatus` option specifies whether to indicate the
presence of the ALE errors and warnings in the current buffer via the defined
`mistflyDiagnosticSymbol` (the Unicode `U+2716` `✖` symbol by default). If
enabled, the status will be displayed in the left-side section of the
_statusline_.

By default, ALE errors and warnings will **not** be indicated.

If ALE indication is desired then please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithALEStatus = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWithALEStatus = 1
```

---

### mistflyWithCocStatus

_mistfly statusline_ supports the [Coc](https://github.com/neoclide/coc.nvim)
plugin.

The `mistflyWithCocStatus` option specifies whether to indicate the
presence of the Coc diagnostics in the current buffer via the defined
`mistflyDiagnosticSymbol` (the Unicode `U+2716` `✖` symbol by default). If
enabled, the status will be displayed in the left-side section of the
_statusline_.

By default, Coc errors will **not** be indicated.

If Coc error indication is desired then please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithCocStatus = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWithCocStatus = 1
```

---

### mistflyWithObessionGeometricCharacters

_mistfly statusline_ supports Tim Pope's
[Obsession](https://github.com/tpope/vim-obsession) plugin.

The `mistflyWithObessionGeometricCharacters` option specifies whether to
display obsession details using Unicode geometric characters (`U+25A0` - Black
Square & `U+25CF` - Black Circle). A modern font, such as
[Iosevka](https://github.com/be5invis/Iosevka), will contain those Unicode
geometric characters.

If `mistflyWithObessionGeometricCharacters` is unset the default value from
the Obsession plugin will be used.

To display Obsession status with geometric characters please add the following
to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithObessionGeometricCharacters = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWithObessionGeometricCharacters = 1
```

Sponsor
-------

[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/bluz71)

License
-------

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
