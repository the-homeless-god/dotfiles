# Environment

![image](./configs/wallpaper.jpeg)

All settings for environment

## Usage

```shell
git clone https://github.com/the-homeless-god/dotfiles
cp -r ./configs ~/
```

## Development

### Common environment

- [Fonts: Nerd](https://github.com/ryanoasis/nerd-fonts)
- [Oh My Zsh: Home](https://ohmyz.sh/)
- [NeoVim: Home](https://neovim.io/)
- [NeoVim: Installation](https://github.com/neovim/neovim/wiki/Installing-Neovim)
- [Vim/NeoVim: Plugin Manager](https://github.com/junegunn/vim-plug)

### Mac OS

- [Visual Studio Code](https://code.visualstudio.com/download)

### Arch Linux

- [Code OSS](https://archlinux.org/packages/community/x86_64/code/)

## TBD

- Fill in installation and other applications

### About VIM

#### Hotkeys:

- `<Leader>ot`: Opens a terminal below.
- `<leader>f`: Formats the whole file.
- `<leader>ca`: Copies the content of the whole file.
- `<K>`: Shows documentation in a preview window.
- `<leader>dd`: Opens the file explorer at the file path.
- `<Leader>da`: Opens the file explorer at the working directory.
- `<leader>ac`: Applies code actions to the current line.
- `<leader>qf`: Applies AutoFix to the problem on the current line.
- `<leader>gd`: Jumps to the definition.
- `<leader>gy`: Jumps to the type definition.
- `<leader>gi`: Jumps to the implementation.
- `<leader>gr`: Shows references.
- `[g` and `]g`: Navigates diagnostics.
- `<leader>a`: Applies code actions to the selected code block.
- `<leader>rn`: Renames symbols.
- `<leader>cl`: Runs the Code Lens action on the current line.
- `<C-f>` and `<C-b>`: Scrolls float windows/popups.
- `<C-s>`: Selects ranges.

#### Plugins:

- `vim-airline`: Provides a status bar for Vim.
- `vim-javascript`: Adds JavaScript support.
- `typescript-vim`: Adds TypeScript syntax highlighting.
- `vim-jsx-pretty`: Adds JS and JSX syntax highlighting.
- `vim-graphql`: Adds GraphQL syntax highlighting.
- `coc.nvim`: Provides autocompletion.
- `vim-prettier`: Formats code using Prettier.
- `vim-healthcheck`: Performs health checks for Vim.
- `vim-floaterm`: Enables floating terminal windows.
- `vim-ripgrep`: Integrates ripgrep search tool.
- `vim-gitgutter`: Shows Git diff in the gutter.

#### Advantages:

- Update of plugins and autostart of Coc plugins on each Vim start.
- Highlights the symbol and its references when holding the cursor.
- Opens a terminal by default at the bottom.
- Sets the size of the terminal with a small height to avoid taking up half of the screen.
- Shows an empty buffer when a file is closed.
- Opens new buffers on the right side.
- Configures various settings for the vim-airline plugin.
- Enables Git lens to show Git diff symbols.
- Uses a specific font with a height.
- Enables formatting on save using Prettier.
- Improves user experience by reducing update time and always showing the signcolumn.
- Sets encoding to utf-8 for Vim.
- Configures various settings for the file explorer.
- Adds (Neo)Vim's native statusline support.
- Sets various key mappings for different actions.
- Configures CoCList mappings for diagnostics, extensions, commands, outline, and workspace symbols.
- Enables scrolling of float windows/popups using Ctrl+f and Ctrl+b.
- Sets key mapping for selecting ranges using Ctrl+s.
