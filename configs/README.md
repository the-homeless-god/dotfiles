# Configs

## Vim

1. After open use `:PlugInstall`
2. After plugins installation use `:CocInstall coc-tsserver coc-eslint coc-json coc-prettier coc-css coc-html coc-snippets`

### Colour scheme

`.vim/colors/digitable.vim` is the scheme `.vimrc` enables. It is installed by
`scripts/install-tools.sh` together with `.vimrc`; nothing has to be downloaded.
To try it without installing anything:

```sh
vim -Nu NONE -c 'set rtp+=configs/.vim' -c 'colorscheme digitable' README.md
```

Colours and role mapping both come from the Digitable Courses portal — the file
header names the exact source of every value. Do not hand-edit the hex numbers:
change the palette table at the top of the file instead, and re-measure.

### The same palette everywhere else

One palette, one spec: `theme/digitable.flang` holds the colours, the role
mapping and the contrast thresholds, and `make check-theme` compares every
painted file in the tree against it (`scripts/check-theme.sh` also re-runs the
spec through the `flang` compiler when it is installed).

| Tool | File | Enabled by |
| --- | --- | --- |
| Vim | `.vim/colors/digitable.vim` | `colorscheme digitable` in `.vimrc` |
| Alacritty | `.alacritty.toml` | the file itself |
| tmux | `.config/tmux/.tmux.conf` | `@dracula-colors` |
| bat, delta | `.config/bat/themes/digitable.tmTheme` | `bat cache --build`, then `--theme=digitable` / `syntax-theme` |
| bpytop | `.config/bpytop/themes/digitable.theme` | `color_theme="+digitable"` |
| lf | `.config/lf/colors`, `.config/lf/lfrc` | read by lf itself |
| vifm | `.config/vifm/colors/digitable.vifm` | `colorscheme digitable` in `vifmrc` |
| eza, GNU ls | `LS_COLORS`, `EZA_COLORS` in `.zshrc` | exported at shell start |
| zsh suggestions | `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` in `.zshrc` | zsh-autosuggestions |
| digit | `.digit/config.yaml` | `display.skin: digitable` (skin ships with digit) |
| Logseq plugins | `.logseq/settings/*.json` | the plugins' own settings |

Note that `lf` reads `~/.config/lf/lfrc` and never `~/.lfrc`; the latter is kept
only because it predates this repository's `.config/lf` layout.
