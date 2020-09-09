moonfly statusline
==================

_moonfly statusline_ is a simple yet informative _statusline_ for Vim and Neovim
that uses [moonfly](https://github.com/bluz71/vim-moonfly-colors) colors by
default. If those colors do not suit then they can easily be
[customized](https://github.com/bluz71/vim-moonfly-statusline#gmoonflyignoredefaultcolors)
if desired.

_moonfly statusline_ is also a very light _statusline_ plugin clocking in at
around 200 lines of Vimscript. For comparison, the
[lightline](https://github.com/itchyny/lightline.vim) and
[airline](https://github.com/vim-airline/vim-airline) _statusline_ plugins
contain over 3,500 and 6,500 lines of Vimscript respectively. In fairness, the
latter two plugins are also more featureful.

Lastly, for those that configure their own _statusline_ but seek only to add
some niceties, such a colorful mode indicator for example, then feel free to
browse the
[source](https://github.com/bluz71/vim-moonfly-statusline/blob/master/plugin/moonfly-statusline.vim)
and borrow freely.

Screenshots
-----------

<img width="900" alt="normal" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_normal.png">

<img width="900" alt="insert" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_insert.png">

<img width="900" alt="visual" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_visual.png">

<img width="900" alt="visual" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_replace.png">

The font in use is [Iosevka](https://github.com/be5invis/Iosevka). Also, the
`g:moonflyWithGitBranchCharacter` option is set to `1`.

Plugins and Diagnostics supported
---------------------------------

- [Obsession](https://github.com/tpope/vim-obsession)

- [ALE](https://github.com/dense-analysis/ale) via the
  `g:moonflyWithALEIndicator` option

- [Coc](https://github.com/neoclide/coc.nvim) via the
  `g:moonflyWithCocIndicator` option

- [Neovim LSP](https://neovim.io/doc/user/lsp.html) via the
  `g:moonflyWithNvimLspIndicator` option

Installation
------------

Use your preferred plugin manager to install **bluz71/vim-moonfly-statusline**.

If using [vim-plug](https://github.com/junegunn/vim-plug) do the following:

1. Add `Plug 'bluz71/vim-moonfly-statusline'` to your _vimrc_
2. Run `:PlugInstall`

Notice
------

File explorers, such as _NERDTree_ and _netrw_, and certain other special
windows will **not** be directly styled by this plugin.

Layout And Default Colors
-------------------------

The *moonfly-statusline* layout contains two groupings, the left side segments:

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
  workding directory

- Likewise, `~` home directory paths in preference to absolute paths

- For screen real estate reasons, filenames will be displayed with compacted
  paths, for example `foo/bar/bazz/hello.txt` will be displayed as
  `f/b/b/hello.txt`

The default [moonfly](https://github.com/bluz71/vim-moonfly-colors) colours used
for the above listed colored `*` segments:

| Segment           | Highlight Group | Background                                                  | Foreground                                                  |
|-------------------|-----------------|-------------------------------------------------------------|-------------------------------------------------------------|
| Normal Mode       | `User1`         | ![background](https://placehold.it/32/80a0ff/000000?text=+) | ![background](https://placehold.it/32/1c1c1c/000000?text=+) |
| Insert Mode       | `User2`         | ![background](https://placehold.it/32/c6c6c6/000000?text=+) | ![background](https://placehold.it/32/1c1c1c/000000?text=+) |
| Visual Mode       | `User3`         | ![background](https://placehold.it/32/ae81ff/000000?text=+) | ![background](https://placehold.it/32/1c1c1c/000000?text=+) |
| Replace Mode      | `User4`         | ![background](https://placehold.it/32/f74782/000000?text=+) | ![background](https://placehold.it/32/1c1c1c/000000?text=+) |
| Git Branch        | `User5`         | `StatusLine` background                                     | ![background](https://placehold.it/32/80a0ff/000000?text=+) |
| Plugins Status    | `User6`         | `StatusLine` background                                     | ![background](https://placehold.it/32/f74782/000000?text=+) |
| Total Lines       | `User7`         | `StatusLine` background                                     | ![background](https://placehold.it/32/80a0ff/000000?text=+) |

Options
-------

### g:moonflyIgnoreDefaultColors

The `g:moonflyIgnoreDefaultColors` option specifies whether custom _statusline_
colors should be used in-place of
[moonfly](https://github.com/bluz71/vim-moonfly-colors) colors. By default
[moonfly](https://github.com/bluz71/vim-moonfly-colors) colors will be
displayed. If custom colors are to be used then please set the following option:

```viml
let g:moonflyIgnoreDefaultColors = 1
```

:gift: Here is an example of a customized _statusline_ color theme which should
work well with most existing Vim color schemes including:
[gruvbox](https://github.com/morhetz/gruvbox) and
[nord](https://github.com/arcticicestudio/nord-vim). Save the following either
at the end of your `~/.vimrc` file or in an appropriate `after` file such as
`~/.vim/after/plugin/moonfly-statusline.vim`:

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
this plugin. **No** custom settings are required with this color scheme.

### g:moonflyHonorUserDefinedColors

**DEPRECATED**, please refer to and use the `g:moonflyIgnoreDefaultColors`
option instead.

### g:moonflyWithGitBranch

The `g:moonflyWithGitBranch` option specifies whether to display Git branch
details in the _statusline_. By default Git branches will be displayed in the
`statusline`.

To disable the display of Git branches in the _statusline_ please add the
following to your _vimrc_:

```viml
let g:moonflyWithGitBranch = 0
```

### g:moonflyWithGitBranchCharacter

The `g:moonflyWithGitBranchCharacter` option specifies whether to display Git
branch details with the Unicode Git branch character `U+E0A0`. By default Git
branches displayed in the `statusline` will not use that character since many
monospace fonts will not contain it. However, some modern fonts, such as [Fira
Code](https://github.com/tonsky/FiraCode) and
[Iosevka](https://github.com/be5invis/Iosevka), do contain that Git branch
character.

If `g:moonflyWithGitBranchCharacter` is unset or set to zero then the current
Git branch will be displayed inside square brackets.

To display with the Unicode Git branch character please add the following to
your _vimrc_:

```viml
let g:moonflyWithGitBranchCharacter = 1
```

The above screenshots are displayed with the Git branch character.

### g:moonflyDiagnosticsIndicator

The `g:moonflyDiagnosticsIndicator` option specifies which character to indicate
diagnostic errors. Currently, [ALE](https://github.com/dense-analysis/ale),
[Coc](https://github.com/neoclide/coc.nvim) and [Neovim
LSP](https://neovim.io/doc/user/lsp.html) diagnostics may be indicated via this
option.

By default, the Unicode cross character (`U+2716`), `✖`, will be displayed. A
modern font, such as [Iosevka](https://github.com/be5invis/Iosevka), will
contain that Unicode character.

To specify your own diagnostics indicator please add the following to your
_vimrc_:

```viml
let g:moonflyDiagnosticsIndicator = "<<CHARACTER-OF-YOUR-CHOOSING>>"
```

### g:moonflyWithALEIndicator

_moonfly statusline_ supports the [ALE](https://github.com/dense-analysis/ale)
plugin.

The `g:moonflyWithALEIndicator` option specifies whether to indicate the
presence of the ALE diagnostics in the current buffer via the defined
`g:moonflyDiagnosticsIndicator` (the Unicode `U+2716` `✖` symbol by default). If
enabled, the indicator will be displayed in the left-side section of the
_statusline_.

By default, ALE errors will **not** be indicated.

If ALE error indication is desired then please add the following to your
_vimrc_:

```viml
let g:moonflyWithALEIndicator = 1
```

### g:moonflyWithCocIndicator

_moonfly statusline_ supports the [Coc](https://github.com/neoclide/coc.nvim)
plugin.

The `g:moonflyWithCocIndicator` option specifies whether to indicate the
presence of the Coc diagnostics in the current buffer via the defined
`g:moonflyDiagnosticsIndicator` (the Unicode `U+2716` `✖` symbol by default). If
enabled, the indicator will be displayed in the left-side section of the
_statusline_.

By default, Coc errors will **not** be indicated.

If Coc error indication is desired then please add the following to your
_vimrc_:

```viml
let g:moonflyWithCocIndicator = 1
```

### g:moonflyWithNvimLspIndicator

_moonfly statusline_ supports [Neovim LSP](https://neovim.io/doc/user/lsp.html)
diagnostics.

The `g:moonflyWithNvimLspIndicator` option specifies whether to indicate the
presence of the Neovim LSP diagnostics in the current buffer via the defined
`g:moonflyDiagnosticsIndicator` (the Unicode `U+2716` `✖` symbol by default). If
enabled, the indicator will be displayed in the left-side section of the
_statusline_.

By default, Neovim LSP diagnositics will **not** be indicated.

If Neovim LSP diagnostic indication is desired then please add the following to
your _vimrc_:

```viml
let g:moonflyWithNvimLspIndicator = 1
```
### g:moonflyWithObessionGeometricCharacters

_moonfly statusline_ supports Tim Pope's
[Obsession](https://github.com/tpope/vim-obsession) plugin.

The `g:moonflyWithObessionGeometricCharacters` option specifies whether to
display obsession details using Unicode geometric characters (`U+25A0` - Black
Square & `U+25CF` - Black Circle). A modern font, such as
[Iosevka](https://github.com/be5invis/Iosevka), will contain those Unicode
geometric characters.

If `g:moonflyWithObessionGeometricCharacters` is unset the default value from
the Obsession plugin will be used.

To display Obsession status with geometric characters please add the following
to your _vimrc_:

```viml
let g:moonflyWithObessionGeometricCharacters = 1
```

License
-------

[MIT](https://opensource.org/licenses/MIT)
