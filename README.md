mistfly statusline
==================

_mistfly statusline_ is a simple, yet informative, _statusline_ for Vim and
Neovim that uses [moonfly](https://github.com/bluz71/vim-moonfly-colors) colors
by default. Note, the _statusline_ colors can easily be
[customized](https://github.com/bluz71/vim-mistfly-statusline#mistflyignoredefaultcolors)
if desired.

_mistfly statusline_ also supports Neovim's `winbar` feature when the
[appropriate option is
enabled](https://github.com/bluz71/vim-mistfly-statusline#mistflywinbar).

_mistfly statusline_ is a very light _statusline_ plugin clocking in at
around 300 lines of Vimscript. For comparison, the
[lightline](https://github.com/itchyny/lightline.vim) and
[airline](https://github.com/vim-airline/vim-airline) _statusline_ plugins
contain over 3,500 and 6,500 lines of Vimscript respectively. In fairness, the
latter two plugins are also more featureful.

Screenshots
-----------

<img width="900" alt="normal" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_normal.png">

<img width="900" alt="insert" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_insert.png">

<img width="900" alt="visual" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_visual.png">

<img width="900" alt="visual" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_replace.png">

The font in use is [Iosevka](https://github.com/be5invis/Iosevka). Also, the
`g:mistflyWithGitBranchCharacter` option is set to `1`.

Plugins, Linters and Diagnostics supported
------------------------------------------

- [vim-devicons](https://github.com/ryanoasis/vim-devicons) and
  [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) via the
  `mistflyWithNerdIcon` option

- [Neovim Diagnostic](https://neovim.io/doc/user/diagnostic.html) via the
  `mistflyWithNvimDiagnosticIndicator` option

- [ALE](https://github.com/dense-analysis/ale) via the
  `mistflyWithALEIndicator` option

- [Coc](https://github.com/neoclide/coc.nvim) via the
  `mistflyWithCocIndicator` option

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

_mistfly statusline_ supports the legacy version of this project, previously
named _moonfly statusline_, via the `moonfly-compat` branch. That legacy version
can be installed with your preferred plugin manager.

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

The *mistfly-statusline* layout contains two groupings, the left side segments:

```
<Mode *> <Filename & Flags> <Git Branch *> <Plugins Status *>
```

And the right side segments:

```
<Line:Column> | <Total Lines *> | <% Position>
```

Segments marked with a `*` will be colored by default, refer to the table below.

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

The default [moonfly](https://github.com/bluz71/vim-moonfly-colors) colours used
for the above listed colored `*` segments:

| Segment           | Highlight Group | Background                                                  | Foreground                                                  |
|-------------------|-----------------|-------------------------------------------------------------|-------------------------------------------------------------|
| Normal Mode       | `User1`         | ![background](https://via.placeholder.com/32/80a0ff?text=+) | ![background](https://via.placeholder.com/32/1c1c1c?text=+) |
| Insert Mode       | `User2`         | ![background](https://via.placeholder.com/32/c6c6c6?text=+) | ![background](https://via.placeholder.com/32/1c1c1c?text=+) |
| Visual Mode       | `User3`         | ![background](https://via.placeholder.com/32/ae81ff?text=+) | ![background](https://via.placeholder.com/32/1c1c1c?text=+) |
| Replace Mode      | `User4`         | ![background](https://via.placeholder.com/32/f74782?text=+) | ![background](https://via.placeholder.com/32/1c1c1c?text=+) |
| Git Branch        | `User5`         | `StatusLine` background                                     | ![background](https://via.placeholder.com/32/80a0ff?text=+) |
| Plugins Status    | `User6`         | `StatusLine` background                                     | ![background](https://via.placeholder.com/32/f74782?text=+) |
| Total Lines       | `User7`         | `StatusLine` background                                     | ![background](https://via.placeholder.com/32/80a0ff?text=+) |

:wrench: Options
----------------

### mistflyIgnoreDefaultColors

The `mistflyIgnoreDefaultColors` option specifies whether custom _statusline_
colors should be used in-place of
[mistfly](https://github.com/bluz71/vim-mistfly-colors) colors. By default
[mistfly](https://github.com/bluz71/vim-mistfly-colors) colors will be
displayed. If custom colors are to be used then please add the following to your
initialization file

```viml
" Vimscript initialization file
let g:mistflyIgnoreDefaultColors = 1
```

```lua
-- Lua initialization file
vim.g.mistflyIgnoreDefaultColors = 1
```

:gift: Here is an example of a customized _statusline_ color theme which should
work well with most existing Vim colorschemes. Save the following either
at the end of your initialization file or in an appropriate `after` file such as
`~/.vim/after/plugin/mistfly-statusline.vim`:

```viml
highlight! link User1 DiffText
highlight! link User2 DiffAdd
highlight! link User3 Search
highlight! link User4 IncSearch
highlight! link User5 StatusLine
highlight! link User6 StatusLine
highlight! link User7 StatusLine
```

:cake: Note, the [nightfly](https://github.com/bluz71/vim-nightfly-guicolors)
color scheme automatically defines _statusline_ colors that are compatible with
this plugin. **No** custom settings are required with that colorscheme.

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

### mistflyDiagnosticSymbol

The `mistflyDiagnosticSymbol` option specifies which character symbol to use to
indicate diagnostic errors. Currently,
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

### mistflyWithNvimDiagnosticIndicator

_mistfly statusline_ supports [Neovim
Diagnostics](https://neovim.io/doc/user/diagnostic.html)

The `mistflyWithNvimDiagnosticIndicator` option specifies whether to indicate
the presence of the Neovim Diagnostics in the current buffer via the defined
`mistflyDiagnosticSymbol` (the Unicode `U+2716` `✖` symbol by default). If
enabled, the indicator will be displayed in the left-side section of the
_statusline_.

By default, Neovim Diagnositics will **not** be indicated.

If Neovim Diagnostic indication is desired then please add the following to
your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithNvimDiagnosticIndicator = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWithNvimDiagnosticIndicator = 1
```

---

### mistflyWithALEIndicator

_mistfly statusline_ supports the [ALE](https://github.com/dense-analysis/ale)
plugin.

The `mistflyWithALEIndicator` option specifies whether to indicate the
presence of the ALE errors and warnings in the current buffer via the defined
`mistflyDiagnosticSymbol` (the Unicode `U+2716` `✖` symbol by default). If
enabled, the indicator will be displayed in the left-side section of the
_statusline_.

By default, ALE errors and warnings will **not** be indicated.

If ALE indication is desired then please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithALEIndicator = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWithALEIndicator = 1
```

---

### mistflyWithCocIndicator

_mistfly statusline_ supports the [Coc](https://github.com/neoclide/coc.nvim)
plugin.

The `mistflyWithCocIndicator` option specifies whether to indicate the
presence of the Coc diagnostics in the current buffer via the defined
`mistflyDiagnosticSymbol` (the Unicode `U+2716` `✖` symbol by default). If
enabled, the indicator will be displayed in the left-side section of the
_statusline_.

By default, Coc errors will **not** be indicated.

If Coc error indication is desired then please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithCocIndicator = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWithCocIndicator = 1
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
