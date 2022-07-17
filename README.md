mistfly statusline
==================

_mistfly statusline_ is a simple, fast and informative `statusline` for Vim and
Neovim.

_mistfly statusline_ also provides optional `tabline` and Neovim
`winbar` support when the appropriate settings are enabled; refer to
[`mistflyTabLine`](https://github.com/bluz71/vim-mistfly-statusline#mistflywinbar)
and
[`mistflyWinBar`](https://github.com/bluz71/vim-mistfly-statusline#mistflywinbar).

_mistfly statusline_ will adapt it's colors to the colorscheme currently in
effect. Colors can also be
[customized](https://github.com/bluz71/vim-mistfly-statusline#highlight-groups-and-colors)
if desired.

Lastly, _mistfly statusline_ is a light _statusline_ plugin clocking in at
about 400 lines of Vimscript. For comparison, the
[lightline](https://github.com/itchyny/lightline.vim),
[airline](https://github.com/vim-airline/vim-airline) and
[lualine](https://github.com/nvim-lualine/lualine.nvim) `statusline` plugins
contain over 3,600, 7,900 and 7,300 lines of code respectively. In fairness, the
latter plugins are also far more featureful and configurable.

Screenshots
-----------

![normal](https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly-normal.png)
![insert](https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly-insert.png)
![visual](https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly-visual.png)
![replace](https://raw.githubusercontent.com/bluz71/misc-binaries/master/mistfly/mistfly-replace.png)

The above screenshots are using the
[moonfly](https://github.com/bluz71/vim-moonfly-colors) colorscheme with the
[Iosevka](https://github.com/be5invis/Iosevka) font.

Statusline Performance Comparison
---------------------------------

A performance comparison of _mistfly stautusline_ against various popular
`statusline` plugins, with their out-of-the-box defaults, on a clean and minimal
Neovim setup. The Neovim startup times in the table below are provived by the
[dstein64/vim-startuptime](https://github.com/dstein64/vim-startuptime) plugin.

Startup times are the average of five consecutive runs. Note, `native` is run
without any `statusline` plugin.

| native  | mistfly | lightline | airline | lualine
|---------|---------|-----------|---------|--------
| 20.4ms  | 22.3ms  | 26.7ms    | 76.6ms  | 29.5ms

Startup times as of July 2022 on my system; performance on other systems will
vary.

Plugins, Linters and Diagnostics supported
------------------------------------------

- [vim-devicons](https://github.com/ryanoasis/vim-devicons) and
  [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) via the
  `mistflyWithNerdIcon` option

- [Gitsigns](https://github.com/lewis6991/gitsigns.nvim) via the
  `mistflyWithGitsignsStatus` option

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
<Mode *> <Filename & Flags> | <Git Branch *> <Plugins Notification *>
```

And the right-side segment:

```
<Line:Column> | <Total Lines *> <% Position> | <Optional Indentation Status >
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
| Command Mode             | `MistflyCommand`       | `DiffText`
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

### mistflyAsciiShapes

The `mistflyAsciiShapes` option specifies whether to only use Ascii characters
for certain dividers and symbols.

_mistfly statusline_ by default **will use** Unicode Symbols and Powerline
Glyphs for certain shapes such as: Git branch, dividers and active tabs. Note,
many modern fonts, such as: [Hack](https://sourcefoundry.org/hack),
[Iosevka](https://typeof.net/Iosevk), [Fira
Code](https://github.com/tonsky/FiraCode) and [Jetbrains
Mono](https://www.jetbrains.com/lp/mono), will provide these shapes.

To limit use only to Ascii shapes please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyAsciiShapes = 1
```

```lua
-- Lua initialization file
vim.g.mistflyAsciiShapes = 1
```

---

### mistflyErrorSymbol

The `mistflyErrorSymbol` option specifies which character symbol to use when
displaying [Neovim Diagnostic](https://neovim.io/doc/user/diagnostic.html),
[ALE](https://github.com/dense-analysis/ale) or
[Coc](https://github.com/neoclide/coc.nvim) errors.

By default, the `x` character, will be displayed.

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

By default, the exclamation symbol, `!`, will be displayed.

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

### mistflyTabLine

The `mistflyTabLine` option specifies whether to let this plugin manage the
`tabline` in addition to the `statusline`. By default `tabline` management will
not be undertaken.

If enabled, _mistfly statusline_ will render a simple numbered, and clickable,
window-space layout in the `tabline`; note, no buffers will be displayed in the
`tabline` since there are many plugins that already provide that capability.

To enable _mistfly statusline_'s `tabline` support please add the following to
your initialization file:

```viml
" Vimscript initialization file
let g:mistflyTabLine = 1
```

```lua
-- Lua initialization file
vim.g.mistflyTabLine = 1
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

### mistflyWithGitsignsStatus

The `mistflyWithGitsignsStatus` option specifies whether to display
[Gitsigns](https://github.com/lewis6991/gitsigns.nvim) of the current buffer in
the _statusline_. If enabled, the Gitsigns will be displayed in the left-side
section of the _statusline_.

By default, Gitsigns will **not** be displayed.

To enable the display of Gitsigns in the _statusline_ please add the following
to your initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithGitsignsStatus = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWithGitsignsStatus = 1
```

Note, the `status_formatter` field of the Gitsigns `setup` function sets the
style output. This can easily be overridden, for example the following
sample implementation will use Unicode characters to indicate additions, changes
and deletions. If `status_formatter` is not set, Gitsigns will use a fallback of
its own.

```lua
require('gitsigns').setup({
  status_formatter = function(status)
    local added, changed, removed = status.added, status.changed, status.removed
    local status_text = {}
    if added and added > 0 then
      table.insert(status_text, '⊞ ' .. added)
    end
    if changed and changed > 0 then
      table.insert(status_text, '⊡ ' .. changed)
    end
    if removed and removed > 0 then
      table.insert(status_text, '⊟ ' .. removed)
    end
    return table.concat(status_text, ' ')
  end
})
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

The `mistflyWithNvimDiagnosticStatus` option specifies whether to indicate the
presence of the Neovim Diagnostics in the current buffer. If enabled, the status
will be displayed in the left-side section of the _statusline_.

By default, Neovim Diagnositics will **not** be displayed.

If Neovim Diagnostic display is desired then please add the following to
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

The `mistflyWithALEStatus` option specifies whether to indicate the presence of
the ALE errors and warnings in the current buffer. If enabled, the status will
be displayed in the left-side section of the _statusline_.

By default, ALE errors and warnings will **not** be displayed.

If ALE errors and warning display is desired then please add the following to
your initialization file:

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

The `mistflyWithCocStatus` option specifies whether to indicate the presence of
the Coc diagnostics in the current buffer. If enabled, the status will be
displayed in the left-side section of the _statusline_.

By default, Coc diagnostics will **not** be displayed.

If Coc diagnostics is desired then please add the following to your
initialization file:

```viml
" Vimscript initialization file
let g:mistflyWithCocStatus = 1
```

```lua
-- Lua initialization file
vim.g.mistflyWithCocStatus = 1
```

Sponsor
-------

[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/bluz71)

License
-------

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
