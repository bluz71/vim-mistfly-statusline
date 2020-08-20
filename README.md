moonfly statusline
==================

_moonfly statusline_ is a simple yet informative _statusline_ for Vim and Neovim
that uses [moonfly](https://github.com/bluz71/vim-moonfly-colors) colors by
default. If those colors don't suit then they can easily be
[customized](https://github.com/bluz71/vim-moonfly-statusline#gmoonflyignoredefaultcolors)
if desired.

:cake: When the `g:moonflyIgnoreDefaultColors` option is set the
[nightly](https://github.com/bluz71/vim-nightfly-guicolors) Vim theme will
automatically style the `statusline` using _nightfly_ colors.

Screenshots
-----------

<img width="900" alt="normal" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_normal.png">

<img width="900" alt="insert" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_insert.png">

<img width="900" alt="visual" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_visual.png">

<img width="900" alt="visual" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_replace.png">

The font in use is [Iosevka](https://github.com/be5invis/Iosevka). Also, the
`g:moonflyWithGitBranchCharacter` option is set to `1`.

Plugins supported
-----------------

- [fugitive](https://github.com/tpope/vim-fugitive)

- [obsession](https://github.com/tpope/vim-obsession)

- [ALE](https://github.com/dense-analysis/ale) via the
  `g:moonflyWithALEIndicator` option

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
<Mode> <Filename & Flags> <Git Branch> <Plugin Indicators>
```

And the right side segments:

```
<Line:Column> | <No. Of Lines> | <% Position>
```

The default [moonfly](https://github.com/bluz71/vim-moonfly-colors) colours used
in this _statusline_ layout:

| Segment           | Highlight Group | Background                                                  | Foreground                                                  |
|-------------------|-----------------|-------------------------------------------------------------|-------------------------------------------------------------|
| Normal Mode       | `User1`         | ![background](https://placehold.it/32/80a0ff/000000?text=+) | ![background](https://placehold.it/32/1c1c1c/000000?text=+) |
| Insert Mode       | `User2`         | ![background](https://placehold.it/32/c6c6c6/000000?text=+) | ![background](https://placehold.it/32/1c1c1c/000000?text=+) |
| Visual Mode       | `User3`         | ![background](https://placehold.it/32/ae81ff/000000?text=+) | ![background](https://placehold.it/32/1c1c1c/000000?text=+) |
| Replace Mode      | `User4`         | ![background](https://placehold.it/32/f74782/000000?text=+) | ![background](https://placehold.it/32/1c1c1c/000000?text=+) |
| Git Branch        | `User5`         | ![background](https://placehold.it/32/303030/000000?text=+) | ![background](https://placehold.it/32/80a0ff/000000?text=+) |
| Line:Column & %   | `User6`         | ![background](https://placehold.it/32/303030/000000?text=+) | ![background](https://placehold.it/32/c6c6c6/000000?text=+) |
| No. Of Line       | `User7`         | ![background](https://placehold.it/32/303030/000000?text=+) | ![background](https://placehold.it/32/80a0ff/000000?text=+) |
| Plugin Indicators | `User8`         | ![background](https://placehold.it/32/303030/000000?text=+) | ![background](https://placehold.it/32/f74782/000000?text=+) |

Options
-------

### g:moonflyIgnoreDefaultColors

The `g:moonflyIgnoreDefaultColors` option specifies whether custom _statusline_
colors should be used in-place of
[moonfly](https://github.com/bluz71/vim-moonfly-colors) colors. By default
[moonfly](https://github.com/bluz71/vim-moonfly-colors) will be displayed. If
custom colors are to be used then please set the following option:

```viml
let g:moonflyIgnoreDefaultColors = 1
```

Note, the [nightfly](https://github.com/bluz71/vim-nightfly-guicolors) color
scheme defines theme-specific _statusline_ colors that are compatible with this
plugin, but only when `let g:moonflyIgnoreDefaultColors = 1` is set.

:gift: Here is an example of a custom _statusline_ color theme saved in an
appropriate `after` file such as `~/.vim/after/plugin/moonfly-statusline.vim`:

```viml
highlight! link User1 DiffText
highlight! link User2 DiffAdd
highlight! link User3 Search
highlight! link User4 IncSearch
highlight! link User5 StatusLine
highlight! link User6 StatusLine
highlight! link User7 StatusLine
highlight! link User8 StatusLine
```

### g:moonflyHonorUserDefinedColors

**DEPRECATED**, please refer to and use the `g:moonflyIgnoreDefaultColors`
option instead.

### g:moonflyWithALEIndicator

_moonfly statusline_ supports the [ALE](https://github.com/dense-analysis/ale)
plugin.

The `g:moonflyWithALEIndicator` option specifies whether to indicate the
presence of the ALE diagnostic errors in the current buffer via the defined
`g:moonflyDiagnosticsIndicator` (the Unicode `U+2716` `✖` symbol by default). If
enabled, the indicator will be displayed in the left-side section of the
_statusline_.

By default, ALE errors will **not** be indicated.

If ALE error indication is desired please add the following to your _vimrc_:

```viml
let g:moonflyWithALEIndicator = 1
```

### g:moonflyDiagnosticsIndicator

The `g:moonflyDiagnosticsIndicator` option specifies which character to indicate
diagnostic errors. Currently, only [ALE](https://github.com/dense-analysis/ale)
lint errors may be indicated. In future other diagnostic systems may also be
supported.

By default, the Unicode cross character (`U+2716`), `✖`, will be displayed. A
modern font, such as [Iosevka](https://github.com/be5invis/Iosevka), will
contain that Unicode character.

To specify your own diagnostics indicator please add the following to your
_vimrc_:

```viml
let g:moonflyDiagnosticsIndicator = "<<CHARACTER-OF-YOUR-CHOOSING>>"
```

### g:moonflyWithGitBranchCharacter

_moonfly statusline_ supports Tim Pope's
[fugitive](https://github.com/tpope/vim-fugitive) plugin.

The `g:moonflyWithGitBranchCharacter` option specifies whether to display Git
branch details using the Unicode Git branch character `U+E0A0`. By default Git
branches displayed in the `statusline` will not use that character since many
monospace fonts will not contain it. However, some modern fonts, such as [Fira
Code](https://github.com/tonsky/FiraCode) and
[Iosevka](https://github.com/be5invis/Iosevka), do contain the Git branch
character.

If `g:moonflyWithGitBranchCharacter` is unset the default value from
the fugitive plugin will be used.

To display the Unicode Git branch character please add the following to your
_vimrc_:

```viml
let g:moonflyWithGitBranchCharacter = 1
```

The above screenshots are displayed with the Git branch character.

### g:moonflyWithObessionGeometricCharacters

_moonfly statusline_ supports Tim Pope's
[obsession](https://github.com/tpope/vim-obsession) plugin.

The `g:moonflyWithObessionGeometricCharacters` option specifies whether to
display obsession details using Unicode geometric characters (`U+25A0` - Black
Square & `U+25CF` - Black Circle). A modern font, such as
[Iosevka](https://github.com/be5invis/Iosevka), will contain those Unicode
geometric characters.

If `g:moonflyWithObessionGeometricCharacters` is unset the default value from
the obsession plugin will be used.

To display Obsession status with geometric characters please add the following
to your _vimrc_:

```viml
let g:moonflyWithObessionGeometricCharacters = 1
```

License
-------

[MIT](https://opensource.org/licenses/MIT)
