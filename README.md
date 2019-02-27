# moonfly statusline

_moonfly statusline_ is a simple _statusline_ for Vim and Neovim that uses
[moonfly](https://github.com/bluz71/vim-moonfly-colors) colors.

## Screenshots

<img width="900" alt="normal" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_normal.png">

<img width="900" alt="insert" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_insert.png">

<img width="900" alt="visual" src="https://raw.githubusercontent.com/bluz71/misc-binaries/master/moonfly/moonfly_visual.png">

The font in use is [Iosevka](https://github.com/be5invis/Iosevka).

## Dependency

First install [moonfly](https://github.com/bluz71/vim-moonfly-colors)

## Installation

Use your favoured plugin manager to install **bluz71/vim-moonfly-statusline**.

If using [vim-plug](https://github.com/junegunn/vim-plug) do the following:

1. Add `Plug 'bluz71/vim-moonfly-statusline'` to your _vimrc_
2. Run `:PlugInstall`

## Options

### g:moonflyWithGitBranchCharacter

The `g:moonflyWithGitBranchCharacter` option specifies whether to display Git
branch details, via [vim-fugitive](https://github.com/tpope/vim-fugitive) if
installed, using the Unicode Git branch character `U+E0A0`. By default Git
branches displayed in the `statusline` will not use that character since many
monospace fonts will not contain that character. However, some modern fonts
such as [Fira Code](https://github.com/tonsky/FiraCode) and
[Ioveska](https://github.com/be5invis/Iosevka) do contain the Git branch
character.

To display the Unicode Git branch character please add the following to your
_vimrc_:

```viml
let g:moonflyWithGitBranchCharacter = 1
```

The above screenshots are displayed with the Git branch character.

### g:moonflyHonorUserDefinedColors

The `g:moonflyHonorUserDefinedColors` option specifies whether user-defined
colors should be used instead of the default colors from the moonfly color
scheme.

```viml
let g:moonflyHonorUserDefinedColors = 1
```

For example, these user-defined colors mimic Vim's default statusline colors:

```viml
highlight! link User1 StatusLine
highlight! link User2 DiffAdd
highlight! link User3 DiffChange
highlight! link User4 DiffDelete
highlight! link User5 StatusLine
highlight! link User6 StatusLine
highlight! link User7 StatusLine
```

## License

[MIT](https://opensource.org/licenses/MIT)
