moonfly statusline
==================

*moonfly statusline* is a simple *statusline* for Vim and Neovim that uses
[moonfly](https://github.com/bluz71/vim-moonfly-colors) colors.

Screenshots
-----------

#### normal mode
![normal](moonfly_normal.png)

#### insert mode
![insert](moonfly_insert.png)

#### replace mode
![replace](moonfly_replace.png)

#### visual mode
![visual](moonfly_visual.png)

Dependency
----------

First install [moonfly](https://github.com/bluz71/vim-moonfly-colors)

Installation
------------

Use your favoured plugin manager to install **bluz71/vim-moonfly-statusline**.

If using [vim-plug](https://github.com/junegunn/vim-plug) do the following:

1. Add `Plug 'bluz71/vim-moonfly-statusline'` to your *vimrc*
2. Run `:PlugInstall`

Options
-------

The `g:moonflyWithGitBranchCharacter` option specifies whether to display Git
branch details, via [vim-fugitive](https://github.com/tpope/vim-fugitive) if
installed, using the Unicode Git branch character `U+E0A0`. By default Git
branches displayed in the `statusline` will not use that character since many
monospace fonts will not contain that character. However, some modern fonts
such as [Fira Code](https://github.com/tonsky/FiraCode) and
[Ioveska](https://github.com/be5invis/Iosevka) do contain the Git branch
character.

To display the Unicode Git branch character please add the following to your
*vimrc*:

```viml
let g:moonflyWithGitBranchCharacter = 1
```

License
-------

[MIT](https://opensource.org/licenses/MIT)
